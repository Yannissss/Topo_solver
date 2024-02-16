module affiche_topologie
    use chargeur_covalence
    use lecture_mol2

    implicit none

contains

    subroutine foo(table, mol, tol_min, tol_max, tol_step)
        type(CovTable), intent(in) :: table
        type(Molecule), intent(in) :: mol
        real, intent(in) :: tol_min, tol_max, tol_step

        integer :: i, j, k

        type(AtomXYZ) :: atom_a, atom_b
        type(Covalence) :: radii_a, radii_b
        real :: distance, tol, delta_simple, delta_double, delta_triple

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
                    if (delta_simple <= tol_min) then
                        print '(a, a, i3, a, a, i3, a, f3.2)', &
                            '[affiche_topologie] Found a simple bond bewteen ', &
                            atom_a%atom, i, ' and ', &
                            atom_b%atom, j, " at tolerance ", tol
                        exit
                    end if

                    ! Check for a double bond
                    if (delta_double <= tol_min) then
                        print '(a, a, i3, a, a, i3, a, f3.2)', &
                            '[affiche_topologie] Found a double bond bewteen ', &
                            atom_a%atom, i, ' and ', &
                            atom_b%atom, j, " at tolerance ", tol
                        exit
                    end if

                    ! Check for a triple bond
                    if (delta_triple <= tol_min) then
                        print '(a, a, i3, a, a, i3, a, f3.2)', &
                            '[affiche_topologie] Found a triple bond bewteen ', &
                            atom_a%atom, i, ' and ', &
                            atom_b%atom, j, " at tolerance ", tol
                        exit
                    end if

                    ! Increase tolerance
                    tol = tol + tol_step
                end do

            end do
        end do

    end subroutine foo

end module affiche_topologie
