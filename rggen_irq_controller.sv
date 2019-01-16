module rggen_irq_controller #(
  parameter TOTAL_INTERRUPTS  = 1
)(
  input   logic                         clk,
  input   logic                         rst_n,
  input   logic [TOTAL_INTERRUPTS-1:0]  i_ier,
  input   logic [TOTAL_INTERRUPTS-1:0]  i_isr,
  output  logic                         o_irq
);
  logic irq;

  assign  o_irq = irq;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      irq <= 1'b0;
    end
    else begin
      irq <= |(i_ier & i_isr);
    end
  end
endmodule
