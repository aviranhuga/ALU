-- ====================================================================
--
--	File Name:		min_max.vhd
--	Description:	find min or max and return it
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

entity min_max is 
generic ( N: integer :=8);
port (
	a : in std_logic_vector(N-1 downto 0);
	b : in std_logic_vector(N-1 downto 0);	
	en : in std_logic;
	LSB : in std_logic;
	min_or_max : in std_logic; -- '0' for finding min, '1' for finding max.
	result : out std_logic_vector(2*N-1 downto 0)
	);
end min_max;

architecture min_max_arch of min_max is

signal zeros: std_logic_vector(N-1 downto 0) := ( others => '0'); 

begin                                         
	process(en,a,b,LSB,min_or_max)
	begin
	check_en:if en='1' then
	equal_check:if SIGNED(a)=SIGNED(b) then -- they are equals
					result(N-1 downto 0) <= a;
				elsif LSB='1' then -- a is max
						if min_or_max='1' then -- max return
						result(N-1 downto 0) <=a;
						else
						result(N-1 downto 0) <=b;
						end if;
				else 
						if min_or_max='1' then -- max return
						result(N-1 downto 0) <=b;
						else
						result(N-1 downto 0) <=a;
						end if;
			end if equal_check;
			result(2*N-1 downto N) <= zeros;
		end if check_en;
	end process;
end min_max_arch;