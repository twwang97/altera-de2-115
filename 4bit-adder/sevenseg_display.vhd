-- file: sevenseg_display.vhd
-- Author: David

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sevenseg_display is
  port(
    clk        : in  std_logic;                    -- board clock (e.g., 50 MHz)
    rst_n      : in  std_logic;                    -- active-low reset input
    sum_number : in  std_logic_vector(3 downto 0); -- 4-bit input value to display (binary 0..15)
    hex0_a     : out std_logic;                    -- segment outputs (a..g)
    hex0_b     : out std_logic;
    hex0_c     : out std_logic;
    hex0_d     : out std_logic;
    hex0_e     : out std_logic;
    hex0_f     : out std_logic;
    hex0_g     : out std_logic
  );
end entity;

architecture rtl of sevenseg_display is

  -- digit holds the 4-bit value that will be decoded to segments.
  -- Use the same type as sum_number to avoid explicit conversions.
  signal digit   : std_logic_vector(3 downto 0) := (others => '0');

  -- seg_pat encodes segments a..g in bit order [6 downto 0] => a b c d e f g.
  -- For a common-anode display the segments are active low:
  --   '0' => segment ON, '1' => segment OFF.
  -- Keep this mapping consistent with the final assignments below.
  signal seg_pat : std_logic_vector(6 downto 0);

begin

  ----------------------------------------------------------------------------
  -- Clocked process: asynchronous reset behavior
  ----------------------------------------------------------------------------  
  process(clk, rst_n)
  begin
    if rst_n = '0' then
      digit <= (others => '0');
    elsif rising_edge(clk) then
      digit <= sum_number;
    end if;
  end process;

  ----------------------------------------------------------------------------
  -- 7-segment decoder (with-select)
  --
  -- Each string is 7 bits long: bit 6 -> segment a, bit 5 -> b, ... bit 0 -> g.
  -- Because this design targets a common-anode module, a '0' means the
  -- segment is illuminated and '1' means it is off.
  --
  -- The table covers values 0..9 and also maps 10..15 to patterns (A-F)
  -- according to the same pattern examples you provided. Adjust any mapping
  -- if you prefer hex-letter shapes or blanking.
  ----------------------------------------------------------------------------
  with digit select
    seg_pat <=
      "0000001" when "0000", -- 0: a b c d e f ON, g OFF
      "1001111" when "0001", -- 1
      "0010010" when "0010", -- 2
      "0000110" when "0011", -- 3
      "1001100" when "0100", -- 4
      "0100100" when "0101", -- 5
      "0100000" when "0110", -- 6
      "0001111" when "0111", -- 7
      "0000000" when "1000", -- 8: all segments ON
      "0000100" when "1001", -- 9
      "0000001" when "1010", -- 10 -> same pattern as 0 (adjust if you want 'A')
      "1001111" when "1011", -- 11 -> same as 1
      "0010010" when "1100", -- 12 -> same as 2
      "0000110" when "1101", -- 13 -> same as 3
      "1001100" when "1110", -- 14 -> same as 4
      "0100100" when "1111", -- 15 -> same as 5
      "1111111" when others;  -- default: all segments OFF (blank)

  ----------------------------------------------------------------------------
  -- Map seg_pat bits to the external port names.
  -- Confirm hardware wiring: this code assumes seg_pat(6) -> hex0_a, ..., seg_pat(0) -> hex0_g.
  ----------------------------------------------------------------------------
  hex0_a <= seg_pat(6);
  hex0_b <= seg_pat(5);
  hex0_c <= seg_pat(4);
  hex0_d <= seg_pat(3);
  hex0_e <= seg_pat(2);
  hex0_f <= seg_pat(1);
  hex0_g <= seg_pat(0);

end architecture;