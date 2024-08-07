from rohdeschwarz.instruments.vna import Vna

# Connect
vna = Vna()
vna.open_tcp()
vna.write('[SENSe1:]PULSe:GENerator1:TRAin:DATA ')
#gen number
# 1 for pulse generator, 2 for sync 
vna.write('[SENSe1:]PULSe:GENerator1:PERiod 12.5ns' )
vna.query('[SENSe1:]PULSe:GENerator1:TRAin:SEGMent:COUNt? ')
#Pulse train segment number. This suffix is ignored; the command counts all segments. 
seg=1
scpi='[SENSe1:]PULSe:GENerator1:TRAin:SEGMent{}:STARt 5 '
vna.write(scpi.format(seg))
'''Parameters SINGle – Single pulse 
CHIGh – Constant high 
CLOW – Constant low 
TRAin – Pulse train (available for pulse generator signal only, <gen_no> = 1)'''

vna.write('[SENSe1:]PULSe:GENerator1:TYPE TRAin')

vna.write('[SENSe1:]PULSe:GENerator1:TRAin:SEGMent[:STATe]OFF')
vna.write('[SENSe1:]PULSe:GENerator1:TRAin:DELete:ALL ')

'''Range [def. 
unit] 
12.5 ns to 54975.5813632 s [s]. The minimum width of a pulse is 12.5 ns, its 
maximum width is given by the pulse train period 
([SENSe<Ch>:]PULSe:GENerator<gen_no>:TRAin:PERiod).   '''