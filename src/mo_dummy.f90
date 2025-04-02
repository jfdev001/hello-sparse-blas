! Defines a dummy module to be used elsewhere for purpose of dependency graphs

MODULE mo_dummy
    IMPLICIT NONE
    PUBLIC 
CONTAINS
    PURE REAL FUNCTION add_two(x) result(r)
        REAL, INTENT(IN) :: x 
        r = x + 2
    END FUNCTION add_two 
END MODULE mo_dummy


