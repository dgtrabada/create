! copyright info:
!
!                             @Copyright 2001
!                           Fireball Committee
! Brigham Young University - James P. Lewis, Chair
! Arizona State University - Otto F. Sankey
! University of Regensburg - Juergen Fritsch
! Universidad de Madrid - Jose Ortega

! Other contributors, past and present:
! Auburn University - Jian Jun Dong
! Arizona State University - Gary B. Adams
! Arizona State University - Kevin Schmidt
! Arizona State University - John Tomfohr
! Lawrence Livermore National Laboratory - Kurt Glaesemann
! Motorola, Physical Sciences Research Labs - Alex Demkov
! Motorola, Physical Sciences Research Labs - Jun Wang
! Ohio University - Dave Drabold

!
! RESTRICTED RIGHTS LEGEND
! Use, duplication, or disclosure of this software and its documentation
! by the Government is subject to restrictions as set forth in subdivision
! { (b) (3) (ii) } of the Rights in Technical Data and Computer Software
! clause at 52.227-7013.

! buildspline_1d.f90
! Program Description
! ===========================================================================
!       This code takes a 1D integral array and generates a single natural 
! cubic spline to fit the entire curve.  Values will later be interpolated 
! based on this "super spline".  The spline and its derivatives are continuous.
! See reference in Numerical Analysis by R. L. Burden and J. D. Faires, 
! section 3.6
! There are several types of splines: not-a-knot, natural spline,
! clamped spline, extrapolated spline, parabolically terminated spline,
! endpoint curvature adjusted spline
! ===========================================================================
! Code written by:
! Kurt R. Glaesemann
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
        subroutine buildspline_1d (xintegral, splineint, numz, xmax)
        implicit none

! Argument Declaration and Description
! ===========================================================================
        integer, intent(in) :: numz
        real*8, intent(in) :: xmax
        real*8, intent(in) :: xintegral(numz)
        real*8, intent(out):: splineint(4,numz)

! Local Variable Declaration and Description
! ===========================================================================
        integer imid
        integer iorder
        integer norder
        integer numz_used

        real*8 fn
        real*8 fnm1
        real*8 fo
        real*8 fop1
        real*8 fpo
        real*8 fpn
        real*8 h
        real*8 xmin

        real*8, dimension (0: numz-1) :: a
        real*8, dimension (0: numz-1) :: b
        real*8, dimension (0: numz-1) :: c
        real*8, dimension (0: numz-1) :: d
        real*8, dimension (0: numz-1) :: alpha
        real*8, dimension (0: numz-1) :: L
        real*8, dimension (0: numz-1) :: mu
        real*8, dimension (0: numz-1) :: Z

! Procedure
! ===========================================================================
! Note : the points must be equally spaced!!!!
        xmin = 0.0d0
        h = (xmax - xmin)/(numz - 1)

        numz_used = numz
        checker: do iorder = numz, 3, -1
          if (xintegral(iorder) .eq. 0) then
              numz_used = iorder
          else
              exit checker
          end if
        end do checker
          
! Initialize some variables
        fn = xintegral(numz_used)
        fnm1 = xintegral(numz_used-1)
        fo = xintegral(1)
        fop1 = xintegral(2)
! Get estimates of derivatives
        fpn = (fn - fnm1)/h
        fpo = (fop1 - fo)/h 

! We are not doing natural splines anymore, but rather we now do clamped
! Cubic splices: "clamped" splines with f'(x) given at both endpoints.
        norder = numz_used - 1
        do iorder = 0, norder
         a(iorder) = xintegral(iorder+1)
        end do

        alpha(0) = 3.0d0*(a(1) - a(0))/h - 3.0d0*fpo
        do iorder = 1, norder - 1
         alpha(iorder) = 3.0d0*(a(iorder+1) - 2.0d0*a(iorder) + a(iorder-1))/h
        end do
        alpha(norder) = 3.0d0*fpn - 3.0d0*(a(norder) - a(norder-1))/h

        L(0) = 2.0d0*h
        mu(0) = 0.5d0
        Z(0) = alpha(0)/L(0)
        do iorder = 1, norder - 1
         L(iorder) = (4.0d0 - mu(iorder-1))*h
         mu(iorder) = h/L(iorder)
         Z(iorder) = (alpha(iorder) - h*Z(iorder-1))/L(iorder)
        end do
        L(norder) = (2.0d0 - mu(norder-1))*h
        mu(norder) = 0.0d0
        Z(norder) = (alpha(norder) - h*Z(norder-1))/L(norder) 
        c(norder) = Z(norder)

        do iorder = norder - 1, 0, -1
         c(iorder) = z(iorder) - mu(iorder)*c(iorder+1)
         b(iorder) = (a(iorder+1) - a(iorder))/h                             &
     &              - h*(c(iorder+1) + 2.0d0*c(iorder))/3.0d0
         d(iorder) = (c(iorder+1) - c(iorder))/(3.0d0*h)
        end do
        b(norder) = 0.0d0
        d(norder) = 0.0d0

! We now have a, b, c, d (the coefficients to the spline segments)
! Now copy these into splineint
        do iorder = 1, numz_used
         splineint(1,iorder) = a(iorder-1)
         splineint(2,iorder) = b(iorder-1)
         splineint(3,iorder) = c(iorder-1)
         splineint(4,iorder) = d(iorder-1)
        end do
! Set end to zero if necessary
        if (numz_used .ne. numz) then
         do iorder = numz_used, numz
          splineint(:,iorder) = 0
         end do
        else if (splineint(1,numz) .eq. 0) then
         splineint(2,numz) = 0.0d0
         splineint(3,numz) = 0.0d0
         splineint(4,numz) = 0.0d0
        end if

! Format Statements
! ===========================================================================

        return
        end
