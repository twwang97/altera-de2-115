-- file: div_by_10.vhd
-- Author: David

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity div_by_10 is
  port(
    a_in  : in  std_logic_vector(3 downto 0);  -- input 0..15
    q_out : out std_logic_vector(3 downto 0)   -- output floor(a_in / 10)  (0 or 1)
  );
end entity;

architecture rtl of div_by_10 is
begin
  process(a_in)
    variable aval : unsigned(a_in'range);
    variable tmp  : integer;
  begin
    aval := unsigned(a_in);
    tmp  := to_integer(aval) / 10;
    q_out <= std_logic_vector(to_unsigned(tmp, q_out'length));
  end process;
end architecture;