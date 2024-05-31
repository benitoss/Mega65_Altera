library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity opl2 is 
    generic (
        OPERATOR_PIPELINE_DELAY : integer := 7;  -- 18 operators + idle state
        NUM_OPERATOR_UPDATE_STATES : integer := (NUM_OPERATORS_PER_BANK +1)   -- Number of operators per bank + idle state 
    );
    port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        opl2_we : in STD_LOGIC;
        opl2_data : in STD_LOGIC_VECTOR(7 downto 0);
        opl2_adr : in STD_LOGIC_VECTOR(7 downto 0);
        kon : out STD_LOGIC_VECTOR(8 downto 0);
        channel_a : out SIGNED(15 downto 0);
        channel_b : out SIGNED(15 downto 0);
        sample_clk : out STD_LOGIC;
        sample_clk_128 : out STD_LOGIC
    );
end opl2;

architecture Behavioral of opl2 is




-- Parameter definitions
-- Register widths
constant REG_MULT_WIDTH : integer := 4;
constant REG_FNUM_WIDTH : integer := 10;
constant REG_BLOCK_WIDTH : integer := 3;
constant REG_WS_WIDTH : integer := 2;
constant REG_ENV_WIDTH : integer := 4;
constant REG_TL_WIDTH : integer := 6;
constant REG_KSL_WIDTH : integer := 2;
constant REG_FB_WIDTH : integer := 3;
-- Other widths
constant SAMPLE_WIDTH : integer := 16;
constant ENV_WIDTH : integer := 9;
constant OP_OUT_WIDTH : integer := 13;
constant PHASE_ACC_WIDTH : integer := 20;
constant AM_VAL_WIDTH : integer := 5;
constant ENV_RATE_COUNTER_OVERFLOW_WIDTH : integer := 8;
constant CHANNEL_ACCUMULATOR_WIDTH : integer := 19;
constant NUM_OPERATORS_PER_BANK : integer := 18;
constant NUM_CHANNELS_PER_BANK : integer := 9;
constant OP_NUM_WIDTH : integer := 5;

-- Operator types
constant OP_NORMAL : integer := 0;
constant OP_BASS_DRUM : integer := 1;
constant OP_HI_HAT : integer := 2;
constant OP_TOM_TOM : integer := 3;
constant OP_SNARE_DRUM : integer := 4;
constant OP_TOP_CYMBAL : integer := 5;

-- Logarithmic function
function CLOG2(x : integer) return integer is
begin
    case x is
        when 2 => return 1;
        when 3 to 4 => return 2;
        when 5 to 8 => return 3;
        when 9 to 16 => return 4;
        when 17 to 32 => return 5;
        when 33 to 64 => return 6;
        when 65 to 128 => return 7;
        when 129 to 256 => return 8;
        when 257 to 512 => return 9;
        when 513 to 1024 => return 10;
        when 1025 to 2048 => return 11;
        when 2049 to 4196 => return 12;
        when 4197 to 8192 => return 13;
        when 8193 to 16384 => return 14;
        when 16385 to 32768 => return 15;
        when 32769 to 65536 => return 16;
        when 65537 to 131072 => return 17;
        when 131073 to 262144 => return 18;
        when 262145 to 524288 => return 19;
        when 524289 to 1048576 => return 20;
        when 1048577 to 2097152 => return 21;
        when 2097153 to 4194304 => return 22;
        when 4194305 to 8388608 => return 23;
        when 8388609 to 16777216 => return 24;
        when 16777217 to 33554432 => return 25;
        when others => return -1; -- Error case
    end case;
end CLOG2;

    constant CLOG2_VALUE : integer := integer(ceil(log2(real(OPERATOR_PIPELINE_DELAY))));
      
    type reg_array is array(0 to 255) of STD_LOGIC_VECTOR(7 downto 0);
    signal opl2_reg : reg_array;

	 signal cntr : unsigned(9 downto 0);
    signal sample_clk_en : STD_LOGIC;

    signal nts, dam, dvb, ryt, bd, sd, tom, tc, hh : STD_LOGIC;
    signal am, vib, egt, ksr : STD_LOGIC_VECTOR(17 downto 0);
    signal mult : STD_LOGIC_VECTOR(3 downto 0);
    signal ksl : STD_LOGIC_VECTOR(1 downto 0);
    signal tl : STD_LOGIC_VECTOR(5 downto 0);
    signal ar, dr, sl, rr : STD_LOGIC_VECTOR(3 downto 0);
    signal fnum : STD_LOGIC_VECTOR(9 downto 0);
    signal kon_sig : STD_LOGIC_VECTOR(17 downto 0);
    --signal block : STD_LOGIC_VECTOR(2 downto 0);
    signal chb, cha : STD_LOGIC_VECTOR(8 downto 0);
    signal fb : STD_LOGIC_VECTOR(2 downto 0);
    signal cnt : STD_LOGIC_VECTOR(8 downto 0);
    signal ws : STD_LOGIC_VECTOR(1 downto 0);
	 
	 signal fnum_tmp, block_tmp, fb_tmp : STD_LOGIC_VECTOR(17 downto 0);
    signal kon_tmp, use_feedback : STD_LOGIC_VECTOR(17 downto 0);
    signal modulation : SIGNED(12 downto 0);

    signal delay_counter : STD_LOGIC_VECTOR( (CLOG2_VALUE - 1) downto 0);
    signal delay_state, next_delay_state : STD_LOGIC_VECTOR( (CLOG2_VALUE - 1) downto 0);
    
    signal op_num : STD_LOGIC_VECTOR((integer(ceil(log2(real(NUM_OPERATORS_PER_BANK)))) - 1) downto 0);

    signal operator_out_tmp : SIGNED(12 downto 0);
    type operator_out_array is array(0 to 17) of SIGNED(12 downto 0);
    signal operator_out : operator_out_array;

    signal latch_feedback_pulse : STD_LOGIC;

    type calc_state_type is (IDLE, CALC_OUTPUTS);
    signal calc_state, next_calc_state : calc_state_type;
    
    signal channel : STD_LOGIC_VECTOR(3 downto 0);

    type channel_2_op_array is array(0 to 8) of SIGNED(15 downto 0);
    signal channel_2_op : channel_2_op_array;

    signal channel_a_acc_pre_clamp, channel_b_acc_pre_clamp : SIGNED(15 downto 0);
    signal channel_a_acc_pre_clamp_p, channel_b_acc_pre_clamp_p : channel_2_op_array;
	 
	 
begin 

    opl2_reg_proc: process(clk)
    begin
	     for i in 0 to 255 loop
           if rising_edge(clk) then
            if reset = '1' then
                opl2_reg(i) <= (others => '0');
            elsif (opl2_we = '1' and opl2_adr = i) then
                opl2_reg(i) <= opl2_data;
            end if;
           end if;
        end loop; 
    end process;	 
	 

   -- Process for sample clock generation
    sample_clk_proc: process(clk, reset)
    begin
	    if rising_edge(clk) then
        if reset = '1' then
            cntr <= 10;
            sample_clk_en <= '0';
            sample_clk <= '0';
        else
            if cntr = 813 then
                cntr <= (others => '0');
            else
                cntr <= cntr + 1;
            end if;
            sample_clk <= not cntr(9);
            sample_clk_128 <= not cntr(0);
				if cntr = 0 then
					sample_clk_en <= '1';
				else 
					sample_clk_en <= '0';
				end if;
        end if;
		 end if;
    end process;
	  
	  
	  
	process(clk)
   begin
    if rising_edge(clk) then
        if reset = '1' then
            nts <= '0';
            dam <= '0';
            dvb <= '0';
            ryt <= '0';
            bd  <= '0';
            sd  <= '0';
            tom <= '0';
            tc  <= '0';
            hh  <= '0';
        elsif sample_clk_en = '1' then
            nts <= opl2_reg(8)(6);
            dam <= opl2_reg(to_integer(unsigned'("00101101")))(7);
            dvb <= opl2_reg(to_integer(unsigned'("00101101")))(6);
            ryt <= opl2_reg(to_integer(unsigned'("00101101")))(5);
            bd  <= opl2_reg(to_integer(unsigned'("00101101")))(4);
            sd  <= opl2_reg(to_integer(unsigned'("00101101")))(3);
            tom <= opl2_reg(to_integer(unsigned'("00101101")))(2);
            tc  <= opl2_reg(to_integer(unsigned'("00101101")))(1);
            hh  <= opl2_reg(to_integer(unsigned'("00101101")))(0);
        end if;
    end if;
    end process;
	
--	
--	 gen_label: for i in 0 to 5 generate
--    begin: name1
--    process(clk)
--    begin
--        if rising_edge(clk) then
--            if reset = '1' then
--                am(i)   <= '0';
--                vib(i)  <= '0';
--                egt(i)  <= '0';
--                ksr(i)  <= '0';
--                mult(i) <= (others => '0');
--                
--                ksl(i) <= (others => '0');
--                tl(i)  <= (others => '0');
--                
--                ar(i) <= (others => '0');
--                dr(i) <= (others => '0');
--                
--                sl(i) <= (others => '0');
--                rr(i) <= (others => '0');
--                
--                ws(i) <= (others => '0');
--            elsif sample_clk_en = '1' then
--                am(i)   <= opl2_reg(to_integer(unsigned'("00100000") + to_unsigned(i, 8)))(7);
--                vib(i)  <= opl2_reg(to_integer(unsigned'("00100000") + to_unsigned(i, 8)))(6);
--                egt(i)  <= opl2_reg(to_integer(unsigned'("00100000") + to_unsigned(i, 8)))(5);
--                ksr(i)  <= opl2_reg(to_integer(unsigned'("00100000") + to_unsigned(i, 8)))(4);
--                mult(i) <= opl2_reg(to_integer(unsigned'("00100000") + to_unsigned(i, 8)))(3 downto 0);
--                
--                ksl(i) <= opl2_reg(to_integer(unsigned'("01000000") + to_unsigned(i, 8)))(7 downto 6);
--                tl(i)  <= opl2_reg(to_integer(unsigned'("01000000") + to_unsigned(i, 8)))(5 downto 0);
--                
--                ar(i) <= opl2_reg(to_integer(unsigned'("01100000") + to_unsigned(i, 8)))(7 downto 4);
--                dr(i) <= opl2_reg(to_integer(unsigned'("01100000") + to_unsigned(i, 8)))(3 downto 0);
--                
--                sl(i) <= opl2_reg(to_integer(unsigned'("10000000") + to_unsigned(i, 8)))(7 downto 4);
--                rr(i) <= opl2_reg(to_integer(unsigned'("10000000") + to_unsigned(i, 8)))(3 downto 0);
--                
--                ws(i) <= opl2_reg(to_integer(unsigned'("11100000") + to_unsigned(i, 8)))(1 downto 0);
--            end if;
--        end if;
--    end process;
--    end generate;
	 

end Behavioral;