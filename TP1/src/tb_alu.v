module tb_alu();
   
   parameter NB_DATA = 4;
   parameter NB_OPERATION = 4;
   localparam SRA =        4'b0011;
   
   wire [NB_DATA-1:0] o_res;
   
   reg [NB_OPERATION-1:0] i_op;
   reg [NB_DATA-1:0]      i_data_a;
   reg [NB_DATA-1:0]      i_data_b;
   

   initial begin
      i_data_a = 'b0;
      i_data_b = 'b0;
      i_op = 'b0;

      #10 i_data_a = 13;

      #18 i_data_b = 1;
      
      #26 i_op = SRA;

      #40 $finish;
   end

   alu#(
        .NB_DATA(NB_DATA),
        .NB_OPERATION(NB_OPERATION)
        )
   u_alu(
         .o_result(o_res),
         .i_data_a(i_data_a),
         .i_data_b(i_data_b),
         .i_op(i_op)
         );
endmodule
