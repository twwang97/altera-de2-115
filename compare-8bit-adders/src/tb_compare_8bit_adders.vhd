-- =============================================================================
-- File    : tb_compare_8bit_adders.vhd
-- Author  : twwang97
-- Date    : 2025-11-22
-- Purpose : Testbench to compare sequential 8-bit RCA and CLA adders
--           - Generates clock and stimulus
--           - Instantiates top_sequential_adders DUT
--           - Checks rca8_sum and rca8_cout for a few vectors
-- Usage   : Run with your simulator (e.g., ModelSim, GHDL). Adjust CLK_PERIOD
--           and TIMEOUT_CYCLES constants if needed.
-- Assumptions :
--           * DUT entity name is top_sequential_adders with the ports shown
--           * Signals use std_logic and std_logic_vector types
-- Notes   : - Uses numeric_std for arithmetic
--           - Hex helper function prints CASCADED_WIDTH nibbles
-- License : SPDX-License-Identifier: MIT
-- Revision History :
--    2025-11-22  Initial version
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_compare_8bit_adders is
end entity tb_compare_8bit_adders;

architecture tb of tb_compare_8bit_adders is
    constant CASCADED_WIDTH : natural := 8;        -- bit width of a, b, rca8_sum
    constant CARRY_WIDTH  : natural := CASCADED_WIDTH + 1;  -- width including carry-out
    constant CIN_WIDTH    : natural := 1;          -- width of carry-in
    constant CLK_PERIOD : time := 10 ns;
    constant TIMEOUT_CYCLES : natural := 500;

    -- DUT interface signals
    signal clk     : std_logic := '0';
    signal rst_n   : std_logic := '0';
    signal start   : std_logic := '0';
    signal a       : std_logic_vector(CASCADED_WIDTH-1 downto 0) := (others => '0');
    signal b       : std_logic_vector(CASCADED_WIDTH-1 downto 0) := (others => '0');
    signal cin     : std_logic := '0';

    signal rca8_sum        : std_logic_vector(CASCADED_WIDTH-1 downto 0);
    signal rca8_cout       : std_logic;
    signal rca8_busy       : std_logic;
    signal rca8_done       : std_logic;
    signal rca8_cycle_count: std_logic_vector(31 downto 0) := (others => '0');

    signal cla8_sum        : std_logic_vector(CASCADED_WIDTH-1 downto 0);
    signal cla8_cout       : std_logic;
    signal cla8_busy       : std_logic;
    signal cla8_done       : std_logic;
    signal cla8_cycle_count: std_logic_vector(31 downto 0) := (others => '0');

    signal A_gt_B : std_logic;
    signal A_lt_B: std_logic;
    signal A_eq_B  : std_logic;
    signal rca8_sum_larger : std_logic;
    signal equal_sum: std_logic;
    signal cla8_sum_larger  : std_logic;

    signal done_prev  : std_logic := '0';

    component top_sequential_exp
      port (
          clk         : in  std_logic;
          rst_n       : in  std_logic;
          start       : in  std_logic;
          cin         : in  std_logic;
          a           : in  std_logic_vector(CASCADED_WIDTH-1 downto 0);
          b           : in  std_logic_vector(CASCADED_WIDTH-1 downto 0);
          rca8_cout        : out  std_logic;
          rca8_busy        : out  std_logic;
          rca8_done        : out  std_logic;
          rca8_sum         : out  std_logic_vector(CASCADED_WIDTH-1 downto 0);
          rca8_cycle_count : out  std_logic_vector(31 downto 0);
          cla8_cout        : out  std_logic;
          cla8_busy        : out  std_logic;
          cla8_done        : out  std_logic;
          cla8_sum         : out  std_logic_vector(CASCADED_WIDTH-1 downto 0);
          cla8_cycle_count : out  std_logic_vector(31 downto 0);
          A_gt_B : out  std_logic;
          A_lt_B: out  std_logic;
          A_eq_B  : out  std_logic;
          rca8_sum_larger : out  std_logic;
          equal_sum: out  std_logic;
          cla8_sum_larger  : out  std_logic
      );
    end component;
begin

    ----------------------------------------------------------------------------
    -- Clock
    ----------------------------------------------------------------------------
    clk_gen : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;
    
	 ----------------------------------------------------------------------------
    -- DUT instantiation
    -- Adjust the entity/port mapping if your DUT uses different types (std_logic_vector vs unsigned)
    ----------------------------------------------------------------------------
    uut: top_sequential_exp
      port map (
        clk => clk,
        rst_n => rst_n,
        start => start,
        a => a,
        b => b,
        cin => cin,
        rca8_sum => rca8_sum,
        rca8_cout => rca8_cout,
        rca8_busy => rca8_busy,
        rca8_done => rca8_done,
        rca8_cycle_count => rca8_cycle_count,
        cla8_sum => cla8_sum,
        cla8_cout => cla8_cout,
        cla8_busy => cla8_busy,
        cla8_done => cla8_done,
        cla8_cycle_count => cla8_cycle_count,
        A_gt_B => A_gt_B,
        A_lt_B => A_lt_B,
        A_eq_B => A_eq_B,
        rca8_sum_larger => rca8_sum_larger,
        equal_sum => equal_sum,
        cla8_sum_larger => cla8_sum_larger
      );
    ----------------------------------------------------------------------------
    -- Test stimulus: simple deterministic vectors with guarded waits
    ----------------------------------------------------------------------------
    stim_proc : process
        variable expect  : unsigned(CARRY_WIDTH-1 downto 0);
        variable ta      : unsigned(CASCADED_WIDTH-1 downto 0);
        variable tb      : unsigned(CASCADED_WIDTH-1 downto 0);
        variable tcin    : unsigned(CIN_WIDTH-1 downto 0);
        variable timeout : natural;
        -- helper to display hex as two-digit hex for 8-bit values
        impure function to_hex_width(v : std_logic_vector(CASCADED_WIDTH-1 downto 0)) return string is
            constant HEX_DIGITS : natural := (CASCADED_WIDTH + 3) / 4; -- ceil(WIDTH/4)
            variable i : integer := to_integer(unsigned(v));
            variable s : string(1 to HEX_DIGITS);
            constant hex : string := "0123456789ABCDEF";
            variable idx : integer;
            variable nibble : integer;
        begin
            -- extract HEX_DIGITS nibbles (least-significant first)
				for idx in HEX_DIGITS downto 1 loop
                nibble := i mod 16;
                s(idx) := hex(nibble + 1); -- VHDL strings are 1-based
                i := i / 16;
            end loop;
            return s;
        end function;
    begin
        -- initial reset
        rst_n <= '0';
        start <= '0';
        a <= (others => '0');
        b <= (others => '0');
        cin <= '0';
        wait for 20 ns;

        -- release reset synchronized to clock and wait a few clocks
        rst_n <= '1';
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        --------------------------------------------------------------------------
        -- Vector 1: 0x01 + 0x02, cin=0
        --------------------------------------------------------------------------
        -- Wait until DUT ready
        wait until rising_edge(clk);
        while rca8_busy = '1' loop
            wait until rising_edge(clk);
        end loop;

        a <= x"01";
        b <= x"02";
        cin <= '0';
        -- pulse start 1 cycle
        wait until rising_edge(clk);
        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        -- wait for rca8_done with timeout
        timeout := 0;
        wait until rising_edge(clk);
        while rca8_done = '0' and timeout < TIMEOUT_CYCLES loop
            timeout := timeout + 1;
            wait until rising_edge(clk);
        end loop;
        if rca8_done = '0' then
            report "ERROR: timeout waiting for rca8_done (vector 1)" severity failure;
        end if;
        wait until rising_edge(clk); -- allow outputs to settle

        -- check result
        ta := unsigned(a);
        tb := unsigned(b);
        -- tcin := to_unsigned(0, CIN_WIDTH);
        expect := ("0" & ta) + ("0" & tb) + to_unsigned(0, CARRY_WIDTH);
        if unsigned(rca8_sum) /= unsigned(expect(CASCADED_WIDTH-1 downto 0)) or (rca8_cout /= expect(CARRY_WIDTH-1)) then
            report "ERROR: a=0x" & to_hex_width(a) & " b=0x" & to_hex_width(b) &
                " cin=0 => got rca8_cout,rca8_sum=" & std_logic'image(rca8_cout) & "_" &
                integer'image(to_integer(unsigned(rca8_sum))) &
                " expected=" & integer'image(to_integer(unsigned(expect))) &
                " cycles=" & integer'image(to_integer(unsigned(rca8_cycle_count)))
                severity error;
        else
            report "OK: a=0x" & to_hex_width(a) & " b=0x" & to_hex_width(b) &
                " cin=0 => rca8_sum=" & integer'image(to_integer(unsigned(rca8_sum))) &
                " rca8_cout=" & std_logic'image(rca8_cout) &
                " cycles=" & integer'image(to_integer(unsigned(rca8_cycle_count)))
                severity note;
        end if;

        --------------------------------------------------------------------------
        -- Vector 2: 0x7F + 0x7F, cin=1
        --------------------------------------------------------------------------
        wait until rising_edge(clk);
        while rca8_busy = '1' loop
            wait until rising_edge(clk);
        end loop;

        a <= x"7F";
        b <= x"7F";
        cin <= '1';
        wait until rising_edge(clk);
        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        timeout := 0;
        wait until rising_edge(clk);
        while rca8_done = '0' and timeout < TIMEOUT_CYCLES loop
            timeout := timeout + 1;
            wait until rising_edge(clk);
        end loop;
        if rca8_done = '0' then
            report "ERROR: timeout waiting for rca8_done (vector 2)" severity failure;
        end if;
        wait until rising_edge(clk);

        ta := unsigned(a);
        tb := unsigned(b);
        expect := ("0" & ta) + ("0" & tb) + to_unsigned(0, CARRY_WIDTH);
        if unsigned(rca8_sum) /= unsigned(expect(CASCADED_WIDTH-1 downto 0)) or (rca8_cout /= expect(CARRY_WIDTH-1)) then
            report "ERROR: a=0x" & to_hex_width(a) & " b=0x" & to_hex_width(b) &
                " cin=0 => got rca8_cout,rca8_sum=" & std_logic'image(rca8_cout) & "_" &
                integer'image(to_integer(unsigned(rca8_sum))) &
                " expected=" & integer'image(to_integer(unsigned(expect))) &
                " cycles=" & integer'image(to_integer(unsigned(rca8_cycle_count)))
                severity error;
        else
            report "OK: a=0x" & to_hex_width(a) & " b=0x" & to_hex_width(b) &
                " cin=0 => rca8_sum=" & integer'image(to_integer(unsigned(rca8_sum))) &
                " rca8_cout=" & std_logic'image(rca8_cout) &
                " cycles=" & integer'image(to_integer(unsigned(rca8_cycle_count)))
                severity note;
        end if;

        --------------------------------------------------------------------------
        -- Vector 3: 0xFF + 0x01, cin=0
        --------------------------------------------------------------------------
        wait until rising_edge(clk);
        while rca8_busy = '1' loop
            wait until rising_edge(clk);
        end loop;

        a <= x"FF";
        b <= x"01";
        cin <= '0';
        wait until rising_edge(clk);
        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        timeout := 0;
        wait until rising_edge(clk);
        while rca8_done = '0' and timeout < TIMEOUT_CYCLES loop
            timeout := timeout + 1;
            wait until rising_edge(clk);
        end loop;
        if rca8_done = '0' then
            report "ERROR: timeout waiting for rca8_done (vector 3)" severity failure;
        end if;
        wait until rising_edge(clk);

        ta := unsigned(a);
        tb := unsigned(b);
        expect := ("0" & ta) + ("0" & tb) + to_unsigned(0, CARRY_WIDTH);
        if unsigned(rca8_sum) /= unsigned(expect(CASCADED_WIDTH-1 downto 0)) or (rca8_cout /= expect(CARRY_WIDTH-1)) then
            report "ERROR: a=0x" & to_hex_width(a) & " b=0x" & to_hex_width(b) &
                " cin=0 => got rca8_cout,rca8_sum=" & std_logic'image(rca8_cout) & "_" &
                integer'image(to_integer(unsigned(rca8_sum))) &
                " expected=" & integer'image(to_integer(unsigned(expect))) &
                " cycles=" & integer'image(to_integer(unsigned(rca8_cycle_count)))
                severity error;
        else
            report "OK: a=0x" & to_hex_width(a) & " b=0x" & to_hex_width(b) &
                " cin=0 => rca8_sum=" & integer'image(to_integer(unsigned(rca8_sum))) &
                " rca8_cout=" & std_logic'image(rca8_cout) &
                " cycles=" & integer'image(to_integer(unsigned(rca8_cycle_count)))
                severity note;
        end if;

        --------------------------------------------------------------------------
        -- Done: finish simulation
        --------------------------------------------------------------------------
        report "All tests applied. End simulation." severity note;
        wait for 20 ns;
        assert false report "Stop simulation" severity failure;
    end process;

    ----------------------------------------------------------------------------
    -- Done-edge monitor: print once when rca8_done rises
    ----------------------------------------------------------------------------
    monitor_done : process(clk)
    begin
        if rising_edge(clk) then
            if rca8_done = '1' and done_prev = '0' then
                report "Time " & time'image(now) & ": Addition finished. rca8_cycle_count=" & integer'image(to_integer(unsigned(rca8_cycle_count))) severity note;
				end if;
            done_prev <= rca8_done;
        end if;
    end process;

end architecture tb;
