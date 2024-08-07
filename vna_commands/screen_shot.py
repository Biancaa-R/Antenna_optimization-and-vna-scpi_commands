from rohdeschwarz.instruments.vna import Vna

# Connect
vna = Vna()
vna.open_tcp()

temp_filename  = 'temp.png'
local_filename = 'screenshot.png'

scpi = ":MMEM:NAME '{0}'"
scpi = scpi.format(temp_filename)
vna.write(scpi)

# Set format
# Options include:
# - BMP
# - PNG
# - JPG
# - PDF
# - SVG
vna.write(":HCOP:DEV:LANG PNG")

# Set contents of screenshot
# to entire screen
vna.write(":HCOP:PAGE:WIND HARD")

# - OR -------------------------
# Set active diagram

diagram = 1
scpi    = "DISP:WIND{0}:MAX 0"
scpi    = scpi.format(diagram)
vna.write(scpi)

# Set contents of screenshot
# to active diagram
scpi    = ":HCOP:PAGE:WIND ACT"
#hard copy of the page in active diagram region
vna.write(scpi)
# ------------------------------

# Set destination to file
vna.write("HCOP:DEST 'MMEM'")

# Save file
# Wait for save to complete
vna.write(":HCOP")
vna.query("*OPC?")

# Copy screenshot off vna
# (See file_transfer.py for details)
vna.file.download_file(temp_filename, local_filename)

# Delete temp file off vna
# Wait for delete to complete
scpi = "MMEM:DEL '{0}'"
scpi = scpi.format(temp_filename)
vna.write(scpi)
vna.query("*OPC?")

vna.close()