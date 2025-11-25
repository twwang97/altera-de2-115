-- file: tb_rca_8bit.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_rca_8bit is
end entity tb_rca_8bit;

architecture tb of tb_rca_8bit is
    constant CASCADED_WIDTH : natural := 8;        -- bit width of a, b, sum
    constant CARRY_WIDTH  : natural := CASCADED_WIDTH + 1;  -- width including carry-out
    constant CIN_WIDTH    : natural := 1;          -- width of carry-in
    constant CLK_PERIOD : time := 10 ns;
    constant TIMEOUT_CYCLES : natural := 500;

    -- DUT interface signals
    signal clk        : std_logic := '0';
    signal rst_n      : std_logic := '0';
    signal start      : std_logic := '0';
    signal a          : std_logic_vector(CASCADED_WIDTH-1 downto 0) := (others => '0');
    signal b          : std_logic_vector(CASCADED_WIDTH-1 downto 0) := (others => '0');
    signal cin        : std_logic := '0';

    signal sum        : std_logic_vector(CASCADED_WIDTH-1 downto 0);
    signal cout       : std_logic;
    signal busy       : std_logic;
    signal done       : std_logic;
    signal cycle_count: std_logic_vector(31 downto 0) := (others => '0');

    signal done_prev  : std_logic := '0';

    component sequential_trigger_rca8
      port (
		  clk         : in  std_logic;
		  rst_n       : in  std_logic;
		  start       : in  std_logic;
		  cin         : in  std_logic;
		  a           : in  std_logic_vector(CASCADED_WIDTH-1 downto 0);
		  b           : in  std_logic_vector(CASCADED_WIDTH-1 downto 0);
		  cout        : out  std_logic;
		  busy        : out  std_logic;
		  done        : out  std_logic;
		  sum         : out  std_logic_vector(CASCADED_WIDTH-1 downto 0);
		  cycle_count : out  std_logic_vector(31 downto 0)
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
    uut: sequential_trigger_rca8
      port map (
        clk => clk,
        rst_n => rst_n,
        start => start,
        a => a,
        b => b,
        cin => cin,
        sum => sum,
        cout => cout,
        busy => busy,
        done => done,
        cycle_count => cycle_count
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
        -- Vector 1: 0x1 + 0x2, cin=0
        --------------------------------------------------------------------------
        -- Wait until DUT ready
        wait until rising_edge(clk);
        while busy = '1' loop
            wait until rising_edge(clk);
        end loop;

        a <= x"01";
        b <= x"02";
        -- a <= x"00000000000000000000000000000001";
        -- b <= x"00000000000000000000000000000002";
        cin <= '0';
        -- pulse start 1 cycle
        wait until rising_edge(clk);
        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        -- wait for done with timeout
        timeout := 0;
        wait until rising_edge(clk);
        while done = '0' and timeout < TIMEOUT_CYCLES loop
            timeout := timeout + 1;
            wait until rising_edge(clk);
        end loop;
        if done = '0' then
            report "ERROR: timeout waiting for done (vector 1)" severity failure;
        end if;
        wait until rising_edge(clk); -- allow outputs to settle

        -- check result
        ta := unsigned(a);
        tb := unsigned(b);
        tcin := to_unsigned(0, CIN_WIDTH);
        expect := ("0" & ta) + ("0" & tb) + to_unsigned(0, CARRY_WIDTH);
        if unsigned(sum) /= unsigned(expect(CASCADED_WIDTH-1 downto 0)) or (cout /= expect(CARRY_WIDTH-1)) then
            report "ERROR: a=0x" & to_hex_width(a) & " b=0x" & to_hex_width(b) &
                " cin=0 => got cout,sum=" & std_logic'image(cout) & "_" &
                integer'image(to_integer(unsigned(sum))) &
                " expected=" & integer'image(to_integer(unsigned(expect))) &
                " cycles=" & integer'image(to_integer(unsigned(cycle_count)))
                severity error;
        else
            report "OK: a=0x" & to_hex_width(a) & " b=0x" & to_hex_width(b) &
                " cin=0 => sum=" & integer'image(to_integer(unsigned(sum))) &
                " cout=" & std_logic'image(cout) &
                " cycles=" & integer'image(to_integer(unsigned(cycle_count)))
                severity note;
        end if;

        --------------------------------------------------------------------------
        -- Vector 2: 0x01 + 0x02, cin=0
        --------------------------------------------------------------------------
        wait until rising_edge(clk);
        while busy = '1' loop
            wait until rising_edge(clk);
        end loop;

        a <= x"7F";
        b <= x"7F";
        -- a <= x"7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
        -- b <= x"7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
        cin <= '1';
        wait until rising_edge(clk);
        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        timeout := 0;
        wait until rising_edge(clk);
        while done = '0' and timeout < TIMEOUT_CYCLES loop
            timeout := timeout + 1;
            wait until rising_edge(clk);
        end loop;
        if done = '0' then
            report "ERROR: timeout waiting for done (vector 2)" severity failure;
        end if;
        wait until rising_edge(clk);

        ta := unsigned(a);
        tb := unsigned(b);
        expect := ("0" & ta) + ("0" & tb) + to_unsigned(0, CARRY_WIDTH);
        if unsigned(sum) /= unsigned(expect(CASCADED_WIDTH-1 downto 0)) or (cout /= expect(CARRY_WIDTH-1)) then
            report "ERROR: a=0x" & to_hex_width(a) & " b=0x" & to_hex_width(b) &
                " cin=0 => got cout,sum=" & std_logic'image(cout) & "_" &
                integer'image(to_integer(unsigned(sum))) &
                " expected=" & integer'image(to_integer(unsigned(expect))) &
                " cycles=" & integer'image(to_integer(unsigned(cycle_count)))
                severity error;
        else
            report "OK: a=0x" & to_hex_width(a) & " b=0x" & to_hex_width(b) &
                " cin=0 => sum=" & integer'image(to_integer(unsigned(sum))) &
                " cout=" & std_logic'image(cout) &
                " cycles=" & integer'image(to_integer(unsigned(cycle_count)))
                severity note;
        end if;

        --------------------------------------------------------------------------
        -- Vector 3: 0xFF + 0x01, cin=0
        --------------------------------------------------------------------------
        wait until rising_edge(clk);
        while busy = '1' loop
            wait until rising_edge(clk);
        end loop;

        a <= x"FF";
        b <= x"01";
        -- a <= x"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
        -- b <= x"00000000000000000000000000000001";
        cin <= '0';
        wait until rising_edge(clk);
        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        timeout := 0;
        wait until rising_edge(clk);
        while done = '0' and timeout < TIMEOUT_CYCLES loop
            timeout := timeout + 1;
            wait until rising_edge(clk);
        end loop;
        if done = '0' then
            report "ERROR: timeout waiting for done (vector 3)" severity failure;
        end if;
        wait until rising_edge(clk);

        ta := unsigned(a);
        tb := unsigned(b);
        expect := ("0" & ta) + ("0" & tb) + to_unsigned(0, CARRY_WIDTH);
        if unsigned(sum) /= unsigned(expect(CASCADED_WIDTH-1 downto 0)) or (cout /= expect(CARRY_WIDTH-1)) then
            report "ERROR: a=0x" & to_hex_width(a) & " b=0x" & to_hex_width(b) &
                " cin=0 => got cout,sum=" & std_logic'image(cout) & "_" &
                integer'image(to_integer(unsigned(sum))) &
                " expected=" & integer'image(to_integer(unsigned(expect))) &
                " cycles=" & integer'image(to_integer(unsigned(cycle_count)))
                severity error;
        else
            report "OK: a=0x" & to_hex_width(a) & " b=0x" & to_hex_width(b) &
                " cin=0 => sum=" & integer'image(to_integer(unsigned(sum))) &
                " cout=" & std_logic'image(cout) &
                " cycles=" & integer'image(to_integer(unsigned(cycle_count)))
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
    -- Done-edge monitor: print once when done rises
    ----------------------------------------------------------------------------
    monitor_done : process(clk)
    begin
        if rising_edge(clk) then
            if done = '1' and done_prev = '0' then
                report "Time " & time'image(now) & ": Addition finished. cycle_count=" & integer'image(to_integer(unsigned(cycle_count))) severity note;
				end if;
            done_prev <= done;
        end if;
    end process;

end architecture tb;
