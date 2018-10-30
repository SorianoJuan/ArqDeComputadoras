module tb_top_level();

   localparam NB_DATA        = 1 ;
   localparam N_DATA         = 8 ;
   localparam LOG2_N_DATA    = 4 ;
   localparam PARITY_CHECK   = 0 ;
   localparam EVEN_ODD_PARITY = 1 ;
   localparam M_STOP         = 1 ;
   localparam LOG2_M_STOP    = 1 ;


   // Outputs.
   wire    [N_DATA+PARITY_CHECK-1:0]           		  o_data;
   
   // Inputs.
   reg [NB_DATA-1:0]                                i_data;
   reg                                          	  i_clk;
   reg                                          	  i_rst;

   reg [((N_DATA+PARITY_CHECK+M_STOP+1)*2)-1:0]     data ;

   initial begin
      i_clk = 1'b0;
      i_rst = 1'b0;
      i_data = 'b0 ;
      data = 'b01100100000100111011101 ;
      //frame recibido 1) 11101110 0
      //frame recibido 2) 00001001 1 Con error de paridad
      
      #2 i_rst = 1'b1;
      #4 i_rst = 1'b0;

      #5000 $finish;

   end

   always #2 i_clk = ~i_clk;

   always @ (posedge i_clk)
     begin
        if (u_tl.brgen_valid_urx)
      	  data <= data>>1'b1 ;
      	i_data <= data ;
     end

   top_level
     u_tl(
          .o_data(o_data),
          .i_data(i_data),
          .i_clk(i_clk),
          .i_rst(i_rst)
          );

endmodule
