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
    parameter                                       NB_DATA                     = 4 ,   // Nr of bits in the registers
    parameter                                       NB_OPERATION                = 6     // Nr of bits in the operation input
)
(
    // Outputs.
    output  reg         [NB_DATA-1:0]               o_result ,      // Result of the operation

    // Inputs.
    input   wire        [NB_DATA-1:0]               i_data_a ,      // Operand a
    input   wire        [NB_DATA-1:0]               i_data_b ,      // Operand b
    input   wire        [NB_OPERATION-1:0]          i_operation ,   // Operation code

    input   wire                                    i_valid ,       // Throughput control.
    input   wire                                    i_reset ,
    input   wire                                    i_clock

) ;
    //==========================================================================
    // LOCAL PARAMETERS.
    //==========================================================================

    //==========================================================================
    // INTERNAL SIGNALS.
    //==========================================================================
    wire                [NB_DATA-1:0]               result ;

    //==========================================================================
    // ALGORITHM.
    //==========================================================================

    always @(posedge i_clock) begin
        if (i_reset) begin
            o_result <= 1'b0 ;
        end
    end

    always @(*)
    begin
        case(i_operation)
        6'b100000: // ADD
            result = i_data_a + i_data_b ; 
        6'b100010: // SUB
            result = i_data_a - i_data_b ;
        6'b100100: // AND
            result = i_data_a & i_data_b ;
        6'b100101: // OR
            result = i_data_a | i_data_b ;
        6'b100110: // XOR
            result = i_data_a ^ i_data_b ;
        6'b000011: // SRA (Arithmetic: keep sign)
            result = i_data_a >>> i_data_b ;
        6'b000010: // SRL (Logical: fills with zero)
            result = i_data_a >> i_data_b ;
        6'b100111: // NOR
            result = ~ (i_data_a & i_data_b)
        default: result = i_data_a + i_data_b ; 
        endcase
    end

    always @(posedge i_clock) begin
        if (i_valid) begin
            o_result <= result ;
        end
    end
    

endmodule
