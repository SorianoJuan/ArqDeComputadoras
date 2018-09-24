

module uart_rx 
#(
    // Parameters.
    parameter                                   NB_DATA         = 8 , // Parallelism meaning how many bits of information are ready to be sent
    parameter                                   N_DATA          = 8 , // Nr of bits from frame
    parameter                                   LOG2_N_DATA     = 4 , // LOG2 (N_DATA+PARITY)
    parameter                                   PARITY_CHECK    = 1 , // 1 If parity check is enabled, otherwise 0
    parameter                                   EVEN_ODD_PARITY = 1 , // 1 If parity is even, 0 if it's odd 
    parameter                                   M_STOP          = 1 , // Nr of bits from stop 
    parameter                                   LOG2_M_STOP     = 1                            
)
(
    // Outputs.
    output  reg                                 o_data ,
    output  reg                                 tx_done ,   // Data is sent
    // Inputs.
    input   wire    [NB_DATA-1:0]               i_data ,
    input   wire                                tx_start ,
    input   wire                                i_valid ,   // Throughput control.

    input   wire                                i_reset ,
    input   wire                                i_clock
) ;

    //==========================================================================
    // LOCAL PARAMETERS.
    //==========================================================================

    // FSM
    localparam                                  NB_STATE        = 2 ;
    localparam      [NB_STATE-1:0]              ST_0_IDLE       = 0 ;
    localparam      [NB_STATE-1:0]              ST_1_START      = 1 ;
    localparam      [NB_STATE-1:0]              ST_2_DATA       = 2 ;
    localparam      [NB_STATE-1:0]              ST_3_STOP       = 3 ;

    // Other
    localparam                                  MAX_TIMER       = 15 ;
    localparam                                  NB_TIMER        = 4 ;

    localparam                                  NB_N_DATA_COUNTER = LOG2_N_DATA ;
    localparam                                  NB_M_STOP_COUNTER = LOG2_M_STOP ;                            

    //==========================================================================
    // INTERNAL SIGNALS.
    //==========================================================================
    reg             [NB_TIMER-1:0]                  timer ;
    wire                                            time_out ;

    wire                                            max_n_data_counter ;
    wire                                            max_m_stop_counter ;

    reg             [LOG2_N_DATA-1:0]               n_data_counter ;
    reg             [LOG2_M_STOP-1:0]               m_stop_counter ;

    // FSM
    reg             [NB_STATE-1:0]                  state ;
    reg             [NB_STATE-1:0]                  next_state ;

    //==========================================================================
    // ALGORITHM.
    //==========================================================================

    //----------------------------------
    //FSM
    //----------------------------------

    // State update.
    always @( posedge i_clock )
    begin
        if ( i_reset )
            state <= ST_0_IDLE ;
        else if ( i_valid )
            state <= next_state ;
    end

    // Calculate next state and FSM outputs.
    always @( * )
    begin

        next_state                  = ST_0_IDLE ;

        case ( state )
            ST_0_IDLE :
            begin
                casez ( {} )

                endcase

            end

            ST_1_START :
            begin
                casez ( {} )

                endcase

            end

            ST_2_DATA :
            begin
                casez ( {} )

                endcase

            end

            ST_3_STOP :
            begin
                casez ( {} )

                endcase

            end

        endcase
    end


    //----------------------------------
    //OTHER LOGIC
    //----------------------------------

    // Timer logic
    /*
    Timer que cuenta ticks para sincronizar los datos.
    */
    //TODO: Ver tema de racing condition entre timeout para el contador de n y m
    always @( posedge i_clock )
    begin
        if ( i_reset || i_valid && fsmo_reset_timer || time_out )
            timer <= {NB_TIMER{1'b0}} ;
        else if ( i_valid && !time_out )
            timer <= timer + 1'b1 ;
    end

    assign time_out = ( timer >= MAX_TIMER ) ;

    assign sampling_timeout = (( timer >= 7 ) && fsmo_middle_sampling ) ;

    // N_DATA Counter
    /*
    Contador que cuenta la cantidad de bits de datos en el frame.
    Al llegar a max_n_data_counter, se resetea.
    */
    always @( posedge i_clock )
    begin
        if ( i_reset || i_valid && fsmo_reset_n_data_counter )
            n_data_counter <= {NB_N_DATA_COUNTER{1'b0}} ;
        else if ( i_valid && !max_n_data_counter && time_out)
            n_data_counter <= n_data_counter + 1'b1 ;
    end

    assign max_n_data_counter = ( n_data_counter >= (N_DATA + PARITY_CHECK) ) ;

    // M_STOP Counter
    /*
    Contador que cuenta la cantidad de bits de stop en el frame.
    Al llegar a max_m_stop_counter, se resetea.
    */
    always @( posedge i_clock )
    begin
        if ( i_reset || i_valid && fsmo_reset_m_stop_counter )
            m_stop_counter <= {NB_M_STOP_COUNTER{1'b0}} ;
        else if ( i_valid && !max_m_stop_counter && time_out)
            m_stop_counter <= m_stop_counter + 1'b1 ;
    end

    assign max_m_stop_counter = ( m_stop_counter >= M_STOP) ;    

endmodule