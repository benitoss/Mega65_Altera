library ieee;
use Std.TextIO.all;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

package version is

  constant gitcommit : string := "development,20240301.19,e91b9b0";
  constant fpga_commit : unsigned(31 downto 0) := x"e91b9b04";
  constant fpga_datestamp : unsigned(15 downto 0) := to_unsigned(1525,16);

end version;
