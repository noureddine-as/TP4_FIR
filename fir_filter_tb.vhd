LIBRARY ieee  ; 
USE ieee.std_logic_1164.all  ; 
USE ieee.numeric_std.all;

use std.textio.ALL;

ENTITY fir_filter_tb  IS 
  GENERIC (
  a3  : std_logic_vector (8 downto 0)   := "010110110" ;  
  a1  : std_logic_vector (8 downto 0)   := "000000110" ;  
  a2  : std_logic_vector (8 downto 0)   := "001100000" ); 
   -- a3  : std_logic_vector (8 downto 0) :=  "000000110" ;  
   -- a1  : std_logic_vector (8 downto 0) :=  "001100000"  ;  
   -- a2  : std_logic_vector (8 downto 0) :=  "011000110"  );
END ; 
 
ARCHITECTURE fir_filter_tb_arch OF fir_filter_tb IS
  SIGNAL y   :  std_logic_vector (7 downto 0)  ; 
  SIGNAL CLK   :  STD_LOGIC  ; 
  SIGNAL xin   :  std_logic_vector (7 downto 0)  ; 
  SIGNAL RSTn   :  STD_LOGIC  ; 
  SIGNAL Enable   :  STD_LOGIC  ; 
  COMPONENT FIR_filter  
    GENERIC ( 
      a3  : std_logic_vector (8 downto 0) ; 
      a1  : std_logic_vector (8 downto 0) ; 
      a2  : std_logic_vector (8 downto 0)  );  
    PORT ( 
      y  : out std_logic_vector (7 downto 0) ; 
      CLK  : in STD_LOGIC ; 
      xin  : in std_logic_vector (7 downto 0) ; 
      RSTn  : in STD_LOGIC ; 
      Enable  : in STD_LOGIC ); 
  END COMPONENT ; 
BEGIN
  DUT  : FIR_filter  
    GENERIC MAP ( 
      a3  => a3  ,
      a1  => a1  ,
      a2  => a2   )
    PORT MAP ( 
      y   => y  ,
      CLK   => CLK  ,
      xin   => xin  ,
      RSTn   => RSTn  ,
      Enable   => Enable   ) ; 
      
RSTn 		<= '0', '1' after 5 ns;
Enable <= '1';
      
P: process
begin
  clk <= '0';
  wait for 10 ns;
  clk <= '1';
  wait for 10 ns;
end process P;

LECTURE : process
  variable L,M	: LINE;
  file ENTREE	 : TEXT is in	"D:\TPs\TP_FPGA_PDSP\PDSP\TP4_FIR\data_in.txt"; 		--nom de fichier des échantillons
  file SORTIE	 : TEXT is out	"D:\TPs\TP_FPGA_PDSP\PDSP\TP4_FIR\data_outtt.txt"; 
  variable A,B	: integer := 0;
 
begin
	wait for 10 ns;
	READLINE(ENTREE, L);
	READ(L,A);
	xin 		<= std_logic_vector(TO_SIGNED(A,8)) after 2 ns;
	--in_im		<= std_logic_vector(TO_SIGNED(-A,gBits)) after 2 ns;
	wait for 10 ns; 

	WRITE(M,to_INTEGER(SIGNED(y))	,LEFT, 6);
	WRITELINE(SORTIE, M);
	
end process LECTURE;
      
      
END ; 

