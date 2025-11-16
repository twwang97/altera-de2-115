-- File: ripple_adder.vhd
-- Author: David

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 4-bit ripple adder top-level wrapper
entity ripple_adder is
  port(
    a     : in  std_logic_vector(3 downto 0);  -- input operand A
    b     : in  std_logic_vector(3 downto 0);  -- input operand B
    -- cin   : in  std_logic;                  -- input carry
    rst_n : in  std_logic;                     -- active-low reset for producer block
    en    : in  std_logic;                     -- enable for producer block
    sum   : out std_logic_vector(3 downto 0);  -- adder result
    cout  : out std_logic                      -- final carry-out
  );
end entity ripple_adder;

architecture rtl of ripple_adder is

  -- Internal signals to carry outputs from pass_or_zero to ripple_adder_4bit
  signal adder_input_a   : std_logic_vector(3 downto 0);
  signal adder_input_b   : std_logic_vector(3 downto 0);
  signal adder_input_cin : std_logic;
  
  -- Initialize cin
  signal cin: std_logic := '0';

  ----------------------------------------------------------------
  -- Component declaration for the producer block (pass_or_zero)
  -- This component takes inputs (a,b,cin), and either passes them
  -- through or drives zeros depending on rst_n/en. It produces
  -- out_a, out_b, out_cin which are wired to the adder inputs.
  ----------------------------------------------------------------
  component pass_or_zero
    port(
      a       : in  std_logic_vector(3 downto 0);
      b       : in  std_logic_vector(3 downto 0);
      cin     : in  std_logic;
      rst_n   : in  std_logic;
      en      : in  std_logic;
      out_a   : out std_logic_vector(3 downto 0);
      out_b   : out std_logic_vector(3 downto 0);
      out_cin : out std_logic
    );
  end component;

  ----------------------------------------------------------------
  -- Component declaration for the 4-bit ripple adder consumer
  ----------------------------------------------------------------
  component cla_4bit
    port (
      a    : in  std_logic_vector(3 downto 0);
      b    : in  std_logic_vector(3 downto 0);
      cin  : in  std_logic;
      sum  : out std_logic_vector(3 downto 0);
      cout : out std_logic
    );
  end component;

begin

  ----------------------------------------------------------------
  -- Instantiate the producer 'pass_or_zero'
  -- Map all input and output ports. The outputs from this
  -- instance drive the internal adder_input_* signals.
  ----------------------------------------------------------------
  pass_or_zero_inst : pass_or_zero
    port map (
      a       => a,
      b       => b,
      cin     => cin,
      rst_n   => rst_n,
      en      => en,
      out_a   => adder_input_a,   -- connect producer output to internal signal
      out_b   => adder_input_b,
      out_cin => adder_input_cin
    );

  ----------------------------------------------------------------
  -- Instantiate the 4-bit ripple adder
  -- Connect the internal adder_input_* signals to the adder inputs,
  -- and drive the top-level sum and cout outputs.
  ----------------------------------------------------------------
  ripple_adder_4bit_inst : cla_4bit
    port map (
      a    => adder_input_a,
      b    => adder_input_b,
      cin  => adder_input_cin,
      sum  => sum,
      cout => cout
    );

end architecture rtl;
