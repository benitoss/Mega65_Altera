library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.UtilityPkg.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity DeviceDna is
   generic (
      GATE_DELAY_G : time := 1 ns
   );
   port ( 
      clk       : in  sl;
      rst       : in  sl;
      -- Parallel interface for current ticks value
      dnaOut    : out slv(63 downto 0)
   );
end DeviceDna;

architecture Behavioral of DeviceDna is

   type StateType     is (IDLE_S,RESET_CLOCK_S,READ_S,CLOCK_S,DONE_S);
   
   type RegType is record
      state        : StateType;
      clk          : sl;
      loadDna      : sl;
      shiftDna     : sl;
      count        : unsigned(5 downto 0);
      dnaVal       : slv(63 downto 0);
   end record RegType;
   
   constant REG_INIT_C : RegType := (
      state        => IDLE_S,
      clk          => '0',
      loadDna      => '0',
      shiftDna     => '0',
      count        => (others => '0'),
      dnaVal       => (others => '0')
   );

   signal r   : RegType := REG_INIT_C;
   signal rin : RegType;

   signal dout : sl := '0';

begin

   --------------------------
   -- Instantiate DNA_PORT --
   --------------------------
   U_DNA_PORT : DNA_PORT
      generic map (
         SIM_DNA_VALUE => X"1F2E3D4C5B6A708" -- Specifies a sample 57-bit DNA value for simulation
      )
      port map (
         DOUT  => dout,      -- 1-bit output: DNA output data.
         CLK   => r.clk,     -- 1-bit input: Clock input.
         DIN   => '0',       -- 1-bit input: User data input pin.
         READ  => r.loadDna, -- 1-bit input: Active high load DNA, active low read input.
         SHIFT => r.shiftDna -- 1-bit input: Active high shift enable input.
      );   

   ---------------------------------------------
   -- State machine to enforce read coherency --
   ---------------------------------------------
   comb : process( r, rst, dout ) is
      variable v : RegType;
   begin
      v := r;

      -- Resets for pulsed outputs
      v.loadDna  := '0';
      v.shiftDna := '0';

      -- State machine 
      case(r.state) is 
         when IDLE_S =>
            v.loadDna := '1';
            -- On startup, go ahead and read
            v.state := RESET_CLOCK_S;
         when RESET_CLOCK_S =>
            v.loadDna := '1';
            v.clk := '1';
            v.state := READ_S;
         when READ_S  =>
            v.clk := '0';
            v.shiftDna := '1';
            v.dnaVal := r.dnaVal(62 downto 0) & dout;
            v.state := CLOCK_S;
         when CLOCK_S =>
            v.clk := '1';
            v.count := r.count + 1;
            v.shiftDna := '1';
            if (r.count = 56) then
               v.state := DONE_S;
            else
               v.state := READ_S;
            end if;
         when DONE_S =>
            -- Stay forever
         when others =>
            v.state := IDLE_S;
      end case;

      -- Reset logic
      if (rst = '1') then
         v := REG_INIT_C;
      end if;

      -- Outputs to ports
      dnaOut <= "0000000" & r.dnaVal(56 downto 0); 
      
      -- Assignment of combinatorial variable to signal
      rin <= v;

   end process;

   seq : process (clk) is
   begin
      if (rising_edge(clk)) then
         r <= rin after GATE_DELAY_G;
      end if;
   end process seq;

end Behavioral;
