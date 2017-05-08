module rggen_bus_splitter #(
  parameter int DATA_WIDTH      = 32,
  parameter int TOTAL_REGISTERS = 1
)(
  input                     clk,
  input                     rst_n,
  rggen_bus_if.slave        bus_if,
  rggen_register_if.master  register_if[TOTAL_REGISTERS]
);
  import  rggen_rtl_pkg::*;

  typedef struct packed {
    logic [DATA_WIDTH-1:0]  read_data;
    rggen_status            status;
  } s_response;

  logic [TOTAL_REGISTERS-1:0] select;
  logic [TOTAL_REGISTERS-1:0] ready;
  logic                       response_ready;
  logic                       no_register_selected;
  logic                       done;
  logic                       read_done;
  logic                       write_done;
  s_response                  response;

  assign  bus_if.done       = done;
  assign  bus_if.read_done  = read_done;
  assign  bus_if.write_done = write_done;
  assign  bus_if.read_data  = response.read_data;
  assign  bus_if.status     = response.status;

  generate if (1) begin : g
    genvar  i;
    for (i = 0;i < TOTAL_REGISTERS;i++) begin : g
      assign  register_if[i].request      = bus_if.request;
      assign  register_if[i].address      = bus_if.address;
      assign  register_if[i].direction    = bus_if.direction;
      assign  register_if[i].write_data   = bus_if.write_data;
      assign  register_if[i].write_strobe = bus_if.write_strobe;
      assign  register_if[i].write_mask   = get_write_mask();
      assign  select[i]                   = register_if[i].select;
      assign  ready[i]                    = register_if[i].ready;
    end
  end endgenerate

  function automatic logic [DATA_WIDTH-1:0] get_write_mask();
    logic [DATA_WIDTH-1:0]  write_mask;
    for (int i = 0;i < DATA_WIDTH;i += 8) begin
      write_mask[i+:8]  = {8{bus_if.write_strobe[i/8]}};
    end
    return write_mask;
  endfunction

  assign  response_ready        =  |ready;
  assign  no_register_selected  = ~|select;
  always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      done        <= '0;
      read_done   <= '0;
      write_done  <= '0;
      response    <= '{'0, RGGEN_OKAY};
    end
    else if (bus_if.request && (response_ready || no_register_selected) && (!done)) begin
      done        <= '1;
      write_done  <= (bus_if.direction == RGGEN_WRITE) ? '1 : '0;
      read_done   <= (bus_if.direction == RGGEN_READ ) ? '1 : '0;
      if (response_ready) begin
        response  <= get_response();
      end
      else begin
        response  <= '{'0, RGGEN_SLAVE_ERROR};
      end
    end
    else begin
      done        <= '0;
      read_done   <= '0;
      write_done  <= '0;
      response    <= '{'0, RGGEN_OKAY};
    end
  end

  function automatic s_response get_response ();
    s_response  masked_response[TOTAL_REGISTERS];
    for (int i = 0;i < TOTAL_REGISTERS;++i) begin
      logic                   select    = register_if[i].select;
      logic [DATA_WIDTH-1:0]  read_data = register_if[i].read_data;
      rggen_status            status    = register_if[i].status;
      masked_response[i].read_data  = read_data & {DATA_WIDTH{1'b1}};
      masked_response[i].status     = rggen_status'(status & {$size(rggen_status){select}});
    end
    return masked_response.or();
  endfunction
endmodule
