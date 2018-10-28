module bip_program_memory
#(
    // Parameters.
    parameter 									NB_DATA = 16,
    parameter 									N_ADDR = 2048,
    parameter 									LOG2_N_INSMEM_ADDR = 11
)
(
    // Outputs.
    output wire     [NB_DATA-1:0]               o_data,
    // Inputs.
    input  wire 	[LOG2_N_INSMEM_ADDR-1:0]    i_addr, // Signal from control unit
    input  wire 								i_clock,
    input  wire 								i_enable,
    input  wire 								i_reset 							
) ;	

    //==========================================================================
    // LOCAL PARAMETERS.
    //==========================================================================


    //==========================================================================
    // INTERNAL SIGNALS.
    //==========================================================================
    reg             [NB_DATA-1:0]               mem_bank [N_ADDR-1:0] ;
    reg             [NB_DATA-1:0]               data ;                            

    //==========================================================================
    // ALGORITHM.
    //==========================================================================

    assign o_data = data ;

    always @ (posedge i_clock)
    begin
        if (i_reset)
            data <= {NB_DATA{1'b0}};
        else if (i_enable)
            data <= mem_bank[i_addr];
    end

endmodule