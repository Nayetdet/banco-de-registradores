module tb_register_file;
  localparam DATA_WIDTH  = 8;
  localparam NUM_REGS    = 4;
  localparam INDEX_WIDTH = $clog2(NUM_REGS);

  logic                   clock;
  logic                   reset;
  logic                   wr_en;
  logic [INDEX_WIDTH-1:0] add_rd0;
  logic [INDEX_WIDTH-1:0] add_rd1;
  logic [INDEX_WIDTH-1:0] add_wr;
  logic [DATA_WIDTH-1:0]  wr_data;
  logic [DATA_WIDTH-1:0]  rd0;
  logic [DATA_WIDTH-1:0]  rd1;

  localparam N = 100;
  logic [13:0] testvectors_in  [N-1:0];
  logic [15:0] testvectors_out [N-1:0];
  logic [DATA_WIDTH-1:0] expected_rd0;
  logic [DATA_WIDTH-1:0] expected_rd1;

  register_file dut (clock, reset, wr_en, add_rd0, add_rd1, add_wr, wr_data, rd0, rd1);
  always #5 clock = ~clock;

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(clock, add_rd0, add_rd1, add_wr, wr_data, rd0, rd1);

    clock = 1; reset = 0; wr_en = 0; add_rd0 = 0; add_rd1 = 0; add_wr = 0; wr_data = 0;
    reset = 1; @(posedge clock); reset = 0;

    $readmemb("testvectors_in.txt", testvectors_in, 0, N-1);
    $readmemb("testvectors_out.txt", testvectors_out, 0, N-1);

    for (int i = 0; i < N; i++) begin
      {add_rd0, add_rd1, add_wr, wr_data} = testvectors_in[i];
      {expected_rd0, expected_rd1} = testvectors_out[i];
      @(posedge clock);

      assert((rd0 === expected_rd0) && (rd1 === expected_rd1));
        else $error(
          "rd0=%b, expected_rd0=%b, rd1=%b, expected_rd1=%b",
          rd0, expected_rd0, rd1, expected_rd1
        );
    end
    $finish;
  end
endmodule
