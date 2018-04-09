-- ====================================================================
--
--	File Name:		mux21.vhd
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

entity mux21 is port (
	a : in std_logic;	
	b : in std_logic;	
	en : in std_logic;	
	o : out std_logic
	);
end mux21;

architecture mux21_arch of mux21 is
begin                                         
-- Design Body
	o <= (b and en) or (a and (not en));
end mux21_arch;

