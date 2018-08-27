module tb_alu();
   
   parameter NB_DATA = 8;
   parameter NB_OPERATION = 6;
   
   wire [NB_DATA-1:0] o_res;
   
   reg [NB_DATA-1:0]  i_data;
   reg                i_clock, i_reset;
   reg [2:0]          i_valid;
   

   initial begin
      i_clock = 1'b0;
      i_reset = 1'b0;
      i_valid = 'b0;
      i_data = 'b0;
      
      #2 i_reset = 1'b1;
      #4 i_reset = 1'b0;

      #10 i_data = 3;
      #12 i_valid = 3'b001;
      #14 i_valid = 3'b000;

      #18 i_data = 4;
      #20 i_valid = 3'b010;
      #22 i_valid = 3'b000;
      
      #26 i_data = 100000;
      #28 i_valid = 3'b100;
      #30 i_valid = 3'b000;

      #40 $finish;
   end

   always #2 i_clock = ~i_clock;

   alu#(
        .NB_DATA(NB_DATA),
        .NB_OPERATION(NB_OPERATION)
        )
   u_alu(
         .o_result(o_res),
         .i_data(i_data),
         .i_valid(i_valid),
         .i_reset(i_reset),
         .i_clock(i_clock)
         );

endmodule
