program complete_mol2
    use affiche_topologie
    use chargeur_covalence
    use lecture_mol2

    implicit none

    character(len=128) :: filename, line

    integer :: i, j, k, ok, end
    real :: tol_max, tol_min, tol_step
    type(Covalence) :: cov
    type(CovTable) :: table
    type(Molecule) :: mol
    type(AtomXYZ) :: atom_xyz
    type(Topology) :: topo

    ! Argument parser

    ! Mandatory arguments
    if (iargc() < 3) then
        call getarg(0, filename)
        print *, 'Error: Unvalid arguments'
        print '(2x, a, 1x, a)', trim(filename), &
            '<Cov_radii> <in_mol2_file> <out_mol2_file> ' // &
            '<tol_max:0.35> <tol_min:0.10> <tol_step:0.05>'
        stop 10
    end if

    ! Optional arguments
    tol_max = 0.35
    tol_min = 0.10
    tol_step = 0.05

    if (iargc() >= 4) then
        call getarg(4, line)
        read(line, *) tol_max
    endif

    if (iargc() >= 5) then
        call getarg(5, line)
        read(line, *), tol_min
    endif

    if (iargc() >= 6) then
        call getarg(6, line)
        read(line, *), tol_step
    endif

    ! Main routine

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
    topo = calcul_topologie(table, mol, tol_min, tol_max, tol_step)

    ! Check if program found a valid topology
    if (topo%num_bonds == 0) then
        stop 1
    else
        call getarg(3, filename)
        print '(a, a)', '[complete_mol2] Writing topology to ', trim(filename)
    end if

    ! Save topology in output file
    i = 10 ! mol2 in file
    j = 20 ! mol2 out file

    ! Open input file
    call getarg(2, filename)
    filename = trim(filename)
    open(unit = i, file = filename, iostat = ok, status = 'old')
    if ( ok /= 0 ) then
        print '(a,4x,a)', "Error during opening", filename
        stop ok
    end if

    ! Open out file
    call getarg(3, filename)
    filename = trim(filename)
    open(unit = j, file = filename, iostat = ok, status = 'replace')
    if ( ok /= 0 ) then
        print '(a,4x,a)', "Error during opening", filename
        stop ok
    end if

    ! Copy first existing content up to bond info in mol2 file
    do
        read (i, '(a)', iostat = end), line
        if (end /= 0 .or. trim(line) == "@<TRIPOS>BOND") then
            ! We re are done copying the input file
            exit
        else
            write (j, '(a)'), line
        end if
    end do

    ! Close in file
    close(i)

    ! Write bond data
    write (j, '(a)'), "@<TRIPOS>BOND"
    do k = 1, topo%num_bonds
        write(j, '(i6, 1x, i4, 1x, i4, 1x, i1)'), k, &
            topo%bonds(1, k), topo%bonds(2, k), topo%bonds(3, k)
    end do

    ! Close out file
    close(j)

    ! Done
    print '(a)', '[complete_mol2] All done.'


end program complete_mol2
