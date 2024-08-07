#calculation of all the s parameters 
import time
import pyvisa

timeout=30000
address='GPIB0::6::INSTR'
with pyvisa.ResourceManager('@py').open_resource(address) as vna:
    vna.timeout = timeout # Set time out duration in ms
    vna.clear()

    vna.write(':SYSTEM:DISPLAY:UPDATE ON' )

:SENSE:CORRECTION:CKIT:N50:SELECT  'ZV-Z121' 

# Select connectors for the ports 
:SENSE1:CORRECTION:COLLECT:CONNECTION1 N50MALE 
:SENSE1:CORRECTION:COLLECT:CONNECTION2 N50MALE 
// 
// 
// Full one port = OSM 
// Select cal procedure 
:SENSe1:CORRection:COLLect:METHod:DEFine     'Test SFK OSM 1', FOPORT, 1 
// 
// Measure Standards 
:SENSe1:CORRection:COLLect:ACQuire:SELected  OPEN,  1 
:SENSe1:CORRection:COLLect:ACQuire:SELected  SHORT, 1 
:SENSe1:CORRection:COLLect:ACQuire:SELected  MATCH, 1 
// 
// Apply cal, activate enhanced wave calibration and load match correction in addition 
:SENSe1:CORRection:COLLect:SAVE:SELected 
:SENSe1:CORRection:EWAVe:STATe ON 
// 
// 
// 2 port TOSM 
// Select cal procedure 
:SENSe1:CORRection:COLLect:METHod:DEFine     'Test SFK TOSM 12', TOSM, 1, 2 
// 
// Measure Standards 
:SENSe1:CORRection:COLLect:ACQuire:SELected  THROUGH, 1, 2 
:SENSe1:CORRection:COLLect:ACQuire:SELected  OPEN,  1 
:SENSe1:CORRection:COLLect:ACQuire:SELected  SHORT, 1 
:SENSe1:CORRection:COLLect:ACQuire:SELected  MATCH, 1 
:SENSe1:CORRection:COLLect:ACQuire:SELected  OPEN,  2 
:SENSe1:CORRection:COLLect:ACQuire:SELected  SHORT, 2 
:SENSe1:CORRection:COLLect:ACQuire:SELected  MATCH, 2 
// 
// Apply calibration 
:SENSe1:CORRection:COLLect:SAVE:SELected 
// 
// Save / load cal files 
// Save calibration in calibration file pool in directory 
// NWA_USER_DIR\Calibration\Data 

// the file name in the commands must not contain the path ! 
:MMEMORY:STORE:CORRection 1, 'OSM1 TOSM12.cal' 
// 
// load cal file from calibration file pool 
:MMEMORY:LOAD:CORRection  1, 'OSM1 TOSM12.cal' 