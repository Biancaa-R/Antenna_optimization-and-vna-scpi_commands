#The diagram area in a VNA typically refers to the graphical display where measurement results such as S-parameters (scattering parameters) are plotted.
from rohdeschwarz.instruments.vna import Vna

# Connect
vna = Vna()
vna.open_tcp()
vna.write('DISP:RFS 80')
vna.write(':DISP:WIND:TRAC:X:OFFS 1MHZ; ')
#display window trace offset x axis
vna.query('DISP:WIND:TRAC:Y:OFFS? ')
#Querying all the traces
vna.write("CALC4:PAR:SDEF 'Ch4Tr1', 'S11' ")
# Create channel 4 and a trace named Ch4Tr1 to measure the input reflection 
# coefficient S11. 
vna.write('DISP:WIND2:STAT ON ')
#Create diagram area no. 2. 
vna.write("DISP:WIND2:TRAC9:FEED 'CH4TR1' ")
# Display the generated trace in diagram area no. 2, assigning the trace number 
# 9 to it. 
vna.write('DISP:WIND2:TRAC9:Y:RLEV -10  ')
# # DISP:WIND2:TRAC9:Y:RLEV -10  
# # or: DISP:WIND2:TRAC:Y:RLEV -10, 'CH4TR1' 
# Change the reference level to –10 dB. 
