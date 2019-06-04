module hazard_unit
  #(
    parameter NB_REG_ADDR   = 5,
    parameter NB_OPCODE     = 6

    )
   (
    output                  o_hazard,

    input                   i_re, // es un LOAD
    input [NB_OPCODE-1:0]    i_op,
    input [NB_REG_ADDR-1:0] i_rd,
    input [NB_REG_ADDR-1:0] i_rs,
    input [NB_REG_ADDR-1:0] i_rt
    ) ;

   assign o_hazard = ((i_rd == i_rs) | (i_rd == i_rt)) & i_re;

endmodule
