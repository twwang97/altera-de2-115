-- file: tb_ripple_adder.vhd
-- Author: David

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ripple_adder is
end entity;

architecture sim of tb_ripple_adder is
    signal rst_n  : std_logic := '1';
    signal en     : std_logic := '0';
    signal a      : std_logic_vector(3 downto 0) := (others => '0');
    signal b      : std_logic_vector(3 downto 0) := (others => '0');
    signal sum    : std_logic_vector(3 downto 0);
    signal cout  : std_logic;

    constant CLK_PERIOD : time := 10 ns;
begin
    -- Instantiate DUT
    DUT: entity work.ripple_adder
        port map (
            rst_n => rst_n,
            en    => en,
            a     => a,
            b     => b,
            sum   => sum,
            cout => cout
        );

    -- Stimulus
    stim_proc: process
    begin
        -- initial reset
        rst_n <= '0';
        en <= '0';
        wait for 2 * CLK_PERIOD;
        rst_n <= '1';
        wait for CLK_PERIOD;

        -- test vector 1: 3 + 5 = 8
        en <= '1';
        a <= "0011"; -- 3
        b <= "0101"; -- 5
        wait for CLK_PERIOD;
        wait for CLK_PERIOD;

        -- test vector 2: 7 + 9 = 16 (carry)
        a <= "0111"; -- 7
        b <= "1001"; -- 9
        wait for CLK_PERIOD;
        wait for CLK_PERIOD;
		  
        -- test vector 3: 5 + 2 = 7
        en <= '1';
        a <= "0101"; -- 5
        b <= "0010"; -- 2
        wait for CLK_PERIOD;
        wait for CLK_PERIOD;

        -- disable enable: outputs should hold previous value
        en <= '0';
        a <= "0001";
        b <= "0001";
        wait for 2 * CLK_PERIOD;

        -- test vector 5: 15 + 2 = 1 with carry
        en <= '1';
        a <= "1111"; -- 15
        b <= "0010"; -- 2
        wait for CLK_PERIOD;
        wait for CLK_PERIOD;
		  
        -- test vector 6: 2 + 4 = 6
        en <= '1';
        a <= "0010"; -- 2
        b <= "0100"; -- 4
        wait for CLK_PERIOD;
        wait for CLK_PERIOD;

        -- end simulation
        wait for 2 * CLK_PERIOD;
        report "Simulation finished" severity note;
		  assert false report "Stop simulation" severity failure;
        -- wait;
    end process stim_proc;
end architecture sim;
