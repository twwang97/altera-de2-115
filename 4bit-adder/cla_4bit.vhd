-- File: cla_4bit.vhd
-- Objective: To implement a CLA (or carry-lookahead adder, or fast adder) 
-- Author: David

library ieee;
use ieee.std_logic_1164.all;

-- 4-bit ripple/CLA-style adder using propagate (p) and generate (g) signals.
-- Inputs:
--   a, b : 4-bit operands (a(3) is MSB)
--   cin  : input carry
-- Outputs:
--   sum  : 4-bit sum
--   cout : output carry (carry out from MSB)
entity cla_4bit is
  port (
    a    : in  std_logic_vector(3 downto 0);
    b    : in  std_logic_vector(3 downto 0);
    cin  : in  std_logic;
    sum  : out std_logic_vector(3 downto 0);
    cout : out std_logic
  );
end entity cla_4bit;

architecture rtl of cla_4bit is
  -- propagate and generate for each bit:
  -- p(i) = a(i) xor b(i)  -> indicates this bit will propagate an incoming carry
  -- g(i) = a(i) and b(i)  -> indicates this bit will generate a carry regardless of incoming carry
  signal p, g : std_logic_vector(3 downto 0);

  -- carries: c(0) is input carry (cin), c(4) is output carry (cout)
  signal c    : std_logic_vector(4 downto 0);
begin
  -- assign initial carry
  c(0) <= cin;

  -- generate p and g for each bit 0..3
  gen_pg: for i in 0 to 3 generate
    p(i) <= a(i) xor b(i);      -- propagate
    g(i) <= a(i) and b(i);      -- generate
  end generate gen_pg;

  -- carry equations expanded (lookahead expansion for clarity)
  -- c(1) is carry into bit 1 (i.e., carry out from bit 0)
  c(1) <= g(0) or (p(0) and c(0));

  -- c(2) is carry into bit 2 (carry out from bit 1)
  c(2) <= g(1) or (p(1) and g(0)) or (p(1) and p(0) and c(0));

  -- c(3) is carry into bit 3 (carry out from bit 2)
  c(3) <= g(2) or (p(2) and g(1)) or (p(2) and p(1) and g(0)) or (p(2) and p(1) and p(0) and c(0));

  -- c(4) is final carry out (carry out from bit 3)
  c(4) <= g(3)
          or (p(3) and g(2))
          or (p(3) and p(2) and g(1))
          or (p(3) and p(2) and p(1) and g(0))
          or (p(3) and p(2) and p(1) and p(0) and c(0));

  -- sum bits: sum(i) = p(i) xor c(i)  (where c(i) is carry into bit i)
  sum(0) <= p(0) xor c(0);
  sum(1) <= p(1) xor c(1);
  sum(2) <= p(2) xor c(2);
  sum(3) <= p(3) xor c(3);

  -- final carry out
  cout <= c(4);

end rtl;
