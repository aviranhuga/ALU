-- ====================================================================
--
--	File Name:		dff.vhd
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

entity dff is port (
	data : in std_logic;	
	clk : in std_logic;	
	reset : in std_logic;	
	q : out std_logic;
	q_not : out std_logic
	);
end dff;

architecture dff_arch of dff is
begin                                         
-- Design Body
	process(clk)
	 begin
	 if rising_edge(clk) then
		if reset='1' then
			q <= '0';
		else
			q <= data;
		end if
		q_not <= not data;
		end if
	end process
end dff_arch;

