! copyright info:
!
!                             @Copyright 2002
!                            Fireball Committee
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
! fireball-qmd is a free (GPLv3) open project.

! This program is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! This program is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with this program.  If not, see <http://www.gnu.org/licenses/>.


! corlyp1c.f90
! Program Description
! ===========================================================================
!       Lee Yang Parr correlation energy functional one-dimensional densities
! only no provisions taken against division by zero.
!
! See e.g. C. Lee et al. Phys. Rev. B 37 785 (1988)
!
! Hartree A.U.
!
! ===========================================================================
! Code written by:
! James P. Lewis
! Department of Physics and Astronomy
! Brigham Young University
! N233 ESC P.O. Box 24658
! Provo, UT 84602-4658
! FAX (801) 422-2265
! Office Telephone (801) 422-7444
! ===========================================================================
!
! Program Declaration
! ===========================================================================
        subroutine corlyp1c (tpot, dp, dm, dp1, dm1, dp2, dm2, ec, vcp0, vcm0)
        implicit none

! Argument Declaration and Description
! ===========================================================================
! Input
        real*8, intent (in) :: dm, dm1, dm2
        real*8, intent (in) :: dp, dp1, dp2

        logical, intent (in) :: tpot

! Output
        real*8, intent (out) :: ec
        real*8, intent (out) :: vcm0
        real*8, intent (out) :: vcp0

! Local Parameters and Data Declaration
! ===========================================================================
        real*8, parameter :: aa = 0.04918d0
        real*8, parameter :: bb = 0.132d0
        real*8, parameter :: cc = 0.2533d0
        real*8, parameter :: dd = 0.349d0
        real*8, parameter :: c5 = 4.55779986d0
        real*8, parameter :: c6 = 1.0d0/72.0d0
        real*8, parameter :: c7 = 1.0d0/18.0d0
        real*8, parameter :: c8 = 0.125d0
        real*8, parameter :: t13 = 1.0d0/3.0d0
        real*8, parameter :: t89 = 8.0d0/9.0d0

! Local Variable Declaration and Description
! ===========================================================================
        real*8 c1, c2, c3, c4, c9
        real*8 chf
        real*8 d0xt13, d0xt53
        real*8 d0, d1, d2
        real*8 dmt53, dpt53
        real*8 dxsq
        real*8 ga
        real*8 gafm, gafp
        real*8 gb
        real*8 h
        real*8 h2
        real*8 hf
        real*8 hff
        real*8 sc
        real*8 sc2
        real*8 scf
        real*8 t43, t53, t83
        real*8 yafm, yafp
        real*8 yb, yb1, yb2
        real*8 ybfm, ybfp
        real*8 yy1
        real*8 yz, yz1, yz2
        real*8 z1, z2
        real*8 zfm, zfp
        real*8 zeta

! Allocate Arrays
! ===========================================================================

! Procedure
! ===========================================================================
! Initialize some parameters
        c1 = -4.0d0*aa
        c2 = dd
        c3 = 2.0d0*bb
        c4 = cc
        t53 = 5.0d0*t13
        t43 = 4.0d0*t13
        t83 = 2.0d0*t43
        c9 = t43 + t89

        d0 = dp + dm
        dxsq = 1.0d0/(d0*d0)
        d1 = dp1 + dm1
        d2 = dp2 + dm2
        d0xt13 = d0**(-t13)
        d0xt53 = d0xt13*d0xt13/d0
        dpt53 = dp**t53
        dmt53 = dm**t53

! Polarization factor
        zeta = c1*(dp*dm)*dxsq

! Scaling function
        sc = 1.0d0/(1.0d0 + c2*d0xt13)
        h = c3*d0xt53*exp(-c4*d0xt13)

! kinetic energy density expansion
        ga = c5*(dp*dpt53 + dm*dmt53)
        gb = c6*(dp1*dp1 - dp*dp2 + dm1*dm1 - dm*dm2) + c7*(dp*dp2 + dm*dm2) &
     &      + c8*(d0*d2 - d1*d1)

! Calculate potential
        if (tpot) then
         gafp = t83*c5*dpt53
         gafm = t83*c5*dmt53

         scf = t13*c2*d0xt13/d0*sc*sc
         sc2 = scf*(d2 + 2.0d0*(scf/sc - 2.0d0*t13/d0)*d1*d1)

         chf = t13*(c4*d0xt13 - 5.0d0)/d0
         hf = chf*h
         hff = h*(chf**2 + t13*(5.0d0 - 4.0d0*t13*c4*d0xt13)*dxsq)
         h2 = (hf*d2 + hff*d1*d1)

         zfp = (c1*dm - 2.0d0*zeta*d0)*dxsq
         zfm = (c1*dp - 2.0d0*zeta*d0)*dxsq
         yz = zeta/c1
         yy1 = dp*dm1 + dm*dp1
         yz1 = (yy1 - 2.0d0*yz*d1*d0)*dxsq
         yz2 = (2.0d0*yz*d1*d1 - 2.0d0*(yz1*d1 + yz*d2)*d0                   &
     &        - 2.0d0*d1*yy1/d0 + (dp*dm2 + 2.0d0*dp1*dm1 + dm*dp2))*dxsq
         z1 = c1*yz1
         z2 = c1*yz2

         yafp = sc*(d0*zfp + zeta) + zeta*d0*scf
         yafm = sc*(d0*zfm + zeta) + zeta*d0*scf

         yb = sc*zeta*h
         ybfp = sc*(h*zfp + zeta*hf) + zeta*h*scf
         ybfm = sc*(h*zfm + zeta*hf) + zeta*h*scf
         yb1 = sc*(h*z1 + zeta*hf*d1) + zeta*h*scf*d1
         yb2 = (sc*hf + h*scf)*d1*z1 + h*sc*z2 + (sc*z1 + zeta*scf*d1)*hf*d1 &
     &        + zeta*sc*h2 + (zeta*hf*d1 + h*z1)*scf*d1 + zeta*h*sc2

! Collect contributions
         vcp0 = yafp + ybfp*(ga + gb)                                        &
     &         + yb*(gafp + 2.0d0*c8*(c9*dp2 + 2.0d0*dm2))                   &
     &         + yb1*2.0d0*c8*(c9*dp1 + 2.0d0*dm1) + yb2*c8*(t43*dp + dm)
         vcm0 = yafm + ybfm*(ga + gb)                                        &
     &         + yb*(gafm + 2.0d0*c8*(c9*dm2 + 2.0d0*dp2))                   &
     &         + yb1*2.0d0*c8*(c9*dm1 + 2.0d0*dp1) + yb2*c8*(t43*dm + dp)
        else
         vcp0 = 0.0d0
         vcm0 = 0.0d0
        endif

! Correlation energy per electron
        ec = zeta*sc*(d0 + h*(ga + gb))/d0

! Deallocate Arrays
! ===========================================================================

! Format Statements
! ===========================================================================

        return
        end
