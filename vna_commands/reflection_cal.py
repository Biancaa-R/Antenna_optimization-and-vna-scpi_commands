from rohdeschwarz.instruments.vna import Vna
import time
# Connect
vna = Vna()
vna.open_tcp()
vna.write(':SYST:DISP:UPD ON') 

vna.write("CORR:COLL:METH:DEF 'Test1',RSHort,1 ")  
vna.write('CORR:COLL:SEL SHOR,1 ') #calibration sweep
vna.write('CORR:COLL:SAVE:SEL ')
time.sleep(300)
#Define a reflection normalization with a Short standard at port 1, perform the 
#calibration sweep, and apply the calibration to the active channel. 
vna.write("CORR:COLL:METH:DEF 'Test2',REFL,1   ")
vna.write("CORR:COLL:SEL OPEN,1")
vna.write('CORR:COLL:SAVE:SEL') 
#Define a reflection normalization with an Open standard at port 2, perform the 
#calibration sweep, and apply the calibration to the active channel. 
vna.query('CORRection:DATA:PARameter1? TYPE ')
#Query the calibration type of the first calibration. The response is RSH. 
vna.query('CORRection:DATA:PARameter2? TYPE') 
#Query the calibration type of the second calibration. The response is REFL. 
vna.query('CORRection:DATA:PARameter:COUNt? ')
#Query the number of active calibrations. The response is 2. 

# REFL 
# RSH 
# Refl Norm Open 
# Refl Norm Short 