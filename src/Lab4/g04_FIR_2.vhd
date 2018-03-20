library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity g04_FIR is
port ( 	
		x			: in std_logic_vector(15 downto 0); --input signal
		coef			: in std_logic_vector(15 downto 0); --input of coefficients		
		clk			: in std_logic;  -- clock
		rst			: in std_logic;  -- asynchronous active-high reset
		y 			: out std_logic_vector(16 downto 0));  -- output signal
end g04_FIR;

architecture fir_implementation of g04_FIR is
	type ARRAY25 is array(24 downto 0) of std_logic_vector(15 downto 0);		-- define an array type
	signal COEFF_ARRAY : ARRAY25;							-- create array to hold coefficients
	signal INPUT_ARRAY : ARRAY25;							-- create array to hold input values	
	signal i 	: integer := 0;							-- create counting variable, initialize at 0
	signal total : std_logic_vector(32 downto 0);					-- create temporary variable to hold the interim total
	
	begin
		counter : process(rst, clk)
			begin
			
			if (rising_edge(clk) and i < 25) then
				COEFF_ARRAY(i) <= coef;
				INPUT_ARRAY(25-i) <= x;
			end if;
			
			if(rising_edge(clk) and i >= 25) then
				if rst = '1' then
					-- what to do
					
				else 
					-- multiply all 25 input values by all 25 coefficients, then output that to y
					total <= "000000000000000000000000000000000";
					for t in 0 to 24 loop
						total <= std_logic_vector(signed(total) + (signed(INPUT_ARRAY(t)) * signed(COEFF_ARRAY(t))));
					end loop;
					
					-- shuffle input values along the array
					for t in 1 to 24 loop
						INPUT_ARRAY(t-i) <= INPUT_ARRAY(t-i-1);
					end loop;
					INPUT_ARRAY(0) <= x;
				end if;
			end if;
		end process; 
	y <= total(16 downto 0);		-- assign result to output outside of the process block, truncating unused digits
end fir_implementation;