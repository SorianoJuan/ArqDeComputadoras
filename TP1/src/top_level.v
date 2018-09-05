module top_level
  #(
    parameter NB_DATA = 4,
    parameter NB_OPERATION = 4
    )
   (
    output [3:0] led,
    input [3:0]  sw, btn,
    input        CLK100MHZ,
    input        ck_rst
    );

    alu#(
         .NB_DATA(NB_DATA),
         .NB_OPERATION(NB_OPERATION)
         )
   u_alu(
         .o_result(led),
         .i_data(sw),
         .i_valid(btn[2:0]),
         .i_reset(ck_rst),
         .i_clock(CLK100MHZ)
         );
endmodule
