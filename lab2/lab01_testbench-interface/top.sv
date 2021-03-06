/***********************************************************************
 * A SystemVerilog top-level netlist to connect testbench to DUT
 **********************************************************************/

module top;
  timeunit 1ns/1ns;

  // user-defined types are defined in instr_register_pkg.sv
  import instr_register_pkg::*;

  // clock variables
  logic clk;
  logic test_clk;

  // interconnecting signals
  // logic          load_en;
  // logic          reset_n;
  // opcode_t       opcode;
  // operand_t      operand_a, operand_b;
  // address_t      write_pointer, read_pointer;
  // instruction_t  instruction_word;

  // instantiate testbench and connect ports
  instr_register_test test (
    .clk(test_clk),
    .load_en(ifc.load_en),
    .reset_n(ifc.reset_n),
    .operand_a(ifc.operand_a),
    .operand_b(ifc.operand_b),
    .opcode(ifc.opcode),
    .write_pointer(ifc.write_pointer),
    .read_pointer(ifc.read_pointer),
    .instruction_word(ifc.instruction_word)
   );

  // instantiate design and connect ports
  instr_register dut (
    .clk(clk),
    .load_en(ifc.load_en),
    .reset_n(ifc.reset_n),
    .operand_a(ifc.operand_a),
    .operand_b(ifc.operand_b),
    .opcode(ifc.opcode),
    .write_pointer(ifc.write_pointer),
    .read_pointer(ifc.read_pointer),
    .instruction_word(ifc.instruction_word)
   );
   
   // instantiate tb_ifc
   tb_ifc ifc(.clk(test_clk));

  // clock oscillators
  initial begin
    clk <= 0;
    forever #5  clk = ~clk;
  end

  initial begin
    test_clk <=0;
    // offset test_clk edges from clk to prevent races between
    // the testbench and the design
    #4 forever begin
      #2ns test_clk = 1'b1;
      #8ns test_clk = 1'b0;
    end
  end

endmodule: top
