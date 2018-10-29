module uart_alu_interface
  #(
    parameter N_DATA = 8,
    parameter PARITY_CHECK = 1,
    parameter N_WORD_BUFFER = 4,
    parameter NB_OPERATION = 6
    )
   (
    output reg [N_DATA-1:0]         o_alu_data_a,
    output reg [N_DATA-1:0]         o_alu_data_b,
    output reg [NB_OPERATION-1:0]   o_alu_data_op,
    output [N_DATA-1:0]             o_tx_data,

    input [N_DATA-1:0]              i_alu_data,
    input [N_DATA+PARITY_CHECK-1:0] i_rx_data,
    input                           i_rx_done, i_tx_done,
    input                           i_rst, i_clk
    );

   localparam N_STATES = 3;
   localparam NB_STATES = $clog2(N_STATES);

   localparam DATA_A = 0;
   localparam DATA_B = 1;
   localparam DATA_OP = 2;

   wire [N_DATA+PARITY_CHECK-1:0]   rx_data;
   wire                             rx_empty;
   wire                             tx_full;
   wire                             rx_read;
   reg                              state[NB_STATES-1:0];
   reg                              prev_state[NB_STATES-1:0];

   assign rx_read = ~rx_empty;
   assign o_tx_data = i_alu_data;

   always @ (posedge i_clk) begin
      prev_state <= state;
      if (i_rst) begin
         o_alu_data_a <= {N_DATA{1'b0}};
         o_alu_data_b <= {N_DATA{1'b0}};
         o_alu_data_op <= {N_OPERATION{1'b0}};
         state <= {NB_STATES{1'b0}};
      end
      else begin
         if(~rx_empty) begin

            case(state)
              DATA_A: begin
                 o_alu_data_a <= rx_data[N_DATA-1:0]; // TODO: parity es el MSB o LSM?
                 state <= state+1;
              end
              DATA_B: begin
                 o_alu_data_b <= rx_data[N_DATA-1:0]; // TODO: parity es el MSB o LSM?
                 state <= state+1;
              end
              DATA_OP: begin
                 o_alu_data_OP <= rx_data[NB_OPERATION-1:0]; // TODO: parity es el MSB o LSM?
                 state <= {NB_STATES{1'b0}};
              end
              default: begin
                 o_alu_data_a <= {N_DATA{1'b0}};
                 o_alu_data_b <= {N_DATA{1'b0}};
                 o_alu_data_op <= {N_OPERATION{1'b0}};
                 state <= {NB_STATES{1'b0}};
              end
            endcase
         end
      end
   end

   //TODO: terminar
   always@(posedge i_clk) begin
      if(state == DATA_OP) begin
         if(~tx_full)
           tx_write <= 1'b1;
         else
      end
   end
   FIFO#(
         .NB_WORD(N_DATA+PARITY_CHECK),
         .N_WORD_BUFFER(N_WORD_BUFFER)
         )
   u_FIFO_rx(
             .o_data(o_alu_data),
             .o_fifo_empty(rx_empty),
             .o_fifo_full(), //not connected
             .i_data(i_rx_data),
             .i_read(rx_read),
             .i_write(i_rx_done),
             .i_rst(i_rst),
             .i_clk(i_clk)
             );

   FIFO#(
         .NB_WORD(N_DATA),
         .N_WORD_BUFFER(N_WORD_BUFFER)
         )
   u_FIFO_tx(
             .o_data(o_tx_data),
             .o_fifo_empty(), //not connected
             .o_fifo_full(tx_full),
             .i_data(i_alu_data),
             .i_read(i_tx_done),
             .i_write(tx_write),
             .i_rst(i_rst),
             .i_clk(i_clk)
             );
endmodule
