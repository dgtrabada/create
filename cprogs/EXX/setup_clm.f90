! copyright info:
!
!                             @Copyright 1999
!                          Fireball2000 Committee
!
! ASU - Otto F. Sankey
!       Kevin Schmidt
!       Jian Jun Dong
!       John Tomfohr
!       Gary B. Adams
!
! Motorola - Alex A. Demkov
!
! University of Regensburg - Juergen Fritsch
!
! University of Utah - James P. Lewis
!                      Kurt R. Glaesemann
!
! Universidad de Madrid - Jose Ortega
!
!                  made possible by support from Motorola
!                         fireball@fermi.la.asu.edu

!
! RESTRICTED RIGHTS LEGEND
!
! Use, duplication, or disclosure of this software and its documentation
! by the Government is subject to restrictions as set forth in subdivision
! { (b) (3) (ii) } of the Rights in Technical Data and Computer Software
! clause at 52.227-7013.

! setup_clm.f
! Program Description
! ===========================================================================
!       This routine sets up the clm coefficients which are needed for 
! the Ylm spherical harmonics integration.
!
! ===========================================================================
! Code rewritten by:
! James P. Lewis
! Henry Eyring Center for Theoretical Chemistry
! Department of Chemistry
! University of Utah 
! 315 S. 1400 E.
! Salt Lake City, UT 84112-0850
! FAX 801-581-4353  
! Office telephone 801-585-1078 
! ===========================================================================
! 
! Program Declaration
! ===========================================================================
      	subroutine setup_clm
        use coefficients
      	implicit none

! Argument Declaration and Description
! ===========================================================================

! Local Parameters and Data Declaration
! ===========================================================================
        integer, parameter :: lmax = 3

! Local Variable Declaration and Description
! ===========================================================================

! Allocate Arrays
! ===========================================================================
        allocate (clm(0:2*lmax, -2*lmax:2*lmax))

! Procedure
! ===========================================================================
! The Ylm coefficients
        clm(0,0)  = 1.0d0

        clm(1,-1) = sqrt(3.0d0/2.0d0)
        clm(1,0)  = sqrt(3.0d0)
        clm(1,1)  = - sqrt(3.0d0/2.0d0)

        clm(2,-2) = sqrt(15.0d0/8.0d0)
        clm(2,-1) = sqrt(15.0d0/2.0d0)
        clm(2,0)  = sqrt(5.0d0/4.0d0)
        clm(2,1)  = - sqrt(15.0d0/2.0d0)
        clm(2,2)  = sqrt(15.0d0/8.0d0)

        clm(3,-3) = sqrt(35.0d0/16.0d0)
        clm(3,-2) = sqrt(105.0d0/8.0d0)
        clm(3,-1) = sqrt(21.0d0/16.0d0)
        clm(3,0)  = sqrt(7.0d0/4.0d0)
        clm(3,1)  = - sqrt(21.0d0/16.0d0)
        clm(3,2)  = sqrt(105.0d0/8.0d0)
        clm(3,3)  = - sqrt(35.0d0/16.0d0)

        clm(4,-4) = sqrt(315.0d0/128.0d0)
        clm(4,-3) = sqrt(315.0d0/16.0d0)
        clm(4,-2) = sqrt(45.0d0/32.0d0)
        clm(4,-1) = sqrt(45.0d0/16.0d0)
        clm(4,0) = sqrt(9.0d0/64.0d0)
        clm(4,1) = - sqrt(45.0d0/16.0d0)
        clm(4,2) = sqrt(45.0d0/32.0d0)
        clm(4,3) = - sqrt(315.0d0/16.0d0)
        clm(4,4) = sqrt(315.0d0/128.0d0)

        clm(5,-5) = 0.0d0
        clm(5,-4) = 0.0d0
        clm(5,-3) = 0.0d0
        clm(5,-2) = 0.0d0
        clm(5,-1) = 0.0d0
        clm(5,0) = 0.0d0
        clm(5,1) = 0.0d0
        clm(5,2) = 0.0d0
        clm(5,3) = 0.0d0
        clm(5,4) = 0.0d0
        clm(5,5) = 0.0d0

        clm(6,-6) = 0.0d0
        clm(6,-5) = 0.0d0
        clm(6,-4) = 0.0d0
        clm(6,-3) = 0.0d0
        clm(6,-2) = 0.0d0
        clm(6,-1) = 0.0d0
        clm(6,0) = 0.0d0
        clm(6,1) = 0.0d0
        clm(6,2) = 0.0d0
        clm(6,3) = 0.0d0
        clm(6,4) = 0.0d0
        clm(6,5) = 0.0d0
        clm(6,6) = 0.0d0

! Deallocate Arrays
! ===========================================================================

! Format Statements
! ===========================================================================

	return
        end
