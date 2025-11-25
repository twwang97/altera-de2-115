-- =============================================================================
-- File    : tb_mag_cmp4.vhd
-- Author  : twwang97
-- Date    : 2025-11-22
-- Purpose : Testbench for mag_cmp4 comparator. Sweeps all 4-bit vectors and
--           checks DUT outputs against expected unsigned comparisons.
-- License : MIT
-- Revision: 1.0
-- Notes   : Run with 10 ns init delay; combinational settle 5 ns.
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_mag_cmp4 is
-- testbench has no ports
end tb_mag_cmp4;

architecture beh of tb_mag_cmp4 is

    -- DUT signals
    signal A    : std_logic_vector(3 downto 0) := (others => '0');
    signal B    : std_logic_vector(3 downto 0) := (others => '0');
    signal A_gt_B : std_logic;
    signal A_lt_B : std_logic;
    signal A_eq_B : std_logic;

    -- test control
    signal fail_flag : boolean := false;

    -- Component declaration for DUT (match your DUT entity if different)
    component mag_cmp4
        port (
            A       : in  std_logic_vector(3 downto 0);
            B       : in  std_logic_vector(3 downto 0);
            A_gt_B  : out std_logic;
            A_lt_B  : out std_logic;
            A_eq_B  : out std_logic
        );
    end component;

begin

    -- Instantiate DUT
    uut: mag_cmp4
        port map (
            A => A,
            B => B,
            A_gt_B => A_gt_B,
            A_lt_B => A_lt_B,
            A_eq_B => A_eq_B
        );

    -- Test process: sweep all vectors and self-check
    stim_proc: process
        variable ai, bi : integer;
        variable exp_gt, exp_lt, exp_eq : std_logic;
        variable total_tests : integer := 0;
        variable total_fail  : integer := 0;
    begin
        -- small wait for initialization
        wait for 10 ns;

        for ai in 0 to 15 loop
            for bi in 0 to 15 loop
                -- apply vectors
                A <= std_logic_vector(to_unsigned(ai, 4));
                B <= std_logic_vector(to_unsigned(bi, 4));

                -- allow combinational outputs to settle
                wait for 5 ns;

                -- compute expected results using unsigned comparisons
                if to_unsigned(ai,4) > to_unsigned(bi,4) then
                    exp_gt := '1'; exp_lt := '0'; exp_eq := '0';
                elsif to_unsigned(ai,4) < to_unsigned(bi,4) then
                    exp_gt := '0'; exp_lt := '1'; exp_eq := '0';
                else
                    exp_gt := '0'; exp_lt := '0'; exp_eq := '1';
                end if;

                total_tests := total_tests + 1;

                -- Check DUT outputs, report mismatch
                if (A_gt_B /= exp_gt) or (A_lt_B /= exp_lt) or (A_eq_B /= exp_eq) then
                    report "Mismatch for A=" & integer'image(ai) & " B=" & integer'image(bi)
                        & " DUT: gt=" & std_logic'image(A_gt_B)
                        & " lt=" & std_logic'image(A_lt_B)
                        & " eq=" & std_logic'image(A_eq_B)
                        & " EXP: gt=" & std_logic'image(exp_gt)
                        & " lt=" & std_logic'image(exp_lt)
                        & " eq=" & std_logic'image(exp_eq)
                        severity error;
                    total_fail := total_fail + 1;
                end if;
            end loop;
        end loop;

        -- Summary
        if total_fail = 0 then
            report "TEST PASSED: " & integer'image(total_tests) & " vectors, 0 failures" severity note;
        else
            report "TEST FAILED: " & integer'image(total_tests) & " vectors, " & integer'image(total_fail) & " failures" severity failure;
        end if;

        wait;
    end process stim_proc;

end beh;
