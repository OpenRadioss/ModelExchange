C MIT License
C 
C Copyright (c) 2025 RM412
C 
C Permission is hereby granted, free of charge, to any person obtaining a copy
C of this software and associated documentation files (the "Software"), to deal
C in the Software without restriction, including without limitation the rights
C to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
C copies of the Software, and to permit persons to whom the Software is
C furnished to do so, subject to the following conditions:
C
C The above copyright notice and this permission notice shall be included in all
C copies or substantial portions of the Software.
C
C THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
C IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
C FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
C AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
C LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
C OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
C SOFTWARE.
C
C Suggestion : 
C 
C BSD 3-Clause License
C Copyright (c) 2014
C  D. Haeufle, M. Günther, A. Bayer, S. Schmitt
C Copyright (c) 2017
C  C. Kleinbach, O. Martynenko, J. Promies, D. F. B. Haeufle, J. Fehr, S. Schmitt
C Copyright (c) 2019
C  O. Martynenko, F. Kempter, C. Kleinbach, S. Schmitt, J. Fehr
C Copyright (c) 2020
C  P. Lerge, O. Martynenko, L. Nölle, S. Schmitt, I. Wochner
C Copyright (c) 2022
C  O. Martynenko, F. Kempter, C. Kleinbach, L. Nölle, P. Lerge, S. Schmitt, J. Fehr
C Copyright (c) 2026
C A. Ardisson, E. Wagnac, M.-H. Beauséjour/ÉTS
C  Adaptation and port to OpenRadioss
C All rights reserved.
C Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following C C conditions are met:
C Redistributions of source code must retain the above copyright notice,
C  this list of conditions and the following disclaimer.
C
C
C Redistributions in binary form must reproduce the above copyright notice,
C  this list of conditions and the following disclaimer in the documentation
C  and/or other materials provided with the distribution.
C 
C 
C Neither the name of the copyright holder nor the names of its contributors
C  may be used to endorse or promote products derived from this software
C  without specific prior written permission.
C
C
C THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS”
C AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
C IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
C ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
C LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
C CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
C SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
C INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
C CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
C ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
C POSSIBILITY OF SUCH DAMAGE.

! C-----------------------------------------------
! C   calc_F_isom FUNCTION !output calc_F_ISOM 
! C----------------------------------------------	   
       double precision FUNCTION calc_F_isom(l_CE,l_CE_opt,cm)
! ! C!  Computation of the isometric force developped by the muscle               
            double precision :: cm(*)
            double precision :: l_CE , f_isom_temp,l_CE_opt
                   IF (l_CE.GE.l_CE_opt) THEN
                        f_isom_temp = exp(-(abs(((l_CE/l_CE_opt)-1.0)/cm(11)))**cm(12))
                   ELSE
                        f_isom_temp = exp(-(abs(((l_CE/l_CE_opt)-1.0)/cm(13)))**cm(14))
                   END IF
C Additional code to detect values less or equal than zero
                   IF (f_isom_temp.LE.1E-13) THEN
                        calc_F_isom = 1E-13
                   ELSE 
                        calc_F_isom = f_isom_temp
                   END IF
            RETURN
       END FUNCTION calc_F_isom
C
C-----------------------------------------------
C   calc_F_PEE FUNCTION ! output calc_F_PEE
C----------------------------------------------
C!  Force of the parallel elastic element PEE
      double precision FUNCTION calc_F_PEE(l_CE, cm, l_PEE0, K_PEE)
            double precision :: cm(*)
            double precision :: l_CE, l_PEE0,K_PEE
            IF (l_CE.GE.l_PEE0) THEN 
                  calc_F_PEE = K_PEE*((l_CE-l_PEE0)**cm(20))
            ELSE
                  calc_F_PEE = 0.0d0
            END IF 
      RETURN
      END FUNCTION calc_F_PEE
C
C-----------------------------------------------
C   calc_F_SEE FUNCTION !output calc_F_SEE
C----------------------------------------------
C!  Force of the serial elastic element SEE 
      double precision function calc_F_SEE(l_CE,l_SEE_0,cm,elleng,l_SEE_nll,v_SEE,K_SEE_nl,K_SEE_l)
            double precision :: cm(*)
            double precision :: l_CE,K_SEE_nl,K_SEE_l,l_SEE,l_SEE_nll
            double precision :: v_SEE,elleng,l_SEE_0
            l_SEE = elleng - l_CE
            IF ((l_SEE.LT.l_SEE_nll).and.(l_SEE.GT.l_SEE_0)) THEN
                  calc_F_SEE = K_SEE_nl*((l_SEE-l_SEE_0)**v_SEE)
            ELSE IF ((l_SEE.GE.l_SEE_nll).and.(l_SEE.GT.l_SEE_0)) THEN
                  calc_F_SEE = cm(25) + K_SEE_l*(l_SEE - l_SEE_nll)
            ELSE
                  calc_F_SEE = 0.0d0
            ENDIF
      RETURN
      END FUNCTION calc_F_SEE
C		
C-----------------------------------------------
C   calc_F_SUM FUNCTION 
C-----------------------------------------------   
C
      DOUBLE PRECISION FUNCTION calc_F_SUM(l_CE,l_CE_opt,l_SEE_0,elleng,q,cm, l_PEE0,K_PEE,l_SEE_nll,v_SEE,K_SEE_nl, K_SEE_l)
            DOUBLE PRECISION, dimension(39) :: cm
            DOUBLE PRECISION l_PEE0, K_PEE, v_SEE, K_SEE_nl, K_SEE_l,l_SEE_nll,l_CE
            DOUBLE PRECISION F_isom, F_PEE, F_SEE, F_CE_init, elleng, q
            DOUBLE PRECISION calc_F_isom, calc_F_PEE, calc_F_SEE,l_SEE_0,l_CE_opt
            F_isom = calc_F_isom(l_CE,l_CE_opt,cm)
            F_PEE = calc_F_PEE(l_CE, cm, l_PEE0, K_PEE)
            F_SEE = calc_F_SEE(l_CE,l_SEE_0,cm,elleng,l_SEE_nll,v_SEE,K_SEE_nl,K_SEE_l) 
            F_CE_init = cm(9)*q*F_isom
            calc_F_SUM = F_SEE - F_CE_init - F_PEE
      RETURN
      END FUNCTION calc_F_SUM
C		
C-----------------------------------------------
C   calc_STIM FUNCTION 
C-----------------------------------------------   
C
      DOUBLE PRECISION FUNCTION calc_STIM(cm,UVAR,tt,lCEdelay,dotlCEdelay,ncycle,NUVAR,I,IFUNC1,IFUNC2,IFUNC3,GET_U_FUNC)
      INTEGER NUVAR,I,ncycle,IFUNC1,IFUNC2,IFUNC3
      DOUBLE PRECISION cm(*),UVAR(NUVAR,I)
      DOUBLE PRECISION lCEdelay, dotlCEdelay 
      DOUBLE PRECISION STIM, lambda, dlambda
      DOUBLE PRECISION STIM_lambda, STIM_hybrid, STIM_reflex
      DOUBLE PRECISION STIM_closed,STIM_open,tt,DXDY
      DOUBLE PRECISION GET_U_FUNC
c
c     get STIM
      SELECT CASE (int(cm(33)))
            CASE (0)
c     NO CONTROLLER     
                  IF (cm(2).GT.0.0) THEN 
C           STIM level from curve
                        STIM = GET_U_FUNC(IFUNC1,tt,DXDY)
                  ELSE
c           constant STIM level
                        STIM = abs(cm(2))
                  END IF
                  IF (STIM.GT.1.0) then
                        STIM = 1.0
                  ELSE IF (STIM.LT.0.0) THEN
                        STIM = 0.0
                  ENDIF
            CASE (1)
c     LAMBDA CONTROLLER
                  IF (cm(34).LT.0.0) THEN
c           lambda from curve
                        lambda = GET_U_FUNC(IFUNC3,tt,DXDY)
                        dlambda=0.0
                  ELSE
c           lambda = constant
                        lambda = abs(cm(34))
                        dlambda=0.0
                  ENDIF
                  IF (lambda.LT.0.0) THEN
                        lambda = 0.0
                  ENDIF
                  UVAR(50,I)=lambda
                  IF (tt.LT.cm(38)) THEN
                        IF (cm(2).GT.0.0) THEN
c           STIM from curve
                              STIM = GET_U_FUNC(IFUNC1,tt,DXDY)
                        ELSE
c           constant STIM level
                              STIM = abs(cm(2))
                        ENDIF
                        IF (STIM.GT.1.0) THEN
                              STIM = 1.0
                        ELSE IF (STIM.LT.0.0) THEN
                              STIM = 0.0
                        ENDIF
                  ELSE
                        STIM = STIM_lambda(cm ,l_CE_opt,UVAR,lCEdelay,dotlCEdelay,tt,lambda,dlambda,NUVAR,I)
                  ENDIF
            CASE (2,3) 
c     HYBRID CONTROLLER STANDARD and KISTEMAKER
                  IF (cm(2).GT.0.0) THEN
c           STIM from curve
                        STIM = GET_U_FUNC(IFUNC1,tt,DXDY)
                  ELSE
c           constant STIM level
                        STIM = abs(cm(2))
                  ENDIF
                  IF (STIM.GT.1.0) THEN
                        STIM = 1.0
                  ELSE IF (STIM.LT.0.0) THEN
                        STIM = 0.0
                  ENDIF
                  IF (cm(34).LT.0.0) THEN
c           lambda from curve
                        lambda = GET_U_FUNC(IFUNC3,tt,DXDY)
                        dlambda=0.0
                  ELSE
c           lambda = constant                
                        lambda = abs(cm(34))
                        dlambda=0.0
                  ENDIF
                  IF (lambda.LT.0.0) THEN
                        lambda = 0.0
                  ENDIF
                  UVAR(50,I) = lambda
                  IF (tt.GE.cm(38)) THEN
                        STIM_closed = STIM_lambda(cm ,l_CE_opt,UVAR,lCEdelay,dotlCEdelay,tt,lambda,dlambda,NUVAR,I)
                        STIM = STIM_hybrid(cm,l_CE_opt,UVAR,STIM_open,lambda,dlambda,lCEdelay,DOtlCEdelay,tt,NUVAR,I)
                  ENDIF
            CASE (4) 
c       REFLEX CONTROLLER    
                  IF (tt.LT.cm(38)) THEN
                        IF (cm(2).GT.0.0) THEN
c           STIM from curve
                              STIM = GET_U_FUNC(IFUNC1,tt,DXDY)
                        ELSE
c           constant STIM level
                              STIM = abs(cm(2))
                        ENDIF
                        IF (STIM.GT.1.0) THEN
                              STIM = 1.0
                        ELSE IF (STIM.LT.0.0) THEN
                              STIM = 0.0
                        END IF 
                  ELSE
                        STIM = STIM_reflex(ncycle,cm,UVAR,tt,I,NUVAR)
                  ENDIF
            CASE DEFAULT
                  STIM = 0
            END SELECT
            calc_STIM = STIM
            UVAR(2,I) = STIM
            RETURN
      END FUNCTION calc_STIM
C		
C-----------------------------------------------
C   calc_dgam FUNCTION 
C-----------------------------------------------   
C
      DOUBLE PRECISION FUNCTION calc_dgam(cm,STIM,UVAR,NUVAR,I)
            DOUBLE PRECISION cm(*), UVAR(NUVAR,I)
            DOUBLE PRECISION :: STIM
            INTEGER I
C
            calc_dgam = cm(7)*(STIM-UVAR(15,I))
C
            RETURN
            END FUNCTION calc_dgam
C		
C-----------------------------------------------
C   calc_dq FUNCTION 
C-----------------------------------------------   
c
      DOUBLE PRECISION FUNCTION calc_dq(UVAR,cm,STIM,tau_q,NUVAR,I)
c  calculates activation with the differential equation
c
         INTEGER NUVAR,I
         DOUBLE PRECISION cm(*),UVAR(NUVAR,I)
         DOUBLE PRECISION STIM,tau_q
c
         calc_dq = 1/tau_q*(STIM-STIM*(1.0-cm(5))*(UVAR(3,I)-cm(3))-cm(5)
     1   *(UVAR(3,I)-cm(3)))
      RETURN
      END FUNCTION calc_dq
C-----------------------------------------------
C   calc_q FUNCTION 
C-----------------------------------------------   

      DOUBLE PRECISION FUNCTION calc_q(cm,l_CE_opt,UVAR,tt,STIM,DT,NUVAR,I,GET_U_FUNC,IFUNC2)
            INTEGER NUVAR,I,IFUNC2
            DOUBLE PRECISION cm(*), UVAR(NUVAR,I)
            DOUBLE PRECISION STIM, q, gam_rel, rho_act, tau
            DOUBLE PRECISION calc_dq, calc_dgam,tt, DT,GET_U_FUNC,l_CE_opt     
            q = cm(3)
            IF (cm(1).EQ.1.0) THEN
c     ZAJAC activation dynamics      
c       get tau
                  IF (cm(4).LT.0.0) THEN
c           tau from curve
                        tau = GET_U_FUNC(IFUNC2,tt,DXDY)
                  ELSE
                        tau = cm(4)
                  ENDIF
c       calc new q
            q = UVAR(3,I) + calc_dq(UVAR,cm,STIM,tau,NUVAR,I)*DT
            ELSE IF (cm(1).EQ.2.0) THEN
c     HATZE activation dynamics
c       calc new gamma
              gam_rel = UVAR(15,I) + calc_dgam(cm,STIM,UVAR,NUVAR,I)*DT
              UVAR(15,I) = gam_rel
c       calc new rho
              rho_act = cm(4)*cm(5)*(cm(6)-1.0)/(cm(6)-(UVAR(10,I)/l_CE_opt))
     1    *(UVAR(10,I)/l_CE_opt)
c       calc new q
              q = (cm(3)+(rho_act*gam_rel)**3)/(1.0+(rho_act*gam_rel)**3)
            ELSE IF (cm(1).EQ.3.0) THEN
c     Modified HATZE activation dynamics by Rockenfeller, Günther 2018
c       calc new gamma
              gam_rel = UVAR(15,I) + calc_dgam(cm,STIM,UVAR,NUVAR,I)*DT
              UVAR(15,I) = gam_rel
c       calc new rho
              rho_act = cm(4)*cm(5)*UVAR(10,I)/l_CE_opt
c       calc new q
              q = (cm(3)+(rho_act*gam_rel)**3)/(1.0+(rho_act*gam_rel)**3)
            ENDIF
            IF (q.GT.1.0) THEN
              q = 1.0
            ELSE IF (q.LT.cm(3)) THEN
              q = cm(3)
            ENDIF
            UVAR(3,I) = q
            calc_q = q
            RETURN
            END FUNCTION calc_q
C-----------------------------------------------
C   delaylCE FUNCTION
C----------------------------------------------- 
      DOUBLE PRECISION function delaylCE(ncycle,UVAR,cm,tt,NUVAR,I)
      DOUBLE PRECISION lasttime, DT1,tt
      INTEGER NUVAR,I,ncycle
      DOUBLE PRECISION cm(*),UVAR(NUVAR,I) 
      INTEGER index1,index2,indexr1, indexr2, iter
c param declaration
      lasttime = UVAR(34,I);
c dt = delay/buffersize
      DT1       = cm(37)/UVAR(30,I);
      indexr1  = UVAR(32,I);
      indexr2  = UVAR(33,I);
      IF (ncycle.LE.3) THEN
c  initialisation
c  set ring buffer values to 0.   
            DO iter =1 , (UVAR(30,I))
                  UVAR((UVAR(31,I)+  iter - 1),I) = 0;
            ENDDO
      ELSEIF (tt.gt.(lasttime + DT1)) THEN
      lasttime = lasttime + DT1
c   mod ensures jump from end to the beginning of the ringbuffer
      indexr1 = mod((UVAR(32,I)+1),(UVAR(30,I)))
      indexr2 = mod((UVAR(33,I)+1),(UVAR(30,I)))
c   save current lce
      index1 = UVAR(31,I) + indexr1
      UVAR(index1,I) = UVAR(10,I);
      ENDIF
c   define absolute index position of current delayedlCE value     
      index2 = UVAR(31,I) + indexr2
c   return delayedlCE
      delaylCE = UVAR(index2,I)       
      UVAR(32,I) = indexr1
      UVAR(33,I) = indexr2
      UVAR(34,I) = lasttime
      return
      end
c
C-----------------------------------------------
C   delaydotlCE FUNCTION
C----------------------------------------------- 
      DOUBLE PRECISION FUNCTION delaydotlCE(ncycle,UVAR,cm,tt,NUVAR,I)
      DOUBLE PRECISION lasttimed,DT1,tt
      integer ncycle,NUVAR,I
      DOUBLE PRECISION cm(*),UVAR(NUVAR,I) 
      integer indexd1,indexd2,indexdr1,indexdr2,iterd
c   ---------initialisation ------
c   param declaration
      lasttimed = UVAR(39,I)
      DT1        = cm(37)/UVAR(30,I)
      indexdr1  = UVAR(37,I)
      indexdr2  = UVAR(38,I)
      IF (ncycle.LE.3) THEN
c   set ring buffer values to 0.   
      DO iterd=1,(UVAR(30,I))
            UVAR((UVAR(36,I) + iterd-1),I) = 0
      ENDDO
      ELSEIF (tt.gt.(lasttimed + DT1)) THEN
            lasttimed = lasttimed + DT1
c   mod ensures jump from end to the beginning of the ringbuffer
            indexdr1 = mod((UVAR(37,I)+1),(UVAR(30,I)))
            indexdr2 = mod((UVAR(38,I)+1),(UVAR(30,I)))
            indexd1 = UVAR(36,I) + indexdr1
c   save current dot_lce
      UVAR(indexd1,I) = UVAR(12,I)
      ENDIF 
c   define absolute index position of current delayeddotlCE value 
      indexd2 = UVAR(36,I) + indexdr2
c   return delayeddotlCE
      delaydotlCE = UVAR(indexd2,I)
      UVAR(39,I) = lasttimed
      UVAR(37,I) = indexdr1
      UVAR(38,I) = indexdr2
      return
      end
C-----------------------------------------------
C   ZEROIN FUNCTION
C----------------------------------------------- 
C         
      DOUBLE PRECISION function ZEROIN(elleng,l_CE_opt,l_SEE_0,act,cm,l_SEE_nll,K_SEE_nl,v_SEE,l_PEE0,K_PEE,K_SEE_l)
      IMPLICIT NONE
C!-----------------------------------------------
c!     Root-finding algorithm using the ZEROIN function
c!     from Sec. 7.2 of:
c!
c!     Forsythe, G.E.; Malcolm, M.A.; Moler, C.B.: Computer Methods for
c!     Mathematical Computations. Prentice Hall Professional Technical 
c!     Reference, 1977
c!
c!     as interval we used [0,elleng], the function to evaluate F(X)
c!     is calc_F_sum(X,elleng,act,cm).
      DOUBLE PRECISION elleng, act,l_SEE_nll,K_SEE_nl
      DOUBLE PRECISION cm(*)        
c!         a zero of the function F(X) is computed in the Interval AX,BX
c!         INPUT:
c!         AX   LEFT ENDPOINT OF INITIAL INTERVAL
c!         BX   RIGHT ENDPOINT OF INITIAL INTERVAL
c!         F    FUNCTION SUBPROGRAM WHICH EVALUATES F(X)
c!              ANY X IN THE INTERVAL AX,BX
c!         TOL  DESIRED LENGTH OF THE INTERVAL OF UNCERTAINTY
c!              OF THE FINAL RESULT (.GE. 0.0)
c!
c!         OUTPUT:
c!         ZEROIN ABCISSA APPROXIMATING A ZERO OF F IN THE INTERVAL AX,BX
      DOUBLE PRECISION A,B,C,D,E,EPS,FA,FB,FC,TOL1,XM,P,Q,R,S,TOL
      DOUBLE PRECISION AX,BX, TOL_CALC
      DOUBLE PRECISION calc_F_SUM,v_SEE,l_PEE0,K_PEE,K_SEE_l,l_CE_opt,l_SEE_0
c!
c!   Get the numerical machine tolerance 
c!
      TOL  = 2.2E-16
      EPS  = 1.0
 10   EPS = EPS/2.0
      TOL_CALC = 1.0 + EPS
      IF (TOL_CALC.GT.1.0) GO TO 10
c!         FIND INTERVAL
      AX  = 0
      BX  = elleng
c         INITIALIZATION
      A   = AX
      B   = BX
      FA  = calc_F_SUM(A,l_CE_opt,l_SEE_0,elleng,act,cm, l_PEE0,K_PEE,
     1 l_SEE_nll,v_SEE,K_SEE_nl, K_SEE_l)
C
      FB  = calc_F_SUM(B ,l_CE_opt,l_SEE_0,elleng,act,cm, l_PEE0,
     2 K_PEE,l_SEE_nll,v_SEE,K_SEE_nl, K_SEE_l)
c        BEGIN STEP
20    C   = A
      FC  = FA
      D   = B-A
      E   = D
30    IF (ABS(FC).GE.ABS(FB)) GO TO 40
      A   = B
      B   = C
      C   = A
      FA  = FB
      FB  = FC
      FC  = FA
c         CONVERGENCE TEST
40    TOL1= 2.0*EPS*ABS(B)+0.5*TOL
      XM  = 0.5*(C-B)
      IF (ABS(XM).LE.TOL1) GO TO 90
      IF (FB.EQ.0.0) GO TO 90
c         IS BISECTION NECESSARY
      IF (ABS(E).LT.TOL1) GO TO 70
      IF (ABS(FA).LE.ABS(FB)) GO TO 70
c        IS QUADRATIC INTERPOLATION POSSIBLE
      IF (A.NE.C) GO TO 50
c        LINEAR INTERPOLATION
      S   = FB/FA
      P   = 2.0d0*XM*S
      Q   = 1.0d0-S
      GO TO 60
c        INVERSE QUADRATIC INTERPOLATION
50    Q   = FA/FC
      R   = FB/FC
      S   = FB/FA
      P   = S*(2.0*XM*Q*(Q-R)-(B-A)*(R-1.0))
      Q   = (Q-1.0)*(R-1.0)*(S-1.0)
c        ADJUST SIGNS
60    IF (P.GT.0.0) Q=-Q
            P   = ABS(P)
c        IS INTERPOLATION ACCEPTABLE
      IF ((2.0*P) .GE. (3.0*XM*Q-ABS(TOL1*Q))) GO TO 70
      IF (P .GE. ABS(0.5*E*Q)) GO TO 70
            E   = D
            D   = P/Q
      GO TO 80
c        BISECTION
70    D   = XM
      E   = D
c        COMPLETE STEP
80    A   = B
      FA  = FB
      IF (ABS(D) .GT. TOL1) B = B+D
      IF (ABS(D) .LE. TOL1) B = B+SIGN(TOL1,XM)
      FB  = calc_F_SUM(B,l_CE_opt,l_SEE_0,elleng,act,cm, l_PEE0,
     1 K_PEE,l_SEE_nll,v_SEE,K_SEE_nl, K_SEE_l)
      IF ((FB*(FC/ABS(FC))) .GT. 0.0) GO TO 20
      GO TO 30
c        DONE
90    ZEROIN=B
      RETURN
      END FUNCTION ZEROIN
C
C-----------------------------------------------
C   STIM_lambda FUNCTION ! output STIM_lambda
C----------------------------------------------
C
      DOUBLE PRECISION FUNCTION STIM_lambda(cm ,l_CE_opt,UVAR,lCEdelay,dotlCEdelay,tt,lambda,dlambda,NUVAR,I)
            DOUBLE PRECISION cm(*),UVAR(NUVAR,I)
            DOUBLE PRECISION lCEdelay,dotlCEdelay,lambda, tt, dlambda,l_CE_opt
            INTEGER I,NUVAR
C
                  STIM_lambda = (cm(35)*(lCEdelay-lambda)+cm(36)*(dotlCEdelay-dlambda))/l_CE_opt
                  IF (cm(33).EQ.3) THEN
                        IF (STIM_lambda.GT.1.0) THEN
                              STIM_lambda = 1.0d0
                        ELSE IF (STIM_lambda.LT.-1.0) THEN
                              STIM_lambda = -1.0d0
                        ELSE
                              CONTINUE
                        END IF
                  ELSE
                        IF (STIM_lambda.GT.1.0) THEN
                              STIM_lambda = 1.0d0
                        ELSE IF (STIM_lambda.LT.0.0) THEN
                              STIM_lambda = 0.0d0
                        ELSE
                              CONTINUE
                        END IF
                  END IF
            RETURN
            END FUNCTION STIM_lambda
C
C-----------------------------------------------
C  Hybrid controller FUNCTION ! output STIM_hybrid
C----------------------------------------------
C
      DOUBLE PRECISION function STIM_hybrid(cm,l_CE_opt,UVAR,STIM_open,lambda,dlambda,lCEdelay,DOtlCEdelay,tt,NUVAR,I)
            IMPLICIT NONE
            INTEGER NUVAR, I
            DOUBLE PRECISION cm(*),UVAR(NUVAR,I)
            DOUBLE PRECISION STIM_open, lambda, dlambda, tt
            DOUBLE PRECISION lCEdelay, DOtlCEdelay,l_CE_opt
            IF (lCEdelay.GT.lambda) THEN
                  STIM_hybrid=(STIM_open+(cm(35)*(lCEdelay-lambda)+cm(36)*(DOtlCEdelay-dlambda))/l_CE_opt)
            ELSE 
                  STIM_hybrid=STIM_open
            END IF
            IF (STIM_hybrid.GT.1.0) THEN
                  STIM_hybrid = 1.0
            ELSE IF (STIM_hybrid.LT.0.0) THEN
                  STIM_hybrid = 0.0
            END IF
            RETURN
            END FUNCTION STIM_hybrid
C
C-----------------------------------------------
C  Reflexive Controller function ! output STIM_reflex
C----------------------------------------------
C
      DOUBLE PRECISION function STIM_reflex(ncycle,cm,UVAR,tt,I,NUVAR)
            IMPLICIT NONE
            DOUBLE PRECISION  cm(*),UVAR(NUVAR,*)
            DOUBLE PRECISION  tt
            INTEGER ncycle,I,NUVAR
c!        initialization of strain (UVAR(23))
            UVAR(23,I) = 0.0d0
c!        initialization of l_CE_ref = l_CE(t=0) OR
c!        IF time < t_PreSim THEN l_CE_ref = l_CE -- l_CE_ref = l_CE(t=t_PreSim)
            IF (ncycle.LE. 3 .OR. tt .LE. cm(38).OR. UVAR(22,I).EQ.0.) THEN
                  UVAR(22,I) = UVAR(10,I)         
            END IF 
c!   UVAR(22) (=l_CE_ref) = l_CE(t=t_PreSim) 
c!   IF time  t_PreSim + delay: calc strain (strain = 0 for t<t_PreSim + delay)
            IF(tt.GT.(cm(38)+cm(37))) THEN
c!   UVAR(23) (=strain) = (lCEdelay-l_CE_ref)/l_CE_ref
                  UVAR(23,I) = (UVAR(20,I)-UVAR(22,I))/UVAR(22,I)       
c!   IF strain bigger than threshold -- activate reflex
            IF ( UVAR(23,I) .GT. cm(39) ) THEN
                  STIM_reflex = 1
c!   IF reflex was active and strain bigger than zero -- activate reflex 
            ELSEif (UVAR(24,I) .EQ. 1 .and. UVAR(23,I) .GE. 0) THEN
                  STIM_reflex = 1
c!   otherwise -- deactivate reflex           
            ELSE
                  STIM_reflex = 0
            END IF    
            END IF
                  UVAR(24,I) = STIM_reflex
            RETURn
            END FUNCTION STIM_reflex
C
Chd|====================================================================
Chd|  RUSER30                                                     
Chd|-- called by -----------
Chd|-- calls ---------------
Chd|        GET_U_FUNC                                                  
Chd|        GET_U_PNU                                                   
Chd|====================================================================
      SUBROUTINE RUSER30(NEL, IOUT   ,IPROP  ,UVAR   ,NUVAR  ,
     2             FX      ,FY      ,FZ     ,XMOM   ,YMOM   ,
     3             ZMOM    ,E       ,OFF    ,STIFM  ,STIFR  ,
     4             VISCM   ,VISCR   ,MASS   ,XINER  ,DT     ,
     5             XL      ,VX      ,RY1    ,RZ1    ,RX     ,
     6             RY2     ,RZ2     ,FR_WAVE)
C-------------------------------------------------------------------------
C     This subroutine compute springs forces and moments.
C-------------------------------------------------------------------------
C----------+---------+---+---+--------------------------------------------
C VAR      | SIZE    |TYP| RW| DEFINITION
C----------+---------+---+---+--------------------------------------------
C IOUT     |  1      | I | R | OUTPUT FILE UNIT (L00 file)
C IPROP    |  1      | I | R | PROPERTY NUMBER
C----------+---------+---+---+--------------------------------------------
C XL       |   NEL   | F | R | ELEMENT LENGTH
C----------+---------+---+---+--------------------------------------------
C UVAR     |NUVAR*NEL| F |R/W| USER ELEMENT VARIABLES
C NUVAR    |  1      | I | R | NUMBER OF USER ELEMENT VARIABLES
C----------+---------+---+---+--------------------------------------------
C LIONEL MORANCAY, MECALOG, 03-24-1999
C The user routine does not need to return elements mass in vector MASS : 
C this vector is not used by RADIOSS since version 4.1E.
C The mass which is used by RADIOSS for time step (and output) is the 
C initial mass which was returned by user routine RINI29 into starter.
C-------------------------------------------------------------------------
C FUNCTION 
C-------------------------------------------------------------------------
C INTEGER II = GET_U_PNU(I,IP,KK)
C         IFUNCI = GET_U_PNU(I,IP,KFUNC)
C         IPROPI = GET_U_PNU(I,IP,KFUNC)
C         IMATI  = GET_U_PNU(I,IP,KMAT)
C         I     :     VARIABLE INDEX(1 for first variable,...)
C         IP    :     PROPERTY NUMBER
C         KK    :     PARAMETER KFUNC,KMAT,KPROP
C         THIS FUNCTION RETURN THE USER STORED FUNCTION(IF KK=KFUNC), 
C         MATERIAL(IF KK=KMAT) OR PROPERTY(IF KK=KPROP) NUMBER. 
C         SEE LECG29 FOR CORRESPONDING ID STORAGE.
C-------------------------------------------------------------------------
C INTEGER IFUNCI = GET_U_MNU(I,IM,KFUNC)
C         I     :     VARIABLE INDEX(1 for first function)
C         IM    :     MATERIAL NUMBER
C         KFUNC :     ONLY FUNCTION ARE YET AVAILABLE.
C         THIS FUNCTION RETURN THE USER STORED FUNCTION NUMBER(function 
C         refered by users materials).
C         SEE LECM29 FOR CORRESPONDING ID STORAGE.
C-------------------------------------------------------------------------
C my_real PARAMI = GET_U_GEO(I,IP)
C         I     :     PARAMETER INDEX(1 for first parameter,...)
C         IP    :     PROPERTY NUMBER
C         THIS FUNCTION RETURN THE USER GEOMETRY PARAMETERS 
C         NOTE: IF(IP==IPROP) UPARAG(I) == GET_U_GEO(I,IPROP)
C         see lecg30 for storage
C-------------------------------------------------------------------------
C my_real PARAMI = GET_U_MAT(I,IM)
C         I     :     PARAMETER INDEX(1 for first parameter,...)
C         IM    :     MATERIAL NUMBER
C         THIS FUNCTION RETURN THE USER MATERIAL PARAMETERS 
C         NOTE: GET_U_MAT(0,IMAT) RETURN THE DENSITY
C         see lecm29,30,31 for storage
C-------------------------------------------------------------------------
C INTEGER PID = GET_U_PID(IP)
C         IP    :     PROPERTY NUMBER
C         THIS FUNCTION RETURN THE USER PROPERTY ID CORRESPONDING TO
C         USER PROPERTY NUMBER IP. 
C-------------------------------------------------------------------------
C INTEGER MID = GET_U_MID(IM)
C         IM   :     MATERIAL NUMBER
C         THIS FUNCTION RETURN THE USER MATERIAL ID CORRESPONDING TO
C         USER MATERIAL NUMBER IM. 
C-------------------------------------------------------------------------
C my_real Y = GET_U_FUNC(IFUNC,X,DXDY)
C         IFUNC :     function number obtained by 
C                     IFUNC = GET_U_MNU(I,IM,KFUNC) or IFUNC = GET_U_PNU(I,IP,KFUNC)
C         X     :     X value
C         DXDY  :     slope dX/dY
C         THIS FUNCTION RETURN Y(X)
C-------------------------------------------------------------------------
C-----------------------------------------------
C   I m p l i c i t   T y p e s
C-----------------------------------------------
      IMPLICIT NONE
C----------------------------------------------------------
C   D u m m y   A r g u m e n t s   a n d   F u n c t i o n
C----------------------------------------------------------
      INTEGER IOUT,NEL,NUVAR,IPROP,GET_U_CYCLE,
     .        GET_U_PNU,GET_U_PID,GET_U_MID,GET_U_MNU,
     .        KFUNC,KMAT,KPROP,GET_SPRING_ELNUM,NSENS
C
      DOUBLE PRECISION
     .   UVAR(NUVAR,*),DT , 
     .   FX(*), FY(*), FZ(*), E(*), VX(*),MASS(*) ,XINER(*),
     .   RY1(*), RZ1(*), OFF(*), XMOM(*), YMOM(*),
     .   ZMOM(*), RX(*), RY2(*), RZ2(*),XL(*),
     .   STIFM(*) ,STIFR(*) , VISCM(*) ,VISCR(*) ,FR_WAVE(*) ,
     .   GET_U_MAT, GET_U_GEO, GET_U_TIME, GET_U_FUNC
      EXTERNAL GET_U_MNU,GET_U_PNU,GET_U_MID,GET_U_PID,
     .         GET_U_MAT,GET_U_GEO, GET_U_TIME,GET_U_CYCLE,
     .         GET_SPRING_ELNUM,GET_U_FUNC

      PARAMETER (KFUNC=29)
      PARAMETER (KMAT=31)
      PARAMETER (KPROP=33)
C=================================================================
C
C     EXAMPLE 2 : Elastoplastic truss defined with 1 user property.
C                 
C               
C=================================================================
C-----------------------------------------------
C   L o c a l   V a r i a b l e s
C-----------------------------------------------
      INTEGER I,SENS_IDi,ncycle,IFUNC1, IFUNC2, IFUNC3
      DOUBLE PRECISION
     .        X,DX,DXDY
      DOUBLE PRECISION
     .   UN,ZERO,tt,NEWLEN,ierr
      INTEGER SENS_ID,IERROR,ActOpt,output_MTD,STIM_ID,numelb
      DOUBLE PRECISION
     .  AMAS,DIAMETER,ELASTIF,XK,SENS_IDf,STIM_ID_f,q0,tauq,betaq,k,m,muscle,
     .  Fmax,t_lCEopt,dWdes,
     .  nuCEdes,dWasc,nuCEasc,Arel0,Brel0,
     .  Secc,Fecc,LPEE0,nuPEE,FPEE,dUSEEnll,duSEEl,
     .  dFSEE0,Damping,Param1,Param2,
     .  timeste,Activation,target_l_CE,kp,kd,
     .  DOtlCEdelay,t_PreSim,threshold,ActOpt_f,  
     .  l_PEE0,K_PEE,d_SE_max,l_SEE_nll,v_SEE,K_SEE_nl, 
     .  K_SEE_l, elleng,ZEROIN,calc_STIM,
C-----------------------------------------------
C   History variables --> UVAR
C-----------------------------------------------
     . STIM,q,F_MTC, F_CE,F_PEE,F_SEE,F_SDE,l_MTC,l_CE, DOt_l_MTC, 
     . DOt_l_CE, counter_output, F_isom, gam_rel, l_MTC_0,
     . lCEdelay, l_CE_ref, strain, STIM_reflex_prev,
     . buffersize, idx_begin_lCEbuffer, lasttime, calc_F_isom, calc_F_PEE, calc_F_SEE,
     . calc_F_SUM, calc_dq,calc_q, calc_dgam, epsilon,tau, lambda,dlambda,
     . rho_act, STIM_lambda, STIM_hybrid, STIM_reflex,dq,l_CE_opt,l_SEE_0
C-----------------------------------------------
C-----------------------------------------------
      DOUBLE PRECISION
     .  cm(39)
C -----------------------------------------------
      CHARACTER*100 FILENAME, COMMAND                       ! USED FOR VARIABLES CHECK
      INTEGER J, IO_STATUS
      DOUBLE PRECISION :: PLOT_X, PLOT_Y, test1, test2, test3 
C-----------------------------------------------
C-----------------------------------------------
      UN   = 1.0d0
      ZERO = 0.0d0
c! ------------------------------------------------------------
c! ------ history variables - overview ------------------------
c! ------------------------------------------------------------
c!         UVAR(1)    = sig(1)
c!         uvar(2)    = STIM
c!         uvar(3)    = q
c!         uvar(4)    = F_MTC
c!         uvar(5)    = F_CE
c!         uvar(6)    = F_PEE
c!         uvar(7)    = F_SEE
c!         uvar(8)    = F_SDE
c!         uvar(9)    = elleng (l_MTC)
c!         uvar(10)   = l_CE
c!         uvar(11)   = dot_l_MTC
c!         uvar(12)   = dot_l_CE
c!         uvar(13)   = counter_output
c!         uvar(14)   = F_isom
c!         uvar(15)   = gam_rel
c!         uvar(16)   = l_MTC_0 (initial element length)
c! ------------------------------------------------------------
c! ------ only needed if controller are used ------------------
c! ------------------------------------------------------------
c!         uvar(20)   = lCEdelay
c!         uvar(21)   = dotlCEdelay
c!         uvar(22)   = l_CE_ref (for reflex controller)
c!         uvar(23)   = strain (for reflex controller)
c!         uvar(24)   = STIM_reflex_prev (STIM value of reflex controller in previous timestep)
c! ------------------------------------------------------------
c! ------ delay buffer-----------------------------------------
c! ------------------------------------------------------------
c!         uvar(30)   = buffersize
c!         uvar(31)   = idx_begin_lCEbuffer (uvar(142:145) seems to be used internally by lsdyna, suggestion: use uvar(31)=150)
c!         uvar(32)   = indexr1...index1 of lce-ringbuffer (not eq index of uvar)
c!         uvar(33)   = indexr1...index2 of lce-ringbuffer (not eq index of uvar)
c!         uvar(34)   = lasttime
c!         uvar(36)   = begindotlCE
c!         uvar(37)   = indexdotr1...index1 of dotlce-ringbuffer (not eq index of uvar)    
c!         uvar(38)   = indexdotr2...index2 of dotlce-ringbuffer (not eq index of uvar)  
c!         uvar(39)   = dotlasttime   
c!         uvar(uvar(31):uvar(31)+uvar(30)-1) = ringbuffer_l_CE
c!         uvar(uvar(36):uvar(36)+uvar(30)-1) = ringbuffer_dot_l_CE
C----------------------------------------------------------
!       FILENAME = "C:/Work/Tools/userlib_sdk/examples/USER_dump/"//                  ! PATH FOR CHEKING PLOT FILES
!      1 "Springs/EXCEL_TESTS/" //
!      2 "EXCEL_TEST_DATA.csv"
      FILENAME = "C:/Memoire/Etude_sensibilite/MISE_A_JOUR/OBSERVATIONS"//              
     1 "/OBSERVATIONS.csv"
C----------------------------------------------------------
      !print *,' ****** ruser START'
      ncycle = GET_U_CYCLE()
      tt   = GET_U_TIME()

      ELASTIF  = GET_U_GEO(2,IPROP)
      DIAMETER = GET_U_GEO(3,IPROP)

      AMAS     = GET_U_GEO(1,IPROP)
c!        IERROR = SET_U_GEO(2,ELASTIF)
c!     Variables (activation dynamic)
      ActOpt      = INT(GET_U_GEO(4,IPROP)+0.0001)
      ActOpt_f    = GET_U_GEO(4,IPROP)
      cm(1)       = INT(ActOpt_f)
      SENS_ID     = INT(GET_U_GEO(5,IPROP)+0.0001)
                    
      STIM_ID     = INT(GET_U_GEO(6,IPROP)+0.0001)
      STIM_ID_f   = GET_U_GEO(6,IPROP)
      cm(2)       = STIM_ID_f                      ! *** is/can be evtl. a function // NOT USED YET 

c!        IFUNC1 = GET_U_PNU(1,IPROP,KFUNC)
c!        
c!        IF (IFUNC1.EQ.ZERO)THEN
c!           SCALE_D1 = 1.0
c!        ELSE
c!           SCALE_D1 = GET_U_FUNC(IFUNC1,TT,DXDY)
c!        ENDIF
C----------------------------------------------------------

C----------------------------------------------------------     
      q0          = GET_U_GEO(7,IPROP)
      cm(3)       = q0
      tauq        = GET_U_GEO(8,IPROP)
      cm(4)       = tauq
      betaq       = GET_U_GEO(9,IPROP)
      cm(5)       = betaq
      k           = GET_U_GEO(10,IPROP)
      cm(6)       = k
                     
      m           = GET_U_GEO(11,IPROP)
      cm(7)       = m
      muscle      = GET_U_GEO(12,IPROP)
      cm(8)       = muscle
c!
c!     Variables (isometric force)
c!
      Fmax        = GET_U_GEO(13,IPROP)
      cm(9)       = Fmax
      t_lCEopt      = GET_U_GEO(14,IPROP)
      cm(10)      = t_lCEopt
      dWdes       = GET_U_GEO(15,IPROP)
      cm(11)      = dWdes
                     
      nuCEdes     = GET_U_GEO(16,IPROP)
      cm(12)      = nuCEdes
      dWasc       = GET_U_GEO(17,IPROP)
      cm(13)      = dWasc
      nuCEasc     = GET_U_GEO(18,IPROP)
      cm(14)      = nuCEasc
c!
c!     Variables (Hill Parameter, concentric)
c!
    
      Arel0       = GET_U_GEO(19,IPROP)
      cm(15)      = Arel0
      Brel0       = GET_U_GEO(20,IPROP)
      cm(16)      = Brel0                
c!
c!     Variables (van Soest Parameter, eccentric)
c!
      Secc        = GET_U_GEO(21,IPROP)
      cm(17)      = Secc
      Fecc        = GET_U_GEO(22,IPROP)
      cm(18)      = Fecc
c!
c!     Variables (Parallel elastic element)
c!

      LPEE0       = GET_U_GEO(23,IPROP)
      cm(19)      = LPEE0
      nuPEE       = GET_U_GEO(24,IPROP)
      cm(20)      = nuPEE
      FPEE        = GET_U_GEO(25,IPROP)
      cm(21)      = FPEE
c!
c!     Variables (Seriell elastic element)
c!

      dUSEEnll    = GET_U_GEO(27,IPROP)
      cm(23)      = dUSEEnll
      duSEEl      = GET_U_GEO(28,IPROP)
      cm(24)      = duSEEl
      dFSEE0      = GET_U_GEO(29,IPROP)
      cm(25)      = dFSEE0
c!
c!     Variables (Damping element)
c!
                     
      Damping     = GET_U_GEO(30,IPROP)
      cm(26)      = Damping
      Param1      = GET_U_GEO(31,IPROP)
      cm(27)      = Param1
      Param2      = GET_U_GEO(32,IPROP)
      cm(28)      = Param2
c!
c!     Variables (Output definition; musout.(partid))
c!
c!     cm(29)=output method (EQ.0.  no output 
c!                           EQ.1.  advanced output (basic output plus dot_l_CE, dot_l_MTC, lCEdelay, dotlCEdelay))
c!
      output_MTD  = INT(GET_U_GEO(33,IPROP)+0.0001)
      cm(29)      = GET_U_GEO(33,IPROP)
      
      timeste     = GET_U_GEO(34,IPROP)
      cm(30)      = timeste
c!
c!     Variables for Controller
c!
c!     cm(33) = Activation Method (EQ.1. lambda_controller
c!                               EQ.2. hybrid_controller
c!                               EQ.3. reflexive controller)
c!
      Activation  = GET_U_GEO(35,IPROP)
      cm(33)      = Activation
C      
      target_l_CE = GET_U_GEO(36,IPROP)
      cm(34)      = target_l_CE
C
      kp          = GET_U_GEO(37,IPROP)
      cm(35)      = kp
      kd          = GET_U_GEO(38,IPROP)
      cm(36)      = kd
                     
      dotlCEdelay = GET_U_GEO(39,IPROP)
      cm(37)      = dotlCEdelay
      t_PreSim    = GET_U_GEO(40,IPROP)
      cm(38)      = t_PreSim
      threshold   = GET_U_GEO(41,IPROP)
      cm(39)      = threshold

      IFUNC1 = GET_U_PNU(1,IPROP,KFUNC)        
      IFUNC2 = GET_U_PNU(2,IPROP,KFUNC)         
      IFUNC3 = GET_U_PNU(3,IPROP,KFUNC)      
C
C initialization of initial laength 
      IF (tt.EQ.0.0) THEN
        DO I = 1,NEL
          !UVAR(1,I) = XL(I)
            UVAR(16,I) = XL(I) + cm(8)
          print *,''
          print *,'*************************************'
          print *,'* VERSION from 27.06.2024 - ver. a1 *'
          print *,'*************************************'
          print *,''
          
          print *,'Spring #= ',GET_SPRING_ELNUM(I),' ; MASS =',MASS(I),' Initialization:'
          print *,'AMAS     =',AMAS
          print *,'ELASTIF       ',ELASTIF
          print *,'DIAMETER      ',DIAMETER
          print *,'ActOpt      = ',ActOpt     
          print *,'ActOpt_f    = ',ActOpt_f   , cm(1)
          print *,'SENS_ID     = ',SENS_ID   
                                              
          print *,'STIM_ID     = ',STIM_ID    , cm(2)
          print *,'q0          = ',q0         , cm(3)
          print *,'tauq        = ',tauq       , cm(4)
          print *,'betaq       = ',betaq      , cm(5)
          print *,'k           = ',k          , cm(6)
                                              
          print *,'m           = ',m          , cm(7)
          print *,'muscle      = ',muscle     , cm(8)
          print *,'Fmax        = ',Fmax       , cm(9)
          print *,'t_lCEopt      = ',t_lCEopt  , cm(10)
          print *,'dWdes       = ',dWdes      , cm(11)
                                              
          print *,'nuCEdes     = ',nuCEdes    , cm(12)
          print *,'dWasc       = ',dWasc      , cm(13)
          print *,'nuCEasc     = ',nuCEasc    , cm(14)
          print *,'Arel0       = ',Arel0      , cm(15)
          print *,'Brel0       = ',Brel0      , cm(16)
                                              
          print *,'Secc        = ',Secc       , cm(17)
          print *,'Fecc        = ',Fecc       , cm(18)
          print *,'LPEE0       = ',LPEE0      , cm(19)
          print *,'nuPEE       = ',nuPEE      , cm(20)
          print *,'FPEE        = ',FPEE       , cm(21)
                                              
          print *,'dUSEEnll    = ',dUSEEnll   , cm(23) 
          print *,'duSEEl      = ',duSEEl     , cm(24)
          print *,'dFSEE0      = ',dFSEE0     , cm(25)
                                              
          print *,'Damping     = ',Damping    , cm(26)
          print *,'Param1      = ',Param1     , cm(27)
          print *,'Param2      = ',Param2     , cm(28)
          print *,'output_MTD  = ',output_MTD , cm(29)
                                              
          print *,'timeste     = ',timeste    , cm(30)
c! cm(31) and cm(32) not used ?
          print *,'Activation  = ',Activation , cm(33)
          print *,'target_l_CE = ',target_l_CE, cm(34)
          print *,'kp          = ',kp         , cm(35)
          print *,'kd          = ',kd         , cm(36)
                                              
          print *,'dotlCEdelay = ',dotlCEdelay, cm(37)
          print *,'t_PreSim    = ',t_PreSim   , cm(38)
          print *,'threshold   = ',threshold  , cm(39)
        ENDDO       
      ENDIF
C-----------------------------------------------
C   Muscle constant parameters calculation
C-----------------------------------------------
C		
C -----------------------------------      
C Loop over elements
C -----------------------------------
      DO  I = 1,NEL
C-----------------------------------------------
C   Calc length element
C-----------------------------------------------
C
      l_CE_opt = cm(10)*UVAR(16,I)        !relative elongation of contractile element
      l_SEE_0 = (1-cm(10))*UVAR(16,I)
      l_PEE0 = cm(19)*l_CE_opt 
      d_SE_max = cm(27)*(cm(9)*cm(15))/(l_CE_opt*cm(16))
      l_SEE_nll = (1.0+cm(23))*l_SEE_0 
      v_SEE = cm(23)/cm(24)
      K_SEE_nl = cm(25)/(cm(23)*l_SEE_0)**v_SEE
      K_SEE_l = cm(25)/(cm(24)*l_SEE_0)
      K_PEE = cm(21)*(cm(9)/(l_CE_opt*(cm(11) + 1.0-cm(19)))**cm(20))
!         elleng = sqrt((x(1,ix1(i))-x(1,ix2(i)))**2
!     1  +(x(2,ix1(i))-x(2,ix2(i)))**2
!      2  +(x(3,ix1(i))-x(3,ix2(i)))**2)+cm(8) 
      elleng = XL(I) + cm(8)
c muscle length is element length plus offset
      IF ((DT.EQ.0).OR.(ncycle.LE.1)) then
            q = cm(3)
            UVAR(3,I) = q
            UVAR(13,I) = 0.0
            UVAR(15,I) = 0.0
            UVAR(16,I) = elleng
C     RETURN
      END IF
C-----------------------------------------------
C   Calculation initial muscle force eqilibrium
C-----------------------------------------------
      IF ((ncycle.LT.5).and.(UVAR(13,I).EQ.0)) THEN
C!           UVAR(13,I)=anint(cm(37)/dt1)		
             dot_l_MTC = 0.0
             q = cm(3)
             l_CE = ZEROIN(elleng ,l_CE_opt,l_SEE_0,q,cm,
     1 l_SEE_nll,K_SEE_nl,v_SEE,l_PEE0,K_PEE,K_SEE_l)

            CALL hill_model(l_CE,l_CE_opt,l_SEE_0,elleng, dot_l_MTC, q, cm,
     1 F_MTC, F_SEE, F_SDE, F_CE, F_PEE, F_isom, DT, UVAR,  
     2 dot_l_CE, tt, i, l_PEE0, K_PEE, d_SE_max, l_SEE_nll, v_SEE, K_SEE_nl, K_SEE_l, epsilon, NUVAR)
      END IF
C!
C-----------------------------------------------
C   Calculation of delayed lCE/DOtlCE
C-----------------------------------------------
c ncycle.EQ.3, because for ncycle<=2: dt1==0 in case of part_averaged
c          cm(37) - delay
c          cm(33) - controller higher than Alpha
      IF (cm(33).ge.1.0) THEN
c all controllers        
            IF (cm(37).EQ.0.0) THEN
c all controllers without delay: 
c lCEdelay=lCE dotlCEdelay=dot_l_CE
                  UVAR(20,I)   = UVAR(10,I)
                  UVAR(21,I)   = UVAR(12,I)
            ELSE
c controller with delay used --> ringbuffer needed         
                  CALL ringbuffer(cm,UVAR,ncycle,tt,NUVAR,I)
            ENDIF
               lCEdelay     = UVAR(20,I) 
               dotlCEdelay  = UVAR(20,I)
      ENDIF
C-----------------------------------------------
C   Calculation of activation
C----------------------------------------------
C
      IF (cm(1).EQ.0) THEN
c!      Use Activation Values directly 
            IF (cm(2).LT.0.0) THEN
                  q = GET_U_FUNC(IFUNC1,tt,DXDY)
            ELSE
                  q = abs(cm(2))
            ENDIF
      IF (q.GT.1.0) THEN
            q = 1.0
      ELSE IF (q.LT.0.0) THEN
            q = 0.0
      END IF
      IF (int(cm(33)).EQ.0) THEN
            UVAR(3,I) = q
      ELSE
            IF (tt.LT.cm(38)) THEN
                  UVAR(3,I) = q
            ELSE
                  cm(1) = 3
                  STIM = calc_STIM(cm,UVAR,tt,lCEdelay,dotlCEdelay,ncycle,NUVAR,I,IFUNC1,IFUNC2,IFUNC3,GET_U_FUNC)
                  q = calc_q(cm,l_CE_opt,UVAR,tt,STIM,DT,NUVAR,I,GET_U_FUNC,IFUNC2)      
            END IF
      ENDIF
      ELSE 
            STIM = calc_STIM(cm,UVAR,tt,lCEdelay,dotlCEdelay,ncycle,NUVAR,I,IFUNC1,IFUNC2,IFUNC3,GET_U_FUNC)
            q = calc_q(cm,l_CE_opt,UVAR,tt,STIM,DT,NUVAR,I,GET_U_FUNC,IFUNC2)
      ENDIF
C----------------------calc dot_l_MTC------------
C     IF (ncycle.GT.1) THEN
      l_CE = UVAR(10,I)
      dot_l_MTC = VX(I)
      UVAR(11,I) = dot_l_MTC
C------------------------------------------------
            CALL hill_model(l_CE,l_CE_opt,l_SEE_0,elleng, dot_l_MTC, q, cm,
     1 F_MTC, F_SEE, F_SDE, F_CE, F_PEE, F_isom, DT, UVAR,  
     2 dot_l_CE, tt, i, l_PEE0, K_PEE, d_SE_max, l_SEE_nll, v_SEE, K_SEE_nl, K_SEE_l, epsilon, NUVAR)
C     ENDIF
      ! Problably have to allocate new value to FX(I)
      DX = DT * dot_l_MTC
      elleng = UVAR(9,I) + DX 
C
      FX(I) = F_MTC
C-----------------------------------------------
      UVAR(4,I)= F_MTC
      UVAR(7,I)= F_SEE
      UVAR(8,I)= F_SDE
      UVAR(5,I)= F_CE
      UVAR(6,I)= F_PEE
      UVAR(14,I)= F_isom
      UVAR(9,I)= elleng
      UVAR(10,I)= l_CE
      UVAR(12,I) = dot_l_CE
C----------------------------------------------
      IF (ncycle/100 == (REAL(ncycle)/100)) THEN
C            print*, "F_MTC = ", F_MTC
C            print*, "F_SEE = ", F_SEE
C            print*, "F_SDE = ", F_SDE
C           print*, "F_CE = ", F_CE
C           print*, "F_PEE = ", F_PEE
C            print*, "F_isom = ", F_isom
C            print*, "elleng = ", elleng
C            print*, "l_CE = ", l_CE
C            print*, "dot_l_CE = ", dot_l_CE
C            print*, "dot_l_MTC = ", dot_l_MTC
C            print*, "q = ", q
      ENDIF
C-----------------------------------------------
C      IF (int(cm(29)).EQ.1.0) THEN
C      IF (ncycle/100 == (REAL(ncycle)/100)) THEN
C            OPEN(UNIT=10, FILE=FILENAME, STATUS='OLD', ACTION='WRITE',
C     1 POSITION='APPEND')
C            IF (IO_STATUS /= 0) THEN
C                  PRINT *, 'Error: Cannot open file ', FILENAME
C                  STOP
C            END IF
C                  WRITE(10,'(F10.4," ",F10.4," ",F10.4," ",F10.4," ",F10.4," ",F10.4," ",F10.4," ",F10.4," ",F10.4" ",F10.4)') tt, 
C     1  UVAR(10,I)-UVAR(9,I), UVAR(10,I), UVAR(14,I),
C     2  UVAR(5,I), UVAR(7,I), UVAR(8,I),q,STIM,UVAR(4,I)
C            CLOSE(UNIT=10)
C      ENDIF
C     ENDIF
C-----------------------------------------------     
C        ***       TIMESTEP       ***
C============================================
C       TIME STEP
C============================================
C
          STIFM(I) = ELASTIF
          STIFR(I) = ZERO
          VISCM(I) = ZERO
          VISCR(I) = ZERO
          XINER(I) = ZERO

      END DO
C-----------------------------------------------
      RETURN
      END subroutine ruser30
C-----------------------------------------------
C-----------------------------------------------
C   hill_model SUBROUTINE 
C-----------------------------------------------
      SUBROUTINE hill_model(l_CE,l_CE_opt,l_SEE_0,elleng,dot_l_MTC,q,cm,
     1 F_MTC,F_SEE, F_SDE ,F_CE,F_PEE,F_isom,DT,UVAR,dot_l_CE,tt,I,l_PEE0,
     2 K_PEE,d_SE_max,l_SEE_nll,v_SEE,K_SEE_nl,K_SEE_l,epsilon,NUVAR)
c
       DOUBLE PRECISION, dimension(39) :: cm
       DOUBLE PRECISION :: UVAR(NUVAR,*)
       integer I,NUVAR
       DOUBLE PRECISION A1,B1,dot_h,dot_h_0,ent_rate,mech_eff
       DOUBLE PRECISION l_PEE0, K_PEE, d_SE_max, l_SEE_nll, v_SEE, K_SEE_nl
       DOUBLE PRECISION l_CE, F_isom, F_PEE, F_SEE, l_SEE, L_A_rel, A_rel
       DOUBLE PRECISION B_rel,Q_Brel,D0,C2,C1,C0,dot_l_CE
       DOUBLE PRECISION v_max, P, O1, O2, O3, F_CE, F_CE_init, F_SDE, F_MTC
       DOUBLE PRECISION dot_l_MTC, elleng, K_SEE_l, Q_Arel, F_SUM, AREA
       DOUBLE PRECISION l_MTC_0,DT,tt,epsilon, Power, dot_l_SDE,q
       DOUBLE precision :: calc_F_isom, calc_F_PEE, calc_F_SEE,l_CE_opt,l_SEE_0
 !common /coeff/ l_PEE0,K_PEE,d_SE_max,l_SEE_nll,v_SEE,K_SEE_nl
 !1 ,K_SEE_l,epsilon
c  Isometric Force
c
       F_isom = calc_F_isom(l_CE,l_CE_opt,cm)
c
c  Force of the parallel elastic element PEE
       F_PEE = calc_F_PEE(l_CE, cm, l_PEE0, K_PEE)
c
c  Force of the serial elastic element SEE
c
       F_SEE = calc_F_SEE(l_CE,l_SEE_0,cm,elleng,l_SEE_nll,v_SEE,K_SEE_nl,K_SEE_l)
c
c  Hill Parameters concentric contraction
c
       if (l_CE.LT.l_CE_opt) then
             L_A_rel = 1.0
       else 
             L_A_rel = F_isom
       end if
       Q_Arel = (0.25)*(1.0+3.0*q)
       A_rel = cm(15)*L_A_rel*Q_Arel
       Q_Brel = (1.0/7.0)*(3.0+4.0*q)
       B_rel = cm(16)*Q_Brel
C  CE CONTRACTION VELOCITY CALCULATION
       call calc_damping(q,l_CE_opt,cm,A_rel,B_rel,F_SEE,F_PEE,F_isom,dot_l_MTC,D0,C2,C1,
     1 C0,l_PEE0,K_PEE,d_SE_max)
c         
       DD = C1**2.0-4.0*C2*C0
       IF ((abs(C2).GT.0.0).and.(DD.GE.0.0)) THEN
             dot_l_CE = (-C1-sqrt(DD))/(2.0*C2)
       ELSE IF (abs(C1).GT.0.0) THEN
             dot_l_CE = -C0/C1
       ELSE
             dot_l_CE = 0.0
       END IF
C ECCENTRIC CONTRACTION CASE 
      IF (dot_l_CE.GT.0.0) THEN
C
            B_rel = (q*F_isom*(1.0-cm(18))/(q*F_isom+A_rel)*B_rel/cm(17))
            A_rel = -cm(18)*q*F_isom
C
C  CE ECCENTRIC CONTRACTION VELOCITY CALCULATION
            call calc_damping(q,l_CE_opt,cm,A_rel,B_rel,F_SEE,F_PEE,F_isom,dot_l_MTC,D0,C2,C1,
     1 C0,l_PEE0,K_PEE,d_SE_max)
c
            DD = C1**2.0-4.0*C2*C0
c
            IF ((abs(C2).GT.0.0).and.(DD.GE.0.0)) THEN
                  dot_l_CE = (-C1+sqrt(DD))/(2.0*C2)
            ELSE IF (abs(C1).GT.0.0) THEN
                  dot_l_CE = -C0/C1
            ELSE
                  dot_l_CE = 0.0
            ENDIF
C 
C      IF (dot_l_CE.LT.0.0) THEN
C            PRINT*, 'eccentric case error in muscle'
C      ENDIF
c            
      ENDIF 
C NUMERICAL RESTRICTION CHECK
C 
      IF (l_CE.LT.(0.001*l_CE_opt)) THEN
            dot_l_CE = dot_l_MTC
      ELSE IF (l_CE.GT.(1.999*l_CE_opt)) THEN
            l_SEE = elleng-l_CE
            IF (l_SEE.GT.l_SEE_nll) THEN
                  dot_l_CE = dot_l_MTC/(1.0+(K_PEE*cm(20)*(l_CE-l_PEE0)**
     1        (cm(20)-1.0))/K_SEE_l)
            ELSE
                  dot_l_CE = dot_l_MTC/(1.0+(K_PEE*cm(20)*(l_CE-l_PEE0)**
     1        (cm(20)-1.0))/(K_SEE_nl*v_SEE*(l_SEE-l_SEE_0)**
     2        (v_SEE-1.0)))
            ENDIF
      ENDIF
c
c  contractile element force
c
c  overwrite existing and (possibly) modyfied A_rel and B_rel
      A_rel = cm(15)*L_A_rel*Q_Arel
      B_rel = cm(16)*Q_Brel
c
      IF (dot_l_CE.GT.0.0) THEN
            B_rel = (q*F_isom*(1.0-cm(18))/(q*F_isom+A_rel)*B_rel/cm(17))
            A_rel = -cm(18)*q*F_isom
      ENDIF
            F_CE = cm(9)*(((q*F_isom+A_rel)/(1.0-dot_l_CE/(l_CE_opt*B_rel)))-A_rel)
c
      IF (F_CE.LT.0.0) THEN
            F_CE = 0.0
      ENDIF
c
c
c  force of the serial damping element
c
      F_SDE = d_SE_max*((1.0-cm(28))*((F_CE+F_PEE)/cm(9))+cm(28))
     1   *(dot_l_MTC-dot_l_CE)
c
c F_SDE force limit start
      SELECT CASE (int(cm(26)))
            CASE (1) 
                  IF (F_SDE.LT.-10*abs(F_SEE)) THEN
                        F_SDE = -10*abs(F_SEE)
                  ENDIF
      END SELECT
c F_SDE force limit stop
c
            F_MTC = F_SEE+F_SDE
c
c  calc l_CE (integrate dot_l_CE with finite difference methode)
cs
            l_CE = l_CE + dot_l_CE * DT
            UVAR(10,I) = l_CE
            UVAR(12,I) = dot_l_CE
c
      RETURN
      END SUBROUTINE hill_model
C-----------------------------------------------
C   calc_damping SUBROUTINE 
C----------------------------------------------		
C	
      SUBROUTINE calc_damping(q,l_CE_opt,cm,A_rel,B_rel,F_SEE,F_PEE,F_isom,dot_l_MTC,D0,C2,C1,
     1 C0,l_PEE0,K_PEE,d_SE_max)
            DOUBLE PRECISION,dimension(39) :: cm
            DOUBLE PRECISION :: q,A_rel,B_rel,F_SEE,F_PEE,F_isom
            DOUBLE PRECISION :: dot_l_MTC,d_SE_max,D0,C2,C1,C0,l_PEE0,K_PEE,l_CE_opt
C    
C!  3. Force-dependent serial (SE)-Damping
            D0 = l_CE_opt*B_rel*d_SE_max*(cm(28)+(1.0-cm(28))*(q*F_isom+F_PEE/cm(9)))
            C2 = d_SE_max*(cm(28)-(A_rel-F_PEE/cm(9))*(1.0-cm(28)))
            C1 = -C2*dot_l_MTC-D0-F_SEE+F_PEE-cm(9)*A_rel
            C0 = D0*dot_l_MTC+l_CE_opt*B_rel*(F_SEE-F_PEE-cm(9)*q*F_isom)
      RETURN
      END
C
C-----------------------------------------------
C   ring buffer subroutine
C----------------------------------------------		
C
      SUBROUTINE ringbuffer(cm,UVAR,ncycle,tt,NUVAR,I)
c
            DOUBLE PRECISION cm(*),UVAR(NUVAR,I)
            INTEGER ncycle,I,NUVAR
            DOUBLE PRECISION lCEdelay,dotlCEdelay,tt 
            DOUBLE PRECISION delaylCE, delaydotlCE
c
c           
              if (UVAR(31,I).EQ.0) then
c ----------- ringbuffer initialisation ----------------         
c introducing Ring-Buffer with starting index - beginlCE 150
c because of lsdyna messing with our data at lower index
                UVAR(31,I) = 150
c total ring-buffer size based on NHISVAR  (FLOOR = "abrunden")         
                UVAR(30,I) = floor((NUVAR-UVAR(31,I)-4)/2)
c NHISVAR is the amount of maximum hsv (defined in compile process)
c no_hsvs is the user defined amount of hsvs (!<=NHISVAR)
c
c indexr1  
                UVAR(32,I) = 0
c indexr2
                UVAR(33,I) = 1
c lasttime
                UVAR(34,I) = 0
c begindotlCE
                UVAR(36,I) = UVAR(31,I)+UVAR(30,I)+2
c indexdotr1              
                UVAR(37,I) = 0
c indexdotr2
                UVAR(38,I) = 1
c dotlasttime
                UVAR(39,I) = 0
c
c init lCEdelay and dotlCEdelay
                lCEdelay = 0
                dotlCEdelay = 0       
c          
              ELSE
c ring buffer already initialised       
                SELECT CASE (int(cm(33)))
                  CASE (1:3)  
c lambda or hybrid controller             
                    lCEdelay    = delaylCE(ncycle,UVAR,cm,tt,NUVAR,I)
                    dotlCEdelay = delaydotlCE(ncycle,UVAR,cm,tt,NUVAR,I)    
                  CASE (4) 
c reflex controller only delaylCE needed             
                    lCEdelay    = delaylCE(ncycle,UVAR,cm,tt,NUVAR,I)
                    dotlCEdelay = UVAR(12,I)
                  CASE DEFAULT
                    END SELECT  
                  ENDIF
              UVAR(30,I) = lCEdelay
              UVAR(21,I) = dotlCEdelay
              RETURN 
            END SUBROUTINE ringbuffer
c