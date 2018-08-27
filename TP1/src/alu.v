/*
OPERATIONS
ADD         100000
SUB         100010
AND         100100
OR          100101
XOR         100110
SRA         000011
SRL         000010
NOR         100111
*/

module alu
  #(
    // Parameters.
    parameter                                       NB_DATA                     = 8 ,   // Nr of bits in the registers
    parameter                                       NB_OPERATION                = 6     // Nr of bits in the operation input
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
          6'b100000: // ADD
            o_result = data_a + data_b ; 
          6'b100010: // SUB
            o_result = data_a - data_b ;
          6'b100100: // AND
            o_result = data_a & data_b ;
          6'b100101: // OR
            o_result = data_a | data_b ;
          6'b100110: // XOR
            o_result = data_a ^ data_b ;
          6'b000011: // SRA (Arithmetic: keep sign)
            o_result = data_a >>> data_b ;
          6'b000010: // SRL (Logical: fills with zero)
            o_result = data_a >> data_b ;
          6'b100111: // NOR
            o_result = ~ (data_a & data_b);
          default: o_result = {NB_DATA{1'b1}};
        endcase
     end
   
endmodule
