----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/07/2025 07:03:01 PM
-- Design Name: 
-- Module Name: OBI_SLAVE_IF - Behavioral
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

entity OBI_SLAVE_IF is

    generic (WIDTH : integer := 32;
             DEPTH : integer := 32   
            );
    
    Port ( clk_i : in STD_LOGIC;
    
           req_i : in STD_LOGIC;
           we_i : in STD_LOGIC;
           gnt_o : out STD_LOGIC;
           rready_i : in STD_LOGIC;
           rvalid_o : out STD_LOGIC;
           rdata_o : out std_logic_vector(WIDTH-1 downto 0);
           wdata_i : in std_logic_vector(WIDTH-1 downto 0);
           addr_i  : in std_logic_vector(WIDTH-1 downto 0);
           be_i    : in std_logic_vector(3 downto 0)   -- a mask that filter the valid bytes 
           
           );
           


end OBI_SLAVE_IF;

architecture Behavioral of OBI_SLAVE_IF is
signal gnt, rvalid:std_logic := '0';

type mem_t is array (0 to DEPTH-1) of std_logic_vector(WIDTH-1 downto 0);
signal mem:mem_t   := (
    0  => std_logic_vector(to_unsigned( 1, 32)),
    1  => std_logic_vector(to_unsigned( 1, 32)),
    2  => std_logic_vector(to_unsigned( 2, 32)),
    3  => std_logic_vector(to_unsigned( 3, 32)),
    4  => std_logic_vector(to_unsigned( 4, 32)),
    5  => std_logic_vector(to_unsigned( 5, 32)),
    6  => std_logic_vector(to_unsigned( 6, 32)),
    7  => std_logic_vector(to_unsigned( 7, 32)),
    8  => std_logic_vector(to_unsigned( 8, 32)),
    9  => std_logic_vector(to_unsigned( 9, 32)),
    10 => std_logic_vector(to_unsigned(10, 32)),
    11 => std_logic_vector(to_unsigned(11, 32)),
    12 => std_logic_vector(to_unsigned(12, 32)),
    13 => std_logic_vector(to_unsigned(13, 32)),
    14 => std_logic_vector(to_unsigned(14, 32)),
    15 => std_logic_vector(to_unsigned(15, 32)),
    16 => std_logic_vector(to_unsigned(16, 32)),
    17 => std_logic_vector(to_unsigned(17, 32)),
    18 => std_logic_vector(to_unsigned(18, 32)),
    19 => std_logic_vector(to_unsigned(19, 32)),
    20 => std_logic_vector(to_unsigned(20, 32)),
    21 => std_logic_vector(to_unsigned(21, 32)),
    22 => std_logic_vector(to_unsigned(22, 32)),
    23 => std_logic_vector(to_unsigned(23, 32)),
    24 => std_logic_vector(to_unsigned(24, 32)),
    25 => std_logic_vector(to_unsigned(25, 32)),
    26 => std_logic_vector(to_unsigned(26, 32)),
    27 => std_logic_vector(to_unsigned(27, 32)),
    28 => std_logic_vector(to_unsigned(28, 32)),
    29 => std_logic_vector(to_unsigned(29, 32)),
    30 => std_logic_vector(to_unsigned(30, 32)),
    31 => std_logic_vector(to_unsigned(31, 32))
);




--==========================================================
--     LATCHED SIGNALS
--==========================================================

signal buff_we, buff_rready: std_logic;
signal buff_wdata, buff_addr: std_logic_vector (WIDTH-1 downto 0);





--==========================================================
--  
--==========================================================
begin

buff_we     <= we_i;
buff_rready <= rready_i;
buff_wdata  <= wdata_i;
buff_addr   <= addr_i;


gnt_o <= gnt;
rvalid_o <= rvalid;
process(clk_i) 
begin 

if(rising_edge(clk_i)) then 
 gnt <= '0';

if(req_i = '1' and gnt='0' and rvalid ='0') then 
    gnt <= '1';
end if;



end if;

end process;

process(clk_i) 
begin 

if(rising_edge(clk_i)) then 


if( gnt='1' and rvalid = '0') then 
    rvalid <= '1';  
elsif(buff_rready = '1' ) then 
    rvalid <= '0';  
  
end if;

end if;

end process;




process(clk_i)
begin 
if(rising_edge(clk_i)) then 

--if(rready_i = '1'  and rvalid ='1') then 
if( gnt='1' and rvalid = '0') then 
        if(buff_we='1') then 
        
            mem(to_integer(unsigned(buff_addr))) <= buff_wdata; 
        else 
            rdata_o <= mem (to_integer(unsigned(buff_addr)));
        end if;     
    
end if;


end if;


end process;

end Behavioral;
