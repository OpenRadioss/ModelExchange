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

Cgw41n4 source deplace de lecg30.F vers rini30.F
Chd|====================================================================
Chd|  RINI30                                                      
Chd|-- called by -----------
Chd|-- calls ---------------
Chd|====================================================================
      SUBROUTINE RINI30(NEL   ,IOUT   ,IPROP ,
     3                  IX    ,XL     ,MASS  ,XINER  ,STIFM ,
     4                  STIFR ,VISCM  ,VISCR ,UVAR   ,NUVAR )
C-------------------------------------------------------------------------
C     This subroutine initialize springs using user properties.
C-------------------------------------------------------------------------
C----------+---------+---+---+--------------------------------------------
C VAR      | SIZE    |TYP| RW| DEFINITION
C----------+---------+---+---+--------------------------------------------
C IOUT     |  1      | I | R | OUTPUT FILE UNIT (L00 file)
C IPROP    |  1      | I | R | PROPERTY NUMBER
C----------+---------+---+---+--------------------------------------------
C IX       | 3*NEL   | I | R | SPRING CONNECTIVITY
C                            | IX(1,I) NODE 1 ID
C                            | IX(2,I) NODE 2 ID
C                            | IX(3,I) OPTIONNAL NODE 3 ID
C                            | IX(4,I) SPRING ID
C XL       |   NEL   | F | R | ELEMENT LENGTH
C----------+---------+---+---+--------------------------------------------
C MASS     |   NEL   | F | W | ELEMENT MASS
C XINER    |   NEL   | F | W | ELEMENT INERTIA (SPHERICAL)
C STIFM    |   NEL   | F | W | ELEMENT STIFNESS (TIME STEP)
C STIFR    |   NEL   | F | W | ELEMENT ROTATION STIFNESS (TIME STEP)
C VISCM    |   NEL   | F | W | ELEMENT VISCOSITY (TIME STEP)
C VISCR    |   NEL   | F | W | ELEMENT ROTATION VISCOSITY (TIME STEP)
C----------+---------+---+---+--------------------------------------------
C UVAR     |NUVAR*NEL| F | W | USER ELEMENT VARIABLES
C NUVAR    |  1      | I | R | NUMBER OF USER ELEMENT VARIABLES
C----------+---------+---+---+--------------------------------------------
C-------------------------------------------------------------------------
C FUNCTION 
C-------------------------------------------------------------------------
C INTEGER II = GET_U_PNU(I,IP,KK)
C         IFUNCI = GET_U_PNU(I,IP,KFUNC)
C         IPROPI = GET_U_PNU(I,IP,KPROP)
C         IMATI = GET_U_PNU(I,IP,KMAT)
C         I     :     VARIABLE INDEX(1 for first variable,...)
C         IP    :     PROPERTY NUMBER
C         KK    :     PARAMETER KFUNC,KMAT,KPROP
C         THIS FUNCTION RETURN THE USER STORED FUNCTION(IF KK=KFUNC), 
C         MATERIAL(IF KK=KMAT) OR PROPERTY(IF KK=KPROP) NUMBERS. 
C         SEE LECG29 FOR CORRESPONDING ID STORAGE.
C-------------------------------------------------------------------------
C INTEGER IFUNCI = GET_U_MNU(I,IM,KFUNC)
C         I     :     VARIABLE INDEX(1 for first function)
C         IM    :     MATERIAL NUMBER
C         KFUNC :     ONLY FUNCTION ARE YET AVAILABLE.
C         THIS FUNCTION RETURN THE USER STORED FUNCTION NUMBERS(function 
C         refered by users materials).
C         SEE LECM29 FOR CORRESPONDING ID STORAGE.
C-------------------------------------------------------------------------
C my_real PARAMI = GET_U_GEO(I,IP)
C         I     :     PARAMETER INDEX(1 for first parameter,...)
C         IP    :     PROPERTY NUMBER
C         THIS FUNCTION RETURN THE USER GEOMETRY PARAMETERS 
C-------------------------------------------------------------------------
C my_real PARAMI = GET_U_MAT(I,IM)
C         I     :     PARAMETER INDEX(1 for first parameter,...)
C         IM    :     MATERIAL NUMBER
C         THIS FUNCTION RETURN THE USER MATERIAL PARAMETERS 
C         NOTE: GET_U_MAT(0,IMAT) RETURN THE DENSITY
C-------------------------------------------------------------------------
C INTEGER MID = GET_U_PID(IP)
C         IP    :     PROPERTY NUMBER
C         THIS FUNCTION RETURN THE USER PROPERTY ID CORRESPONDING TO
C         USER PROPERTY NUMBER IP. 
C-------------------------------------------------------------------------
C INTEGER PID = GET_U_MID(IM)
C         IM   :     MATERIAL NUMBER
C         THIS FUNCTION RETURN THE USER MATERIAL ID CORRESPONDING TO
C         USER MATERIAL NUMBER IM. 
C-------------------------------------------------------------------------
C-----------------------------------------------
C   I m p l i c i t   T y p e s
C-----------------------------------------------
       IMPLICIT NONE
C----------------------------------------------------------
C   D u m m y   A r g u m e n t s   a n d   F u n c t i o n
C----------------------------------------------------------
      INTEGER IOUT,NUVAR,NEL,IPROP,   
     .        IX(4,NEL) ,
     .        GET_U_PNU,GET_U_PID,GET_U_MID,GET_U_MNU,
     .        KFUNC,KMAT,KPROP
      double precision
     .        XL(NEL) ,MASS(NEL) ,XINER(NEL) ,STIFM(NEL) ,
     .        STIFR(NEL),VISCM(NEL) ,VISCR(NEL),UVAR(NUVAR,*),
     .        GET_U_MAT,GET_U_GEO
      EXTERNAL GET_U_PNU,GET_U_MNU,GET_U_MAT,GET_U_GEO,GET_U_PID,
     .         GET_U_MID
      PARAMETER (KFUNC=29)
      PARAMETER (KMAT=31)
      PARAMETER (KPROP=33)
C=================================================================
C-----------------------------------------------
C   L o c a l   V a r i a b l e s
C-----------------------------------------------
      double precision
     .        AMAS,ELASTIF,DIAMETER,ActOpt_f,q0,STIM_ID
      INTEGER I
      DOUBLE PRECISION UN,ZERO
C-----------------------------------------------
      UN=1.0
      ZERO = 0.0      
        print *,' *** 1: rini START'

        AMAS     = GET_U_GEO(1,IPROP)
        ELASTIF  = GET_U_GEO(2,IPROP)
        DIAMETER = GET_U_GEO(3,IPROP)
        ActOpt_f = GET_U_GEO(4,IPROP)
        STIM_ID = GET_U_GEO(6,IPROP)
        q0          = GET_U_GEO(7,IPROP)
C--------------------------------------
C       ELEMENT CHECK
C--------------------------------------
        DO I=1,NEL
          IF(XL(I).EQ.0.0)THEN
            WRITE(IOUT,*)' **ERROR: ZERO LENGTH SPRING :'
          ENDIF
        ENDDO
C--------------------------------------
C       ELEMENT INITIALIZATION
C--------------------------------------
        DO I=1,NEL
          MASS(I)   = AMAS*3.14*((DIAMETER/2)**2)*XL(I) !here the real mass has to be computed density * volume
          XINER(I)  = ZERO
C
C
C FOR NODAL AND ELEMENT TIME STEP COMPUTATION
          STIFM(I) = ELASTIF
          STIFR(I) = ZERO
          VISCM(I) = ZERO
          VISCR(I) = ZERO
          print *,' *** 1: rini values: I        =',I
          print *,' *** 1: rini values: AMAS     =',AMAS
          print *,' *** 1: rini values: DIAMETER =',DIAMETER
          print *,' *** 1: rini values: XL(I)    =',XL(I)
          print *,' *** 1: rini values: MASS     =',MASS(I)
          print *,' *** 1: rini values: ActOpt_f =',ActOpt_f
          print *,' *** 1: rini values: q0       =',q0
          print *,' *** 1: rini values: STIM_ID  =',STIM_ID
          print *,' *** 1: rini values: STIFM(I)       =',STIFM(I)

          WRITE(IOUT,1000)
     .     AMAS,MASS(I)

        ENDDO
C
        print *,' *** rini END'
 
      RETURN
 1000 FORMAT(
     & 5X,'  Extended Hill-type Muscle Model INITAILIZATION :',/,
     & 5X,'AMAS. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/,
     & 5X,'ELEMENT MASS. . . . . . . . . . . . . . . . . . . . . . . . . . . . .=',E12.4/)

      END
