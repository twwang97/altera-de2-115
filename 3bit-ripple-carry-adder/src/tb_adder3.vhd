-- =============================================================================
-- File       : tb_adder3.vhd
-- Author     : twwang97
-- Date       : 2025-11-01
-- Purpose    : Testbench for 3-bit adder (adder3)
-- Description:
--   - Exhaustive test of all combinations of a[2:0], b[2:0], and cin
--   - Compares DUT output (cout & sum) against expected integer sum
--   - Reports mismatches and ends simulation with PASS/FAIL
-- Notes:
--   - Uses numeric_std for arithmetic conversions
--   - Change WIDTH to parameterize testbench (recommended)
-- Revision History:
--   1.0 2025-11-01  Initial version
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_adder3 is
end tb_adder3;

architecture behavior of tb_adder3 is
    -- DUT signals
    signal a    : std_logic_vector(2 downto 0) := (others => '0');
    signal b    : std_logic_vector(2 downto 0) := (others => '0');
    signal cin  : std_logic := '0';
    signal sum  : std_logic_vector(2 downto 0) := (others => '0');
    signal cout : std_logic := '0';

    -- Component declaration for the adder under test
    component adder3
        port (
            a   : in  std_logic_vector(2 downto 0);
            b   : in  std_logic_vector(2 downto 0);
            cin : in  std_logic;
            sum : out std_logic_vector(2 downto 0);
            cout: out std_logic
        );
    end component;
begin
    -- Instantiate DUT (adjust name/port order if your entity differs)
    uut: adder3
        port map (
            a    => a,
            b    => b,
            cin  => cin,
            sum  => sum,
            cout => cout
        );

    -- Stimulus process
    stim_proc: process
        variable i, j, k       : integer;
        variable errors        : integer := 0;
        variable got_int       : integer;
        variable expected_int  : integer;
    begin
        report "time    a   b  cin | cout sum | expected_c expected_sum";

        for i in 0 to 7 loop
            for j in 0 to 7 loop
                for k in 0 to 1 loop
                    -- apply inputs
                    a   <= std_logic_vector(to_unsigned(i, 3));
                    b   <= std_logic_vector(to_unsigned(j, 3));
                    if k = 0 then
                        cin <= '0';
                    else
                        cin <= '1';
                    end if;

                    wait for 5 ns;  -- wait for outputs to settle

                    -- compute expected and compare
                    expected_int := i + j + k;  -- 0..15
                    got_int := to_integer(unsigned(cout & sum)); -- concat cout as MSB

                    if got_int /= expected_int then
                        report time'image(now) & "  a=" & integer'image(i) & " b=" & integer'image(j)
                               & " cin=" & integer'image(k)
                               & " | got=" & integer'image(got_int)
                               & " expected=" & integer'image(expected_int);
                        errors := errors + 1;
                    end if;
                end loop;
            end loop;
        end loop;

        if errors = 0 then
            report "PASS: all combinations matched" severity note;
        else
            report "FAIL: " & integer'image(errors) & " mismatches" severity error;
        end if;

        wait for 10 ns;
        -- stop simulation: use an assertion to terminate
        assert false report "End of simulation" severity failure;
    end process stim_proc;
end architecture behavior;
