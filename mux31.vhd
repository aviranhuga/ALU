-- ====================================================================
--
--	File Name:		mux31.vhd
--	Description:	mux 2 to 1
--					
--
--	Date:			7/07/2018
--	Designer:		Aviran Huga
--
-- ====================================================================


-- libraries decleration
library ieee;
use ieee.std_logic_1164.all;

entity mux31 is port (
	a : in std_logic;	
	b : in std_logic; -- for right shift
	c : in std_logic; -- for left shift
	left_right : in std_logic; -- '0' for right shift, '1' for left
	en : in std_logic;	
	o : out std_logic
	);
end mux31;

architecture mux31_arch of mux31 is
begin                                         
-- Design Body
	process(en,a,b,c,left_right)
		begin
		if (en='0') then
			o <= a;
		elsif (left_right='0') then
			o <= b;
		else 
			o <= c;
		end if;
	end process;
end mux31_arch;

