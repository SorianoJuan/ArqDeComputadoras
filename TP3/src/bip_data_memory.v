module bip_data_memory
#(
    // Parameters.
    parameter 									NB_DATA = 16,
    parameter 									N_ADDR = 1024, 
    parameter 									LOG2_N_DATA_ADDR = 10
)
(
    // Outputs.
    output wire     [NB_DATA-1:0]               o_data,
    // Inputs.
    input  wire 	[LOG2_N_DATA_ADDR-1:0]		i_addr, // Address to read/write from
    input  wire     [NB_DATA-1:0]		        i_data,
    input  wire                                 i_clock,
    input  wire                                 i_wr, //Write enable
    input  wire                                 i_rd, //Read enable
    input  wire                                 i_reset 				
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
        else if (i_wr)
            mem_bank[i_addr] <= i_data ; //Write
        else if (i_rd)
            data <= mem_bank[i_addr]; //Read
        end
    end

endmodule