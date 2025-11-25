-- =============================================================================
-- File        : tb_moore.vhd
-- Title       : Testbench for moore_detect_01 (Moore FSM)
-- Author      : twwang97
-- Date        : 2025-11-22
-- Description : Self-contained testbench that instantiates moore_detect_01,
--               generates clock and reset, applies stimulus sequence, and
--               terminates the simulation with an assertion.
-- Usage       : Run with any VHDL simulator (ModelSim, GHDL, Riviera-PRO, etc.)
-- Notes       : - Reset is active-low (rst_n); adjust if DUT uses active-high.
--               - Clock period is parameterized by CLK_PERIOD constant.
--               - For multiple test cases, extract stimulus into procedure.
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_moore is
end entity;

architecture tb of tb_moore is
    -- timing constants (parameterize bench)
    constant CLK_PERIOD : time := 10 ns;
    constant HALF_CLK   : time := CLK_PERIOD / 2;
    constant RESET_TIME : time := 11 ns;

    -- signals
    signal clk           : std_logic := '0'; -- free-running clock
    signal rst_n         : std_logic := '0'; -- active-low reset
    signal inp           : std_logic := '0'; -- serial input
    signal detect_moore  : std_logic;        -- DUT output

    -- component declarations (match the Verilog module port names)
	 component moore_detect_01
	     port (
	         clk    : in  std_logic;
	         rst_n  : in  std_logic;
	         data_in: in  std_logic;
	         detect : out std_logic
		  );
	 end component;
begin
    -- Instantiate DUT (named mapping)
	 U_MOORE: moore_detect_01
	     port map (
		      clk => clk,
		      rst_n => rst_n,
		      data_in => inp,
		      detect => detect_moore
	     );

	 -- Clock: toggle every 5 ns -> 10 ns period (100 MHz)
    clk_proc : process
    begin
        wait for HALF_CLK;
        clk <= not clk;
    end process;

    -- Stimulus process with reset hold and test vector
    stim_proc : process
    begin
        rst_n <= '0';
        inp   <= '0';
        wait for 1 ns;
        wait for RESET_TIME;
        rst_n <= '1';

        wait for CLK_PERIOD; inp <= '1';
        wait for CLK_PERIOD; inp <= '0';
        wait for CLK_PERIOD; inp <= '1';

        wait for 40 ns;
        assert false report "End of simulation" severity failure;
        wait;
    end process;
end architecture;