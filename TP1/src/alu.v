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
    input wire [NB_DATA-1:0] i_data , 
    
    input wire [2:0]         i_valid , // Throughput control.
    input wire               i_reset ,
    input wire               i_clock
    
    ) ;
   //==========================================================================
   // LOCAL PARAMETERS.
   //==========================================================================
   
   //==========================================================================
   // INTERNAL SIGNALS.
   //==========================================================================
   reg [NB_DATA-1:0]         data_a ;
   reg [NB_DATA-1:0]         data_b ;
   reg [NB_OPERATION-1:0]    op ;
   
   //==========================================================================
   // ALGORITHM.
   //==========================================================================
   
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
   
   always @(*)
     begin
        case(op)
          ADD: // ADD
            o_result = data_a + data_b ; 
          SUB: // SUB
            o_result = data_a - data_b ;
          AND: // AND
            o_result = data_a & data_b ;
          OR: // OR
            o_result = data_a | data_b ;
          XOR: // XOR
            o_result = data_a ^ data_b ;
          SRA: // SRA (Arithmetic: keep sign)
            o_result = data_a >>> data_b ;
          SRL: // SRL (Logical: fills with zero)
            o_result = data_a >> data_b ;
          NOR: // NOR
            o_result = ~ (data_a & data_b);
          default: o_result = {NB_DATA{1'b1}};
        endcase
     end
   
endmodule
