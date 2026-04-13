library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ripple_carry is
    port(
        X     : in  std_logic_vector(3 downto 0);
        Y     : in  std_logic_vector(3 downto 0);
        c_in  : in  std_logic;
        c_out : out std_logic;
        Z     : out std_logic_vector(3 downto 0)
    );
end ripple_carry;

architecture structural of ripple_carry is

    component full_adder is
        port(
            a, b : in  std_logic;
            cin  : in  std_logic;
            cout : out std_logic;
            s    : out std_logic
        );
    end component;

    signal temp : std_logic_vector(3 downto 0);

begin

    -- bit 0
    FA0: full_adder
        port map(
            a    => X(0),
            b    => Y(0),
            cin  => c_in,
            cout => temp(0),
            s    => Z(0)
        );

    -- bit 1
    FA1: full_adder
        port map(
            a    => X(1),
            b    => Y(1),
            cin  => temp(0),
            cout => temp(1),
            s    => Z(1)
        );

    -- bit 2
    FA2: full_adder
        port map(
            a    => X(2),
            b    => Y(2),
            cin  => temp(1),
            cout => temp(2),
            s    => Z(2)
        );

    -- bit 3
    FA3: full_adder
        port map(
            a    => X(3),
            b    => Y(3),
            cin  => temp(2),
            cout => c_out,
            s    => Z(3)
        );

end structural;
