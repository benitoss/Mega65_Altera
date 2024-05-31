library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;




entity asym_ram_sdp is
    generic (
        WIDTHB : integer := 4;
        SIZEB : integer := 1024;
        ADDRWIDTHB : integer := 10;
        
        WIDTHA : integer := 16;
        SIZEA : integer := 256;
        ADDRWIDTHA : integer := 8
    );
    port (
        clkA, clkB : in std_logic;
        weA : in std_logic;
        enaA, enaB : in std_logic;
        addrA : in unsigned(ADDRWIDTHA-1 downto 0);
        addrB : in unsigned(ADDRWIDTHB-1 downto 0);
        diA : in std_logic_vector(WIDTHA-1 downto 0);
        doB : out std_logic_vector(WIDTHB-1 downto 0)
    );
end entity asym_ram_sdp;

architecture Behavioral of asym_ram_sdp is


    function max(a, b : integer) return integer is
begin
    if a > b then
        return a;
    else
        return b;
    end if;
end function max;

function min(a, b : integer) return integer is
begin
    if a < b then
        return a;
    else
        return b;
    end if;
end function min;


function log2(value: integer) return integer is
    variable shifted: integer range 0 to 31;
    variable res: integer;
begin
    if value < 2 then
        return value;
    else
        shifted := value - 1;
        res := 0;
        while shifted > 0 loop
            shifted := shifted / 2;
            res := res + 1;
        end loop;
        return res;
    end if;
end function log2;


    constant maxSIZE : integer := integer(max(SIZEA, SIZEB));
    constant maxWIDTH : integer := integer(max(WIDTHA, WIDTHB));
    constant minWIDTH : integer := integer(min(WIDTHA, WIDTHB));
    
    constant RATIO : integer := maxWIDTH / minWIDTH;
    constant log2RATIO : integer := integer(log2(RATIO));
    
    type ram_array is array (natural range <>) of std_logic_vector(minWIDTH-1 downto 0);
    signal RAM : ram_array(0 to maxSIZE-1);
    signal readB : std_logic_vector(WIDTHB-1 downto 0);
    
begin
    process (clkB)
    begin
        if rising_edge(clkB) then
            if enaB = '1' then
                readB <= RAM(to_integer(addrB));
            end if;
        end if;
    end process;

    doB <= readB;

    ramwrite: process (clkA)
        variable lsbaddr : std_logic_vector(log2RATIO-1 downto 0);
        variable i : integer;
    begin
        if rising_edge(clkA) then
            for i in 0 to RATIO-1 loop
                lsbaddr := std_logic_vector(to_unsigned(i, log2RATIO));
                if enaA = '1' then
                    if weA = '1' then
                        RAM(to_integer(addrA) * RATIO + i) <= diA((i+1)*minWIDTH-1 downto i*minWIDTH);
                    end if;
                end if;
            end loop;
        end if;
    end process ramwrite;
end architecture Behavioral;
