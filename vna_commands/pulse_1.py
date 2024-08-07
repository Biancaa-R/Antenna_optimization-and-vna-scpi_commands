from rohdeschwarz.instruments.vna import Vna

# Connect
vna = Vna()
vna.open_tcp()
vna.write('SENS1:PUL:GEN1:TR:DA')
#gen number
# 1 for pulse generator, 2 for sync 
vna.write('SENS1:PUL:GEN1:PER125NS')
vna.query('SENS1:PUL:GEN1:TR:SEGM:CO?')
#Pulse train segment number. This suffix is ignored; the command counts all segments. 
seg=1
scpi='SENS1:PUL:GEN1:TR:SEGM{}:ST5'
vna.write(scpi.format(seg))
'''Parameters SINGle – Single pulse 
CHIGh – Constant high 
CLOW – Constant low 
TRAin – Pulse train (available for pulse generator signal only, <gen_no> = 1)'''

vna.write('SEN1:PUL:GEN1:TYTR')

vna.write('SENS1:PUL:GEN1:TR:SEGM[:STE]OFF')
vna.write('SENS1:PUL:GEN1:TR:DELE:ALL')

'''Range [def. 
unit] 
12.5 ns to 54975.5813632 s [s]. The minimum width of a pulse is 12.5 ns, its 
maximum width is given by the pulse train period 
([SEN<CH>:]PUL:GEN<GEN_NO>:TR:PER).'''
