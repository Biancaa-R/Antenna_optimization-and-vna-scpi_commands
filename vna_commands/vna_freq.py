"""
@author: Ziad (zi.hatab@gmail.com)
Script to log trace data from R&S ZNA. The scrip also allow you to collect as many sweeps you want.

The SCPI commands are found on the manual guide of ZNA:
"ZNA_UserManual_en_31.pdf"
https://www.rohde-schwarz.com/manual/zna/
"""
 
import pyvisa
'''
to install pyvisa 
python -m pip install -U pyvisa

Also, you need the backend for pyvisa
python -m pip install -U pyvisa-py

You can read more from here: https://pyvisa.readthedocs.io/en/latest/introduction/getting.html
'''
import numpy as np  # python -m pip install numpy

import time
from datetime import timedelta

def read_traces(address='GPIB0::6::INSTR', num_sweeps=1, 
                channels=[1], timeout=30000, turn_fact_cal_off=None):
    '''
    Read the traces from the VNA.
    
    Parameters
    ----------
    address : str
        The address of the VNA. This can TCP (ethernet) or GPIB. 
        The default is 'GPIB0::6::INSTR'.
    channels : list of int
        The channels to read. The default is [1].
    timeout : int
        The timeout in ms. The default is 30000.
        Returns
    turn_fact_cal_off : boolean
        Turn the factory calibration off. 
        Necessary to turn it off if you doing calibration outside the VNA via Python
    -------
    frequencies : list of ndarray
        array containing the frequency.
    measurements : list of ndarray
        array containing all sweeps of the traces on the selected channels. Index style [channel, sweep, freq, rx-port, tx-port]
    trace_definitions : list of list
        list containing the definition of the measured traces. Index style [channel].
    '''

    channels = np.atleast_1d(channels)
    with pyvisa.ResourceManager('@py').open_resource(address) as vna:
        vna.timeout = timeout # Set time out duration in ms
        vna.clear()
        vna.write(':SYSTem:DISPlay:UPDate ON') # display in the screen updates while in remote control
        
        if turn_fact_cal_off:
            num_ports = int( vna.query_ascii_values('INST:PORT:COUN?', converter='s', separator='\n')[0] )
            #getting the output response back from ascii to string response
            backup_port_access_status = []
            for p in range(num_ports):
                backup_port_access_status.append( vna.query_ascii_values(f'PATH{p+1}:MEASurement:DIRectaccess?', converter='s', separator='\n')[0] )
                vna.write(f'PATH{p+1}:DIRectaccess B16')
            
        frequencies = []
        measurements = []
        trace_definitions = []    
        
        # go through the selected channels
        for ch in channels:
            # get number of traces on selected channel
            trace_names_and_defs = vna.query_ascii_values(f'CALCulate{ch}:PARameter:CATalog?', converter='s', separator='\n')[0][1:-1].split(',')
            trace_names = trace_names_and_defs[::2]
            trace_defs = trace_names_and_defs[1::2]
            
            vna.write(f':INITiate{ch}:CONTinuous OFF') # hold sweep
            vna.write(f':INITiate{ch}:IMMediate:SCOPe SINGle') # select channel to sweep
                    
            # collect sweep measurements
            meas = []
            tic_total = time.time()
            print(f'Sweep started on channel {ch}:')
            try:
                for sweep in range(num_sweeps):  # number of sweeps
                    vna.write(f':INITiate{ch}:IMMediate; *WAI') # run single sweep and wait until finished
                    all_data = []
                    tic = time.time()
                    for trace_name in trace_names:
                        vna.write(f':CALCulate{ch}:PARameter:SELect {trace_name}')  # select active trace
                        data = vna.query_ascii_values(f':CALCulate{ch}:DATA? SDATa', container=np.array).reshape((-1,2))
                        data = data[:,0] + data[:,1]*1j   # construct back to complex number
                        all_data.append(data)
                    toc = time.time()
                    swp_time = toc-tic
                    remain_time = timedelta(seconds=(num_sweeps-sweep-1)*swp_time)
                    print(f'Sweep {sweep+1:0{len(str(num_sweeps))}d}/{num_sweeps} (sweep time {swp_time:.2f} sec) [est. remaining time: {remain_time}]')
                    meas.append(all_data)
            except KeyboardInterrupt:
                print('Sweep Canceled!!!')
            toc_total = time.time()
            print(f'Total sweep time {toc_total-tic_total:.2f} sec\n')

            meas = np.array(meas)
            f = vna.query_ascii_values(f'CALCulate{ch}:DATA:STIMulus?', container=np.array) # get frequency (x-axis)
            
            frequencies.append(f)
            measurements.append(meas)
            trace_definitions.append(trace_defs)
            
            vna.write(f':INITiate{ch}:CONTinuous ON') # resume sweep in continues mode

        # turn the fact cal back on if turned off
        if turn_fact_cal_off:
            for p, p_access in enumerate(backup_port_access_status):
                vna.write(f'PATH{p+1}:DIRectaccess {p_access}')

        vna.write('SYSTem:DISPlay:UPDate ONCE') # go to local

    return frequencies, measurements, trace_definitions


if __name__=='__main__':
    frequencies, measurements, trace_definitions = read_traces(address='TCPIP::192.168.0.82::INSTR', num_sweeps=10
                                                               , turn_fact_cal_off=True)

#