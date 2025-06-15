`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2025 10:07:35 AM
// Design Name: 
// Module Name: fifo_shares
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
    //input  share_0_idx_01_i,  //apply the offset to the write data since its 12'bit  
    //input  share_0_idx_23_i,   /// those signal s should be uese in the master in terface 
                               // have to check the obi / CPU endianna  to know how to deecod ethe input data 
                               ///  shoul dalso check where the offset is added ==>  at the begennig or the end of the word 





module fifo_shares_0 #(parameter DEPTH = 4, WIDTH = 32)  //

(
    input   clk_i,
    input   nreset_i,

                               
                               
    input fifo_wr_en_i,
    input fifo_rd_en_i,                           
                               
    input  [WIDTH-1: 0] input_share_0_xx, 
    output [WIDTH-1: 0] output_share_0_xx,                           
                               
    
    output    fifo_full_o,
    output    fifo_empty_o
    );

//============================================================

logic [2:0]  fifo_elt;
logic fifo_full, fifo_empty;
logic [WIDTH-1: 0] output_share_0;   
logic [WIDTH-1:0] mem[0:DEPTH-1]  = '{
  32'd0, 32'd0, 32'd0, 32'd0
};
 
 

//initial begin 

//output_share_0 = 0;
//end 


 


//============================================================
        
always @(posedge clk_i or negedge nreset_i)
begin
if(!nreset_i)  begin

  fifo_elt     <= '0;
  
 
  

end else begin



        if(fifo_wr_en_i && !fifo_full)
        begin
            
                mem[fifo_elt]   <=  input_share_0_xx; 
                fifo_elt        <=  fifo_elt   + 1;
                    
        end else if(fifo_rd_en_i && !fifo_empty)
        begin 
              
                output_share_0    <=  mem[DEPTH - fifo_elt];
                fifo_elt        <=  fifo_elt   - 1; 
              
        end 
        
end
end //always 





always_comb  begin 

fifo_empty <= (fifo_elt == 0       ) ? 1 : 0 ;
fifo_full  <= (fifo_elt  == DEPTH  ) ? 1 : 0 ;

end 

   
    
//============================================================

assign fifo_full_o   = fifo_full;
assign fifo_empty_o  = fifo_empty;
assign output_share_0_xx = output_share_0 ;




//============================================================
    
    
    
endmodule
