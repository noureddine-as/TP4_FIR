LIBRARY ieee  ; 
USE ieee.std_logic_arith.all  ; 
USE ieee.STD_LOGIC_SIGNED.all  ;
use ieee.std_logic_1164.all;        


entity FIR_filter is
  generic(
    a3  : std_logic_vector (8 downto 0) :=  "000000110" ;  
    a1  : std_logic_vector (8 downto 0) :=  "001100000"  ;  
    a2  : std_logic_vector (8 downto 0) :=  "011000110"  ); 
  port (
    CLK : in STD_LOGIC;   -- Global clock
    Enable : in std_logic; -- Global Enable
    RSTn : in std_logic; -- Le reset global
    xin : in std_logic_vector(7 downto 0); --La valeur r�elle de l'�chantillon � l'entr�e
    y : out std_logic_vector(7 downto 0) -- la correlation symbole
  );
end FIR_filter;

architecture arch of FIR_filter is
  
  type FIFO is array(1 to 6) of std_logic_vector(7 downto 0); -- array of 8 bits
  signal my_fifo : FIFO;
  
  signal add1, add2, add3 : std_logic_vector(8 downto 0); -- 9 bits
  signal mul1, mul2, mul3 : std_logic_vector(17 downto 0); -- 18bits

  signal final_add : std_logic_vector(18 downto 0); --20 bits

begin
  
-- My Fifo
process(CLK, RSTn)  
begin
  if RSTn = '0' then
    my_fifo <=(others => (others =>  '0'));
  elsif rising_edge(CLK) then
    my_fifo(1) <= xin;
    for i in 2 to 6 loop
      my_fifo(i) <= my_fifo(i-1);
    end loop;
  end if;
end process;  
 

--s_res_add <= (s_in_retard(gBits-1)&s_in_retard) - (In_re_sr(gBits-1)&In_re_sr);

add1 <= (my_fifo(6)(7)&my_fifo(6)) + (my_fifo(1)(7)&my_fifo(1));
add2 <= (my_fifo(5)(7)&my_fifo(5)) + (my_fifo(2)(7)&my_fifo(2));
add3 <= (my_fifo(4)(7)&my_fifo(4)) + (my_fifo(3)(7)&my_fifo(3));

mul1 <= a1 * add1;
mul2 <= a2 * add2;
mul3 <= a3 * add3;

final_add <= (mul1(17)&mul1) + (mul2(17)&mul2) + (mul3(17)&mul3);


-- Shift register
process(CLK, RSTn)  
begin
  if RSTn = '0' then
    y <= (others =>  '0');
  elsif rising_edge(CLK) then
    y <= final_add(18 downto 11);
    --y <= final_add(18 downto 0);
  end if;
end process;  



end arch;



