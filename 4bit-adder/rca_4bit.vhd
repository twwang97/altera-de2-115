-- File: rca_4bit.vhd
-- Objective: To implement an RCA (or ripple-carry adder)
-- Author: David

library ieee;
use ieee.std_logic_1164.all;

entity rca_4bit is
  port(
    a     : in  std_logic_vector(3 downto 0);
    b     : in  std_logic_vector(3 downto 0);
    cin   : in  std_logic;
    sum   : out std_logic_vector(3 downto 0);
    cout  : out std_logic
  );
end entity;

architecture structural of rca_4bit is
  signal c : std_logic_vector(4 downto 0);
begin
  c(0) <= cin;

  fa0: entity work.full_adder(rtl)
    port map(a(0), b(0), c(0), sum(0), c(1));

  fa1: entity work.full_adder(rtl)
    port map(a(1), b(1), c(1), sum(1), c(2));

  fa2: entity work.full_adder(rtl)
    port map(a(2), b(2), c(2), sum(2), c(3));

  fa3: entity work.full_adder(rtl)
    port map(a(3), b(3), c(3), sum(3), c(4));

  cout <= c(4);
end architecture;
