library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder_sub is
    port(
        X    : in  std_logic_vector(3 downto 0);
        Y    : in  std_logic_vector(3 downto 0);
        cin  : in  std_logic;
        Z    : out std_logic_vector(3 downto 0);
        cout : out std_logic
    );
end adder_sub;

architecture structural of adder_sub is

    component ripple_carry is
        port(
            X     : in  std_logic_vector(3 downto 0);
            Y     : in  std_logic_vector(3 downto 0);
            c_in  : in  std_logic;
            c_out : out std_logic;
            Z     : out std_logic_vector(3 downto 0)
        );
    end component;

    signal complementoy : std_logic_vector(3 downto 0);

begin

    complemento_y : for i in 0 to 3 generate
        complementoy(i) <= Y(i) xor cin;
    end generate;

    RA : ripple_carry
        port map(
            X     => X,
            Y     => complementoy,
            c_in  => cin,
            c_out => cout,
            Z     => Z
        );

end structural;
