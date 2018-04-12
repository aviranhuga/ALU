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
generic ( N: integer :=8);
port (
	a : in std_logic_vector(N-1 downto 0);
	b : in std_logic_vector(4 downto 0);	
	left_side : in std_logic; -- '0' for right and '1' for left
	result : out std_logic_vector(N-1 downto 0)
	);
end shift_unit;

architecture shift_unit_arch of shift_unit is
component mux31 
	port (
	a : in std_logic;	
	b : in std_logic; -- for right shift
	c : in std_logic; -- for left shift
	left_right : in std_logic; -- '0' for right shift, '1' for left
	en : in std_logic;	
	o : out std_logic
	);
end component;

--wires between different levels of shift
signal shift1_wire : std_logic_vector(N-1 downto 0);
signal shift2_wire : std_logic_vector(N-1 downto 0);
signal shift3_wire : std_logic_vector(N-1 downto 0);
signal shift4_wire : std_logic_vector(N-1 downto 0);
signal zero : std_logic;

begin              
	zero <= '0';

-- first shift line
	SHIFT1: for i in 0 to N-1 generate
		
		FIRST_MUX1: if i<1 generate
		MUX1i: mux31 port map (a=>a(i),b=>a(i+1),c=>zero,left_right=>left_side,en=>b(0),o=>shift1_wire(i));
		end generate FIRST_MUX1;	
		
		LAST_MUX1: if i>N-2 generate
		MUX1i: mux31 port map (a=>a(i),b=>zero,c=>a(i-1),left_right=>left_side,en=>b(0),o=>shift1_wire(i));
		end generate LAST_MUX1;
		
		REST_MUX1: if (i>0 and i<N-1) generate
		MUX1i: mux31 port map (a=>a(i),b=>a(i+1),c=>a(i-1),left_right=>left_side,en=>b(0),o=>shift1_wire(i));
		end generate REST_MUX1;
		
		end generate SHIFT1;
		
-- second shift line
	SHIFT2: for i in 0 to N-1 generate
	
		FIRST_MUX2: if i<2 generate
		MUX2i: mux31 port map (a=>shift1_wire(i),b=>shift1_wire(i+2),c=>zero,left_right=>left_side, en=>b(1),o=>shift2_wire(i));
		end generate FIRST_MUX2;	
	
		LAST_MUX2: if i>N-3 generate
		MUX2i: mux31 port map (a=>shift1_wire(i),b=>zero,c=>shift1_wire(i-2),left_right=>left_side, en=>b(1),o=>shift2_wire(i));
		end generate LAST_MUX2;
		
		REST_MUX2: if (i>1 and i<N-2) generate
		MUX2i: mux31 port map (a=>shift1_wire(i),b=>shift1_wire(i+2),c=>shift1_wire(i-2),left_right=>left_side,en=>b(1),o=>shift2_wire(i));
		end generate REST_MUX2;
		
		end generate SHIFT2;

-- third shift line
	SHIFT3: for i in 0 to N-1 generate
	
		FIRST_MUX3: if i<4 generate
		MUX3i: mux31 port map (a=>shift2_wire(i),b=>shift2_wire(i+4),c=>zero,left_right=>left_side, en=>b(2),o=>shift3_wire(i));
		end generate FIRST_MUX3;
		
		LAST_MUX3: if i>N-5 generate
		MUX3i: mux31 port map (a=>shift2_wire(i),b=>zero,c=>shift2_wire(i-4),left_right=>left_side, en=>b(2),o=>shift3_wire(i));
		end generate LAST_MUX3;
		
		REST_MUX3: if (i>3 and i<N-4) generate
		MUX3i: mux31 port map (a=>shift2_wire(i),b=>shift2_wire(i+4),c=>shift2_wire(i-4),left_right=>left_side,en=>b(2),o=>shift3_wire(i));
		end generate REST_MUX3;
		
		end generate SHIFT3;

-- four shift line
	SHIFT4: for i in 0 to N-1 generate
	
		FIRST_MUX44: if (i<8 and i+8>N-1) generate
		MUX4i: mux31 port map (a=>shift3_wire(i),b=>zero,c=>zero,left_right=>left_side, en=>b(3),o=>shift4_wire(i));
		end generate FIRST_MUX44;
	
		FIRST_MUX4: if (i<8 and i+8<N) generate
		MUX4i: mux31 port map (a=>shift3_wire(i),b=>shift3_wire(i+8),c=>zero,left_right=>left_side, en=>b(3),o=>shift4_wire(i));
		end generate FIRST_MUX4;
		
		LAST_MUX4: if (i>N-9 and i>7) generate
		MUX4i: mux31 port map (a=>shift3_wire(i),b=>zero,c=>shift3_wire(i-8),left_right=>left_side, en=>b(3),o=>shift4_wire(i));
		end generate LAST_MUX4;
		
		REST_MUX4: if (i>7 and i<N-8) generate
		MUX4i: mux31 port map (a=>shift3_wire(i),b=>shift3_wire(i+8),c=>shift3_wire(i-8),left_right=>left_side,en=>b(3),o=>shift4_wire(i));
		end generate REST_MUX4;
		
		end generate SHIFT4;
		
-- last shift_line
	SHIFT5: for i in 0 to N-1 generate
	
		FIRST_MUX5: if (i<16 and i+16>N-1) generate
		MUX5i: mux31 port map (a=>shift4_wire(i),b=>zero,c=>zero,left_right=>left_side, en=>b(4),o=>result(i));
		end generate FIRST_MUX5;
	
		FIRST_MUX55: if (i<16 and i+16<N) generate
		MUX5i: mux31 port map (a=>shift4_wire(i),b=>shift4_wire(i+16),c=>zero,left_right=>left_side, en=>b(4),o=>result(i));
		end generate FIRST_MUX55;
		
		LAST_MUX5: if (i>N-17 and i>15) generate
		MUX5i: mux31 port map (a=>shift4_wire(i),b=>zero,c=>shift4_wire(i-16),left_right=>left_side, en=>b(4),o=>result(i));
		end generate LAST_MUX5;
		
		REST_MUX5: if (i>15 and i<N-16) generate
		MUX5i: mux31 port map (a=>shift4_wire(i),b=>shift4_wire(i+16),c=>shift4_wire(i-16),left_right=>left_side,en=>b(4),o=>result(i));
		end generate REST_MUX5;
		
		end generate SHIFT5;

end shift_unit_arch;
