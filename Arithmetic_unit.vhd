-- ====================================================================
--
--	File Name:		Arithmetic_unit.vhd
--	Description:	Arithmetic unit implement
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

entity Arithmetic_unit is 
generic ( N: integer :=8);
port (
	A : in std_logic_vector(N-1 downto 0);
	B : in std_logic_vector(N-1 downto 0);	
	Opcode : in std_logic_vector(3 downto 0);
	clk : in std_logic;
	HI : out std_logic_vector(N-1 downto 0);
	LO : out std_logic_vector(N-1 downto 0);
	status: out std_logic_vector(5 downto 0)
	);
end Arithmetic_unit;

architecture Arithmetic_unit_arch of Arithmetic_unit is

component add_sub 
generic( N: integer :=8);
port (
	x : in std_logic_vector(2*N-1 downto 0);
	y : in std_logic_vector(2*N-1 downto 0);	
	sub : in std_logic;
	result : out std_logic_vector(2*N-1 downto 0)
	);
end component;

component AU_IN_MUX 
generic( N: integer :=8);
port (
	input_a : in std_logic_vector(N-1 downto 0);
	input_b : in std_logic_vector(N-1 downto 0);	
	SEL : in std_logic;
	output1_a : out std_logic_vector(N-1 downto 0);--output for add/sub
	output1_b : out std_logic_vector(N-1 downto 0);	
	output2_a : out std_logic_vector(N-1 downto 0);--output for mul
	output2_b : out std_logic_vector(N-1 downto 0)
	);
end component;

component AU_OUT_MUX 
generic( N: integer :=8);
port (
	input_a : in std_logic_vector(2*N-1 downto 0);-- ADD/SUB  Output
	input_b : in std_logic_vector(2*N-1 downto 0);-- MUL  output
	input_c : in std_logic_vector(2*N-1 downto 0);-- MIN_MAX output
	SEL : in std_logic_vector(1 downto 0);
	TRIGGER : in std_logic;
	output_LO : out std_logic_vector(N-1 downto 0);	
	output_HI : out std_logic_vector(N-1 downto 0)	
	);
end component;

component MAC_reg 
generic( N: integer :=8);
port (
	data : in std_logic_vector(2*N-1 downto 0);
	clk : in std_logic;
	reset : in std_logic;
	q : out std_logic_vector(2*N-1 downto 0)
	);
end component;

component min_max 
generic( N: integer :=8);
port (
	a : in std_logic_vector(N-1 downto 0);
	b : in std_logic_vector(N-1 downto 0);	
	en : in std_logic;
	min_or_max : in std_logic; -- '0' for finding min, '1' for finding max.
	result : out std_logic_vector(2*N-1 downto 0)
	);
end component;

component MUL 
generic( N: integer :=8);
port (
	x : in std_logic_vector(N-1 downto 0);
	y : in std_logic_vector(N-1 downto 0);
	en: in std_logic;
	result : out std_logic_vector(2*N-1 downto 0)
	);
end component;

component mux_21 
generic( N: integer :=8);
port (
	input : in std_logic_vector(2*N-1 downto 0);
	SEL : in std_logic;
	output_a : out std_logic_vector(2*N-1 downto 0); 
	output_b : out std_logic_vector(2*N-1 downto 0) 
	);
end component;

component add_sub_input_mux 
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
end component;


-- control signals
signal MAC_OP_CONTROL: std_logic_vector(1 downto 0) := "00";--AU control line for mac
signal AU_IN_MUX_SEL: std_logic; --'0' for add/sub, '1' for mul
signal AU_OUT_MUX_SEL: std_logic_vector(1 downto 0); --'00' for add/sub '01' for mul '10' for min/max other-'0'
signal AU_OUT_MUX_TRIGGER: std_logic := '0'; --Toggle to change output
signal MAC_reg_reset: std_logic; -- '1' for reset
signal MAC_reg_en: std_logic; -- '1' for en
signal add_sub_input_mux_en : std_logic; -- '0' for A B , '1' for mac op
signal add_sub_sub : std_logic; -- '0' for add , '1' for subtract
signal ADD_SUB_OUT_Reg_en: std_logic; -- '1' for enable output
signal MUL_en: std_logic; -- '1' for enable
signal MUL_OUT_MUX_SEL: std_logic; -- '0' for output, '1' for mac
signal min_max_en: std_logic; -- '1' for enable
signal min_max_choose: std_logic; --'1' for max


-- connection signals
signal AU_IN_MUX_output1_a: std_logic_vector(N-1 downto 0);
signal AU_IN_MUX_output1_b: std_logic_vector(N-1 downto 0);
signal AU_IN_MUX_output2_a: std_logic_vector(N-1 downto 0);
signal AU_IN_MUX_output2_b: std_logic_vector(N-1 downto 0);


signal Add_sub_out_reg: std_logic_vector(2*N-1 downto 0);

signal MAC_reg_q: std_logic_vector(2*N-1 downto 0);

signal MUL_OUTPUT_MUX_a: std_logic_vector(2*N-1 downto 0);
signal MUL_OUTPUT_MUX_b: std_logic_vector(2*N-1 downto 0);

signal ADD_SUB_INPUT_A: std_logic_vector(2*N-1 downto 0);
signal ADD_SUB_INPUT_B: std_logic_vector(2*N-1 downto 0);

signal ADD_SUB_RESULT: std_logic_vector(2*N-1 downto 0);
signal MUL_RESULT: std_logic_vector(2*N-1 downto 0);
signal min_max_result: std_logic_vector(2*N-1 downto 0);
signal eq: std_logic;
signal zero : std_logic := '0';

begin
	--component init
	AU_OUT_MUX_s: AU_OUT_MUX
		generic map(N)
		port map(
		input_a => Add_sub_out_reg,
		input_b => MUL_OUTPUT_MUX_a,
		input_c => min_max_result,
		SEL => AU_OUT_MUX_SEL,
		TRIGGER => AU_OUT_MUX_TRIGGER,
		output_LO => LO,
		output_HI => HI);
	
	min_max_s: min_max
		generic map (N)
		port map(
		a => A,
		b => B,
		en => min_max_en,
		min_or_max => min_max_choose,
		result => min_max_result);
		
	MUL_OUT_MUX_s: mux_21
		generic map (N)
		port map(
		input => MUL_RESULT,
		SEL => MUL_OUT_MUX_SEL,
		output_a => MUL_OUTPUT_MUX_a,
		output_b => MUL_OUTPUT_MUX_b);
		
	MUL_s: MUL
		generic map (N)
		port map(
		x => AU_IN_MUX_output2_a,
		y => AU_IN_MUX_output2_b,
		en => MUL_en,
		result =>MUL_RESULT);
	
	ADD_SUB_OUT_REG_s: MAC_reg
		generic map (N)
		port map(
		data => ADD_SUB_RESULT,
		clk => ADD_SUB_OUT_Reg_en,
		reset => zero,
		q => Add_sub_out_reg);
	
	add_sub_s: add_sub
		generic map (N)
		port map(
		x => ADD_SUB_INPUT_A,
		y => ADD_SUB_INPUT_B,
		sub => add_sub_sub,
		result => ADD_SUB_RESULT);
		
	add_sub_input_mux_s: add_sub_input_mux
		generic map (N)
		port map(
		input_a => AU_IN_MUX_output1_a,
		input_b => AU_IN_MUX_output1_b,
		inputMUL_a => MUL_OUTPUT_MUX_b,
		inputMAC_b => MAC_reg_q,
		SEL => add_sub_input_mux_en,
		A_OUT => ADD_SUB_INPUT_A,
		B_OUT => ADD_SUB_INPUT_B);
	
	MAC_reg_s: MAC_reg
		generic map (N)
		port map(
		data => Add_sub_out_reg,
		clk => MAC_reg_en,
		reset => MAC_reg_reset,
		q => MAC_reg_q);
			
	AU_IN_MUX_s: AU_IN_MUX
		generic map(N)
		port map(
		input_a => A, 
		input_b => B,
		SEL => AU_IN_MUX_SEL,
		output1_a => AU_IN_MUX_output1_a,
		output1_b => AU_IN_MUX_output1_b,
		output2_a => AU_IN_MUX_output2_a,
	    output2_b => AU_IN_MUX_output2_b);
			   	   
			    	   
	--status handle process
	process(A,B,add_sub_sub,ADD_SUB_RESULT,Opcode)
	begin
	if (add_sub_sub='1' and Opcode="0010") then -- only in SUB OP
		if SIGNED(A) = SIGNED(B) then
			eq <= '1';
		else
			eq <= '0';
		end if;
		status(0) <= eq;
		status(1) <= (not eq);
		status(2) <= eq or (not ADD_SUB_RESULT(2*N-1));
		status(3) <= (not eq) and (not ADD_SUB_RESULT(2*N-1));
		status(4) <= eq and ADD_SUB_RESULT(2*N-1);
		status(5) <= (not eq) and (ADD_SUB_RESULT(2*N-1));
	else 
		status <= (others => '0');
	end if;
	end process;

	--opcode decode and change control lines
	process(clk)
		begin
		if (rising_edge(clk)) then
		case Opcode is
			when "0001" => --ADD OPCODE
				--MAC_OP_CONTROL <= "01";--AU control for mac op (2bit)
				AU_IN_MUX_SEL <= '0';--'0' for add/sub, '1' for mul (1bit)
				AU_OUT_MUX_SEL <= "00"; --'00' for add/sub '01' for mul '10' for min/max other-'0' (2bit)
				MAC_reg_reset <= '0';-- '1' for reset (1bit)
				MAC_reg_en <= '0';-- '1' for en (1bit)
				add_sub_input_mux_en <= '0';-- '0' for A B , '1' for mac op (1bit)
				add_sub_sub <= '0';-- '0' for add , '1' for subtract (1bit)
				ADD_SUB_OUT_Reg_en <= '1';--'1' for enable output (1bit)
				MUL_en <= '0';-- '1' for enable (1bit)
				--MUL_OUT_MUX_SEL <= '0'-- '0' for output, '1' for mac (1bit)
				min_max_en <= '0';-- '1' for enable (1bit)
				--min_max_choose <= --'1' for max (1bit)
				--U_OUT_MUX_TRIGGER <= not AU_OUT_MUX_TRIGGER; 'Trigger output result"
			when "0010" => -- SUB OPCODE
				--MAC_OP_CONTROL <= "01";--AU control for mac op (2bit)
				AU_IN_MUX_SEL <= '0';--'0' for add/sub, '1' for mul (1bit)
				AU_OUT_MUX_SEL <= "00"; --'00' for add/sub '01' for mul '10' for min/max other-'0' (2bit)
				MAC_reg_reset <= '0';-- '1' for reset (1bit)
				MAC_reg_en <= '0';-- '1' for en (1bit)
				add_sub_input_mux_en <= '0';-- '0' for A B , '1' for mac op (1bit)
				add_sub_sub <= '1';-- '0' for add , '1' for subtract (1bit)
				ADD_SUB_OUT_Reg_en <= '1';-- '0' for output , '1' for mac (1bit)
				MUL_en <= '0';-- '1' for enable (1bit)
				--MUL_OUT_MUX_SEL <= '0'-- '0' for output, '1' for mac (1bit)
				min_max_en <= '0';-- '1' for enable (1bit)
				--min_max_choose <= --'1' for max (1bit)
				--U_OUT_MUX_TRIGGER <= not AU_OUT_MUX_TRIGGER; 'Trigger output result"
			when "0011" => --MUL
				--MAC_OP_CONTROL <= "01";--AU control for mac op (2bit)
				AU_IN_MUX_SEL <= '1';--'0' for add/sub, '1' for mul (1bit)
				AU_OUT_MUX_SEL <= "01"; --'00' for add/sub '01' for mul '10' for min/max other-'0' (2bit)
				MAC_reg_reset <= '0';-- '1' for reset (1bit)
				MAC_reg_en <= '0';-- '1' for en (1bit)
				--add_sub_input_mux_en <= '0';-- '0' for A B , '1' for mac op (1bit)
				--add_sub_sub <= '1';-- '0' for add , '1' for subtract (1bit)
				ADD_SUB_OUT_Reg_en <= '0';-- '1' for enable (1bit)
				MUL_en <= '1';-- '1' for enable (1bit)
				MUL_OUT_MUX_SEL <= '0';-- '0' for output, '1' for mac (1bit)
				min_max_en <= '0';-- '1' for enable (1bit)
				--min_max_choose <= --'1' for max (1bit)
				--U_OUT_MUX_TRIGGER <= not AU_OUT_MUX_TRIGGER; 'Trigger output result"
			when "0100" => -- MAC OPCODE
				case MAC_OP_CONTROL is
				when "00" =>
				MAC_OP_CONTROL <= "01";--AU control for mac op (2bit)
				AU_IN_MUX_SEL <= '1';--'0' for add/sub, '1' for mul (1bit)
				AU_OUT_MUX_SEL <= "00"; --'00' for add/sub '01' for mul '10' for min/max other-'0' (2bit)
				MAC_reg_reset <= '0';-- '1' for reset (1bit)
				MAC_reg_en <= '0'; -- '1' for en (1bit)
				add_sub_input_mux_en <= '1';-- '0' for A B , '1' for mac op (1bit)
				add_sub_sub <= '0';-- '0' for add , '1' for subtract (1bit)
				ADD_SUB_OUT_Reg_en <= '1';-- '1' for enable (1bit)
				MUL_en <= '1';-- '1' for enable (1bit)
				MUL_OUT_MUX_SEL <= '1';-- '0' for output, '1' for mac (1bit)
				min_max_en <= '0';-- '1' for enable (1bit)
				--min_max_choose <= --'1' for max (1bit)
				--U_OUT_MUX_TRIGGER <= not AU_OUT_MUX_TRIGGER; 'Trigger output result"
				when "01" =>
				MAC_OP_CONTROL <= "10";--AU control for mac op (2bit)
				when "10" =>
				MAC_OP_CONTROL <= "00";--AU control for mac op (2bit)
				ADD_SUB_OUT_Reg_en <= '0';-- '1' for enable (1bit)
				MAC_reg_reset <= '0';-- '1' for reset (1bit)
				MAC_reg_en <= '1'; -- '1' for en (1bit)
				when others => 
				MAC_OP_CONTROL <= "00";--AU control for mac op (2bit)
				end case;
			when "0101" => -- MAX OPCODE
				--MAC_OP_CONTROL <= "01";--AU control for mac op (2bit)
				--AU_IN_MUX_SEL <= '0';--'0' for add/sub, '1' for mul (1bit)
				AU_OUT_MUX_SEL <= "10"; --'00' for add/sub '01' for mul '10' for min/max other-'0' (2bit)
				MAC_reg_reset <= '0';-- '1' for reset (1bit)
				MAC_reg_en <= '0';-- '1' for en (1bit)
				add_sub_input_mux_en <= '0';-- '0' for A B , '1' for mac op (1bit)
				add_sub_sub <= '0';-- '0' for add , '1' for subtract (1bit)
				ADD_SUB_OUT_Reg_en <= '0';--'1' for enable output (1bit)
				MUL_en <= '0';-- '1' for enable (1bit)
				--MUL_OUT_MUX_SEL <= '0'-- '0' for output, '1' for mac (1bit)
				min_max_en <= '1';-- '1' for enable (1bit)
				min_max_choose <= '1';--'1' for max (1bit)
				--U_OUT_MUX_TRIGGER <= not AU_OUT_MUX_TRIGGER; 'Trigger output result"
			when "0110" => -- MIN OPCODE
				--MAC_OP_CONTROL <= "01";--AU control for mac op (2bit)
				--AU_IN_MUX_SEL <= '0';--'0' for add/sub, '1' for mul (1bit)
				AU_OUT_MUX_SEL <= "10"; --'00' for add/sub '01' for mul '10' for min/max other-'0' (2bit)
				MAC_reg_reset <= '0';-- '1' for reset (1bit)
				MAC_reg_en <= '0';-- '1' for en (1bit)
				add_sub_input_mux_en <= '0';-- '0' for A B , '1' for mac op (1bit)
				add_sub_sub <= '0';-- '0' for add , '1' for subtract (1bit)
				ADD_SUB_OUT_Reg_en <= '0';--'1' for enable output (1bit)
				MUL_en <= '0';-- '1' for enable (1bit)
				--MUL_OUT_MUX_SEL <= '0'-- '0' for output, '1' for mac (1bit)
				min_max_en <= '1';-- '1' for enable (1bit)
				min_max_choose <= '0';--'1' for max (1bit)
				--U_OUT_MUX_TRIGGER <= not AU_OUT_MUX_TRIGGER; 'Trigger output result"
			when "0111" =>
				--MAC_OP_CONTROL <= "01";--AU control for mac op (2bit)
				--AU_IN_MUX_SEL <= '0';--'0' for add/sub, '1' for mul (1bit)
				AU_OUT_MUX_SEL <= "11"; --'00' for add/sub '01' for mul '10' for min/max other-'0' (2bit)
				MAC_reg_reset <= '1';-- '1' for reset (1bit)
				MAC_reg_en <= '1';-- '1' for en (1bit)
				--add_sub_input_mux_en <= '0';-- '0' for A B , '1' for mac op (1bit)
				--add_sub_sub <= '0';-- '0' for add , '1' for subtract (1bit)
				--ADD_SUB_OUT_Reg_en <= '1';-- '1' for enable (1bit)
				MUL_en <= '0';-- '1' for enable (1bit)
				--MUL_OUT_MUX_SEL <= '0'-- '0' for output, '1' for mac (1bit)
				min_max_en <= '0';-- '1' for enable (1bit)
				--min_max_choose <= --'1' for max (1bit)
				--U_OUT_MUX_TRIGGER <= not AU_OUT_MUX_TRIGGER; 'Trigger output result"
			when others => -- clear all
				MAC_OP_CONTROL <= "00";--AU control for mac op (2bit)
				--AU_IN_MUX_SEL <= '0';--'0' for add/sub, '1' for mul (1bit)
				AU_OUT_MUX_SEL <= "11"; --'00' for add/sub '01' for mul '10' for min/max other-'0' (2bit)
				--MAC_reg_reset <= '1';-- '1' for reset (1bit)
				MAC_reg_en <= '0';-- '1' for en (1bit)
				add_sub_input_mux_en <= '0';-- '0' for A B , '1' for mac op (1bit)
				add_sub_sub <= '0';-- '0' for add , '1' for subtract (1bit)
				ADD_SUB_OUT_Reg_en <= '1';-- '1' for enable (1bit)
				MUL_en <= '0';-- '1' for enable (1bit)
				--MUL_OUT_MUX_SEL <= '0'-- '0' for output, '1' for mac (1bit)
				min_max_en <= '0';-- '1' for enable (1bit)
				--min_max_choose <= --'1' for max (1bit)
				--U_OUT_MUX_TRIGGER <= not AU_OUT_MUX_TRIGGER; 'Trigger output result"
		end case;
		end if;
	end process;
end Arithmetic_unit_arch;		   
			   
			   
			   
			   
			   
			   
			   
			   
			   
			   
			   
			   
			   
			   
			   
			   
			   
			   
			   