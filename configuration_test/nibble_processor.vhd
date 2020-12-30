library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nibble_processor is
    generic(
        DATA_WIDTH : natural := 8
    );
    port(
        clk         : in std_logic;
        din_data    : in std_logic_vector(DATA_WIDTH-1 downto 0);
        din_ready   : out std_logic := '0';

        dout_data   : out std_logic_vector(1 downto 0);
        dout_valid  : out std_logic 
    );
end nibble_processor;

architecture rtl of nibble_processor is
    signal count        : natural   := 0;
    signal ready_int    : std_logic := '0';
begin

    din_ready <= ready_int;

    process(clk)
        begin   
            if rising_edge(clk) then
                ready_int   <= '0';
                count       <= count + 1;

                if count = 4 then
                    count       <= 0;
                    ready_int   <= '1';
                end if;
            end if;
    end process;

    process(clk)
            variable tmp : std_logic;
        begin
            if rising_edge(clk) then
                dout_valid <= '0';

                if ready_int then 
                    for j in 0 to 1 loop
                        for i in 0 to (DATA_WIDTH/2)-1 loop
                            if i = 0 then
                                tmp := din_data(j*(DATA_WIDTH/2));
                            else
                                tmp := tmp and din_data(j*(DATA_WIDTH/2) + 1); 
                            end if;
                        end loop;
                        dout_data(j) <= tmp;
                    end loop;
                    dout_valid <= '1';
                end if;
            end if;
    end process;

end architecture;
