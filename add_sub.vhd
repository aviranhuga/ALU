-- ====================================================================
--
--	File Name:		add_sub.vhd
--	Description:	adder and subtracter using Full Header
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

entity add_sub is 
generic ( N: integer :=8);
port (
	x : in std_logic_vector(N-1 downto 0);
	y : in std_logic_vector(N-1 downto 0);	
	sub : in std_logic;
	result : out std_logic_vector(N-1 downto 0);
	cout : out std_logic
	);
end add_sub;

architecture add_sub_arch of add_sub is
component FA 
	port (
	x : in std_logic;	
	y : in std_logic;	
	cin : in std_logic;	
	sum : out std_logic;
	cout : out std_logic
	);
end component;

signal moving_carry: std_logic_vector(N-2 downto 0); 
signal y_subtract : std_logic_vector(N-1 downto 0);

begin                                         
-- Design Body
	SUBTRACT: for j in 0 to N-1 generate
		y_subtract(j) <= sub xor y(j);
		end generate SUBTRACT;

	Array_Of_FA: for i in 0 to N-1 generate
	
		LSB: if i=0 generate
			FAi: FA port map (x(0),y_subtract(0),sub,result(0),moving_carry(0));
			end generate LSB;
			
		MSB: if i=N-1 generate
			FAi: FA port map (x(i),y_subtract(i),moving_carry(i-1),result(i),cout);
			end generate MSB;
			
		REST_OF_BITS: if ((i/=0) AND (i/=N-1))  generate
			FAi: FA port map (x(i),y_subtract(i),moving_carry(i-1), result(i), moving_carry(i));
			end generate REST_OF_BITS;
			
	end generate Array_Of_FA;

end add_sub_arch;
