----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/07/2025 07:03:01 PM
-- Design Name: 
-- Module Name: OBI_MASTER_IF - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--    input  share_0_idx_01_i,  //apply the offset to the write data since its 12'bit  
--    input  share_0_idx_23_i,


entity OBI_MASTER_IF is
    generic (WIDTH : integer := 32
            
             
               );
    
    Port ( clk_i    : in STD_LOGIC;
           nreset_i : in STD_LOGIC;
           req_o    : out STD_LOGIC;
           we_o     : out STD_LOGIC;
           gnt_i    : in STD_LOGIC;
           rready_o : out STD_LOGIC;
           rvalid_i : in STD_LOGIC;
           rdata_i  : in std_logic_vector(WIDTH-1 downto 0);
           wdata_o  : out std_logic_vector(WIDTH-1 downto 0);
           addr_o   : out std_logic_vector(WIDTH-1 downto 0);
           be_o     : out std_logic_vector(3  downto 0); 
           
           -- from the internal module 
           start_single_write_i: in std_logic;
           start_single_read_i : in std_logic;
           
           wfifo_wdata_i  : in std_logic_vector(WIDTH-1 downto 0);
           wfifo_rdata_o  : out std_logic_vector(WIDTH-1 downto 0);
           generated_addr_i   : in std_logic_vector(WIDTH-1 downto 0);
           addr_valid_i     : in std_logic
           --op_done            : in std_logic   --- a confirmer  !!!



           
           
           
           
           
           );
end OBI_MASTER_IF;

architecture Behavioral of OBI_MASTER_IF is

type state_t is (IDLE, ADDR_PHASE, RESP_PHASE,EXIT_ST);
signal state : state_t;
signal rready, start, we: std_logic := '0';

signal req : std_logic := '0' ;
signal latched_addr: std_logic_vector(WIDTH-1 downto 0);
signal be    : std_logic_vector(3  downto 0);  

signal req_count: unsigned(2 downto 0)  :=   (others=>'0');
begin
  rready_o <= rready;
  we_o     <=  we;
  req_o    <=  req;
  be_o     <=  be;

-------------------------------------------------------------------
-- UPGRADE : TRIGGER SYSTEM TO SAMPLE THE ACCEPTA TRANSACTION DURING THE REPONSE PHASE 

-------------------------------------------------------------------




process(clk_i , nreset_i)
begin 

if(rising_edge(clk_i) or falling_edge(nreset_i))  then 
 

if(addr_valid_i = '1') then 
    latched_addr  <= generated_addr_i;   -- noramlly we don't need it 
end if ;
 
 
 if(nreset_i = '0')then 
    state       <= IDLE;
    req         <= '0';
    rready      <= '0';
    we          <= '0';
    addr_o      <= (others=>'0');
    wdata_o     <= (others=>'0');
    be          <= (others=>'0');
 else
    be     <=  (others => '1');

  

 
 case state is 
     when IDLE =>
        req <= '0';
        rready <= '0';
        
        
        if(start_single_read_i = '1') then
        req     <= '1'; 
        req_count <= req_count + 1;
        we      <= '0';
        addr_o  <= latched_addr;          -- o^o
        state   <= ADDR_PHASE;
         
        elsif(start_single_write_i = '1') then 
        req <= '1';
        req_count <= req_count + 1;
        we   <= '1';
        addr_o  <= latched_addr;          -- o^o;
        wdata_o <= wfifo_wdata_i ;        -- o^o;
        state   <= ADDR_PHASE;
        
        
        end if;
        
        
    
    when ADDR_PHASE => 
        if(gnt_i='1') then 
            req <= '0';
            rready <= '1';
            state <= RESP_PHASE;
        end if;
     
    

    
when RESP_PHASE =>  
    if(rvalid_i='1')then
        rready <= '0'; 
        if(start_single_read_i = '1'  or   start_single_write_i = '1') then 
         req  <= '1';        
        end  if ; 
        
        if(we = '0') then 
        wfifo_rdata_o <= rdata_i;  
          
        end if ;
       --- state <= IDLE;
      end  if ; 
       
      if(req_count < "100" )   then       
        state <= IDLE;
     else 
       state  <= EXIT_ST;
     
      end if;
    
    
    
       
when others => 
    state <= IDLE;
     
 end case;
 
 


end if;
end if; 

 
end process;





end Behavioral;