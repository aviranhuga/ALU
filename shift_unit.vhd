-- ====================================================================
--
--	File Name:		shift_unit.vhd
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

entity shift_unit is 
generic ( N: integer :=32);
port (
	a : in std_logic_vector(N-1 downto 0);
	b : in std_logic_vector(3 downto 0);	
	left_side : in std_logic;
	result : out std_logic_vector(N-1 downto 0)
	);
end shift_unit;

architecture shift_unit_arch of shift_unit is
component mux21 
	port (
	a : in std_logic;	
	b : in std_logic;	
	en : in std_logic;	
	o : out std_logic
	);
end component;

signal shift1_wire : std_logic_vector(N-1 downto 0);
signal shift2_wire : std_logic_vector(N-1 downto 0);
signal shift3_wire : std_logic_vector(N-1 downto 0);
signal zero : std_logic;

begin              
	zero <= '0';
-- first shift line
	SHIFT1: for i in 0 to N-1 generate
	
		LAST_MUX1: if i=N-1 generate
		MUX1i: mux21 port map (a=>a(i),b=>zero,en=>b(0),o=>shift1_wire(i));
		end generate LAST_MUX1;
		
		REST_MUX1: if i/=N-1 generate
		MUX1i: mux21 port map (a=>a(i),b=>a(i+1),en=>b(0),o=>shift1_wire(i));
		end generate REST_MUX1;
		
		end generate SHIFT1;
		
-- second shift line
	SHIFT2: for i in 0 to N-1 generate
	
		LAST_MUX2: if i>N-3 generate
		MUX2i: mux21 port map (a=>shift1_wire(i),b=>zero,en=>b(1),o=>shift2_wire(i));
		end generate LAST_MUX2;
		
		REST_MUX2: if i<N-2 generate
		MUX2i: mux21 port map (a=>shift1_wire(i),b=>shift1_wire(i+2),en=>b(1),o=>shift2_wire(i));
		end generate REST_MUX2;
		
		end generate SHIFT2;

-- third shift line
	SHIFT3: for i in 0 to N-1 generate
	
		LAST_MUX3: if i>N-5 generate
		MUX3i: mux21 port map (a=>shift2_wire(i),b=>zero,en=>b(2),o=>shift3_wire(i));
		end generate LAST_MUX3;
		
		REST_MUX3: if i<N-4 generate
		MUX3i: mux21 port map (a=>shift2_wire(i),b=>shift2_wire(i+4),en=>b(2),o=>shift3_wire(i));
		end generate REST_MUX3;
		
		end generate SHIFT3;

-- last shift line
	SHIFT4: for i in 0 to N-1 generate
	
		LAST_MUX4: if i>N-9 generate
		MUX4i: mux21 port map (a=>shift3_wire(i),b=>zero,en=>b(3),o=>result(i));
		end generate LAST_MUX4;
		
		REST_MUX4: if i<N-8 generate
		MUX4i: mux21 port map (a=>shift3_wire(i),b=>shift3_wire(i+8),en=>b(3),o=>result(i));
		end generate REST_MUX4;
		
		end generate SHIFT4;
		
end shift_unit_arch;
