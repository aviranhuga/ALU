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
	en_status: in std_logic;
	result : out std_logic_vector(7 downto 0);
	cout : out std_logic;
	status: out std_logic_vector(5 downto 0)
	);
end component;  

signal A : std_logic_vector(7 downto 0);
signal B : std_logic_vector(7 downto 0);
signal innerResult : std_logic_vector(7 downto 0);
signal innersub : std_logic;
signal innerCout : std_logic;
signal innerStatus : std_logic_vector(5 downto 0);
signal innerEnStatus : std_logic;

begin
        tester : add_sub
        port map(x=>A, y=>B, sub=>innersub,en_status=>innerEnStatus ,result=>innerResult,cout=>innerCout, status=> innerStatus);
		
		testbench : process
        begin
		   A <= "10100111";
      	B <= "10100111" ;
	      innersub <= '1';
	      innerEnStatus <='1';
	      wait for 1 ns;
	      innerEnStatus <='0';
	    --output should be 00000110
      wait for 10 ns;
		  A <= "00000111" ;
	    B <= "00001111" ;
	    innersub <= '1';
	    innerEnStatus <='1';
	    wait for 1 ns;
	     innerEnStatus <='0';
	    --output should be 11111111
	    wait for 10 ns;

	    A <= "00001111";
	    B <= "00000100";
	    innersub <= '1';

	    --output should be 00000000
	    wait for 10 ns;

	    A <= "00000001" ;
	    B <= "00000001" ;
	    innersub <= '1';
	    innerEnStatus <='1';
	    wait for 1 ns;
	     innerEnStatus <='0';
	    --output should be 00000111 
	    wait for 10 ns;
        end process testbench;
        
end rtl;
