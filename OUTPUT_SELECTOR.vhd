-- ====================================================================
--
--	File Name:		OUTPUT_SELECTOR.vhd
--	Description:	ALU output selector
--					
--
--	Date:			7/07/2018
--	Designer:		Aviran Huga
--
-- ====================================================================


-- libraries decleration
library ieee;
use ieee.std_logic_1164.all;

entity OUTPUT_SELECTOR is
generic ( N: integer :=8);
port (
	shift_unit_INPUT : in std_logic_vector(N-1 downto 0);-- shift register output
	AU_LO_INPUT : in std_logic_vector(N-1 downto 0);-- Arithmetic unit output LO
	AU_HI_INPUT : in std_logic_vector(N-1 downto 0);-- Arithmetic unit output HI
	AU_status : in std_logic_vector(5 downto 0);-- AU status 
	SEL : in std_logic_vector(1 downto 0);
	output_LO : out std_logic_vector(N-1 downto 0) := (others => '0');	
	output_HI : out std_logic_vector(N-1 downto 0) := (others => '0');
	output_status : out std_logic_vector(5 downto 0)
	);
end OUTPUT_SELECTOR;

architecture OUTPUT_SELECTOR_arch of OUTPUT_SELECTOR is
begin                                         
-- Design Body
	process(shift_unit_INPUT,AU_LO_INPUT,AU_status,SEL)
		begin
		case SEL is
			when "00" => --shift_unit_out
				output_HI <= (others => '0');
				output_LO <= shift_unit_INPUT;
				output_status <= (others => '0');
			when "01" => --AU only LO
				output_HI <= (others => '0');
				output_LO <= AU_LO_INPUT;
				output_status <= AU_status;
			when "10" => -- AU LO AND HI
				output_HI <= AU_HI_INPUT;
				output_LO <= AU_LO_INPUT;
				output_status <= (others => '0');
			when others =>
				output_HI <= (others => '0');
				output_LO <= (others => '0');
				output_status <= (others => '0');
			end case;
	end process;
end OUTPUT_SELECTOR_arch;