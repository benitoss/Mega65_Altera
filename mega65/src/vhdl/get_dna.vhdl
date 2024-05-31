Library UNISIM;
use UNISIM.vcomponents.all;


-- DNA_PORT: Device DNA Access Port
--           7 Series
-- Xilinx HDL Language Template, version 2021.2

DNA_PORT_inst : DNA_PORT
generic map (
   SIM_DNA_VALUE => X"000000000000000"  -- Specifies a sample 57-bit DNA value for simulation
)
port map (
   DOUT => DOUT,   -- 1-bit output: DNA output data.
   CLK => CLK,     -- 1-bit input: Clock input.
   DIN => DIN,     -- 1-bit input: User data input pin.
   READ => READ,   -- 1-bit input: Active high load DNA, active low read input.
   SHIFT => SHIFT  -- 1-bit input: Active high shift enable input.
);​