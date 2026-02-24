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

Chd|====================================================================
Chd|  LECG30                                                      
Chd|-- called by -----------
Chd|-- calls ---------------
Chd|        SET_U_GEO                                                   
Chd|        SET_U_PNU                                                   
Chd|====================================================================
      SUBROUTINE LECG30(IIN   ,IOUT  ,NUVAR ,PARGEO)
C-----------------------------------------------
C   I m p l i c i t   T y p e s
C-----------------------------------------------
       IMPLICIT NONE
C----------+---------+---+---+--------------------------------------------
C VAR      | SIZE    |TYP| RW| DEFINITION
C----------+---------+---+---+--------------------------------------------
C IIN      |  1      | I | R | INPUT FILE UNIT (D00 file) 
C IOUT     |  1      | I | R | OUTPUT FILE UNIT (L00 file)
C NUVAR    |  1      | I | W | NUMBER OF USER ELEMENT VARIABLES
C----------+---------+---+---+--------------------------------------------
C PARGEO   |  *      | F | W | 1)SKEW NUMBER
C          |         |   |   | 2)STIFNESS FOR INTERFACE
C          |         |   |   | 3)FRONT WAVE OPTION
C          |         |   |   | 4)... not yet used
C----------+---------+---+---+--------------------------------------------
C
C     This subroutine read the user geometry parameters.
C
C     The geometry datas has to bee stored in radioss storage 
C     with the function SET_U_GEO(value_index,value). 
C
C     If some standard radioss functions (time function or 
C     x,y function) are used, this function IDs has to 
C     bee stored with the function SET_U_PNU(func_index,func_id,KFUNC).
C
C     If this property refers to a user material, this 
C     material IDs has to bee stored with the function 
C     SET_U_PNU(mat_index,mat_id,KMAT).
C
C     If this property refers to a user property, this 
C     sub-property IDs has to bee stored with the function 
C     SET_U_PNU(sub_prop_index,sub_prop_id,KMAT).
C
C     SET_U_GEO and SET_U_PNU return 0 if no error 
C     SET_U_GEO and SET_U_PNU return the maximum allowed index 
C     if index is larger than this maximum
C-----------------------------------------------
C   D u m m y   A r g u m e n t s
C-----------------------------------------------
      INTEGER IIN,IOUT,NUVAR
      DOUBLE PRECISION
     .        PARGEO(*)
      INTEGER SET_U_PNU,SET_U_GEO,
     .        KFUNC,KMAT,KPROP
      EXTERNAL SET_U_PNU,SET_U_GEO
      PARAMETER (KFUNC=29)
      PARAMETER (KMAT=31)
      PARAMETER (KPROP=30)
C=================================================================
C-----------------------------------------------
C   L o c a l   V a r i a b l e s
C-----------------------------------------------
      INTEGER SENS_ID,IERROR,ActOpt,output_MTD,IFUNC1
      INTEGER IFUNC2,IFUNC3
      DOUBLE PRECISION
     .  AMAS,DIAMETER,ELASTIF,XK,SENS_IDf,q0,tauq,betaq,k,m,muscle,
     .  Fmax,t_lCEopt,dWdes,
     .  nuCEdes,dWasc,nuCEasc,Arel0,Brel0,
     .  Secc,Fecc,LPEE0,nuPEE,FPEE,dUSEEnll,duSEEl,
     .  dFSEE0,Damping,Param1,Param2,
     .  timeste,Activation,target_l_CE,kp,kd,
     .  dotlCEdelay,t_PreSim,threshold,ActOpt_f,SENS_ID_f,output_MTD_f,
     .  STIM_ID
C             
C=================================================================
C
        WRITE(IOUT,*) ' MUSCLE User routine : Debug Start USER '
        WRITE(IOUT,*) '  by  C. Kleinbach, O. Martynenko, J. Promies, D.F.B. Haeufle, J. Fehr, S. Schmitt'
        WRITE(IOUT,*) '  Extended Hill-type Muscle Model       '
        WRITE(IOUT,*) '        *** Springs  ***                '
        WRITE(IOUT,*) '    M.Bulla, A.Ardisson 2025.03.10      '
        WRITE(IOUT,*) '                                        ' 
        
        NUVAR     = 39
        
c! hsv(1) to hsv(39)
c! ------------------------------------------------------------
c! ------ history variables - overview ------------------------
c! ------------------------------------------------------------
c!         hsv(1)    = sig(1)
c!         hsv(2)    = STIM
c!         hsv(3)    = q
c!         hsv(4)    = F_MTC
c!         hsv(5)    = F_CE
c!         hsv(6)    = F_PEE
c!         hsv(7)    = F_SEE
c!         hsv(8)    = F_SDE
c!         hsv(9)    = elleng (l_MTC)
c!         hsv(10)   = l_CE
c!         hsv(11)   = dot_l_MTC
c!         hsv(12)   = dot_l_CE
c!         hsv(13)   = counter_output
c!         hsv(14)   = F_isom
c!         hsv(15)   = gam_rel
c!         hsv(16)   = l_MTC_0 (initial element length)
c! ------------------------------------------------------------
c! ------ only needed if controller are used ------------------
c! ------------------------------------------------------------
c!         hsv(20)   = lCEdelay
c!         hsv(21)   = dotlCEdelay
c!         hsv(22)   = l_CE_ref (for reflex controller)
c!         hsv(23)   = strain (for reflex controller)
c!         hsv(24)   = STIM_reflex_prev (STIM value of reflex controller in previous timestep)
c! ------------------------------------------------------------
c! ------ delay buffer-----------------------------------------
c! ------------------------------------------------------------
c!         hsv(30)   = buffersize
c!         hsv(31)   = idx_begin_lCEbuffer (hsv(142:145) seems to be used internally by lsdyna, suggestion: use hsv(31)=150)
c!         hsv(32)   = indexr1...index1 of lce-ringbuffer (not eq index of hsv)
c!         hsv(33)   = indexr1...index2 of lce-ringbuffer (not eq index of hsv)
c!         hsv(34)   = lasttime
c!         hsv(36)   = begindotlCE
c!         hsv(37)   = indexdotr1...index1 of dotlce-ringbuffer (not eq index of hsv)    
c!         hsv(38)   = indexdotr2...index2 of dotlce-ringbuffer (not eq index of hsv)  
c!         hsv(39)   = dotlasttime   
c!         hsv(hsv(31):hsv(31)+hsv(30)-1) = ringbuffer_l_CE
c!         hsv(hsv(36):hsv(36)+hsv(30)-1) = ringbuffer_dot_l_CE
C
C
c!*MAT_USER_DEFINED_MATERIAL_MODELS
c!$ Hill-type Muscle for a cat soleus moerl12
c!$#     mid        ro        mt       lmc       nhv    iortho     ibulk        ig
c!         1  1.000E-6        41        28        14         0         3         4
c!$#   ivect     ifail    itherm    ihyper      ieos      lmca    unused    unused
c!         0         0         0         0         0         0                    
c!$#   cm(1)     cm(2)     cm(3)     cm(4)     cm(5)     cm(6)     cm(7)     cm(8)
c!$#  ActOpt   STIM_ID        q0    tauq/c betaq/eta         k         m    muscle
c!         2         3    1.0E-4  1.373E-4    5.27E4       2.9     22.54
c!$#   cm(9)    cm(10)    cm(11)    cm(12)    cm(13)    cm(14)    cm(15)    cm(16)
c!$#    Fmax    lCEopt     dWdes   nuCEdes     dWasc   nuCEasc     Arel0     Brel0      
c!      10.0     0.053      0.35       1.5      0.35       3.0      0.07       0.2
c!$#  cm(17)    cm(18)    cm(19)    cm(20)    cm(21)    cm(22)    cm(23)    cm(24)
c!$#    Secc      Fecc     LPEE0     nuPEE      FPEE     lSEE0  dUSEEnll    duSEEl
c!       2.0       1.5       0.9       2.5       2.0     0.060    0.0425     0.017
c!$#  cm(25)    cm(26)    cm(27)    cm(28)    cm(29)    cm(30)    cm(31)    cm(32)
c!$#  dFSEE0   Damping    Param1    Param2 output me o.timeste
c!       4.0       3.0       0.3      0.01    
c!     Variables (activation dynamic)
c!     cm(1)=Activation Option (EQ.0. Activation Values see STIM ID, EQ.1 Zajac, EQ.2 Hatze)
c!     cm(2)=GT0: LE.0.0 constant values for STIM or Activation GT.0.0 curve id for STIM or Activation
c!     cm(3)=q0 minimum value of q
c!     cm(4)=tau_q time constant of rising activation LT0 curve id of tau_q over time
c!     cm(4)=c
c!     cm(5)=beta_q ratio between tau_q and time constant of falling activation
c!     cm(5)=eta
c!     cm(6)=k
c!     cm(7)=m
c!     cm(8)=muscle length offset (not needed, use instead *Part_Averaged for routing)
c!     Variables (activation dynamic)
c!
c!     Variables (isometric force)
c!
c!     cm(9)=F_max maximum isometric force
c!     cm(10)=l_CE_opt optimal fibre length
c!     cm(11)=dW_des
c!     cm(12)=nu_CE_des
c!     cm(13)=dW_asc
c!     cm(14)=nu_CE_asc
c!
c!     Variables (Hill Parameter, concentric)
c!
c!     cm(15)=A_rel_0
c!     cm(16)=B_rel_0
c!
c!     Variables (van Soest Parameter, eccentric)
c!
c!     cm(17)=S_ecc
c!     cm(18)=S_ecc
c!
c!     Variables (Parallel elastic element)
c!
c!     cm(19)=L_PEE_0
c!     cm(20)=nu_PEE
c!     cm(21)=F_PEE
c!
c!     Variables (Seriell elastic element)
c!
c!     cm(22)=l_SEE_0
c!     cm(23)=dU_SEE_nllfindkParams
c!     cm(24)=dU_SEE_l
c!     cm(25)=dF_SEE_0
c!
c!     Variables (Damping element)
c!
c!     cm(26)= --- (former damping method)
c!     cm(27)=D_SE
c!     cm(28)=R_SE
c!
c!     Variables (Output definition; musout.(partid))
c!
c!     cm(29)=output method (EQ.0.  no output 
c!                           EQ.1.  basic output (idpart, tt, hsv(2:10)) 
c!                           EQ.2.  advanced output (basic output plus dot_l_CE, dot_l_MTC, lCEdelay, dotlCEdelay))
c!
c!     cm(30)=timestep of outputfile
c!
c!     Variables for Controller
c!
c!     cm(33)=Activation Method (EQ.1. lambda_controller
c!                               EQ.2. hybrid_controller
c!                               EQ.3. reflexive controller)
c!
c!     cm(34)=target l_CE    !!! POSSIBLE CURVE/FUNCTION
c!     cm(35)=kp
c!     cm(36)=kd
c!     cm(37)=delay of lCEdelay / dotlCEdelay
c!     cm(38)=time till swap from alpha to lambda / t_PreSim for reflexive controller
c!     cm(39)=threshold for reflex controller (e.g. 0.10 for a 10% strain threshold)
c!
c! [...]
c!
c!     d1  - strain rate/increment in x  direction, local x for shells
c!     d2  - strain rate/increment in y  direction, local y for shells
c!     d3  - strain rate/increment in z  direction, local z for shells
c! ------------------------------------------------------------
c! ------ history variables - overview ------------------------
c! ------------------------------------------------------------
c!         hsv(1)    = sig(1)
c!         hsv(2)    = STIM
c!         hsv(3)    = q
c!         hsv(4)    = F_MTC
c!         hsv(5)    = F_CE
c!         hsv(6)    = F_PEE
c!         hsv(7)    = F_SEE
c!         hsv(8)    = F_SDE
c!         hsv(9)    = elleng (l_MTC)
c!         hsv(10)   = l_CE
c!         hsv(11)   = dot_l_MTC
c!         hsv(12)   = dot_l_CE
c!         hsv(13)   = counter_output
c!         hsv(14)   = F_isom
c!         hsv(15)   = gam_rel
c!         hsv(16)   = l_MTC_0 (initial element length)
c! ------------------------------------------------------------
c! ------ only needed if controller are used ------------------
c! ------------------------------------------------------------
c!         hsv(20)   = lCEdelay
c!         hsv(21)   = dotlCEdelay
c!         hsv(22)   = l_CE_ref (for reflex controller)
c!         hsv(23)   = strain (for reflex controller)
c!         hsv(24)   = STIM_reflex_prev (STIM value of reflex controller in previous timestep)
c! ------------------------------------------------------------
c! ------ delay buffer-----------------------------------------
c! ------------------------------------------------------------
c!         hsv(30)   = buffersize
c!         hsv(31)   = idx_begin_lCEbuffer (hsv(142:145) seems to be used internally by lsdyna, suggestion: use hsv(31)=150)
c!         hsv(32)   = indexr1...index1 of lce-ringbuffer (not eq index of hsv)
c!         hsv(33)   = indexr1...index2 of lce-ringbuffer (not eq index of hsv)
c!         hsv(34)   = lasttime
c!         hsv(36)   = begindotlCE
c!         hsv(37)   = indexdotr1...index1 of dotlce-ringbuffer (not eq index of hsv)    
c!         hsv(38)   = indexdotr2...index2 of dotlce-ringbuffer (not eq index of hsv)  
c!         hsv(39)   = dotlasttime   
c!         hsv(hsv(31):hsv(31)+hsv(30)-1) = ringbuffer_l_CE
c!         hsv(hsv(36):hsv(36)+hsv(30)-1) = ringbuffer_dot_l_CE
c!
        READ(IIN,ERR=999,END=999,FMT='(3F20.0,2I10)')
     .                    AMAS,DIAMETER,XK,ActOpt,SENS_ID
        IF (SENS_ID .NE.0) SENS_IDf = real(SENS_ID)+0.00001
        
        READ(IIN,ERR=999,END=999,FMT='(5F20.0)')
     .                    STIM_ID,q0,tauq,betaq,k
        READ(IIN,ERR=999,END=999,FMT='(5F20.0)')
     .                    m,muscle,Fmax,t_lCEopt,dWdes
        READ(IIN,ERR=999,END=999,FMT='(5F20.0)')
     .                    nuCEdes,dWasc,nuCEasc,Arel0,Brel0
        READ(IIN,ERR=999,END=999,FMT='(5F20.0)')
     .                    Secc,Fecc,LPEE0,nuPEE,FPEE
        READ(IIN,ERR=999,END=999,FMT='(3F20.0)')
     .                    dUSEEnll,    duSEEl, dFSEE0
        READ(IIN,ERR=999,END=999,FMT='(3F20.0,I10)')
     .                    Damping,Param1,Param2,output_MTD
        READ(IIN,ERR=999,END=999,FMT='(5F20.0)')
     .                    timeste,Activation,target_l_CE,kp,kd
        READ(IIN,ERR=999,END=999,FMT='(3F20.0)')
     .                    dotlCEdelay,t_PreSim,threshold
c     Variables (isometric force)

        PARGEO(1) = 0
        PARGEO(2) = XK
        PARGEO(3) = 1
C
c!        WRITE(IOUT,1000)
c!     .     AMAS,ELASTIF,XK,SENS_ID
c!        WRITE(IOUT,1000)
c!     .     AMAS,DIAMETER,XK,ActOpt,STIM_ID,q0,tauq,betaq,k,m,muscle,Fmax,lCEopt,dWdes,
c!     .     nuCEdes,dWasc,nuCEasc,Arel0,Brel0,Secc,Fecc,LPEE0,nuPEE,FPEE,
c!     .     lSEE0,dUSEEnll,duSEEl,dFSEE0,Damping,Param1,Param2,output_MTD,
c!     .     timeste,Activation,target_l_CE,kp,kd,dotlCEdelay,t_PreSim,threshold
        WRITE(IOUT,1000)
     .     AMAS,DIAMETER,XK,ActOpt,STIM_ID,q0,tauq,betaq,k,m,muscle,Fmax,t_lCEopt,dWdes,
     .     nuCEdes,dWasc,nuCEasc,Arel0,Brel0,Secc,Fecc,LPEE0,nuPEE,FPEE,
     .     dUSEEnll,duSEEl,dFSEE0,Damping,Param1,Param2,output_MTD,
     .     timeste,Activation,target_l_CE,kp,kd,dotlCEdelay,t_PreSim,threshold
c!C
        IERROR = SET_U_GEO(1,AMAS)
c!      IERROR = SET_U_GEO(2,ELASTIF)
        IERROR = SET_U_GEO(2,XK)
        IERROR = SET_U_GEO(3,DIAMETER)
       
        ActOpt_f= REAL(ActOpt)+0.00001
          print *,'ActOpt      = ',ActOpt     
          print *,'REAL(ActOpt)      = ',REAL(ActOpt)  
c!        SENS_ID_f = REAL(SENS_ID)+0.00001
        IERROR = SET_U_GEO(4, ActOpt_f)
        SENS_ID_f = DBLE(SENS_ID)+0.00001
        SENS_ID_f = SENS_ID+0.00001
        IERROR = SET_U_GEO(5,SENS_ID_f)
c!        IERROR = SET_U_GEO(5,REAL(SENS_ID)+0.00001)       
        IERROR = SET_U_GEO(6,STIM_ID)
          print*, STIM_ID
C-----------------------------------------------------------------------
        IF (STIM_ID .GT. 0.0)   THEN
           IFUNC1 = INT(STIM_ID+0.00001)
           print*, 'IFUNC1_lecg = ', IFUNC1
           IERROR = SET_U_PNU(1,IFUNC1,KFUNC)
        ENDIF
C-----------------------------------------------------------------------
        IERROR = SET_U_GEO(7,q0)
        IERROR = SET_U_GEO(8,tauq)
C-----------------------------------------------------------------------
        IF (tauq .LT. 0.0) THEN                 !not sure of this
         IFUNC2 = INT(tauq+0.00001)
         print*, 'IFUNC2_lecg', IFUNC2
         IERROR = SET_U_PNU(2,IFUNC2,KFUNC)      
        ENDIF
C-----------------------------------------------------------------------
        IERROR = SET_U_GEO(9,betaq)
        IERROR = SET_U_GEO(10,k)
        
        IERROR = SET_U_GEO(11,m)
        IERROR = SET_U_GEO(12,muscle)
        IERROR = SET_U_GEO(13,Fmax)
        IERROR = SET_U_GEO(14,t_lCEopt)
        IERROR = SET_U_GEO(15,dWdes)
        
        IERROR = SET_U_GEO(16,nuCEdes)
        IERROR = SET_U_GEO(17,dWasc)
        IERROR = SET_U_GEO(18,nuCEasc)
        IERROR = SET_U_GEO(19,Arel0)
        IERROR = SET_U_GEO(20,Brel0)

        IERROR = SET_U_GEO(21,Secc)
        IERROR = SET_U_GEO(22,Fecc)
        IERROR = SET_U_GEO(23,LPEE0)
        IERROR = SET_U_GEO(24,nuPEE)
        IERROR = SET_U_GEO(25,FPEE)

        IERROR = SET_U_GEO(27,dUSEEnll)
        IERROR = SET_U_GEO(28,duSEEl)
        IERROR = SET_U_GEO(29,dFSEE0)

        IERROR = SET_U_GEO(30,Damping)
        IERROR = SET_U_GEO(31,Param1)
        IERROR = SET_U_GEO(32,Param2)
        output_MTD_f = REAL(output_MTD)+0.00001
        IERROR = SET_U_GEO(33,output_MTD_f)
c!        IERROR = SET_U_GEO(33,REAL(output_MTD)+0.00001)

        IERROR = SET_U_GEO(34,timeste)
        IERROR = SET_U_GEO(35,Activation)
        IERROR = SET_U_GEO(36,target_l_CE)
C-----------------------------------------------------------------------
        !IF (target_l_CE .GT. 0.0)   THEN
         IFUNC3 = INT(target_l_CE+0.00001)
         print*, 'IFUNC3_lecg', IFUNC3
         IERROR = SET_U_PNU(3,IFUNC3,KFUNC)         
        !ENDIF
C-----------------------------------------------------------------------        
        IERROR = SET_U_GEO(37,kp)
        IERROR = SET_U_GEO(38,kd)

        IERROR = SET_U_GEO(39,dotlCEdelay)
        IERROR = SET_U_GEO(40,t_PreSim)
        IERROR = SET_U_GEO(41,threshold)

c!        IERROR = SET_U_GEO(4,SENS_IDf)

C
      RETURN
 999  CONTINUE
        WRITE(IOUT,*)' **ERROR IN USER PROPERTY INPUT !!!'
      RETURN
 1000 FORMAT(
     & 5X,'  Extended Hill-type Muscle Model:',/,
     & 5X,'  Version 25.06.2024 a ',/,
     & 5X,'',/,     
     & 5X,'Density. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'Crossection area . . . . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'STIFFNESS FOR INTERFACE. . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,     
     & 5X,'Variables (activation dynamic):',/,
     & 5X,'Activation Option. . . . . . . . . . . . . . . . . . . . . . . . . . . .=',I10/,
     & 5X,'(EQ.0. Activation Values see STIM ID, EQ.1 Zajac, EQ.2 Hatze)',/,
     & 5X,'STIM_ID . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'LE.0.0 constant values for STIM or Activation GT.0.0 curve id for STIM or Activation',/,
     & 5X,'q0 minimum value of q . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'tau_q time constant of rising activation LT0 curve id of tau_q over time=',E12.4/,
     & 5X,'beta_q ratio between tau_q and time constant of falling activation eta .=',E12.4/,
     & 5X,'k. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'m. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'muscle length offset (not needed, use instead *Part_Averaged for routing)',E12.4/,
     & 5X,'Variables (isometric force):',/,
     & 5X,'F_max maximum isometric force. . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'t_l_CE_opt optimal fibre length proportion . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'dW_des . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'nu_CE_des. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'dW_asc . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'nu_CE_asc. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'Variables (Hill Parameter, concentric):',/,
     & 5X,'A_rel_0. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'B_rel_0. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'Variables (van Soest Parameter, eccentric):',/,
     & 5X,'S_ecc. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'F_ecc. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'Variables (Parallel elastic element):',/,
     & 5X,'L_PEE_0. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'nu_PEE . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'F_PEE. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'Variables (Seriell elastic element):',/,
     & 5X,'l_SEE_0. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'dU_SEE_nllfindkParams. . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'dU_SEE_l . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'dF_SEE_0 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'Variables (Damping element):',/,
     & 5X,'former damping method. . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'D_SE . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'R_SE . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'Variables (Output definition; musout.(partid)):',/,
     & 5X,'output method. . . . . . . . . . . . . . . . . . . . . . . . . . . . . .=',I10/,
     & 5X,'EQ.0.  no output ',/,
     & 5X,'EQ.1.  basic output (idpart, tt, hsv(2:10)) ',/,
     & 5X,'EQ.2.  advanced output (basic output plus dot_l_CE, dot_l_MTC, lCEdelay, dotlCEdelay) ',/,
     & 5X,'timestep of outputfile . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'Variables (for Controller):',/,
     & 5X,'Activation Method. . . . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'EQ.1. lambda_controller',/,
     & 5X,'EQ.2. hybrid_controller',/,
     & 5X,'EQ.3. reflexive controller',/,
     & 5X,'target l_CE. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'kp . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'kd . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'delay of lCEdelay / dotlCEdelay. . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'time till swap from alpha to lambda / t_PreSim for reflexive controller.=',E12.4/,
     & 5X,'threshold for reflex controller (e.g. 0.10 for a 10% strain threshold) .=',E12.4//)
     

c!     & 5X,'STIFFNESS FOR INTERFACE . . . . . . . . .=',E12.4/,
c!     & 5X,'SENSOR ID . . . . . . . . . . . . . . . .=',I10//)
      END
