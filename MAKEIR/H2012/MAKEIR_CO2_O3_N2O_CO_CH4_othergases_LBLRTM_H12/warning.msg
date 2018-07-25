 driver file name is junk.nml                                                                        
 output file name is junk.dat                                                                        
 checking parameters in kcarta.param
   
 Max #of atmospheres from *RADFIL =   5
 Max #of gases from *GAS/XSCFIL =   80
 Max #of mixed paths *MIXFIL =   200
   
 kTemperVary = -1     !!!temperature in layer constant USE THIS!!!! DEFAULT
 checking parameters (from *PARAMS) .... 
   
 Reading in the Namelists ............. 
 successfully read in params .....
 checking parameters (from *PARAMS) .... 
   
 **********************************************************************
 successfully read in freqs .....
 **********************************************************************
 successfully read in molgas .....
 **********************************************************************
 successfully read in xscgas .....
 **********************************************************************
 successfully read in prfile .....
 **********************************************************************
 successfully read in weight .....
 **********************************************************************
 successfully read in radnce .....
 **********************************************************************
 successfully read in jacobn .....
 **********************************************************************
 successfully read in spectra .....
 **********************************************************************
 successfully read in nonlte .....
 **********************************************************************
 successfully read in scattr .....
 **********************************************************************
 successfully read in output .....
 **********************************************************************
 successfully read in endinp .....
 **********************************************************************
 checking parameters (from *PARAMS) .... 
   
 successfully checked params .....
 kActualJacs,kActualJacsB,kActualJacsT =  -1 -1 -1
 **********************************************************************
 successfully checked freqs .....
 **********************************************************************
 including user specified lbl gases
 using user sepcified list
Warning! GasID 101 is a new continuum gas
Warning! GasID 102 is a new continuum gas
Warning! GasID 103 is heavy water (gasID  =  1, HITRAN isotope  =  4)
 MOLGAS ... gases stored are   11
      going to use compressed database gas   1
      going to use compressed database gas   2
      going to use compressed database gas   3
      going to use compressed database gas   4
      going to use compressed database gas   5
      going to use compressed database gas   6
      going to use compressed database gas   7
      going to use compressed database gas   22
      going to use new continuum gas   101
      going to use new continuum gas   102
      going to use new heavy water gas   103
 successfully checked molgas .....
 **********************************************************************
 successfully checked xscgas .....
 **********************************************************************
 KCARTA expecting RTP hdf style input profile
 new style RTP profile to be read is  : 
local_pin_feb2002_sea_airsnadir_g80_op.o3.rtp                                   
 within this file, we will read profile #   49
 head.ptype =   1
 head.ngas  =   76
 Expecting   11  gases in rtp profile
 head.ptype =   1
 success : read in RTP profile   49
 Reading profile from RTP file... 
   number layers, gases in file =   97  76
   the profile that came out of KLAYERS has p.lay
   top,bot =   4  100  1013.95  5.000000E-03
 Profile has   76  gases in atm
 Profile has   97  layers in atm
 Compiled kCARTA had kProfLayer =   100
 Will add on dummy info to LOWER layers
 i,height,thickness  1 -897.088  297.088
 i,height,thickness  2 -600.000  297.088
 i,height,thickness  3 -302.912  297.088
 i,height,thickness  4 -5.82333  235.261
 i,height,thickness  5  229.438  237.157
 i,height,thickness  6  466.595  239.060
 i,height,thickness  7  705.654  240.975
 i,height,thickness  8  946.629  242.911
 i,height,thickness  9  1189.54  244.883
 i,height,thickness  10  1434.42  246.870
 i,height,thickness  11  1681.29  248.867
 i,height,thickness  12  1930.16  250.882
 i,height,thickness  13  2181.04  252.931
 i,height,thickness  14  2433.97  254.998
 i,height,thickness  15  2688.97  257.072
 i,height,thickness  16  2946.04  259.172
 i,height,thickness  17  3205.21  261.319
 i,height,thickness  18  3466.53  263.483
 i,height,thickness  19  3730.02  265.654
 i,height,thickness  20  3995.67  267.865
 i,height,thickness  21  4263.53  270.116
 i,height,thickness  22  4533.65  272.379
 i,height,thickness  23  4806.03  274.658
 i,height,thickness  24  5080.69  276.991
 i,height,thickness  25  5357.68  279.354
 i,height,thickness  26  5637.03  281.733
 i,height,thickness  27  5918.77  284.139
 i,height,thickness  28  6202.90  286.600
 i,height,thickness  29  6489.50  289.081
 i,height,thickness  30  6778.59  291.581
 i,height,thickness  31  7070.17  294.139
 i,height,thickness  32  7364.31  296.742
 i,height,thickness  33  7661.05  299.359
 i,height,thickness  34  7960.41  302.016
 i,height,thickness  35  8262.42  304.729
 i,height,thickness  36  8567.15  307.469
 i,height,thickness  37  8874.62  310.239
 i,height,thickness  38  9184.86  313.125
 i,height,thickness  39  9497.99  316.042
 i,height,thickness  40  9814.03  318.986
 i,height,thickness  41  10133.0  321.981
 i,height,thickness  42  10455.0  325.006
 i,height,thickness  43  10780.0  328.204
 i,height,thickness  44  11108.2  333.798
 i,height,thickness  45  11442.0  340.371
 i,height,thickness  46  11782.4  347.182
 i,height,thickness  47  12129.6  354.273
 i,height,thickness  48  12483.8  361.628
 i,height,thickness  49  12845.5  369.260
 i,height,thickness  50  13214.7  377.165
 i,height,thickness  51  13591.9  385.386
 i,height,thickness  52  13977.3  393.920
 i,height,thickness  53  14371.2  402.787
 i,height,thickness  54  14774.0  412.025
 i,height,thickness  55  15186.0  421.640
 i,height,thickness  56  15607.6  431.666
 i,height,thickness  57  16039.3  442.114
 i,height,thickness  58  16481.4  453.037
 i,height,thickness  59  16934.5  464.453
 i,height,thickness  60  17398.9  476.391
 i,height,thickness  61  17875.3  488.898
 i,height,thickness  62  18364.2  502.020
 i,height,thickness  63  18866.2  515.795
 i,height,thickness  64  19382.0  530.258
 i,height,thickness  65  19912.3  545.924
 i,height,thickness  66  20458.2  563.262
 i,height,thickness  67  21021.5  581.729
 i,height,thickness  68  21603.2  601.361
 i,height,thickness  69  22204.5  622.217
 i,height,thickness  70  22826.8  644.430
 i,height,thickness  71  23471.2  668.102
 i,height,thickness  72  24139.3  693.375
 i,height,thickness  73  24832.7  720.395
 i,height,thickness  74  25553.1  749.355
 i,height,thickness  75  26302.4  780.467
 i,height,thickness  76  27082.9  814.018
 i,height,thickness  77  27896.9  850.408
 i,height,thickness  78  28747.3  889.875
 i,height,thickness  79  29637.2  933.047
 i,height,thickness  80  30570.2  981.061
 i,height,thickness  81  31551.3  1033.90
 i,height,thickness  82  32585.2  1095.32
 i,height,thickness  83  33680.5  1168.73
 i,height,thickness  84  34849.2  1250.86
 i,height,thickness  85  36100.1  1343.68
 i,height,thickness  86  37443.8  1448.90
 i,height,thickness  87  38892.7  1569.56
 i,height,thickness  88  40462.2  1708.75
 i,height,thickness  89  42171.0  1871.17
 i,height,thickness  90  44042.2  2062.21
 i,height,thickness  91  46104.4  2283.06
 i,height,thickness  92  48387.4  2506.05
 i,height,thickness  93  50893.5  2721.03
 i,height,thickness  94  53614.5  2964.85
 i,height,thickness  95  56579.4  3238.88
 i,height,thickness  96  59818.2  3571.98
 i,height,thickness  97  63390.2  4005.69
 i,height,thickness  98  67395.9  4582.83
 i,height,thickness  99  71978.7  5446.17
 i,height,thickness  100  77424.9  6909.91
  ---------------------------------------------
  Reading Gas number   1  of   76  : ID =   1
 empty layer gasID, set rAmt = 0.0  1 gindx,layer   1  98
 empty layer gasID, set rAmt = 0.0  1 gindx,layer   1  99
 empty layer gasID, set rAmt = 0.0  1 gindx,layer   1  100
read in  100 atm layers for gas ID   1
  ---------------------------------------------
  Reading Gas number   2  of   76  : ID =   2
 empty layer gasID, set rAmt = 0.0  2 gindx,layer   2  98
 empty layer gasID, set rAmt = 0.0  2 gindx,layer   2  99
 empty layer gasID, set rAmt = 0.0  2 gindx,layer   2  100
read in  100 atm layers for gas ID   2
  ---------------------------------------------
  Reading Gas number   3  of   76  : ID =   3
 empty layer gasID, set rAmt = 0.0  3 gindx,layer   3  98
 empty layer gasID, set rAmt = 0.0  3 gindx,layer   3  99
 empty layer gasID, set rAmt = 0.0  3 gindx,layer   3  100
read in  100 atm layers for gas ID   3
  ---------------------------------------------
  Reading Gas number   4  of   76  : ID =   4
 empty layer gasID, set rAmt = 0.0  4 gindx,layer   4  98
 empty layer gasID, set rAmt = 0.0  4 gindx,layer   4  99
 empty layer gasID, set rAmt = 0.0  4 gindx,layer   4  100
read in  100 atm layers for gas ID   4
  ---------------------------------------------
  Reading Gas number   5  of   76  : ID =   5
 empty layer gasID, set rAmt = 0.0  5 gindx,layer   5  98
 empty layer gasID, set rAmt = 0.0  5 gindx,layer   5  99
 empty layer gasID, set rAmt = 0.0  5 gindx,layer   5  100
read in  100 atm layers for gas ID   5
  ---------------------------------------------
  Reading Gas number   6  of   76  : ID =   6
 empty layer gasID, set rAmt = 0.0  6 gindx,layer   6  98
 empty layer gasID, set rAmt = 0.0  6 gindx,layer   6  99
 empty layer gasID, set rAmt = 0.0  6 gindx,layer   6  100
read in  100 atm layers for gas ID   6
  ---------------------------------------------
  Reading Gas number   7  of   76  : ID =   7
 empty layer gasID, set rAmt = 0.0  7 gindx,layer   7  98
 empty layer gasID, set rAmt = 0.0  7 gindx,layer   7  99
 empty layer gasID, set rAmt = 0.0  7 gindx,layer   7  100
read in  100 atm layers for gas ID   7
  ---------------------------------------------
  Reading Gas number   8  of   76  : ID =   8
read in  100 atm layers for gas ID   8
Gas molecular ID  8 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   9  of   76  : ID =   9
read in  100 atm layers for gas ID   9
Gas molecular ID  9 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   10  of   76  : ID =   10
read in  100 atm layers for gas ID  10
Gas molecular ID 10 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   11  of   76  : ID =   11
read in  100 atm layers for gas ID  11
Gas molecular ID 11 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   12  of   76  : ID =   12
read in  100 atm layers for gas ID  12
Gas molecular ID 12 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   13  of   76  : ID =   13
read in  100 atm layers for gas ID  13
Gas molecular ID 13 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   14  of   76  : ID =   14
read in  100 atm layers for gas ID  14
Gas molecular ID 14 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   15  of   76  : ID =   15
read in  100 atm layers for gas ID  15
Gas molecular ID 15 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   16  of   76  : ID =   16
read in  100 atm layers for gas ID  16
Gas molecular ID 16 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   17  of   76  : ID =   17
read in  100 atm layers for gas ID  17
Gas molecular ID 17 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   18  of   76  : ID =   18
read in  100 atm layers for gas ID  18
Gas molecular ID 18 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   19  of   76  : ID =   19
read in  100 atm layers for gas ID  19
Gas molecular ID 19 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   20  of   76  : ID =   20
read in  100 atm layers for gas ID  20
Gas molecular ID 20 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   21  of   76  : ID =   21
read in  100 atm layers for gas ID  21
Gas molecular ID 21 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   22  of   76  : ID =   22
 empty layer gasID, set rAmt = 0.0  22 gindx,layer   8  98
 empty layer gasID, set rAmt = 0.0  22 gindx,layer   8  99
 empty layer gasID, set rAmt = 0.0  22 gindx,layer   8  100
read in  100 atm layers for gas ID  22
  ---------------------------------------------
  Reading Gas number   23  of   76  : ID =   23
read in  100 atm layers for gas ID  23
Gas molecular ID 23 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   24  of   76  : ID =   24
read in  100 atm layers for gas ID  24
Gas molecular ID 24 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   25  of   76  : ID =   25
read in  100 atm layers for gas ID  25
Gas molecular ID 25 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   26  of   76  : ID =   26
read in  100 atm layers for gas ID  26
Gas molecular ID 26 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   27  of   76  : ID =   27
read in  100 atm layers for gas ID  27
Gas molecular ID 27 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   28  of   76  : ID =   28
read in  100 atm layers for gas ID  28
Gas molecular ID 28 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   29  of   76  : ID =   29
read in  100 atm layers for gas ID  29
Gas molecular ID 29 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   30  of   76  : ID =   30
read in  100 atm layers for gas ID  30
Gas molecular ID 30 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   31  of   76  : ID =   31
read in  100 atm layers for gas ID  31
Gas molecular ID 31 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   32  of   76  : ID =   32
read in  100 atm layers for gas ID  32
Gas molecular ID 32 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   33  of   76  : ID =   33
read in  100 atm layers for gas ID  33
Gas molecular ID 33 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   34  of   76  : ID =   34
read in  100 atm layers for gas ID  34
Gas molecular ID 34 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   35  of   76  : ID =   35
read in  100 atm layers for gas ID  35
Gas molecular ID 35 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   36  of   76  : ID =   36
read in  100 atm layers for gas ID  36
Gas molecular ID 36 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   37  of   76  : ID =   37
read in  100 atm layers for gas ID  37
Gas molecular ID 37 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   38  of   76  : ID =   38
read in  100 atm layers for gas ID  38
Gas molecular ID 38 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   39  of   76  : ID =   39
read in  100 atm layers for gas ID  39
Gas molecular ID 39 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   40  of   76  : ID =   40
read in  100 atm layers for gas ID  40
Gas molecular ID 40 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   41  of   76  : ID =   41
read in  100 atm layers for gas ID  41
Gas molecular ID 41 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   42  of   76  : ID =   42
read in  100 atm layers for gas ID  42
Gas molecular ID 42 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   43  of   76  : ID =   51
read in  100 atm layers for gas ID  51
Gas molecular ID 51 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   44  of   76  : ID =   52
read in  100 atm layers for gas ID  52
Gas molecular ID 52 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   45  of   76  : ID =   53
read in  100 atm layers for gas ID  53
Gas molecular ID 53 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   46  of   76  : ID =   54
read in  100 atm layers for gas ID  54
Gas molecular ID 54 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   47  of   76  : ID =   55
read in  100 atm layers for gas ID  55
Gas molecular ID 55 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   48  of   76  : ID =   56
read in  100 atm layers for gas ID  56
Gas molecular ID 56 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   49  of   76  : ID =   57
read in  100 atm layers for gas ID  57
Gas molecular ID 57 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   50  of   76  : ID =   58
read in  100 atm layers for gas ID  58
Gas molecular ID 58 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   51  of   76  : ID =   59
read in  100 atm layers for gas ID  59
Gas molecular ID 59 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   52  of   76  : ID =   60
read in  100 atm layers for gas ID  60
Gas molecular ID 60 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   53  of   76  : ID =   61
read in  100 atm layers for gas ID  61
Gas molecular ID 61 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   54  of   76  : ID =   62
read in  100 atm layers for gas ID  62
Gas molecular ID 62 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   55  of   76  : ID =   63
read in  100 atm layers for gas ID  63
Gas molecular ID 63 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   56  of   76  : ID =   64
read in  100 atm layers for gas ID  64
Gas molecular ID 64 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   57  of   76  : ID =   65
read in  100 atm layers for gas ID  65
Gas molecular ID 65 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   58  of   76  : ID =   66
read in  100 atm layers for gas ID  66
Gas molecular ID 66 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   59  of   76  : ID =   67
read in  100 atm layers for gas ID  67
Gas molecular ID 67 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   60  of   76  : ID =   68
read in  100 atm layers for gas ID  68
Gas molecular ID 68 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   61  of   76  : ID =   69
read in  100 atm layers for gas ID  69
Gas molecular ID 69 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   62  of   76  : ID =   70
read in  100 atm layers for gas ID  70
Gas molecular ID 70 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   63  of   76  : ID =   71
read in  100 atm layers for gas ID  71
Gas molecular ID 71 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   64  of   76  : ID =   72
read in  100 atm layers for gas ID  72
Gas molecular ID 72 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   65  of   76  : ID =   73
read in  100 atm layers for gas ID  73
Gas molecular ID 73 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   66  of   76  : ID =   74
read in  100 atm layers for gas ID  74
Gas molecular ID 74 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   67  of   76  : ID =   75
read in  100 atm layers for gas ID  75
Gas molecular ID 75 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   68  of   76  : ID =   76
read in  100 atm layers for gas ID  76
Gas molecular ID 76 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   69  of   76  : ID =   77
read in  100 atm layers for gas ID  77
Gas molecular ID 77 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   70  of   76  : ID =   78
read in  100 atm layers for gas ID  78
Gas molecular ID 78 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   71  of   76  : ID =   79
read in  100 atm layers for gas ID  79
Gas molecular ID 79 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   72  of   76  : ID =   80
read in  100 atm layers for gas ID  80
Gas molecular ID 80 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Gas number   73  of   76  : ID =   81
read in  100 atm layers for gas ID  81
Gas molecular ID 81 not set from GASFIL or XSCFIL
  ---------------------------------------------
  Reading Cloud100 Layer Profiles, as gas   74  of   76
  ---------------------------------------------
  Reading Cloud100 Layer Profiles, as gas   75  of   76
  ---------------------------------------------
  Reading Cloud100 Layer Profiles, as gas   76  of   76
 Using water profile for gasID   101
 Using water profile for gasID   102
 Using water profile for gasID   103
       
 Pressure level, layer thickness info (RTP file)
 -----------------------------------------------
 Number of layers =   97
 Lowest  layer : press levels (mb) =   1013.95  986.067
 Highest layer : press levels (mb) =   1.610000E-02  5.000000E-03
 2 Lowest layers thickness (km) =   0.235261  0.237157
 2 Highest layers thickness (km) =   5.44617  6.90991
 Highest database pressure (lowest level) :   1100.00
 Lowest database pressure (highest level) :   5.000000E-03
 Highest klayers pressure (lowest level) :   1013.95
 Lowest  klayers pressure (highest level) :   5.000000E-03
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>                 
 RRTM PSEUDO IN (ie incorrect format!!) --- start cut below this line ----
local_pin_feb2002_sea_airsnadir_g80_op.o3.rtp                                   
$ start of info                                                                 
                                                 0                   1          
Stemp 1 0 Emis                                                                  
   1  97  7  1.00000
   0.986866  287.497  1013.95  287.497  986.067  287.497
   4.4790E+21   2.1758E+20   1.5819E+16   1.8822E+17   8.7875E+16   1.0559E+18   1.2293E+23   0.0000E+00
   0.959551  285.971  986.067  285.971  958.591  285.971
   4.1843E+21   2.1448E+20   1.5963E+16   1.8554E+17   8.5944E+16   1.0409E+18   1.2118E+23   0.0000E+00
   0.932636  284.425  958.591  284.425  931.524  284.425
   3.8930E+21   2.1137E+20   1.6099E+16   1.8284E+17   8.4016E+16   1.0257E+18   1.1942E+23   0.0000E+00
   0.906124  282.858  931.524  282.858  904.866  282.858
   3.6053E+21   2.0823E+20   1.6228E+16   1.8014E+17   8.2093E+16   1.0105E+18   1.1765E+23   0.0000E+00
   0.880018  281.282  904.866  281.282  878.620  281.282
   3.3324E+21   2.0508E+20   1.6361E+16   1.7741E+17   8.0175E+16   9.9525E+17   1.1587E+23   0.0000E+00
   0.854320  279.711  878.620  279.711  852.788  279.711
   3.0879E+21   2.0191E+20   1.6510E+16   1.7466E+17   7.8262E+16   9.7985E+17   1.1408E+23   0.0000E+00
   0.829031  278.119  852.788  278.119  827.371  278.119
   2.8479E+21   1.9872E+20   1.6652E+16   1.7191E+17   7.6356E+16   9.6438E+17   1.1228E+23   0.0000E+00
   0.804152  276.506  827.371  276.506  802.371  276.506
   2.6112E+21   1.9552E+20   1.6786E+16   1.6914E+17   7.4458E+16   9.4885E+17   1.1047E+23   0.0000E+00
   0.779685  274.878  802.371  274.878  777.790  274.878
   2.3790E+21   1.9231E+20   1.6837E+16   1.6636E+17   7.2574E+16   9.3326E+17   1.0865E+23   0.0000E+00
   0.755633  273.254  777.790  273.254  753.628  273.254
   2.1527E+21   1.8908E+20   1.6671E+16   1.6357E+17   7.0718E+16   9.1761E+17   1.0683E+23   0.0000E+00
   0.731995  271.609  753.628  271.609  729.886  271.609
   1.9302E+21   1.8585E+20   1.6489E+16   1.6077E+17   6.8874E+16   9.0193E+17   1.0501E+23   0.0000E+00
   0.708772  269.940  729.886  269.940  706.565  269.940
   1.7117E+21   1.8261E+20   1.6304E+16   1.5797E+17   6.7039E+16   8.8619E+17   1.0317E+23   0.0000E+00
   0.685965  268.258  706.565  268.258  683.667  268.258
   1.5140E+21   1.7936E+20   1.6111E+16   1.5516E+17   6.5265E+16   8.7041E+17   1.0134E+23   0.0000E+00
   0.663575  266.580  683.667  266.580  661.192  266.580
   1.3584E+21   1.7609E+20   1.5902E+16   1.5233E+17   6.3617E+16   8.5455E+17   9.9489E+22   0.0000E+00
   0.641602  264.877  661.192  264.877  639.140  264.877
   1.2073E+21   1.7282E+20   1.5691E+16   1.4950E+17   6.1982E+16   8.3867E+17   9.7641E+22   0.0000E+00
   0.620048  263.150  639.140  263.150  617.511  263.150
   1.0592E+21   1.6954E+20   1.5478E+16   1.4666E+17   6.0356E+16   8.2277E+17   9.5789E+22   0.0000E+00
   0.598911  261.416  617.511  261.416  596.306  261.416
   9.2985E+20   1.6626E+20   1.5431E+16   1.4382E+17   5.8898E+16   8.0684E+17   9.3935E+22   0.0000E+00
   0.578193  259.679  596.306  259.679  575.525  259.679
   8.2152E+20   1.6297E+20   1.5574E+16   1.4098E+17   5.7627E+16   7.9089E+17   9.2078E+22   0.0000E+00
   0.557892  257.915  575.525  257.915  555.167  257.915
   7.1558E+20   1.5969E+20   1.5706E+16   1.3814E+17   5.6359E+16   7.7494E+17   9.0221E+22   0.0000E+00
   0.538010  256.126  555.167  256.126  535.232  256.126
   6.1331E+20   1.5640E+20   1.5825E+16   1.3530E+17   5.5092E+16   7.5900E+17   8.8365E+22   0.0000E+00
   0.518545  254.341  535.232  254.341  515.720  254.341
   5.3766E+20   1.5311E+20   1.5895E+16   1.3245E+17   5.3782E+16   7.4304E+17   8.6507E+22   0.0000E+00
   0.499496  252.540  515.720  252.540  496.630  252.540
   4.7312E+20   1.4983E+20   1.5939E+16   1.2961E+17   5.2460E+16   7.2709E+17   8.4651E+22   0.0000E+00
   0.480864  250.711  496.630  250.711  477.961  250.711
   4.1012E+20   1.4655E+20   1.5974E+16   1.2677E+17   5.1144E+16   7.1118E+17   8.2798E+22   0.0000E+00
   0.462647  248.864  477.961  248.864  459.712  248.864
   3.5202E+20   1.4327E+20   1.6137E+16   1.2394E+17   4.9770E+16   6.9524E+17   8.0948E+22   0.0000E+00
   0.444844  247.021  459.712  247.021  441.882  247.021
   3.0539E+20   1.4000E+20   1.6702E+16   1.2111E+17   4.8209E+16   6.7917E+17   7.9101E+22   0.0000E+00
   0.427454  245.151  441.882  245.151  424.470  245.151
   2.6066E+20   1.3674E+20   1.7267E+16   1.1829E+17   4.6650E+16   6.6315E+17   7.7259E+22   0.0000E+00
   0.410475  243.251  424.470  243.251  407.474  243.251
   2.1754E+20   1.3350E+20   1.7805E+16   1.1548E+17   4.5105E+16   6.4719E+17   7.5425E+22   0.0000E+00
   0.393907  241.355  407.474  241.355  390.893  241.355
   1.8640E+20   1.3026E+20   1.8336E+16   1.1268E+17   4.3442E+16   6.3128E+17   7.3594E+22   0.0000E+00
   0.377746  239.444  390.893  239.444  374.724  239.444
   1.6105E+20   1.2703E+20   1.8848E+16   1.0989E+17   4.1740E+16   6.1545E+17   7.1772E+22   0.0000E+00
   0.361993  237.501  374.724  237.501  358.966  237.501
   1.3644E+20   1.2382E+20   1.9329E+16   1.0711E+17   4.0065E+16   5.9969E+17   6.9957E+22   0.0000E+00
   0.346643  235.543  358.966  235.543  343.618  235.543
   1.1264E+20   1.2062E+20   2.0542E+16   1.0433E+17   3.8322E+16   5.8394E+17   6.8152E+22   0.0000E+00
   0.331696  233.583  343.618  233.583  328.675  233.583
   8.9736E+19   1.1744E+20   2.3035E+16   1.0153E+17   3.6445E+16   5.6817E+17   6.6355E+22   0.0000E+00
   0.317149  231.590  328.675  231.590  314.137  231.590
   6.7584E+19   1.1429E+20   2.5450E+16   9.8754E+16   3.4603E+16   5.5251E+17   6.4571E+22   0.0000E+00
   0.303000  229.576  314.137  229.576  300.000  229.576
   4.8071E+19   1.1114E+20   2.7852E+16   9.5977E+16   3.2793E+16   5.3689E+17   6.2796E+22   0.0000E+00
   0.289245  227.590  300.000  227.590  286.262  227.590
   3.7695E+19   1.0802E+20   3.0588E+16   9.3147E+16   3.0994E+16   5.2113E+17   6.1032E+22   0.0000E+00
   0.275882  225.577  286.262  225.577  272.919  225.577
   2.8737E+19   1.0492E+20   3.3245E+16   9.0331E+16   2.9232E+16   5.0546E+17   5.9281E+22   0.0000E+00
   0.262908  223.529  272.919  223.529  259.969  223.529
   2.0487E+19   1.0185E+20   3.6049E+16   8.7527E+16   2.7514E+16   4.8993E+17   5.7544E+22   0.0000E+00
   0.250320  221.464  259.969  221.464  247.408  221.464
   1.6120E+19   9.8797E+19   4.1377E+16   8.4610E+16   2.5844E+16   4.7436E+17   5.5819E+22   0.0000E+00
   0.238115  219.365  247.408  219.365  235.234  219.365
   1.2800E+19   9.5771E+19   4.7100E+16   8.1693E+16   2.4218E+16   4.5892E+17   5.4110E+22   0.0000E+00
   0.226289  217.325  235.234  217.325  223.441  217.325
   9.6749E+18   9.2773E+19   5.2563E+16   7.8812E+16   2.2631E+16   4.4364E+17   5.2416E+22   0.0000E+00
   0.214838  216.773  223.441  216.773  212.028  216.773
   7.6627E+18   8.9806E+19   5.8284E+16   7.5940E+16   2.1011E+16   4.2838E+17   5.0740E+22   0.0000E+00
   0.203759  216.740  212.028  216.740  200.989  216.740
   6.0620E+18   8.6866E+19   6.3863E+16   7.3098E+16   1.9414E+16   4.1325E+17   4.9079E+22   0.0000E+00
   0.193048  216.707  200.989  216.707  190.320  216.707
   4.5715E+18   8.3959E+19   6.9011E+16   7.0300E+16   1.7853E+16   3.9832E+17   4.7436E+22   0.0000E+00
   0.182701  216.700  190.320  216.700  180.018  216.700
   3.6396E+18   8.1085E+19   7.2741E+16   6.7535E+16   1.6183E+16   3.8337E+17   4.5812E+22   0.0000E+00
   0.172713  216.700  180.018  216.700  170.078  216.700
   2.8911E+18   7.8244E+19   7.5877E+16   6.4813E+16   1.4527E+16   3.6857E+17   4.4207E+22   0.0000E+00
   0.163080  216.700  170.078  216.700  160.496  216.700
   2.2148E+18   7.5439E+19   7.9260E+16   6.2138E+16   1.2944E+16   3.5400E+17   4.2623E+22   0.0000E+00
   0.153798  216.700  160.496  216.700  151.266  216.700
   1.7492E+18   7.2669E+19   8.4714E+16   5.9498E+16   1.1474E+16   3.3955E+17   4.1057E+22   0.0000E+00
   0.144861  216.700  151.266  216.700  142.385  216.700
   1.3291E+18   6.9938E+19   9.0061E+16   5.6909E+16   1.0071E+16   3.2536E+17   3.9515E+22   0.0000E+00
   0.136266  216.700  142.385  216.700  133.846  216.700
   1.0500E+18   6.7245E+19   9.5851E+16   5.4353E+16   8.8087E+15   3.1136E+17   3.7993E+22   0.0000E+00
   0.128007  216.700  133.846  216.700  125.646  216.700
   9.4314E+17   6.4591E+19   1.0231E+17   5.1826E+16   7.7073E+15   2.9755E+17   3.6494E+22   0.0000E+00
   0.120078  216.700  125.646  216.700  117.777  216.700
   8.4108E+17   6.1980E+19   1.0869E+17   4.9348E+16   6.6703E+15   2.8401E+17   3.5019E+22   0.0000E+00
   0.112475  216.700  117.777  216.700  110.237  216.700
   7.3739E+17   5.9411E+19   1.1808E+17   4.6868E+16   5.7874E+15   2.7066E+17   3.3567E+22   0.0000E+00
   0.105192  216.700  110.237  216.700  103.017  216.700
   6.3750E+17   5.6885E+19   1.2747E+17   4.4436E+16   4.9707E+15   2.5758E+17   3.2140E+22   0.0000E+00
   9.822413E-02  216.700  103.017  216.700  96.1138  216.700
   5.7677E+17   5.4403E+19   1.3957E+17   4.1967E+16   4.2996E+15   2.4455E+17   3.0737E+22   0.0000E+00
   9.156480E-02  216.700  96.1138  216.700  89.5204  216.700
   5.4466E+17   5.1967E+19   1.5328E+17   3.9497E+16   3.7420E+15   2.3165E+17   2.9361E+22   0.0000E+00
   8.520851E-02  216.700  89.5204  216.700  83.2310  216.700
   5.1511E+17   4.9578E+19   1.6755E+17   3.7063E+16   3.2256E+15   2.1904E+17   2.8011E+22   0.0000E+00
   7.914924E-02  216.700  83.2310  216.700  77.2396  216.700
   4.8921E+17   4.7236E+19   1.8358E+17   3.4642E+16   2.7589E+15   2.0666E+17   2.6688E+22   0.0000E+00
   7.338102E-02  216.700  77.2396  216.700  71.5398  216.700
   4.6478E+17   4.4944E+19   1.9878E+17   3.2254E+16   2.3351E+15   1.9450E+17   2.5393E+22   0.0000E+00
   6.789741E-02  216.700  71.5398  216.700  66.1253  216.700
   4.4291E+17   4.2701E+19   2.1409E+17   2.9829E+16   1.9780E+15   1.8236E+17   2.4126E+22   0.0000E+00
   6.269211E-02  216.700  66.1253  216.700  60.9895  216.700
   4.2193E+17   4.0509E+19   2.2932E+17   2.7469E+16   1.6733E+15   1.7037E+17   2.2888E+22   0.0000E+00
   5.775877E-02  216.700  60.9895  216.700  56.1260  216.700
   4.0228E+17   3.8368E+19   2.4675E+17   2.5143E+16   1.4624E+15   1.5815E+17   2.1678E+22   0.0000E+00
   5.309070E-02  216.864  56.1260  216.864  51.5278  216.864
   3.8349E+17   3.6281E+19   2.6051E+17   2.2904E+16   1.2892E+15   1.4616E+17   2.0499E+22   0.0000E+00
   4.868116E-02  217.355  51.5278  217.355  47.1882  217.355
   3.6581E+17   3.4247E+19   2.6906E+17   2.0742E+16   1.1651E+15   1.3423E+17   1.9349E+22   0.0000E+00
   4.452334E-02  217.900  47.1882  217.900  43.1001  217.900
   3.4880E+17   3.2268E+19   2.8036E+17   1.8763E+16   1.0743E+15   1.2245E+17   1.8231E+22   0.0000E+00
   4.061035E-02  218.491  43.1001  218.491  39.2566  218.491
   3.3247E+17   3.0343E+19   2.9338E+17   1.6966E+16   1.0121E+15   1.1090E+17   1.7143E+22   0.0000E+00
   3.693522E-02  219.103  39.2566  219.103  35.6505  219.103
   3.1786E+17   2.8474E+19   3.0092E+17   1.5462E+16   9.7701E+14   1.0005E+17   1.6088E+22   0.0000E+00
   3.349072E-02  219.737  35.6505  219.737  32.2744  219.737
   3.0339E+17   2.6663E+19   3.0484E+17   1.4086E+16   9.5123E+14   8.9895E+16   1.5065E+22   0.0000E+00
   3.026961E-02  220.393  32.2744  220.393  29.1210  220.393
   2.8794E+17   2.4910E+19   3.0521E+17   1.2752E+16   9.2946E+14   8.0543E+16   1.4074E+22   0.0000E+00
   2.726466E-02  221.073  29.1210  221.073  26.1829  221.073
   2.7332E+17   2.3214E+19   3.0495E+17   1.1413E+16   9.0730E+14   7.2086E+16   1.3116E+22   0.0000E+00
   2.446849E-02  221.771  26.1829  221.771  23.4526  221.771
   2.5843E+17   2.1577E+19   3.0111E+17   1.0179E+16   8.7683E+14   6.4728E+16   1.2191E+22   0.0000E+00
   2.187361E-02  222.479  23.4526  222.479  20.9224  222.479
   2.4201E+17   2.0000E+19   2.9030E+17   9.1611E+15   8.2942E+14   5.8807E+16   1.1300E+22   0.0000E+00
   1.947246E-02  223.213  20.9224  223.213  18.5847  223.213
   2.2594E+17   1.8483E+19   2.7874E+17   8.2094E+15   7.8177E+14   5.3249E+16   1.0443E+22   0.0000E+00
   1.725751E-02  223.980  18.5847  223.980  16.4318  223.980
   2.1033E+17   1.7026E+19   2.6691E+17   7.3158E+15   7.3498E+14   4.7991E+16   9.6196E+21   0.0000E+00
   1.522108E-02  224.809  16.4318  224.809  14.4559  224.809
   1.9520E+17   1.5630E+19   2.5547E+17   6.4745E+15   6.9027E+14   4.2976E+16   8.8310E+21   0.0000E+00
   1.335550E-02  225.679  14.4559  225.679  12.6492  225.679
   1.8054E+17   1.4296E+19   2.4374E+17   5.6905E+15   6.4638E+14   3.8265E+16   8.0769E+21   0.0000E+00
   1.165300E-02  226.636  12.6492  226.636  11.0038  226.636
   1.6626E+17   1.3023E+19   2.3165E+17   4.9500E+15   6.0357E+14   3.3858E+16   7.3579E+21   0.0000E+00
   1.010584E-02  227.852  11.0038  227.852  9.51190  227.852
   1.5198E+17   1.1812E+19   2.1937E+17   4.2116E+15   5.6308E+14   2.9714E+16   6.6735E+21   0.0000E+00
   8.706223E-03  229.150  9.51190  229.150  8.16550  229.150
   1.3827E+17   1.0663E+19   2.0680E+17   3.5337E+15   5.2329E+14   2.5881E+16   6.0246E+21   0.0000E+00
   7.446305E-03  231.164  8.16550  231.164  6.95670  231.164
   1.2515E+17   9.5766E+18   1.9299E+17   2.9069E+15   4.8608E+14   2.2282E+16   5.4107E+21   0.0000E+00
   6.318282E-03  234.361  6.95670  234.361  5.87760  234.361
   1.1262E+17   8.5520E+18   1.7766E+17   2.3249E+15   4.5219E+14   1.8885E+16   4.8318E+21   0.0000E+00
   5.314413E-03  237.750  5.87760  237.750  4.92040  237.750
   1.0064E+17   7.5888E+18   1.6058E+17   1.7989E+15   4.2051E+14   1.5802E+16   4.2876E+21   0.0000E+00
   4.426837E-03  241.341  4.92040  241.341  4.07700  241.341
   8.9217E+16   6.6892E+18   1.4120E+17   1.3242E+15   3.9203E+14   1.3028E+16   3.7794E+21   0.0000E+00
   3.647822E-03  245.222  4.07700  245.222  3.33980  245.222
   7.8575E+16   5.8495E+18   1.2090E+17   9.5152E+14   3.6449E+14   1.0543E+16   3.3049E+21   0.0000E+00
   2.969705E-03  249.408  3.33980  249.408  2.70090  249.408
   6.8723E+16   5.0719E+18   1.0078E+17   6.5904E+14   3.3747E+14   8.3451E+15   2.8656E+21   0.0000E+00
   2.384793E-03  253.937  2.70090  253.937  2.15260  253.937
   5.9862E+16   4.3549E+18   7.9300E+16   4.2488E+14   3.1359E+14   6.3553E+15   2.4605E+21   0.0000E+00
   1.885479E-03  258.856  2.15260  258.856  1.68720  258.856
   5.1609E+16   3.6985E+18   5.9864E+16   2.4967E+14   2.9179E+14   4.6370E+15   2.0896E+21   0.0000E+00
   1.464266E-03  264.210  1.68720  264.210  1.29720  264.210
   4.3727E+16   3.1012E+18   4.3753E+16   1.3704E+14   2.7249E+14   3.2174E+15   1.7521E+21   0.0000E+00
   1.113851E-03  269.425  1.29720  269.425  0.975300  269.425
   3.6279E+16   2.5614E+18   2.9423E+16   7.1255E+13   2.5503E+14   2.1121E+15   1.4472E+21   0.0000E+00
   8.269136E-04  270.398  0.975300  270.398  0.714000  270.398
   2.9377E+16   2.0807E+18   1.8507E+16   3.2354E+13   2.5051E+14   1.3302E+15   1.1756E+21   0.0000E+00
   5.963663E-04  266.412  0.714000  266.412  0.506400  266.412
   2.3107E+16   1.6545E+18   1.1344E+16   1.7856E+13   2.4511E+14   8.9952E+14   9.3476E+20   0.0000E+00
   4.152765E-04  260.487  0.506400  260.487  0.345400  260.487
   1.7630E+16   1.2842E+18   6.3953E+15   1.0614E+13   2.3594E+14   6.1275E+14   7.2557E+20   0.0000E+00
   2.768959E-04  252.322  0.345400  252.322  0.224400  252.322
   1.2746E+16   9.6608E+17   3.5767E+15   6.3331E+12   2.3900E+14   4.2956E+14   5.4583E+20   0.0000E+00
   1.748044E-04  243.039  0.224400  243.039  0.137000  243.039
   8.6605E+15   6.9855E+17   1.8595E+15   3.5956E+12   2.4590E+14   2.9914E+14   3.9467E+20   0.0000E+00
   1.027128E-04  232.761  0.137000  232.761  7.690000E-02  232.761
   5.4034E+15   4.8091E+17   8.8905E+14   1.9610E+12   2.5246E+14   2.0589E+14   2.7171E+20   0.0000E+00
   5.471471E-05  221.323  7.690000E-02  221.323  3.840000E-02  221.323
   2.9829E+15   3.0847E+17   3.0748E+14   9.9715E+11   2.5592E+14   1.3207E+14   1.7429E+20   0.0000E+00
   2.531917E-05  209.992  3.840000E-02  209.992  1.610000E-02  209.992
   1.4038E+15   1.7885E+17   1.2802E+14   4.4939E+11   3.0823E+14   7.6612E+13   1.0110E+20   0.0000E+00
   9.368071E-06  198.164  1.610000E-02  198.164  5.000000E-03  198.164
   4.8725E+14   8.8342E+16   7.9884E+13   1.7026E+11   4.1201E+14   3.8204E+13   5.0002E+19   0.0000E+00
   
 Pressure LEVELS                                                                
   4  1013.95
   5  986.067
   6  958.591
   7  931.524
   8  904.866
   9  878.620
   10  852.788
   11  827.371
   12  802.371
   13  777.790
   14  753.628
   15  729.886
   16  706.565
   17  683.667
   18  661.192
   19  639.140
   20  617.511
   21  596.306
   22  575.525
   23  555.167
   24  535.232
   25  515.720
   26  496.630
   27  477.961
   28  459.712
   29  441.882
   30  424.470
   31  407.474
   32  390.893
   33  374.724
   34  358.966
   35  343.618
   36  328.675
   37  314.137
   38  300.000
   39  286.262
   40  272.919
   41  259.969
   42  247.408
   43  235.234
   44  223.441
   45  212.028
   46  200.989
   47  190.320
   48  180.018
   49  170.078
   50  160.496
   51  151.266
   52  142.385
   53  133.846
   54  125.646
   55  117.777
   56  110.237
   57  103.017
   58  96.1138
   59  89.5204
   60  83.2310
   61  77.2396
   62  71.5398
   63  66.1253
   64  60.9895
   65  56.1260
   66  51.5278
   67  47.1882
   68  43.1001
   69  39.2566
   70  35.6505
   71  32.2744
   72  29.1210
   73  26.1829
   74  23.4526
   75  20.9224
   76  18.5847
   77  16.4318
   78  14.4559
   79  12.6492
   80  11.0038
   81  9.51190
   82  8.16550
   83  6.95670
   84  5.87760
   85  4.92040
   86  4.07700
   87  3.33980
   88  2.70090
   89  2.15260
   90  1.68720
   91  1.29720
   92  0.975300
   93  0.714000
   94  0.506400
   95  0.345400
   96  0.224400
   97  0.137000
   98  7.690000E-02
   99  3.840000E-02
   100  1.610000E-02
   101  5.000000E-03
 geopotential heigt vs layer thinckness
 iI   p2h    laythick  GeoHgt1  GeoHgt2   Error1   Error2
 ---------------------------------------------------------
   4  40.1814  235.261  234.601  234.600  0.280589  0.280917
   5  287.103  237.157  236.527  236.527  0.265616  0.265598
   6  535.992  239.060  238.462  238.462  0.250030  0.249809
   7  786.846  240.975  240.411  240.410  0.233972  0.234252
   8  1039.70  242.911  242.381  242.379  0.218040  0.218850
   9  1294.58  244.883  244.380  244.380  0.205386  0.205165
   10  1551.56  246.870  246.395  246.395  0.192112  0.192255
   11  1810.64  248.867  248.423  248.423  0.178182  0.178432
   12  2071.87  250.882  250.474  250.471  0.162607  0.163704
   13  2335.51  252.931  252.551  252.551  0.149959  0.150055
   14  2601.72  254.998  254.651  254.650  0.136197  0.136322
   15  2870.58  257.072  256.759  256.758  0.121385  0.121808
   16  3142.00  259.172  258.896  258.894  0.106531  0.107342
   17  3415.70  261.319  261.064  261.063  9.788871E-02  9.806156E-02
   18  3691.54  263.483  263.253  263.253  8.726120E-02  8.738041E-02
   19  3969.50  265.654  265.454  265.453  7.519722E-02  7.539392E-02
   20  4249.65  267.865  267.689  267.687  6.572604E-02  6.666183E-02
   21  4532.04  270.116  269.957  269.957  5.877018E-02  5.871654E-02
   22  4816.73  272.379  272.241  272.241  5.086660E-02  5.081296E-02
   23  5103.73  274.658  274.546  274.543  4.083514E-02  4.191995E-02
   24  5393.07  276.991  276.892  276.891  3.580451E-02  3.621578E-02
   25  5684.77  279.354  279.267  279.267  3.110170E-02  3.117919E-02
   26  5978.86  281.733  281.662  281.661  2.523065E-02  2.539158E-02
   27  6275.37  284.139  284.086  284.083  1.837611E-02  1.967549E-02
   28  6574.37  286.600  286.554  286.554  1.598001E-02  1.600385E-02
   29  6875.88  289.081  289.046  289.047  1.196861E-02  1.193881E-02
   30  7179.91  291.581  291.567  291.563  4.845858E-03  6.145239E-03
   31  7486.52  294.139  294.129  294.127  3.433228E-03  3.975630E-03
   32  7795.70  296.742  296.737  296.737  1.645088E-03  1.519918E-03
   33  8107.51  299.359  299.365  299.363 -1.764297E-03 -1.084805E-03
   34  8421.98  302.016  302.034  302.030 -5.984306E-03 -4.708767E-03
   35  8739.20  304.729  304.750  304.751 -6.866455E-03 -6.926060E-03
   36  9059.17  307.469  307.499  307.498 -9.787083E-03 -9.524822E-03
   37  9381.95  310.239  310.292  310.283 -1.685619E-02 -1.406670E-02
   38  9707.58  313.125  313.168  313.168 -1.373291E-02 -1.372099E-02
   39  10036.1  316.042  316.093  316.092 -1.598597E-02 -1.583099E-02
   40  10367.4  318.986  319.043  319.041 -1.772642E-02 -1.720190E-02
   41  10701.7  321.981  322.050  322.044 -2.127886E-02 -1.944304E-02
   42  11039.0  325.006  325.035  325.053 -9.071827E-03 -1.435280E-02
   43  11379.3  328.204  328.633  328.400 -0.130701 -5.961657E-02
   44  11722.7  333.798  333.929  333.880 -3.919601E-02 -2.462864E-02
   45  12069.3  340.371  340.431  340.435 -1.760721E-02 -1.873970E-02
   46  12419.3  347.182  347.257  347.252 -2.166033E-02 -2.014637E-02
   47  12772.7  354.273  354.342  354.341 -1.934767E-02 -1.902580E-02
   48  13129.6  361.628  361.698  361.698 -1.940727E-02 -1.928806E-02
   49  13489.7  369.260  369.332  369.332 -1.946688E-02 -1.944304E-02
   50  13853.3  377.165  377.238  377.238 -1.934767E-02 -1.924038E-02
   51  14220.2  385.386  385.457  385.458 -1.862049E-02 -1.864433E-02
   52  14590.8  393.920  393.992  393.992 -1.821518E-02 -1.823902E-02
   53  14965.4  402.787  402.859  402.859 -1.779795E-02 -1.780987E-02
   54  15343.7  412.025  412.095  412.095 -1.685619E-02 -1.685619E-02
   55  15725.9  421.640  421.705  421.705 -1.556873E-02 -1.559258E-02
   56  16112.4  431.666  431.731  431.730 -1.505613E-02 -1.485348E-02
   57  16505.0  442.114  442.175  442.175 -1.366138E-02 -1.372099E-02
   58  16905.2  453.037  453.090  453.090 -1.173019E-02 -1.173019E-02
   59  17314.9  464.453  464.500  464.500 -1.012087E-02 -1.012087E-02
   60  17737.6  476.391  476.430  476.430 -8.285046E-03 -8.320808E-03
   61  18175.1  488.898  488.937  488.937 -7.832050E-03 -7.879734E-03
   62  18627.8  502.020  502.049  502.048 -5.793571E-03 -5.674362E-03
   63  19096.9  515.795  515.814  515.818 -3.790855E-03 -4.506111E-03
   64  19583.5  530.258  530.321  530.290 -1.189709E-02 -5.996227E-03
   65  20088.6  545.924  546.055  545.976 -2.405643E-02 -9.632111E-03
   66  20613.3  563.262  563.261  563.263  8.940697E-05 -3.099442E-04
   67  21159.1  581.729  581.746  581.736 -3.075600E-03 -1.263618E-03
   68  21727.3  601.361  601.355  601.356  1.096725E-03  9.417534E-04
   69  22318.7  622.217  622.208  622.208  1.394749E-03  1.472235E-03
   70  22933.5  644.430  644.417  644.417  1.901388E-03  1.943111E-03
   71  23572.9  668.102  668.084  668.083  2.610683E-03  2.759695E-03
   72  24238.3  693.375  693.351  693.353  3.409386E-03  3.236532E-03
   73  24931.4  720.395  720.363  720.367  4.422665E-03  3.761053E-03
   74  25654.4  749.355  749.328  749.328  3.618002E-03  3.659725E-03
   75  26409.7  780.467  780.439  780.439  3.582239E-03  3.588200E-03
   76  27199.7  814.018  814.000  813.989  2.151728E-03  3.510714E-03
   77  28027.5  850.408  850.371  850.370  4.416704E-03  4.535913E-03
   78  28896.0  889.875  889.845  889.838  3.403425E-03  4.214048E-03
   79  29808.9  933.047  933.154  933.058 -1.152754E-02 -1.227856E-03
   80  30770.3  981.061  980.964  980.993  9.888411E-03  6.926060E-03
   81  31784.9  1033.90  1034.23  1033.99 -3.166199E-02 -8.368492E-03
   82  32858.5  1095.32  1095.96  1095.47 -5.815029E-02 -1.369715E-02
   83  33997.3  1168.73  1168.51  1168.57  1.865625E-02  1.308918E-02
   84  35208.6  1250.86  1250.77  1250.75  6.783009E-03  8.571148E-03
   85  36501.0  1343.68  1343.59  1343.56  6.425381E-03  8.887053E-03
   86  37884.9  1448.90  1448.78  1448.75  8.720160E-03  1.068115E-02
   87  39372.4  1569.56  1569.39  1569.36  1.073480E-02  1.275539E-02
   88  40978.4  1708.75  1708.55  1708.51  1.173615E-02  1.426339E-02
   89  42720.4  1871.17  1870.83  1870.82  1.820326E-02  1.873374E-02
   90  44620.4  2062.21  2061.71  2061.78  2.430677E-02  2.069473E-02
   91  46703.9  2283.06  2277.24  2280.72  0.254893  0.102401
   92  48992.8  2506.05  2500.00  2503.95  0.241381  8.381009E-02
   93  51499.4  2721.03  2720.71  2721.42  1.166463E-02 -1.416206E-02
   94  54234.6  2964.85  2963.27  2964.96  5.335808E-02 -3.778934E-03
   95  57232.6  3238.88  3241.07  3240.82 -6.774664E-02 -6.009340E-02
   96  60529.7  3571.98  3575.26  3574.76 -9.179115E-02 -7.790327E-02
   97  64160.1  4005.69  4010.73  4010.01 -0.125766 -0.107765
   98  68195.0  4582.83  4596.09  4591.55 -0.289488 -0.190389
   99  72760.0  5446.17  5463.86  5458.48 -0.324738 -0.226045
   100  78059.0  6909.91  6924.07  6928.13 -0.204837 -0.263631
 ------------------------------------------------------------
   
 successfully checked prfile .....
 **********************************************************************
 read in info for weighted set number   1
 the weights are : 
   1  1  0.000000
   2  2  0.000000
   3  3  0.000000
   4  4  0.000000
   5  5  0.000000
   6  6  0.000000
   7  7  0.000000
   8  22  0.000000
   9  101  0.000000
   10  102  0.000000
   11  103  0.000000
  
 successfully checked weight .....
 **********************************************************************
 Can set profile temp == CO2 temp!
 Using RTP file to set atm info ....
 RTP file says obs,upwell =   0.000000  1
 Code reinterprets this (along with surf press)
 as that for a downlook instr, with Surf,OBS press
 being   1013.25  0.000000
  
  
 downlook instr : satellite hgt, view angle info : 
 scanang, zobs(km), satzen, saconv(satzen,zobs) =   0.000000  705.000  0.000000  0.000000
 scanang,satzen,zobs present in rtp file
 scanang and saconv(satzen,zobs) agree
 using kCARTA scanang =   0.000000
  
 Reset pressure of top level to   5.000000E-03
 Downlooking instrument : Press, Layer, Frac
 START  1013.25  4  0.974980
 STOP   5.000000E-03  100  1.00000
 Atmosphere has   97  layers
 BC : Tspace,Sat angle =   2.70000  0.000000
 BC : Tsurface_Readin,TsurfaceAdjusted=   288.200  288.200
 Warning! Resetting Solar Angle from   150.000  to 150.0
 and setting kSolar from  -1  to -1 (solar = off)
 Solar on/off, Solar angle, Solar emiss =  -1  150.000 -1.00000
 Thermal on/off,Thermal angle,Thermal Jacob =  0 -1.00000  1
   769.231  0.976740
   800.000  0.982880
   833.333  0.988940
   869.565  0.991940
   909.091  0.992520
   952.381  0.991330
   1000.00  0.989120
   1041.67  0.987530
   1086.96  0.986270
   1136.36  0.985110
   1190.48  0.984010
   1250.00  0.983060
   2439.02  0.977600
   2500.00  0.977050
   2564.10  0.976400
   2631.58  0.975620
   2702.70  0.974510
   2777.78  0.973250
   2857.14  0.971510
   769.231  7.403906E-03
   800.000  5.449466E-03
   833.333  3.520507E-03
   869.565  2.565590E-03
   909.091  2.380966E-03
   952.381  2.759757E-03
   1000.00  3.463228E-03
   1041.67  3.969327E-03
   1086.96  4.370410E-03
   1136.36  4.739658E-03
   1190.48  5.089800E-03
   1250.00  5.392169E-03
   2439.02  7.130148E-03
   2500.00  7.305229E-03
   2564.10  7.512127E-03
   2631.58  7.760404E-03
   2702.70  8.113733E-03
   2777.78  8.514798E-03
   2857.14  9.068670E-03
 cfrac12 =  -9999.00
 cfrac1,cngwat1,ctype1,ctop1 =   0.000000  0.000000 -9999 -9999.00
 cfrac2,cngwat2,ctype2,ctop2 =   0.000000  0.000000 -9999 -9999.00
 iNclouds_RTP =   0
 Found 100 layer cloud(s) in rtp profile, set caCloudPFname = caPFname
 successfully checked radnce .....
  
 no scattering required .....
 **********************************************************************
 Will be substituting compressed files for   1  gases :   3
 successfully checked spectra .....
 **********************************************************************
 after checking *SCATTR, kWhichScatterCode =   0
 **********************************************************************
 **********************************************************************
 namelist file specified   1  total outputs 
 Output_number  OutOption(1/2/3)   Atm number
 Num of path/MP/rads to output (if -1, list all)
 Item      Type(1=path,2=MP,3=rad)      List
 ----------------------------------------------
         1               3               1           
 
 list of pressures (partial fractions)
   986.067 (  0.974980 )
   958.591 (  1.00000 )
   931.524 (  1.00000 )
   904.866 (  1.00000 )
   878.620 (  1.00000 )
   852.788 (  1.00000 )
   827.371 (  1.00000 )
   802.371 (  1.00000 )
   777.790 (  1.00000 )
   753.628 (  1.00000 )
   729.886 (  1.00000 )
   706.565 (  1.00000 )
   683.667 (  1.00000 )
   661.192 (  1.00000 )
   639.140 (  1.00000 )
   617.511 (  1.00000 )
   596.306 (  1.00000 )
   575.525 (  1.00000 )
   555.167 (  1.00000 )
   535.232 (  1.00000 )
   515.720 (  1.00000 )
   496.630 (  1.00000 )
   477.961 (  1.00000 )
   459.712 (  1.00000 )
   441.882 (  1.00000 )
   424.470 (  1.00000 )
   407.474 (  1.00000 )
   390.893 (  1.00000 )
   374.724 (  1.00000 )
   358.966 (  1.00000 )
   343.618 (  1.00000 )
   328.675 (  1.00000 )
   314.137 (  1.00000 )
   300.000 (  1.00000 )
   286.262 (  1.00000 )
   272.919 (  1.00000 )
   259.969 (  1.00000 )
   247.408 (  1.00000 )
   235.234 (  1.00000 )
   223.441 (  1.00000 )
   212.028 (  1.00000 )
   200.989 (  1.00000 )
   190.320 (  1.00000 )
   180.018 (  1.00000 )
   170.078 (  1.00000 )
   160.496 (  1.00000 )
   151.266 (  1.00000 )
   142.385 (  1.00000 )
   133.846 (  1.00000 )
   125.646 (  1.00000 )
   117.777 (  1.00000 )
   110.237 (  1.00000 )
   103.017 (  1.00000 )
   96.1138 (  1.00000 )
   89.5204 (  1.00000 )
   83.2310 (  1.00000 )
   77.2396 (  1.00000 )
   71.5398 (  1.00000 )
   66.1253 (  1.00000 )
   60.9895 (  1.00000 )
   56.1260 (  1.00000 )
   51.5278 (  1.00000 )
   47.1882 (  1.00000 )
   43.1001 (  1.00000 )
   39.2566 (  1.00000 )
   35.6505 (  1.00000 )
   32.2744 (  1.00000 )
   29.1210 (  1.00000 )
   26.1829 (  1.00000 )
   23.4526 (  1.00000 )
   20.9224 (  1.00000 )
   18.5847 (  1.00000 )
   16.4318 (  1.00000 )
   14.4559 (  1.00000 )
   12.6492 (  1.00000 )
   11.0038 (  1.00000 )
   9.51190 (  1.00000 )
   8.16550 (  1.00000 )
   6.95670 (  1.00000 )
   5.87760 (  1.00000 )
   4.92040 (  1.00000 )
   4.07700 (  1.00000 )
   3.33980 (  1.00000 )
   2.70090 (  1.00000 )
   2.15260 (  1.00000 )
   1.68720 (  1.00000 )
   1.29720 (  1.00000 )
   0.975300 (  1.00000 )
   0.714000 (  1.00000 )
   0.506400 (  1.00000 )
   0.345400 (  1.00000 )
   0.224400 (  1.00000 )
   0.137000 (  1.00000 )
   7.690000E-02 (  1.00000 )
   3.840000E-02 (  1.00000 )
   1.610000E-02 (  1.00000 )
   5.000000E-03 (  1.00000 )
  
 successfully checked output .....
 **********************************************************************
                  
 Input file successfully read in!!!!!
 with the following parameters .......
                  
 Number of gases to be used =   11
 Number of atm to be processed =   1
 Lower boundary temp =   1  288.200
 Boundaries are   4  100
 Frequencies are         980.000  1180.00
                  
      num         GAS ID            con/nocon
 --------------------------------------------
         1             1         Y
         2             2         N
         3             3         N
         4             4         N
         5             5         N
         6             6         N
         7             7         N
         8            22         N
         9           101         N
        10           102         N
        11           103         N
                  
 **********************************************************************
 WATER : Computing average ppmvs in lower trop between lays   5  15
 avg rWVMix =   5283.57  ppmv
  column amount water =   14.3476  mm
 CO2 : Computing average ppmvs in lower trop between lays   20  80
 avg rCO2Mix =   369.824  ppmv
 O3 : Computing average ppmvs in lower trop between lays   40  70
 avg rO3Mix =   1.28999  ppmv
  column amount ozone =   345.188  du
 N2O/CO/CH4 : Computing average ppmvs in lower trop between lays   20  80
 avg rN2OMix =   0.272174  ppmv
 avg rCOMix =   6.544380E-02  ppmv
 avg rCH4Mix =   1.58948  ppmv
 assumed fracBot =   0.974980  0.974980
  
 iJ p(database) p(klayers) frac_delta +++ pav(database) pav(klayers) frac_delta
  4 1013.94800 1013.94800 .42137E-06 +++  999.94293  999.94421 .12818E-05
  5  986.06660  986.06660 .00000E+00 +++  972.26464  972.26464 .00000E+00
  6  958.59112  958.59112 .00000E+00 +++  944.99200  944.99200 .00000E+00
  7  931.52362  931.52362 .00000E+00 +++  918.12950  918.12950 .00000E+00
  8  904.86590  904.86590 .00000E+00 +++  891.67913  891.67913 .00000E+00
  9  878.62011  878.62011 .00000E+00 +++  865.64044  865.64044 .00000E+00
 10  852.78802  852.78802 .00000E+00 +++  840.01574  840.01574 .00000E+00
 11  827.37130  827.37130 .00000E+00 +++  814.80731  814.80731 .00000E+00
 12  802.37140  802.37140 .00000E+00 +++  790.01544  790.01544 .00000E+00
 13  777.78970  777.78970 .00000E+00 +++  765.64642  765.64642 .00000E+00
 14  753.62750  753.62750 .00000E+00 +++  741.69270  741.69270 .00000E+00
 15  729.88570  729.88570 .00000E+00 +++  718.16174  718.16174 .00000E+00
 16  706.56542  706.56542 .00000E+00 +++  695.05460  695.05460 .00000E+00
 17  683.66730  683.66730 .00000E+00 +++  672.36724  672.36724 .00000E+00
 18  661.19201  661.19201 .00000E+00 +++  650.10410  650.10410 .00000E+00
 19  639.13980  639.13980 .00000E+00 +++  628.26312  628.26312 .00000E+00
 20  617.51123  617.51123 .00000E+00 +++  606.84720  606.84720 .00000E+00
 21  596.30621  596.30621 .00000E+00 +++  585.85500  585.85500 .00000E+00
 22  575.52480  575.52480 .00000E+00 +++  565.28533  565.28533 .00000E+00
 23  555.16690  555.16690 .00000E+00 +++  545.13920  545.13920 .00000E+00
 24  535.23220  535.23220 .00000E+00 +++  525.41580  525.41580 .00000E+00
 25  515.72000  515.72000 .00000E+00 +++  506.11420  506.11420 .00000E+00
 26  496.62980  496.62980 .00000E+00 +++  487.23600  487.23600 .00000E+00
 27  477.96070  477.96070 .00000E+00 +++  468.77640  468.77640 .00000E+00
 28  459.71180  459.71180 .00000E+00 +++  450.73754  450.73754 .00000E+00
 29  441.88190  441.88190 .00000E+00 +++  433.11724  433.11724 .00000E+00
 30  424.46980  424.46980 .00000E+00 +++  415.91440  415.91440 .00000E+00
 31  407.47380  407.47380 .00000E+00 +++  399.12610  399.12610 .00000E+00
 32  390.89260  390.89260 .00000E+00 +++  382.75140  382.75140 .00000E+00
 33  374.72410  374.72410 .00000E+00 +++  366.78870  366.78870 .00000E+00
 34  358.96650  358.96650 .00000E+00 +++  351.23651  351.23651 .00000E+00
 35  343.61761  343.61761 .00000E+00 +++  336.09120  336.09120 .00000E+00
 36  328.67530  328.67530 .00000E+00 +++  321.35162  321.35162 .00000E+00
 37  314.13690  314.13690 .00000E+00 +++  307.01452  307.01452 .00000E+00
 38  300.00000  300.00000 .00000E+00 +++  293.07740  293.07740 .00000E+00
 39  286.26170  286.26170 .00000E+00 +++  279.53732  279.53732 .00000E+00
 40  272.91910  272.91910 .00000E+00 +++  266.39181  266.39181 .00000E+00
 41  259.96910  259.96910 .00000E+00 +++  253.63710  253.63710 .00000E+00
 42  247.40850  247.40850 .00000E+00 +++  241.26971  241.26971 .00000E+00
 43  235.23380  235.23380 .00000E+00 +++  229.28723  229.28723 .00000E+00
 44  223.44150  223.44150 .00000E+00 +++  217.68460  217.68460 .00000E+00
 45  212.02770  212.02770 .00000E+00 +++  206.45890  206.45890 .00000E+00
 46  200.98870  200.98870 .00000E+00 +++  195.60603  195.60603 .00000E+00
 47  190.32030  190.32030 .00000E+00 +++  185.12164  185.12164 .00000E+00
 48  180.01830  180.01830 .00000E+00 +++  175.00120  175.00120 .00000E+00
 49  170.07840  170.07840 .00000E+00 +++  165.24081  165.24081 .00000E+00
 50  160.49590  160.49590 .00000E+00 +++  155.83570  155.83570 .00000E+00
 51  151.26640  151.26640 .00000E+00 +++  146.78091  146.78091 .00000E+00
 52  142.38480  142.38480 .00000E+00 +++  138.07153  138.07153 .00000E+00
 53  133.84620  133.84620 .00000E+00 +++  129.70262  129.70262 .00000E+00
 54  125.64560  125.64560 .00000E+00 +++  121.66921  121.66921 .00000E+00
 55  117.77750  117.77750 .00000E+00 +++  113.96543  113.96543 .00000E+00
 56  110.23660  110.23660 .00000E+00 +++  106.58623  106.58623 .00000E+00
 57  103.01720  103.01720 .00000E+00 +++   99.52557   99.52557 .00000E+00
 58   96.11380   96.11380 .00000E+00 +++   92.77802   92.77802 .00000E+00
 59   89.52040   89.52040 .00000E+00 +++   86.33752   86.33752 .00000E+00
 60   83.23100   83.23100 .00000E+00 +++   80.19804   80.19804 .00000E+00
 61   77.23960   77.23960 .00000E+00 +++   74.35335   74.35335 .00000E+00
 62   71.53980   71.53980 .00000E+00 +++   68.79707   68.79707 .00000E+00
 63   66.12530   66.12530 .00000E+00 +++   63.52282   63.52282 .00000E+00
 64   60.98950   60.98950 .00000E+00 +++   58.52406   58.52406 .00000E+00
 65   56.12600   56.12600 .00000E+00 +++   53.79416   53.79416 .00000E+00
 66   51.52780   51.52780 .00000E+00 +++   49.32619   49.32619 .00000E+00
 67   47.18820   47.18820 .00000E+00 +++   45.11330   45.11330 .00000E+00
 68   43.10010   43.10010 .00000E+00 +++   41.14843   41.14843 .00000E+00
 69   39.25660   39.25660 .00000E+00 +++   37.42462   37.42462 .00000E+00
 70   35.65050   35.65050 .00000E+00 +++   33.93448   33.93448 .00000E+00
 71   32.27440   32.27440 .00000E+00 +++   30.67070   30.67070 .00000E+00
 72   29.12100   29.12100 .00000E+00 +++   27.62593   27.62593 .00000E+00
 73   26.18290   26.18290 .00000E+00 +++   24.79269   24.79269 .00000E+00
 74   23.45260   23.45260 .00000E+00 +++   22.16344   22.16344 .00000E+00
 75   20.92240   20.92240 .00000E+00 +++   19.73047   19.73047 .00000E+00
 76   18.58470   18.58470 .00000E+00 +++   17.48616   17.48616 .00000E+00
 77   16.43180   16.43180 .00000E+00 +++   15.42275   15.42275 .00000E+00
 78   14.45590   14.45590 .00000E+00 +++   13.53246   13.53246 .00000E+00
 79   12.64920   12.64920 .00000E+00 +++   11.80740   11.80740 .00000E+00
 80   11.00380   11.00380 .00000E+00 +++   10.23974   10.23974 .00000E+00
 81    9.51190    9.51190 .00000E+00 +++    8.82158    8.82158 .00000E+00
 82    8.16550    8.16550 .00000E+00 +++    7.54497    7.54497 .00000E+00
 83    6.95670    6.95670 .00000E+00 +++    6.40200    6.40200 .00000E+00
 84    5.87760    5.87760 .00000E+00 +++    5.38483    5.38483 .00000E+00
 85    4.92040    4.92040 .00000E+00 +++    4.48549    4.48549 .00000E+00
 86    4.07700    4.07700 .00000E+00 +++    3.69616    3.69616 .00000E+00
 87    3.33980    3.33980 .00000E+00 +++    3.00905    3.00905 .00000E+00
 88    2.70090    2.70090 .00000E+00 +++    2.41639    2.41639 .00000E+00
 89    2.15260    2.15260 .00000E+00 +++    1.91046    1.91046 .00000E+00
 90    1.68720    1.68720 .00000E+00 +++    1.48367    1.48367 .00000E+00
 91    1.29720    1.29720 .00000E+00 +++    1.12861    1.12861 .00000E+00
 92    0.97530    0.97530 .00000E+00 +++    0.83787    0.83787 .00000E+00
 93    0.71400    0.71400 .00000E+00 +++    0.60427    0.60427 .00000E+00
 94    0.50640    0.50640 .00000E+00 +++    0.42078    0.42078 .00000E+00
 95    0.34540    0.34540 .00000E+00 +++    0.28056    0.28056 .00000E+00
 96    0.22440    0.22440 .00000E+00 +++    0.17712    0.17712 .00000E+00
 97    0.13700    0.13700 .00000E+00 +++    0.10407    0.10407 .00000E+00
 98    0.07690    0.07690 .00000E+00 +++    0.05544    0.05544 .00000E+00
 99    0.03840    0.03840 .00000E+00 +++    0.02565    0.02565 .00000E+00
100    0.01610    0.01610 .00000E+00 +++    0.00949    0.00949 .00000E+00
 difference between kCARTA database and klayers ...
   can use kCARTA database levels for lower atm
 MinDiff, MaxDiff, i(MaxDiff), Press(i(MaxDiff)), Sum(abs(diff))/Numlayers = 
   0.000000  4.213688E-07  4  1013.95  4.344009E-09
 iSplineType =   2  fast : use 
 database (pavglayers,abscoeeff) for temp interp
 as presslevel scheme of klayers = kCARTA database!!
   note abscoeff = optical depth/gas amount
 **********************************************************************
 Successfully read in user file ....
 **********************************************************************
 num of mixed paths =   100
 Gas number   2  is CO2!!
 Fatal Error found : closing all units ..
 bad luck ... emergency exit!
