# Handy tool for generating a harmonic series above a given root,
# and then rounding out to the nearest 12-TET semitone.

# owmtxy, 2013
# python v.2.7.5

import math

root = input("Root frequency: ")
length = input("Spectra length: ")
freqSpectra = []
noteSpectra = []

# Write out to a .txt
file = open('harmonic_spectra_'+str(root)+'Hz.txt', 'w')

# Define note names
noteName = [
    'C', 'C#', 'D', 'D#', 'E', 'F',
    'F#', 'G', 'G#', 'A', 'A#', 'B']

### convert freq to pitch method (inc octaves)
def freq2pitch(freq):
    pitch = 12 * math.log(freq/261.626) / math.log(2) #calculate relative to middle C4
    note = noteName[int(round(pitch)) % 12] #get name
    octave = (int(round(pitch)) / 12)+4 #get octave, offset from C(4)
    return str(note + str(octave)) # no. semitones relative to C4

for i in range(1,length+1): #give >length< partials above root
    freqSpectra.append(root*i)
    noteSpectra.append(freq2pitch(root*i))
    
# print out data to .txt      
print('Spectra as frequency (Hz) / closest note:')
file.write('Partial \t Freq \t Note \n')
for i in range(length):
    txt = str(i+1)+"\t"+str(freqSpectra[i])+"\t"+str(noteSpectra[i])+"\n"
    print i+1, "\t",freqSpectra[i], "\t", noteSpectra[i]
    file.write(txt)

file.close()

