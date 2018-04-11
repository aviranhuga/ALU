-- ====================================================================
--
--	File Name:		MUL_tb.vhd
--	Description:	MUL testbench  
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


entity MUL_tb is
end MUL_tb;

architecture rtl of MUL_tb is  

component MUL
  
port (
	x : in std_logic_vector(7 downto 0);
	y : in std_logic_vector(7 downto 0);
	clock: in std_logic;
	result : out std_logic_vector(15 downto 0)
	);
end component;  

signal clk : std_logic;
signal A : std_logic_vector(7 downto 0);
signal B : std_logic_vector(7 downto 0);
signal innerResult : std_logic_vector(15 downto 0);

begin
        tester : MUL
        port map(x=>A, y=>B, clock=>clk ,result=>innerResult);
		
		testbench : process
        begin
		clk <= '0';
        A <= "00000111";
      	B <= "00000011" ;
		--output should be 21
	    wait for 10 ps;
		clk <= '1';
        wait for 10 ns;
		
		clk <= '0';
        A <= "01111111";
      	B <= "01111111" ;
		--output should be 21
	    wait for 10 ps;
		clk <= '1';
        wait for 10 ns;
		
		clk <= '0';
        A <= "01010111";
      	B <= "00000000" ;
		--output should be 0
	    wait for 10 ps;
		clk <= '1';
        wait for 10 ns;
        end process testbench;
		
        
end rtl;