library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

entity VectorMatcher is
    generic (
        VECTOR_SIZE : integer := 60 -- Vector size: 60 bits
    );    
    port (
        vector1, vector2 : in std_logic_vector(VECTOR_SIZE -1 downto 0); -- Vector size: 60 bits
        match : out std_logic
    );
end entity VectorMatcher;

architecture Behavioral of VectorMatcher is
begin
    process(vector1, vector2)
    begin
        if vector1 = vector2 then
            match <= '1'; -- Vectors match
        else
            match <= '0'; -- Vectors don't match
        end if;
    end process;
end architecture Behavioral;