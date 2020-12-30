library work;
use work.all;

configuration case_1_config of bench_framework_nibble_processor is
  for arch 
    for dut : uut
      use entity nibble_processor;
    end for;
  end for;
end case_1_config;
