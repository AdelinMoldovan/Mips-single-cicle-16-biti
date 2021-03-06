----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2022 09:25:09 PM
-- Design Name: 
-- Module Name: IF - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IFetch is
 Port (clk: in std_logic;
       jumpAddress: in std_logic_vector(15 downto 0);
       branchAddress: in std_logic_vector(15 downto 0);
       jump: in std_logic;
       PCSrc: in std_logic;
       enable: in std_logic;
       reset: in std_logic;
       instruction: out std_logic_vector(15 downto 0);
       nextPC: inout std_logic_vector(15 downto 0));   
end IFetch;

architecture Behavioral of IFetch is

signal outmux1, outmux2, pc: std_logic_vector(15 downto 0):=x"0000";
type mem is array (0 to 31) of std_logic_vector(15 downto 0);
signal adrese:mem:=(x"2081",    --B"001_000_001_0000001" / addi $1,$0,1
                    x"C10A",    --B"110_000_010_0001010" / ori $2,$0,10
                    x"2280",    --B"001_000_101_0000000" / addi $5,$0,0
                    x"C200",    --B"110_000_100_0000000" / ori $4,$0,0
                    x"A781",    --B"101_001_111_0000001" / andi $7,$1,1
                    x"9C03",    --B"100_111_000_0000011" / beq $7,$0,3
                    x"27FF",    --B"001_001_111_1111111" / addi $7,$1,-1
                    x"7780",    --B"011_101_111_0000000" / sw $7,0($5)
                    x"E00B",    --B"111_0000000001011" / j 11
                    x"046A",    --B"000_001_000_110_1_010" / sll $6,$1,1
                    x"7700",    --B"011_101_110_0000000" / sw $6,0($5)
                    x"5580",    --B"010_101_011_0000000" / lw $3,0($5)
                    x"11C0",    --B"000_100_011_100_0_000" / add $4,$4,$3
                    x"2481",    --B"001_001_001_0000001" / addi $1,$1,1
                    x"3681",    --B"001_101_101_0000001" / addi $5,$5,1
                    x"8501",    --B"100_001_010_0000001" / beq $1,$2,1
                    x"E004",    --B"111_0000000000100" / j 4
                   others=> x"7600"     --B"011_101_100_0000000" sw $4,0($5)
                    );

    begin

process(clk, reset)
begin
  if rising_edge(clk) then
    if enable = '1' then
       pc<=outmux2;
    end if;
  end if; 
    if reset = '1' then
      pc<= x"0000";
   end if;     
 end process;  

instruction<=adrese(conv_integer(pc(4 downto 0)));
nextPC<=pc+1;

outmux1 <= nextPC  when PCSrc = '0' else branchAddress;
outmux2 <= outmux1 when jump = '0' else jumpAddress; 

end Behavioral;
