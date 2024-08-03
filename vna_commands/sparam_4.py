#calculation of all the s parameters 
import time
import pyvisa

timeout=30000
address='GPIB0::6::INSTR'
with pyvisa.ResourceManager('@py').open_resource(address) as vna:
    vna.timeout = timeout # Set time out duration in ms
    vna.clear()
    vna.write(':SYSTem:DISPlay:UPDate ON') # display in the screen updates while in remote control
    # Reset the instrument, add diagram areas no. 2, 3, 4. 
    vna.write('*RST; :DISPlay:WINDow2:STATe ON') 
    vna.write('DISPlay:WINDow3:STATe ON') 
    vna.write('DISPlay:WINDow4:STATe ON')

    time.sleep(100)

    # Assign the reflection parameter S11 to the default trace. 
    vna.write_str_with_opc(":CALCulate1:PARameter:MEASure 'Trc1', 'S11' ")
    #Assign the remaining S-parameters to new traces Trc2, Trc3, Tr4; 

    vna.write('CALCulate1:FORMat SMITh')
    time.sleep(10) 
    vna.write_str_with_opc("CALCulate1:PARameter:SDEFine 'Trc2', 'S21'") 
    vna.write_str_with_opc("CALCulate1:PARameter:SDEFine 'Trc3', 'S12' ")
    vna.write_str_with_opc("CALCulate1:PARameter:SDEFine 'Trc4', 'S22'")
    vna.write('CALCulate1:FORMat SMITh')     
    time.sleep(10) 

    vna.write("DISPlay:WINDow2:TRACe2:FEED 'Trc2'")
    vna.write("DISPlay:WINDow3:TRACe3:FEED 'Trc3' ")
    vna.write("DISPlay:WINDow4:TRACe4:FEED 'Trc4' ")

    vna.write('SYSTem:DISPlay:UPDate ONCE')
    #shouldnt be necessary