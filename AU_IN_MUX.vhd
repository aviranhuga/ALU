-- ====================================================================
--
--	File Name:		AU_IN_MUX.vhd
--	Description:	Arithmentic unit input mux
--					
--
--	Date:			7/07/2018
--	Designer:		Aviran Huga
--
-- ====================================================================


-- libraries decleration
library ieee;
use ieee.std_logic_1164.all;

entity AU_IN_MUX is
generic ( N: integer :=8);
port (
	input_a : in std_logic_vector(N-1 downto 0);
	input_b : in std_logic_vector(N-1 downto 0);	
	SEL : in std_logic;
	output1_a : out std_logic_vector(N-1 downto 0);--output for add/sub
	output1_b : out std_logic_vector(N-1 downto 0);	
	output2_a : out std_logic_vector(N-1 downto 0);--output for mul
	output2_b : out std_logic_vector(N-1 downto 0)		
	);
end AU_IN_MUX;

architecture AU_IN_MUX_arch of AU_IN_MUX is

begin                                         
-- Design Body
	process(input_a,input_b,SEL)
		begin
		if SEL='0' then
					output1_a <= input_a;
					output1_b <= input_b;
		else
					output2_a <= input_a;
					output2_b <= input_b;
			end if;
	end process;
end AU_IN_MUX_arch;