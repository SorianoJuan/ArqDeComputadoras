/*
OPERATIONS
*/

module alu
  #(
    // Parameters.
    parameter                                       NB_DATA                     = 8 ,   // Nr of bits in the registers
    parameter                                       NB_OPERATION                = 6 ,    // Nr of bits in the operation input
    localparam ADD =        4'b1000,
    localparam SUB =        4'b1010,
    localparam AND =        4'b1100,
    localparam OR  =        4'b1101,
    localparam XOR =        4'b1110,
    localparam SRA =        4'b0011,
    localparam SRL =        4'b0010,
    localparam NOR =        4'b1111
    )
   (
    // Outputs.
    output reg [NB_DATA-1:0] o_result , // Result of the operation
    
    // Inputs.
    input wire [NB_DATA-1:0] i_data_a,
    input wire [NB_DATA-1:0] i_data_b,
    input wire [NB_DATA-1:0] i_op
    ) ;
   
   wire [NB_DATA-1:0]        shifted;
   wire [NB_DATA-1:0]        ashifted;
   integer                   i;

   always @(*)
     begin
        case(i_op)
          ADD: // ADD
            o_result = i_data_a + i_data_b ;
          SUB: // SUB
            o_result = i_data_a - i_data_b ;
          AND: // AND
            o_result = i_data_a & i_data_b ;
          OR: // OR
            o_result = i_data_a | i_data_b ;
          XOR: // XOR
            o_result = i_data_a ^ i_data_b ;
          SRA: begin// SRA (Arithmetic: keep sign)
             o_result = 'b0;
             for(i = 0; i<2**NB_DATA; i=i+1) begin
                if(i_data_b == i)
                  o_result = $signed(i_data_a) >>> i;
             end
          end
          SRL: begin// SRL (Logical: fills with zero)
             o_result = 'b0;
             for(i = 0; i<2**NB_DATA; i=i+1) begin
                if(i_data_b == i)
                  o_result = i_data_a >> i;
             end
          end
          NOR: // NOR
            o_result = ~ (i_data_a & i_data_b);
          default: o_result = {NB_DATA{1'b1}};
        endcase
     end
endmodule
