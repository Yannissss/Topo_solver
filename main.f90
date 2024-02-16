program main
    use affiche_topologie
    use chargeur_covalence
    use lecture_mol2

    implicit none

    call entrypoint()

contains

    subroutine entrypoint()
        character(len=128) :: filename, line

        integer :: i, j, k
        type(Covalence) :: cov
        type(CovTable) :: table
        type(Molecule) :: mol
        type(AtomXYZ) :: atom_xyz

        if (iargc() /= 2) then
            call getarg(0, filename)
            print *, 'Error: Unvalid arguments'
            print '(2x, a, 1x, a)', trim(filename), '<Cov_radii> <mol2_file>'
            stop 10
        end if

        ! Loading covalence table
        call getarg(1, filename)
        filename = trim(filename)
        table = charge_covalence(filename)
        ! do i = 1, table%num_cov
        !     print '(a, 2x, 3(i3, 2x))', table%data(i)%atom, table%data(i)%simple, table%data(i)%double, table%data(i)%triple
        ! end do

        ! Loading mol2 file
        call getarg(2, filename)
        filename = trim(filename)
        mol = lecture_fichier_mol2(filename)
        ! print '(a, a, 2x, a)', "mol2 file: ", trim(filename), trim(mol%mol_name)
        ! print '(a, i4)', "Num atoms: ", mol%num_atoms
        ! do j = 1, mol%num_atoms
        !     atom_xyz = mol%atoms(j)
        !     print '(a, i4, a, a8, a, 2x, 3(f10.4, 1x))', "Atom data: ", j, ", ", atom_xyz%atom, ", ", atom_xyz%x, atom_xyz%y, atom_xyz%z
        ! end do

        ! ! Small questions about Elements
        ! do i = 1, 5
        !     print *, "Which elem do you CoV radii of ?"
        !     read('(a2)'), line
        !     print '(a, a, a)', "CoV radii of '", trim(line), "'"
        !     cov = table%get_cov_radii(line)
        !     print '(a, 2x, 3i3)', cov%atom, cov%simple, cov%double, cov%triple
        ! end do

        call foo(table, mol, 0.10, 0.35, 0.05)

    end subroutine entrypoint

end program main
