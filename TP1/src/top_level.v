module top_level
  #(
    parameter NB_DATA = 4,
    parameter NB_OPERATION = 4
    )
   (
    output [3:0] o_led,
    input [3:0]  i_sw,
    input        i_clk,
    input        i_btnU,
    input        i_btnR,
    input        i_btnC,
    input        i_btnL
    );

   wire [NB_DATA-1:0] i_data;
   wire               i_clock;
   wire               i_reset;
   wire [2:0]         i_valid;

   reg [NB_DATA-1:0]  data_a ;
   reg [NB_DATA-1:0]  data_b ;
   reg [NB_OPERATION-1:0] op ;

   assign i_data = i_sw;

   assign i_valid[0] = i_btnR;
   assign i_valid[1] = i_btnC;
   assign i_valid[2] = i_btnL;

   assign i_clock = i_clk;
   assign i_reset = i_btnU;

   always @(posedge i_clock) begin
      if (i_reset) begin
         //o_result <= 'b0 ;
         data_a <= 'b0 ;
         data_b <= 'b0 ;
         op <= 'b0 ;
      end
      else begin
         case(1'b1)
           i_valid[0]: data_a <= i_data;
           i_valid[1]: data_b <= i_data;
           i_valid[2]: op <= i_data[NB_OPERATION-1:0];
         endcase
      end
   end

    alu#(
         .NB_DATA(NB_DATA),
         .NB_OPERATION(NB_OPERATION)
         )
   u_alu(
         .o_result(o_led),
         .i_data_a(data_a),
         .i_data_b(data_b),
         .i_op(op)
         );
endmodule
