-- File: pass_or_zero.vhd
-- Author: David

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pass_or_zero is
  port(
    a       : in  std_logic_vector(3 downto 0);
    b       : in  std_logic_vector(3 downto 0);
	 cin     : in  std_logic;
    rst_n   : in  std_logic;
    en      : in  std_logic;
    out_a   : out std_logic_vector(3 downto 0);
    out_b   : out std_logic_vector(3 downto 0);
	 out_cin : out  std_logic
  );
end entity pass_or_zero;

architecture rtl of pass_or_zero is
begin

  -- Combinational assignment: outputs follow inputs only when rst_n='1' and en='1'
  out_a <= a when (rst_n = '1' and en = '1') else (others => '0');
  out_b <= b when (rst_n = '1' and en = '1') else (others => '0');
  out_cin <= cin when (rst_n = '1' and en = '1') else '0';

end architecture rtl;