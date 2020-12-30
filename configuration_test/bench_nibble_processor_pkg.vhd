library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


package bench_nibble_processor_pkg is

  constant TEST_CONSTANT : natural := 0;

  component uut is 
    generic(
      DATA_WIDTH : natural := 8
    );
    port(
      clk       : in std_logic;
      din_data  : in std_logic_vector(DATA_WIDTH-1 downto 0);
      din_ready : out std_logic := '0';

      dout_data   : out std_logic_vector(1 downto 0);
      dout_valid  : out std_logic 
    );
  end component;

  impure function generate_random_value(num_bits : integer) return std_logic_vector;

end bench_nibble_processor_pkg;

package body bench_nibble_processor_pkg is

  shared variable seed1, seed2 : positive := 1;

  impure function generate_random_value(min_value, max_value : integer) return integer is
      variable random_value : real;
    begin
      uniform(seed1, seed2, random_value);
      random_value := random_value * real(max_value - min_value) + real(min_value);

      return integer(random_value);
  end function generate_random_value;

  impure function generate_random_value(num_bits : integer) return std_logic_vector is
      variable random             : std_logic_vector(num_bits-1 downto 0);
      constant NUM_BYTES          : natural := random'length/8;
      constant NUM_REMAINDER_BITS : natural := random'length mod 8;
    begin
      for i in NUM_BYTES-1 downto 0 loop
        random((i+1)*8 - 1 downto i*8) := std_logic_vector(to_unsigned(generate_random_value(0, 255), 8));
      end loop;

      if NUM_REMAINDER_BITS /= 0 then
        random(random'high downto random'length-NUM_REMAINDER_BITS) := std_logic_vector(to_unsigned(generate_random_value(0, (2**NUM_REMAINDER_BITS)-1), NUM_REMAINDER_BITS));
      end if;

      return random(num_bits-1 downto 0);
  end function generate_random_value;

end bench_nibble_processor_pkg;
