-- ====================================================================
--
--	File Name:		MUL.vhd
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
use ieee.std_logic_arith.all;

entity MUL is 
generic ( N: integer :=8);
port (
	x : in std_logic_vector(N-1 downto 0);
	y : in std_logic_vector(N-1 downto 0);
	en: in std_logic;
	result : out std_logic_vector(2*N-1 downto 0)
	);
end MUL;

architecture MUL_arch of MUL is
begin                                         
-- Design Body
	process(x,y,en)
	begin
		if en='1' then
		result <= SIGNED(x) * SIGNED(y);
		end if;
	end process;
end MUL_arch;

