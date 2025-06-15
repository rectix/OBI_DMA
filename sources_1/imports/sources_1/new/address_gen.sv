`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2025 05:05:39 PM
// Design Name: 
// Module Name: address_gen
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








//=============================================================================
//   I have to kno w if the dirst read op is done  to send the next address
// I have to find the right timing to send the new address 
/// how switch the address to share_1 bases addr 

//=============================================================================


//Mak the address update i the amian file comb since we ned to ipdate it quickly 
// THe actual delay to get the new request address is 1 CC                             !!!!!!!!!!!!!!!



module address_gen #(parameter ADDR_WIDTH     = 32,
                     parameter SUB_SHARES     = 3
                    )
(  ///SHOULD SPECIFY A SELECTOR FOR WHICH SHARE AND WRITRE :READ  
    input logic  clk_i,
    input logic  nreset_i,
    
    
    //input logic STATUS_done_i,
    
    input logic [ADDR_WIDTH-1 : 0] CFG_share_0_start_raddr_i,
    input logic [ADDR_WIDTH-1 : 0] CFG_share_1_start_raddr_i,
    input logic [ADDR_WIDTH-1 : 0] CFG_share_0_start_waddr_i, // NOT USED YET
    input logic [ADDR_WIDTH-1 : 0] CFG_share_1_start_waddr_i,
    
    input logic master_rready_i,
    input logic mem_rvalid_i,
    input logic load_store_i,
    
    
    output logic [ADDR_WIDTH-1 : 0]  master_addr_o,
    output logic addr_valid_o
    
    );
    
    localparam  BYTE_OFFSET = 4;
    typedef enum logic [1:0] {
        LOOP,
        GEN,
        EXIT  // should go to the share_1 load 
    } fsm_t;
//=======================================================
 logic [ADDR_WIDTH-1 : 0]  share_0_base_addr;
 logic [ADDR_WIDTH-1 : 0]  share_1_base_addr;
 logic [ADDR_WIDTH-1 : 0]  output_addr;
 logic [2 : 0]             count;
 logic                     generate_next ;
 fsm_t                     state;
 logic                     addr_valid; 
 logic [ADDR_WIDTH - 1 : 0]  next_addr_space, current_addr_space, addr_space, addr;
 
 

//=======================================================    

initial  begin 
state       =  LOOP;
output_addr =  '0;

end 




//=======================================================    





always_comb 
begin
generate_next       =   mem_rvalid_i && master_rready_i;
addr_valid          =  (output_addr[1:0] == '0) ? 1'b1 : 1'b0;
//if(STATUS_done_i)  begin
    current_addr_space  =  (load_store_i==1'b1 ) ? CFG_share_0_start_raddr_i : CFG_share_0_start_waddr_i ;
    next_addr_space     =  (load_store_i==1'b1 ) ? CFG_share_1_start_raddr_i : CFG_share_1_start_waddr_i ;
//end 
end











/*    
always @(posedge clk_i or negedge nreset_i) 
begin 

if(!nreset_i)
begin
    //output_addr    <= current_addr_space;
   
    
    
    count          <= 0; 
    state          <= LOOP ;

end else begin


    case(state)
  LOOP: begin
            if(count == SUB_SHARES -1)
            begin 
                addr_space    <=next_addr_space ;
            
            end else begin
                addr_space  <=  current_addr_space ; 
            end 
  
            if(generate_next && (count < SUB_SHARES) )begin
                 count <= count + 1;
                 state <= GEN;
            end else begin
                 state  <= LOOP;
            end
            
        end
  GEN : begin
            
            //output_addr <= output_addr + BYTE_OFFSET ; 
            //output_addr  <= addr;
            
            
            output_addr <= addr_space + ((count) << 2);
            state <= LOOP;
           

        end
    endcase
        

 


end





end //always    
    
*/





//=================================================================    
//   OUTPUT ASSIGNEMENT 
//=================================================================    
    
assign  master_addr_o  = output_addr;  
assign  addr_valid_o   = addr_valid;
  
    
    
    
    
    
endmodule




/*

module address_gen #(
    parameter ADDR_WIDTH = 32,
    parameter SUB_SHARES = 3
)(
    input  logic                    clk_i,
    input  logic                    nreset_i,

    input  logic [ADDR_WIDTH-1:0]   CFG_share_0_start_raddr_i,
    input  logic [ADDR_WIDTH-1:0]   CFG_share_1_start_raddr_i,
    input  logic [ADDR_WIDTH-1:0]   CFG_share_0_start_waddr_i,
    input  logic [ADDR_WIDTH-1:0]   CFG_share_1_start_waddr_i,

    input  logic                    master_rready_i, // OBI address handshake
    input  logic                    load_store_i,    // 1=read, 0=write

    output logic [ADDR_WIDTH-1:0]   master_addr_o,
    output logic                    addr_valid_o
);

    localparam BYTE_OFFSET = 4; // 4-byte word offset

    typedef enum logic [1:0] {
        IDLE,   // Waiting state
        ISSUE   // Address issue state
    } fsm_t;

    // Internal signals
    fsm_t                   state;
    logic [ADDR_WIDTH-1:0]  addr_space;    // Current share base address
    logic [2:0]             count;         // For SUB_SHARES
    logic [ADDR_WIDTH-1:0]  output_addr;   // Currently generated address
    logic [ADDR_WIDTH-1:0]  share0_base_addr, share1_base_addr;

    // Base address selection (combinational)
    always_comb begin
        share0_base_addr = (load_store_i) ? CFG_share_0_start_raddr_i : CFG_share_0_start_waddr_i;
        share1_base_addr = (load_store_i) ? CFG_share_1_start_raddr_i : CFG_share_1_start_waddr_i;
    end

    // FSM Sequential logic
    always_ff @(posedge clk_i or negedge nreset_i) begin
        if (!nreset_i) begin
            state        <= IDLE;
            addr_space   <= '0;
            output_addr  <= '0;
            count        <= 3'd0;
            addr_valid_o <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    addr_space   <= share0_base_addr;   
                    output_addr  <= share0_base_addr;   
                    count        <= 3'd0;
                    addr_valid_o <= 1'b1;               
                    state        <= ISSUE;
                end

                ISSUE: begin
                    addr_valid_o <= 1'b1; 

                    if (master_rready_i) begin
                        count       <= count + 1'b1;
                        output_addr <= output_addr + BYTE_OFFSET; 

                        if (count == (SUB_SHARES - 1)) begin
                            addr_space   <= share1_base_addr;    // Switch to share 1
                            output_addr  <= share1_base_addr;    // Load share 1 base address
                            count        <= 3'd0;
                        end
                    end
                end
            endcase
        end
    end


    assign master_addr_o = output_addr;

endmodule


*/






