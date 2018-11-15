module bip_uart_interface
  #(
    parameter                                   NB_DATA = 16,
    parameter                                   LOG2_N_INSMEM_ADDR = 11,
    parameter                                   NB_DATATX = 8,
    parameter                                   N_WORD_BUFFER = 4
    )
   (
    output [NB_DATATX-1:0]         o_data,
    output                         o_tx_start,
    output                         o_valid,

    input                          i_tx_done,
    input                          i_clk, i_rst,
    input [NB_DATA-1:0]            i_acc, i_instruction,
    input [LOG2_N_INSMEM_ADDR-1:0] i_nclock
    );

   wire [3*NB_DATATX-1:0]          ext_data;
   wire [NB_DATATX-1:0]            tx_i_data;
   wire                            fifo_full;
   wire                            neg_tx_start;
   reg [1:0]                       state;
   reg                             valid_reg;

   assign o_tx_start = ~neg_tx_start;
   
   always@(posedge i_clk)begin
      valid_reg <= o_valid;
      if(i_rst)
        state <= 2'b00;
      else begin
        if(!fifo_full)
          state <= state +1'b1;
      end
   end

   assign o_valid = (state==2'b00) & valid_reg;
   
   assign ext_data = {
                       i_acc[NB_DATATX-1:0],
                       i_instruction[NB_DATATX-1:0],
                       i_nclock[NB_DATATX-1:0]
                       };

   assign tx_i_data = ext_data[state*NB_DATATX-:NB_DATATX];

   FIFO#(
         .NB_WORD(NB_DATATX),
         .N_WORD_BUFFER(N_WORD_BUFFER)
         )
   u_FIFO(
          .o_data(o_data),
          .o_fifo_empty(neg_tx_start),
          .o_fifo_full(fifo_full), //not connected
          .i_data(tx_i_data),
          .i_read(i_tx_done),
          .i_write(~fifo_full),
          .i_rst(i_rst),
          .i_clk(i_clk)
          );
endmodule
