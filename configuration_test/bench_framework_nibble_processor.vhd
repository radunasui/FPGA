library ieee;
library work;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.bench_nibble_processor_pkg.all;

entity bench_framework_nibble_processor is
  generic(
    DATA_WIDTH : natural := 8
  );
end entity;

architecture arch of bench_framework_nibble_processor is

    signal clk          : std_logic;

    signal sim_finished : boolean := false;
    signal sim_passed   : boolean := false;

    signal input_data   : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal input_ready  : std_logic;

    signal output_data  : std_logic_vector(1 downto 0);
    signal output_valid : std_logic;

    signal sim_count    : natural := 0;

begin

  sim: process(clk)
    begin
      if rising_edge(clk) then
        sim_count <= sim_count + 1;
        if sim_count = 100 then
          sim_finished  <= true;
          sim_passed    <= true;
        end if;
      end if;
  end process;

  proc_clock: process
      constant CLOCK_PERIOD : time := 10 ns;
    begin
      clk <= '0';
      wait for 0 ns;
      while sim_finished = false loop
        clk <= not clk;
        wait for CLOCK_PERIOD / 2;
      end loop;
      wait;
  end process;

  driver: process(clk)
    begin
      if rising_edge(clk) then
        if input_ready then
          input_data <= generate_random_value(DATA_WIDTH);
        end if;
      end if;
  end process;

  dut : component uut
    generic map(
      DATA_WIDTH => DATA_WIDTH
    )
    port map(
      clk         => clk,
      din_data    => input_data,
      din_ready   => input_ready,

      dout_data   => output_data,
      dout_valid  => output_valid
    );

end architecture;