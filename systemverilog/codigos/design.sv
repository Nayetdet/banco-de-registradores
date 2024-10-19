module register_file #(
  parameter DATA_WIDTH  = 8,
  parameter NUM_REGS    = 4,
  parameter INDEX_WIDTH = $clog2(NUM_REGS)
)(
  input  logic                   clock,
  input  logic                   reset,
  input  logic                   wr_en,
  input  logic [INDEX_WIDTH-1:0] add_rd0,
  input  logic [INDEX_WIDTH-1:0] add_rd1,
  input  logic [INDEX_WIDTH-1:0] add_wr,
  input  logic [DATA_WIDTH-1:0]  wr_data,
  output logic [DATA_WIDTH-1:0]  rd0,
  output logic [DATA_WIDTH-1:0]  rd1
);
  integer i;
  logic [DATA_WIDTH-1:0] registers [NUM_REGS-1:0];

  always_ff @(posedge clock, posedge reset) begin
    if (reset) begin
      for (i = 0; i < NUM_REGS; i++) begin
        registers[i] <= 0;
      end
    end
    else if (!wr_en) begin
      registers[add_wr] <= wr_data;
    end
  end

  assign rd0 = registers[add_rd0];
  assign rd1 = registers[add_rd1];
endmodule
