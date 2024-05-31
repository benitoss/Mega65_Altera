library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

entity VectorComparator is
    generic (
        WIDTH : integer := 8  -- Change this value to match the width of your vectors
    );
    port (
        vector1 : in  std_logic_vector(WIDTH-1 downto 0);
        vector2 : in  std_logic_vector(WIDTH-1 downto 0);
        equal   : out std_logic
    );
end VectorComparator;

architecture Behavioral of VectorComparator is
begin
    process(vector1, vector2)
    begin
        equal <= '1';  -- Assume vectors are equal
        for i in 0 to WIDTH-1 loop
            if (vector1(i) /= vector2(i)) then
                equal <= '0';  -- Vectors are not equal
                exit;  -- Exit loop as soon as inequality is found
            end if;
        end loop;
    end process;
end Behavioral;