!
! Copyright (C) 2001-2009 Quantum ESPRESSO group
! This file is distributed under the terms of the
! GNU General Public License. See the file `License'
! in the root directory of the present distribution,
! or http://www.gnu.org/copyleft/gpl.txt .
!
!
!-----------------------------------------------------------------------
subroutine qvan2 (ngy, ih, jh, np, qmod, qg, ylmk0)
  !-----------------------------------------------------------------------
  !
  !    This routine computes the fourier transform of the Q functions
  !    The interpolation table for the radial fourier transform is stored 
  !    in qrad.
  !
  !    The formula implemented here is
  !
  !     q(g,i,j) = sum_lm (-i)^l ap(lm,i,j) yr_lm(g^) qrad(g,l,i,j)
  !
  !
  USE kinds, ONLY: DP
  USE us, ONLY: dq, qrad
  USE uspp_param, ONLY: lmaxq, nbetam
  USE uspp, ONLY: nlx, lpl, lpx, ap, indv, nhtolm
  implicit none
  !
  ! Input variables
  !
  integer,intent(IN) :: ngy, ih, jh, np
  ! ngy   :   number of G vectors to compute
  ! ih, jh:   first and second index of Q
  ! np    :   index of pseudopotentials
  !
  real(DP),intent(IN) :: ylmk0 (ngy, lmaxq * lmaxq), qmod (ngy)
  real(DP) :: igl(ngy)
  ! ylmk0 :  spherical harmonics
  ! qmod  :  moduli of the q+g vectors
  !
  ! output: the fourier transform of interest
  !
  real(DP),intent(OUT) :: qg (2,ngy)
  !
  !     here the local variables
  !
  real (DP), allocatable :: sig(:), sigap(:)
  ! the nonzero real or imaginary part of (-i)^L 
  real (DP), parameter :: sixth = 1.d0 / 6.d0
  !
  integer :: nb, mb, ijv, ivl, jvl, ig, lm, i0, i1, i2, i3
  integer, allocatable :: lp(:), l(:), ind(:) 
  integer :: qmig
  ! nb,mb  : atomic index corresponding to ih,jh
  ! ijv    : combined index (nb,mb)
  ! ivl,jvl: combined LM index corresponding to ih,jh
  ! ig     : counter on g vectors
  ! lp     : combined LM index
  ! l-1    is the angular momentum L
  ! lm     : all possible LM's compatible with ih,jh
  ! i0-i3  : counters for interpolation table
  ! ind    : ind=1 if the results is real (l even), ind=2 if complex (l odd)
  !
  real(DP) :: dqi, qm, px, ux, vx, wx, uvx, pwx, work, qm1
  ! 1 divided dq
  ! qmod/dq
  ! measures for interpolation table
  ! auxiliary variables for intepolation
  ! auxiliary variables
  !
  !     compute the indices which correspond to ih,jh
  !
  dqi = 1.0_DP / dq
  nb = indv (ih, np)
  mb = indv (jh, np)
  if (nb.ge.mb) then
     ijv = nb * (nb - 1) / 2 + mb
  else
     ijv = mb * (mb - 1) / 2 + nb
  endif
  ivl = nhtolm(ih, np)
  jvl = nhtolm(jh, np)
  if (nb > nbetam .OR. mb > nbetam) &
       call errore (' qvan2 ', ' wrong dimensions (1)', MAX(nb,mb))
  if (ivl > nlx .OR. jvl > nlx) &
       call errore (' qvan2 ', ' wrong dimensions (2)', MAX(ivl,jvl))
  qg = 0.d0
  !
  !    and make the sum over the non zero LM
  !
  allocate(lp(lpx(ivl, jvl)))
  allocate(l(lpx(ivl, jvl)))
  allocate(ind(lpx(ivl, jvl)))
  allocate(sig(lpx(ivl, jvl)))
  allocate(sigap(lpx(ivl, jvl)))

  do lm = 1, lpx (ivl, jvl)
     lp(lm) = lpl (ivl, jvl, lm)
     if (lp(lm) == 1) then
        l(lm) = 1
        sig(lm) = 1.0d0
        ind(lm) = 1
     elseif ( lp(lm) <= 4) then
        l(lm) = 2
        sig(lm) = -1.0d0
        ind(lm) = 2
     elseif ( lp(lm) <= 9) then
        l(lm) = 3
        sig(lm) = -1.0d0
        ind(lm) = 1
     elseif ( lp(lm) <= 16) then
        l(lm) = 4
        sig(lm) = 1.0d0
        ind(lm) = 2
     elseif ( lp(lm) <= 25) then
        l(lm) = 5
        sig(lm) = 1.0d0
        ind(lm) = 1
     elseif ( lp(lm) <= 36) then
        l(lm) = 6
        sig(lm) = -1.0d0
        ind(lm) = 2
     else
        l(lm) = 7
        sig(lm) = -1.0d0
        ind(lm) = 1
     endif
     sigap(lm) = sig(lm) * ap (lp(lm), ivl, jvl)
  enddo
  do lm = 1, lpx (ivl, jvl)
     if ( lp(lm) < 1 .or. lp(lm) > 49 ) call errore ('qvan2', ' lp wrong ', max(lp(lm),1))
  enddo


  qm1 = -1.0_dp !  any number smaller than qmod(1)
  qmig = 1
  do ig = 1, ngy
     igl(ig) = ig
  enddo
  do ig = 1, ngy
     IF ( ABS( qmod(ig) - qm1 ) > 1.0D-6 ) THEN
        qm1 = qmod(ig)
        qmig = ig
     endif
     igl(ig) = qmig
  enddo

  do lm = 1, lpx (ivl, jvl)
!$omp parallel do default(shared), private(qm,px,ux,vx,wx,i0,i1,i2,i3,uvx,pwx,work)
     do ig = 1, ngy
           !
           qm = qmod (igl(ig)) * dqi
           px = qm - int (qm)
           ux = 1.d0 - px
           vx = 2.d0 - px
           wx = 3.d0 - px
           i0 = INT( qm ) + 1
           i1 = i0 + 1
           i2 = i0 + 2
           i3 = i0 + 3
           uvx = ux * vx * sixth
           pwx = px * wx * 0.5d0
           work = qrad (i0, ijv, l(lm), np) * uvx * wx + &
                  qrad (i1, ijv, l(lm), np) * pwx * vx - &
                  qrad (i2, ijv, l(lm), np) * pwx * ux + &
                  qrad (i3, ijv, l(lm), np) * px * uvx
        qg (ind(lm),ig) = qg (ind(lm),ig) + sigap(lm) * ylmk0 (ig, lp(lm)) * work
     enddo
!$omp end parallel do

  enddo
  deallocate(lp, l, ind, sig, sigap)

  return
end subroutine qvan2

