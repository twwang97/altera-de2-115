--==============================================================================
-- Project : Dual Detector (Mealy and Moore) verification
-- File    : tb_dual_detector.vhd
-- Author  : twwang97
-- Date    : 2025-11-22
-- Purpose : Testbench for dual_detector_top (mealy + moore detectors).
--           Applies clock, reset, and a simple stimulus sequence to verify
--           that both Mealy and Moore detector outputs assert correctly
--           for the tested input patterns.
--
-- Testbench summary:
--   - Clock: 10 ns period (toggle every 5 ns) => 100 MHz
--   - Reset: active-low (rst_n). Initially asserted low, released after 10 ns.
--   - Input stimulus: toggling bit sequence to exercise detector logic
--   - Simulation end: stops after the stimulus sequence and a 40 ns wait
--   - Uses assertion failure to indicate end of simulation
--
-- Signals instantiated:
--   clk           : std_logic  -- testbench clock
--   rst_n         : std_logic  -- active-low reset for DUT
--   inp           : std_logic  -- input data bit to DUT
--   detect_mealy  : std_logic  -- output from Mealy detector
--   detect_moore  : std_logic  -- output from Moore detector
--
-- DUT:
--   Component name : dual_detector_top
--   Ports (mapped to testbench signals):
--     clk    : in  std_logic
--     rst_n  : in  std_logic
--     data_in: in  std_logic
--     detect_mealy  : out std_logic
--     detect_moore  : out std_logic
--
-- Expected behavior (brief):
--   - After reset deassertion, given the reference input sequence, the
--     Mealy and Moore outputs should assert at the cycle(s) defined by
--     the detector specification. Use waveform inspection or assertions
--     in an enhanced testbench to validate exact timing and values.
--
-- How to run (example, simulator dependent):
--   1. Analyze/compile design and tb files.
--   2. Run simulation for at least the duration of this testbench.
--   3. Inspect waveforms for clk, rst_n, inp, detect_mealy, detect_moore.
--   4. Optionally add checks or assertions comparing outputs to expected.
--
-- Revision history:
--   v1.0 - initial testbench skeleton and stimulus sequence
--   (add future revisions here)
--==============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_dual_detector is
end entity;

architecture tb of tb_dual_detector is
    -- signals
    signal clk           : std_logic := '0';
    signal rst_n         : std_logic := '0';
    signal inp           : std_logic := '0';
    signal detect_mealy  : std_logic;
    signal detect_moore  : std_logic;

    -- component declarations (match the Verilog module port names)
    component dual_detector_top
        port (
            clk    : in  std_logic;
            rst_n  : in  std_logic;
            data_in: in  std_logic;
            detect_mealy : out std_logic;
				detect_moore : out std_logic
        );
    end component;

begin
    -- Instantiate Mealy and Moore detectors
    U_TOP_DUAL: dual_detector_top
        port map (
            clk    => clk,
            rst_n  => rst_n,
            data_in=> inp,
            detect_mealy => detect_mealy,
				detect_moore => detect_moore
        );

    -- Clock: toggle every 5 ns -> 10 ns period (100 MHz)
    clk_proc : process
    begin
        wait for 5 ns;
        clk <= not clk;
    end process;

    -- Stimulus process (follows the timing from the Verilog testbench)
    stim_proc : process
    begin
        -- follow the Verilog sequence: #1 rst_n = 0; #10 rst_n = 1;
        rst_n <= '0';
        inp   <= '0';
        wait for 1 ns;
        rst_n <= '0';
        wait for 10 ns;
        rst_n <= '1';

        -- Stimulus: send bits 1 0 1 0 1 ...
        wait for 10 ns; inp <= '1'; -- t = 1 + 10 + 10 = 21 ns (approx Verilog timing)
        wait for 10 ns; inp <= '0'; -- next change
        wait for 10 ns; inp <= '1';
        wait for 10 ns; inp <= '0';
        wait for 10 ns; inp <= '1';

        -- wait 40 ns then finish
		assert false report "End of simulation" severity failure;
        wait; -- ensure process does not fall through
    end process;
end architecture;