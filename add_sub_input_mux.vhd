-- ====================================================================
--
--	File Name:		add_sub_input_mux.vhd
--	Description:	Arithmentic unit add/sub unit input mux
--					
--
--	Date:			7/07/2018
--	Designer:		Aviran Huga
--
-- ====================================================================


-- libraries decleration
library ieee;
use ieee.std_logic_1164.all;

entity add_sub_input_mux is
generic( N: integer :=8);
port (
	input_a : in std_logic_vector(N-1 downto 0);--main input
	input_b : in std_logic_vector(N-1 downto 0);--main input
	inputMUL_a : in std_logic_vector(2*N-1 downto 0);-- MUL input
	inputMAC_b : in std_logic_vector(2*N-1 downto 0);-- MAC input
	SEL : in std_logic; -- '0' for main input
	A_OUT : out std_logic_vector(2*N-1 downto 0);
	B_OUT : out std_logic_vector(2*N-1 downto 0)
	);
end add_sub_input_mux;

architecture add_sub_input_mux_arch of add_sub_input_mux is
signal zeros: std_logic_vector(N-1 downto 0) := ( others => '0'); 
begin                                         
-- Design Body
	process(input_a,input_b,SEL)
		begin
		if SEL='0' then 
					A_OUT <= (others => input_a(N-1));
					A_OUT(N-1 downto 0) <= input_a;
					B_OUT <= (others => input_b(N-1));
					B_OUT(N-1 downto 0) <= input_b;
		else 
			    A_OUT <= inputMUL_a;
				  B_OUT <= inputMAC_b;
			end if;
	end process;
end add_sub_input_mux_arch;