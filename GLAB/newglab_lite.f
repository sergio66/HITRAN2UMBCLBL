C=======================================================================
C=======================================================================
C
C    University of Maryland Baltimore County (UMBC)
C
C    GENLN2 support program
C
C    GLAB
C
!F77====================================================================


!ROUTINE NAME:
C    GLAB


!ABSTRACT:
C    Create an input file for GENLN2 to simulate typical lab spectra.
C    This version does a single absorbing gas.


!CALL PROTOCOL
C    none (main program)


!INPUT PARAMETERS:
C    none


!OUTPUT PARAMETERS:
C    none


!INPUT/OUTPUT PARAMETERS:
C    none


!RETURN VALUES:
C    none


!PARENT(S)
C    none


!ROUTINES CALLED:
C    none


!FILES ACCESSED:
C    unit 5: user input instructions, etc
C    unit 6: text messages output to screen
C    unit 10: output text file


!COMMON BLOCKS
C    none


!DESCRIPTION:
C    Asks user some questions about freq range, which gas,
C    temperature, path length, pressure, etc.  It processes the
C    info and outputs a GENLN2 input file for these conditions.
C    This is for use with Scott's modified version of GENLN2
C    based upon David Edwards GENLN2 version 3.Y.


!ALGORITHM REFERENCES:
C    none


!KNOWN BUGS AND LIMITATIONS:
C    none


!ROUTINE HISTORY:
C    Date         Programmer    Comments
C    ----------- -------------- --------------------------------------
C    1991?       Scott Hannon   Created
C    1993?       Scott Hannon   Modified for use with GENLN2 3.Y
C    25 Sep 1997 Scott Hannon   Cleaned up
C    29 Mar 1999 Scott Hannon   "lite" version created; fewer questions
C    19 Jul 2000 Scott Hannon   FSTART & FEND & GASID read from input
C                                  as reals and converted to integer


!END====================================================================


C      =================================================================
       PROGRAM GLAB
C      =================================================================


C-----------------------------------------------------------------------
C      IMPLICIT NONE
C-----------------------------------------------------------------------
       IMPLICIT NONE


C-----------------------------------------------------------------------
C      INCLUDE FILES
C-----------------------------------------------------------------------
C      none


C-----------------------------------------------------------------------
C      EXTERNAL FUNCTIONS
C-----------------------------------------------------------------------
C      none


C-----------------------------------------------------------------------
C      ARGUMENTS
C-----------------------------------------------------------------------
C      none (main program)


C-----------------------------------------------------------------------
C      LOCAL VARIABLES
C-----------------------------------------------------------------------
C
       INTEGER    GASID ! HITRAN gas ID number
       INTEGER   FSTART ! start frequency for GENLN2 run
       INTEGER     FEND ! end frequency for GENLN2 run
c       INTEGER        I
       INTEGER   INTERP ! GENLN2 interpolation factor
c       INTEGER        J
c       INTEGER        K
       INTEGER    LVERS ! HITRAN line version number
       INTEGER     NDIV ! number of points per cm-1
C
       REAL        A ! amount
       REAL       AV ! Avagadro's number
       REAL   CMULT1 ! total or self continuum multiplier
       REAL   CMULT2 ! foreign continuum multiplier
       REAL      DEN ! density
       REAL   DENREF ! reference density (molecules/cm^3 at STP)
       REAL    NMULT ! temp dep of witdh "n" power multiplier
       REAL    PARTP ! partial pressure of absorbing gas
       REAL     PLEN ! pathlength
       REAL    SMULT ! strength multiplier
       REAL   STMINW ! min strength for GENLN2 wing calcs
       REAL   STMINF ! min strength for GENLN2 fine mesh calc
       REAL        T ! temperature
       REAL     TOTP ! total gas pressure
       REAL     TREF ! reference temperature
       REAL    WMULT ! width multiplier
       REAL    RJUNK
C
c       CHARACTER*80    CLINE ! character line
       CHARACTER*8    CONSTR ! GENLN2 continuum string
       CHARACTER*40     GFIL ! name of GENLN2 input file to create
       CHARACTER*80   LINFIL ! GENLN2 database name
       CHARACTER*8    LSHAPE ! GENLN2 lineshape type
       CHARACTER*40   OUTNAM ! name of GENLN2 data output file
       CHARACTER*1         Q ! single quote string
       CHARACTER*40   RADFIL ! GENLN2 radiance instruction file
       CHARACTER*40    TITLE ! GENLN2 title string
       CHARACTER*1     YNANS ! Y/N answer string
C
       LOGICAL    DORAD ! radiance calc
       LOGICAL    ISCON ! far wing continuum
       LOGICAL   MIXING ! line mixing
C

C***********************************************************************
C***********************************************************************
C                    EXECUTABLE CODE
C***********************************************************************
C***********************************************************************
C
C      -------------------------
C      Initialize some variables
C      -------------------------
       Q=''''
       INTERP=15
       STMINW=1.0E-07
       STMINF=1.0E-10
       CONSTR='NOCON   '
       LSHAPE='VOIGT   '
       TREF=273.15
       DENREF=2.6867E+19
       AV=6.022045E+26
       MIXING=.FALSE.
       DORAD=.FALSE.
c92       LINFIL='/asl/packages/Genln2/Hitlin/hitlin92.bin'
c98       LINFIL='/asl/packages/Genln2/Hitlin/hitlin98.bin'
c08       LINFIL='/asl/packages/Genln2/Hitlin/hitlin08May09x.bin'
c12       LINFIL='/asl/packages/Genln2/Hitlin/hitlin12Jul14.bin'

       LINFIL='/asl/packages/Genln2/Hitlin/hitlin12Jul14.bin'
       LINFIL='/asl/packages/Genln2/Hitlin/hitlin28Sep14.bin'

       CMULT1=1.0E+0
       CMULT2=1.0E+0
C
C      -----------------------------
C      Get info about the GENLN2 run
C      -----------------------------
       WRITE(6,*) '**************************************************'
       WRITE(6,*) '******************* GLAB LITE ********************'
       WRITE(6,*) '**************************************************'
       WRITE(6,*) ' '
C
C      Get name of file to create (GENLN2 input file)
ccc
c       WRITE(6,*) 'Enter the name of the file to make (up to 40 char)'
c       WRITE(6,8010)
c 8010  FORMAT('----------------------------------------')
c       READ(5,2000) GFIL
       GFIL='lite.ip'
c 2000  FORMAT(A40)
c       WRITE(6,*) ' '
ccc
C
C      Get "title" string to include in GENLN2 output data
ccc
c       WRITE(6,*) 'Enter the title for this run (up to 40 char)'
c       WRITE(6,8010)
c       READ(5,2000) TITLE
       TITLE='glab lite'
c       WRITE(6,*) ' '
ccc
C
C      Get start and end frequencies for the GENLN2 run
       WRITE(6,*) 'Enter the start freq (integer, in cm-1)'
c       READ(5,*) FSTART
       READ(5,*) RJUNK
       FSTART=NINT(RJUNK)
       WRITE(6,*) ' '
C
       WRITE(6,*) 'Enter the end freq (integer, in cm-1)'
c       READ(5,*) FEND
       READ(5,*) RJUNK
       FEND=NINT(RJUNK)
       WRITE(6,*) ' '
C
C      Get number of points per cm-1 (ie resolution)
ccc
c       WRITE(6,*) 'Enter the # of pts per wide mesh (integer)'
c       READ(5,*) NDIV
       NDIV=2000
c       WRITE(6,*) ' '
ccc
ccc
c Commented out as we very rarely want to adjust these
cC      Get min strengths and interpolation factor for GENLN2
c       WRITE(6,*) 'Enter wide mesh min stength (usually 1.0E-07)'
c       READ(5,*) STMINW
c       WRITE(6,*) ' '
cC
c       WRITE(6,*) 'Enter fine mesh min stength (usually 1.0E-10)'
c       READ(5,*) STMINF
c       WRITE(6,*) ' '
cC
c       WRITE(6,*) 'Enter fine mesh interpolation factor (usually 15)'
c       READ(5,*) INTERP
c       WRITE(6,*) ' '
ccc
C
C      ------------------------------------------
C      Get GENLN2 lineshape and line version info
C      ------------------------------------------
C      Get absorbing gas ID
       WRITE(6,*) 'What gas? Enter gas id (1=H2O, 2=CO2, etc)'
c       READ(5,*) GASID
       READ(5,*) RJUNK
       GASID=NINT(RJUNK)
       WRITE(6,*) ' '
C
C      Get HITRAN database gas version number
ccc
c       WRITE(6,*) 'What version of this gas? (integer, usually 10)'
c       READ(5,*) LVERS
       LVERS=10
       IF (GASID .EQ. 1) THEN
c92          LVERS=12
          LVERS=13
       ELSEIF (GASID .EQ. 2) THEN
          LVERS=11
       ENDIF
c       WRITE(6,*) ' '
ccc
C
C      Get lineshape type
ccc
c       WRITE(6,*) 'Do you want to use the voigt lineshape (y/n)?'
c       READ(5,8000) YNANS
c 8000  FORMAT(A1)
c       WRITE(6,*) ' '
c       IF ((YNANS .NE. 'Y') .AND. (YNANS .NE. 'y')) THEN
c          WRITE(6,*) 'Here are your other all possible choices...'
c          WRITE(6,*) 'LORENTZ'
c          WRITE(6,*) 'DOPPLER'
c          WRITE(6,*) 'VOIGT'
c          WRITE(6,*) 'VOIGTCO2'
c          WRITE(6,*) 'GROSS'
c          WRITE(6,*) 'VANVHUB'
c          WRITE(6,*) 'XSECTION'
c          WRITE(6,*) '(NEWSHAPE is not currently defined)'
c          WRITE(6,*) 'Enter the lineshape (in CAPITALS)(8 char)'
c          WRITE(6,8020)
c 8020     FORMAT('--------')
c          READ(5,2010) LSHAPE
c 2010     FORMAT(A8)
c          WRITE(6,*) ' '
c       ENDIF
cC
cC      Determine if we need to do line mixing
c       YNANS='N'
       IF (GASID .EQ. 2) THEN
       LSHAPE='VOIGTCO2'
c          WRITE(6,*) 'Do you want Q-branch line mixing (y/n)?'
c          READ(5,8000) YNANS
c          WRITE(6,*) ' '
c          IF ((YNANS .EQ. 'Y') .OR. (YNANS .EQ. 'y')) THEN
             MIXING=.TRUE.
c          ENDIF
       ENDIF
ccc
C
C      ----------------------------------------------
C      Determine what to do to the far wing continuum
C      ----------------------------------------------
C      Determine if there is any continuum to consider
       ISCON=.FALSE.
       IF (GASID .EQ. 1) ISCON=.TRUE.
       IF (GASID .EQ. 2) ISCON=.TRUE.
       IF (GASID .EQ. 7) ISCON=.TRUE.
       IF (GASID .EQ. 22) ISCON=.TRUE.
C
C      If there is a continuum, do you want to include it?
ccc
       YNANS='N'
       IF (ISCON) THEN
       YNANS='Y'
c          WRITE(6,*) 'Do you want the continuum (y/n)?'
c          READ(5,8000) YNANS
c          WRITE(6,*) ' '
       ENDIF
ccc
C
C      If you want the continuum, determine how to modify it
       IF ((YNANS .EQ. 'Y') .OR. (YNANS .EQ. 'y')) THEN
          CONSTR='CON     '
c          IF (GASID .NE. 1) THEN
c             WRITE(6,*) 'Enter the continuum strength multiplier'
c             READ(5,*) CMULT1
c             CMULT2=1.0
c          ELSE
c             WRITE(6,*) 'Enter the self continuum strength mult.'
c             READ(5,*) CMULT1
c             WRITE(6,*) ' '
c             WRITE(6,*) 'Enter the foreign continuum strength mult.'
c             READ(5,*) CMULT2
c          ENDIF
c          WRITE(6,*) ' '
       ENDIF
ccc
C
C      --------------------------------------
C      Get info about the lab/cell conditions
C      --------------------------------------
C      Get total pressure
       WRITE(6,*) 'Enter the total pressure (in torr)'
       READ(5,*) TOTP
       WRITE(6,*) ' '
C
C      Get absorbing gas particial pressure
       WRITE(6,*) 'Enter the partial pressure (in torr)'
       READ(5,*) PARTP
       WRITE(6,*) ' '
C
C      Get pathlength length
ccc
c       WRITE(6,*) 'Enter the pathlength (in meters)'
c       READ(5,*) PLEN
       PLEN=1.0
c       WRITE(6,*) ' '
ccc
C
C      Get gas temperature
       WRITE(6,*) 'Enter the temperature (in K)'
       READ(5,*) T
       WRITE(6,*) ' '
C
C      -------------------------------------------
C      Get info on HITRAN line parameter modifiers
C      -------------------------------------------
ccc
       SMULT=1.0
       WMULT=1.0
       NMULT=1.0
cC      Get line strength multiplier
c       WRITE(6,*) 'Enter the line strength multiplier'
c       READ(5,*) SMULT
c       WRITE(6,*) ' '
cC
cC      Get width (both self & foreign) multiplier
c       WRITE(6,*) 'Enter width multiplier'
c       READ(5,*) WMULT
c       WRITE(6,*) ' '
cC
cC      Get temperature dependence scaling power multiplier
c       WRITE(6,*) 'Enter multiplier of "n" for temp dep of width'
c       READ(5,*) NMULT
c       WRITE(6,*) ' '
ccc
C
C      ------------------------------------------
C      Determine what to do about a radiance calc
C      ------------------------------------------
ccc
C      Decide if we are to do a radiance calc
c       YNANS='N'
c       WRITE(6,*) 'Do you want a radiance? (y/n, n = trans)?'
c       READ(5,8000) YNANS
c       WRITE(6,*) ' '
c       IF ((YNANS .EQ. 'Y') .OR. (YNANS .EQ. 'y')) THEN
c          DORAD=.TRUE.
c       ENDIF
cC
cC      Get name of file describing the radiance calc
c       YNANS='N'
c       IF (DORAD) THEN
c          WRITE(6,*) 'Enter name of *RADFIL file'
c          READ(5,2000) RADFIL
c          WRITE(6,*) ' '
c       ENDIF
ccc
C
C      -------------------------------------------
C      Get name to use for GENLN2 output data file
C      -------------------------------------------
ccc
c       WRITE(6,*) 'Enter GENLN2 output data file name (up to 40 char)'
c       WRITE(6,8010)
c       READ(5,2000) OUTNAM
       OUTNAM='lite.dat'
c       WRITE(6,*) ' '
ccc
C
C      --------------------------------------
C      Open the text file (GENLN2 input file)
C      --------------------------------------
       WRITE(6,*) 'saving file'
       OPEN(UNIT=10, FILE=GFIL, STATUS='NEW', FORM='FORMATTED')
C
       WRITE(10,1000)
 1000  FORMAT('! This file was created by GLAB lite')
       WRITE(10,1010)
 1010  FORMAT('! ')
       WRITE(10,1990)
 1990  FORMAT('!----------------------------------')
C
C      ---------------------------------
C      GENLN2 input file *TITLES section
C      ---------------------------------
       WRITE(10,1100) 
 1100  FORMAT('*TITLES')
       WRITE(10,1992) Q, TITLE, Q
 1992  FORMAT(A1, A40, A1)
 1995  FORMAT(A1, A80, A1)
       WRITE(10,1110) ' .FALSE.', '  .TRUE.'
 1110  FORMAT(2A8)
c       WRITE(10,1991) 1
 1991  FORMAT(I3)
c       WRITE(10,1991) -1
       WRITE(10,1990)
C
C      ---------------------------------
C      GENLN2 input file *GASFIL section
C      ---------------------------------
       WRITE(10,1200)
 1200  FORMAT('*GASFIL')
C
c SGI      WRITE(10,1993) 1, 1
       WRITE(10,1993) 1, 2
       WRITE(10,1994) STMINW, STMINF
 1994  FORMAT(1PE8.1, '  ', E8.1)
C
       WRITE(10,1995) Q, LINFIL, Q
       WRITE(10,1991) 1
       WRITE(10,1991) GASID
       WRITE(10,1991) LVERS
       WRITE(10,1990)
C
C      ---------------------------------
C      GENLN2 input file *LINMIX section
C      ---------------------------------
       IF (MIXING) THEN
          WRITE(10,1300)
 1300     FORMAT('*LINMIX')
          WRITE(10,1990)
       ENDIF
C
C      ---------------------------------
C      GENLN2 input file *DEFGRD section
C      ---------------------------------
       WRITE(10,1400)
 1400  FORMAT('*DEFGRD')
       WRITE(10,1410) FSTART-25, FSTART, FEND, FEND+25, 1
 1410  FORMAT(5I6)
C
       WRITE(10,1510) 1, 25, NDIV, INTERP
 1510  FORMAT(4I6)
       WRITE(10,1990)
C
C      ---------------------------------
C      GENLN2 input file *PTHPAR section
C      ---------------------------------
       WRITE(10,1600)
 1600  FORMAT('*PTHPAR')
       WRITE(10,1991) 1
C
C      Calculate gas density
       DEN=DENREF*TREF/T
C
C      Convert pressure to atm
       TOTP=TOTP/760.0
       PARTP=PARTP/760.0
C
C      Calc amount (k-moles/cm^2)
       A=100*PLEN*DEN*PARTP/AV
C
       WRITE(10,1610) 1, GASID, 0, A, T, 0.0, TOTP, 0.0, PARTP, 0.0
 1610  FORMAT(I3, ',', I3, ',', I2, ',', 1PE12.4, ',', 0PF9.3,
     $    ',', 0PF9.3, ',', 3(1PE12.4, ','), 0PF9.3)
       WRITE(10,1620) Q, LSHAPE, Q, Q, CONSTR, Q
 1620  FORMAT(A1, A8, A1, 2X, A1, A8, A1)
       WRITE(10,1990)
C
C      ---------------------------------
C      GENLN2 input file *RADFIL section
C      ---------------------------------
       IF (DORAD) THEN
          WRITE(10,1701)
 1701     FORMAT('*RADFIL')
          WRITE(10,1992) Q, RADFIL, Q
          WRITE(10,1990)
       ENDIF
C
C      ---------------------------------
C      GENLN2 input file *OUTPUT section
C      ---------------------------------
       WRITE(10,1700)
 1700  FORMAT('*OUTPUT')
       WRITE(10,1992) Q,OUTNAM,Q
       IF (DORAD) THEN
          WRITE(10,1991) 7
          WRITE(10,1993) 1, 1
 1993     FORMAT(I3, 2X, I3)
       ELSE
          WRITE(10,1991) 1
          WRITE(10,1991) 1
       ENDIF
       WRITE(10,1991) 1
       WRITE(10,1990)
C
C      ---------------------------------
C      GENLN2 input file *SSTUFF section
C      ---------------------------------
C      Note: non-standard GENLN2; added by Scott to "zinput.f"
       WRITE(10,1791)
 1791  FORMAT('*SSTUFF')
       WRITE(10,1796) GASID, SMULT, WMULT, NMULT
 1796  FORMAT(I2, 3(1X, F10.5))
       WRITE(10,1990)
C
C      ---------------------------------
C      GENLN2 input file *XCONTM section
C      ---------------------------------
C      Note: non-standard GENLN2; added by Scott to "zinput.f"
       IF (ISCON) THEN
          WRITE(10,1790)
 1790     FORMAT('*XCONTM')
          WRITE(10,1795) GASID, CMULT1, CMULT2
 1795     FORMAT(I2, 1X , F10.5, 1X, F10.5)
          WRITE(10,1990)
       ENDIF
C
C      ---------------------------------
C      GENLN2 input file *ENDINP section
C      ---------------------------------
       WRITE(10,1800)
 1800  FORMAT('*ENDINP')
       WRITE(10,1990)
C
C      ------------------------------
C      Close the output file and exit
C      ------------------------------
       CLOSE(10)
C
       WRITE(6,*) 'all done'
C
       STOP
       END
