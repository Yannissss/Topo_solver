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
        type(Topology) :: topo

        if (iargc() /= 3) then
            call getarg(0, filename)
            print *, 'Error: Unvalid arguments'
            print '(2x, a, 1x, a)', trim(filename), &
                '<Cov_radii> <in_mol2_file> <out_mol2_file>'
            stop 10
        end if

        ! Loading covalence table
        call getarg(1, filename)
        filename = trim(filename)
        table = charge_covalence(filename)

        ! Loading mol2 file
        call getarg(2, filename)
        filename = trim(filename)
        mol = lecture_fichier_mol2(filename)

        ! Compute topology and save to file
        call getarg(3, filename)
        filename = trim(filename)
        topo = calcul_topologie(table, mol, 0.10, 0.35, 0.05)
        print '(a, i4, a)', "[calcul_topologie] Done! Found ", topo%num_bonds, 'bond(s)'

    end subroutine entrypoint

end program main
