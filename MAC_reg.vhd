-- ====================================================================
--
--	File Name:		MAC_reg.vhd
--	Description:	MAC register
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

entity MAC_reg is 
generic ( N: integer :=8);
port (
	data : in std_logic_vector(2*N-1 downto 0);
	clk : in std_logic;
	reset : in std_logic;
	q : out std_logic_vector(2*N-1 downto 0)
	);
end MAC_reg;

architecture MAC_reg_arch of MAC_reg is
component DFF 
	port (
	data : in std_logic;	
	clk : in std_logic;	
	reset : in std_logic;	
	q : out std_logic
	);
end component;

begin            
	Array_Of_DFFs: for i in 0 to 2*N-1 generate
		dffi: DFF port map(data => data(i),clk=>clk, reset=>reset, q=>q(i));
	end generate Array_Of_DFFs;
	
end MAC_reg_arch;