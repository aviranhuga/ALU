-- ====================================================================
--
--	File Name:		shift_unit_tb.vhd
--	Description:	shift_unit_tb 
--					
--
--	Date:			4/07/2018
--	Designer:		Aviran Huga
--
-- ====================================================================


library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity shift_unit_tb is
end shift_unit_tb;

architecture rtl of shift_unit_tb is  

component shift_unit
port (
	a : in std_logic_vector(31 downto 0);
	b : in std_logic_vector(3 downto 0);	
	left_side : in std_logic;
	result : out std_logic_vector(31 downto 0)
	);
end component;  

signal A : std_logic_vector(31 downto 0);
signal B : std_logic_vector(3 downto 0);
signal innerResult : std_logic_vector(31 downto 0);
signal innerLeft : std_logic;

begin
        tester : shift_unit
        port map(a=>A, b=>B, left_side=>innerLeft ,result=>innerResult);
		
		testbench : process
        begin
		innerLeft <= '0';
		A <= "00011000000110000001100000011000";
      	B <= "0111" ;
	    wait for 10 ns; 
	    A <= "00011000000110000001100000011000";
      	B <= "0010" ;
	    wait for 10 ns;
		A <= "10000000100000001000000010000000";
      	B <= "1010" ;
	    wait for 10 ns;
		A <= "10000000100000001000000010000000";
      	B <= "1111" ;
	    wait for 10 ns;
		
    end process testbench;
		
        
end rtl;