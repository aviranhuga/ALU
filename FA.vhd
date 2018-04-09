-- ====================================================================
--
--	File Name:		FA.vhd
--	Description:	full adder 
--					
--
--	Date:			7/07/2018
--	Designer:		Aviran Huga
--
-- ====================================================================


-- libraries decleration
library ieee;
use ieee.std_logic_1164.all;

entity FA is port (
	x : in std_logic;	
	y : in std_logic;	
	cin : in std_logic;	
	sum : out std_logic;
	cout : out std_logic
	);
end FA;

architecture FA_arch of FA is
begin                                         
-- Design Body
	sum <= x xor y xor cin;
	cout <= (x and y) or (y and cin) or (x and cin);
end FA_arch;

