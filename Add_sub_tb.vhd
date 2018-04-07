-- ====================================================================
--
--	File Name:		Add_sub_tb.vhd
--	Description:	add-sub testbench  
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


entity Add_sub_tb is
end Add_sub_tb;

architecture rtl of Add_sub_tb is  

component add_sub
port (
	x : in std_logic_vector(7 downto 0);
	y : in std_logic_vector(7 downto 0);	
	sub : in std_logic;
	result : out std_logic_vector(7 downto 0);
	cout : out std_logic
	);
end component;  

signal A : std_logic_vector(7 downto 0);
signal B : std_logic_vector(7 downto 0);
signal innerResult : std_logic_vector(7 downto 0);
signal innersub : std_logic;
signal innerCout : std_logic;

begin
        tester : add_sub
        port map(x=>A, y=>B, sub=>innersub ,result=>innerResult,cout=>innerCout);
		
		testbench : process
        begin
        A <= "10101101";
      		B <= "10100111" ;
	      innersub <= '1';
	      --output should be 00000110
        wait for 10 ns;
        A <= "01110111" ;
	     	B <= "10001000" ;
	      innersub <= '0';
	      --output should be 11111111
	      wait for 10 ns;
	      A <= "01000001";
	      B <= "01000001";
	      innersub <= '1';
	      --output should be 00000000
	      wait for 10 ns;
	      A <= "00101010" ;
	     	B <= "00100011" ;
	      innersub <= '1';
	      --output should be 00000111 
	      wait for 10 ns;
        end process testbench;
        
end rtl;
