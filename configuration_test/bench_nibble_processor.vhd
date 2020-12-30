library work;

entity bench_nibble_processor_case_1 is
end entity;

architecture sim of bench_nibble_processor_case_1 is
  begin
    FRAMEWORK : entity work.bench_framework_nibble_processor
      generic map(
        DATA_WIDTH => 2
      );
end architecture;
