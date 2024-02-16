module affiche_topologie
    use chargeur_covalence
    use lecture_mol2

    implicit none

    integer, parameter :: BOND_SIMPLE = 0
    integer, parameter :: BOND_DOUBLE = 1
    integer, parameter :: BOND_TRIPLE = 2

    type, public :: Topology
        ! (atom_a_num, atom_b_num, bond_type)
        integer, allocatable, dimension(:, :) :: bonds
        integer :: num_bonds
    end type Topology

contains

    type(Topology) function calcul_topologie(table, mol, tol_min, tol_max, tol_step)
        type(CovTable), intent(in) :: table
        type(Molecule), intent(in) :: mol
        real, intent(in) :: tol_min, tol_max, tol_step

        integer :: i, j, k

        type(AtomXYZ) :: atom_a, atom_b
        type(Covalence) :: radii_a, radii_b
        real :: distance, tol, delta_simple, delta_double, delta_triple

        ! Allocate enough space for topology
        k = mol%num_atoms * mol%num_atoms
        allocate(calcul_topologie%bonds(3, k))
        calcul_topologie%num_bonds = 0

        ! Main loop
        do i=1, mol%num_atoms
            do j=i + 1, mol%num_atoms
                ! We check if there is a bond between atom A & B
                atom_a = mol%atoms(i) ! Read atom positions
                atom_b = mol%atoms(j)

                radii_a = table%get_cov_radii(atom_a%atom) ! Read elements
                radii_b = table%get_cov_radii(atom_b%atom) ! radii

                ! Compute distance in picometers
                distance = atom_a%compute_dist(atom_b)

                ! Compute delta for differents bond types
                delta_simple = abs(radii_a%simple + radii_b%simple - distance)
                delta_double = abs(radii_a%double + radii_b%double - distance)
                delta_triple = abs(radii_a%triple + radii_b%triple - distance)

                tol = tol_min
                ! Tolerance increasing loop
                do while (tol <= tol_max)

                    ! Check for a simple bond
                    if (delta_simple <= tol) then
                        print '(a, a, i3, a, a, i3, a, f3.2)', &
                            '[affiche_topologie] Found a simple bond bewteen ', &
                            atom_a%atom, i, ' and ', &
                            atom_b%atom, j, " at tolerance ", tol

                        ! Add bond to topology
                        k = calcul_topologie%num_bonds
                        calcul_topologie%bonds(0, k) = radii_a%atom_num
                        calcul_topologie%bonds(1, k) = radii_b%atom_num
                        calcul_topologie%bonds(2, k) = BOND_SIMPLE
                        calcul_topologie%num_bonds = k + 1

                        ! No more possible bond for this atom pair
                        exit
                    end if

                    ! Check for a double bond
                    if (delta_double <= tol) then
                        print '(a, a, i3, a, a, i3, a, f3.2)', &
                            '[affiche_topologie] Found a double bond bewteen ', &
                            atom_a%atom, i, ' and ', &
                            atom_b%atom, j, " at tolerance ", tol

                        ! Add bond to topology
                        ! k = calcul_topologie%num_bonds
                        ! calcul_topologie%bonds(0, k) = radii_a%atom_num
                        ! calcul_topologie%bonds(1, k) = radii_b%atom_num
                        ! calcul_topologie%bonds(2, k) = BOND_DOUBLE
                        ! calcul_topologie%num_bonds = k + 1

                        ! No more possible bond for this atom pair
                        exit
                    end if

                    ! Check for a triple bond
                    if (delta_triple <= tol) then
                        print '(a, a, i3, a, a, i3, a, f3.2)', &
                            '[affiche_topologie] Found a triple bond bewteen ', &
                            atom_a%atom, i, ' and ', &
                            atom_b%atom, j, " at tolerance ", tol
                        exit

                        ! Add bond to topology
                        ! k = calcul_topologie%num_bonds
                        ! calcul_topologie%bonds(0, k) = radii_a%atom_num
                        ! calcul_topologie%bonds(1, k) = radii_b%atom_num
                        ! calcul_topologie%bonds(2, k) = BOND_TRIPLE
                        ! calcul_topologie%num_bonds = k + 1

                        ! No more possible bond for this atom pair
                    end if

                    ! Increase tolerance
                    tol = tol + tol_step
                end do

            end do
        end do

    end function calcul_topologie

end module affiche_topologie
