Synthf Setup Wizard
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// Preferably do not use Headphones, protect your ears. Also localization is mainly wavefield, not binaural, so stereo loudspeakers  as output is recommended.
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////for latest synthf 'vf' Mathlib is required

~download and install SuperCollider  https://supercollider.github.io

~project synthf builds against SuperCollider 3.13.0, but you may install the latest build

//////////////////////////////////// if you install any of the builds on folders: sculpture, wavefield, multichannel expansion, compiling also Mathlib to SuperCollider is required

~MathLib library Quark is required, make sure your pc has access to quarks, install git for mac and similarly for windows. Install MathLib by selecting on the SuperCollider IDE options panel Language then Quarks and look for MathLib, after installing it close and reopen SuperCollider. Synthf will not execute if MathLib is not installed and compiled.

////////////////////////////////////////////////////for startup.scd Mathlib is not required/

~download startup.scd and image1.jpg or choose an image of your own liking to load to the gui interface

~find SuperCollider startup.scd file in SuperCollider file in User Library, APPDATA on Windows, Application Support on Mac

~open startup.scd and paste on the writing environment of SuperCollider, the content of startup.scd from this repository 

~on this line in the file ~img_print = Image.open("/home/pi/Desktop/synth/image1.jpg");///////////////paste image image1.jpg , delete the content of the parentheses and copy paste or drag and drop in the parentheses image1.jpg from your location. You should see in the parentheses only the new file path in ""

~save startup.scd and overwrite the existing startup file

~close SuperCollider and reopen it, now it will open along with synthf and the sound engine running

~terminate the synth either by closing SuperCollider or quiting the server from the small rectangular server window 

~audio knobs on the left panel of the gui interface are clockwise 0 to 9 with 0 being 11o clock. 0 and 1 are quantized tone variation in complex relation and localization (azimuth and elevation rotational limits), 2 is reverb mix and overdrive, 3 is tonal range, 4 is rectifier drive, 5 is envelope attack, 6 is scale tonal range, 7 is tempered fundamental from sub low to mid/high, 8 is decay and 9 tempo.

~control knobs on the right panel of the gui interface are in series from left to right gain, compressor wavelength size, lowend cutt, reverb room size, rectifier bridge harmonic

~this synthf build has bo limiters, clips or crash prohibiting 'if' statements, on control interface or synth definition. Therefore follow the below warnings and instructions:

~if turning tempo to max, preferably do not set max long attack and decay at the same time so the server does not crash. If the sever crashes quickly turn tempo and decay to low, so as to end the crash, or close SuperCollider

~if you set extreme value combinations, especially at high frequencies, that will crash the synth sound but not the server, just return knobs to normal and the sound will normalize. 

~CAUTION in setting fundamental, tonal range and drive high at the same time: Nyquist crash. Also very low/sub fundamental will slow cook speaker driver coils, especially at hight tonal range. If unsure on speaker system dynamic range or speaker wattage do not set gain too high at very low pitch or drive at very high pitch and use low values on the compressor knob as well as high values on the lowcutt knob.

~synthf output is 3*spat independent channels of audio and 1024 possible localizations, or pixel count possible localizations in case of loading image as audio data seed (image to sound folder). According to audio interface, n channels are audible, at full range, or more if you clone the synth, eg. laptop orchestra setup.

~system runs on windows pc, mac, linux and or raspberry pi 5

 ///////////////////////////////////////////////////////////////////IMAGE TO SOUND

~on this file you can find a synthf startup file, at which you can load different images as timbre,spat and rhythm information source for the synth.

~On that build the same image that is used for the timbre, is used for tonal information

~Image on interface can be normal size. Image for sound must be resized to 100x100 pixels or less, before loading it into the buffer.

~same instructions apply as in no image to sound startup file, only difference image has to be loaded also to a second buffer (line bellow the first one). 

~Programm needs more time to load cause of image sonification.

~in case of interpreter crash (rare case if you load to many image synth clones, or run the code many times on the same server instance), terminate scsynth from activity monitor



///////////////////////////////////////Raspberry:

~ install jack

~ install SuperCollider

~ save synthf as startupfile at directory home/usr/config/SuperCollider, and load image as mentioned above.

~start jack with prefered Audio Interface

~start SuperCollider

~ adjust window size in sc or screen resolution. Window size is 700-1200px by default 



/////////////////////////////////////////////////// kanal.scd and last startup.scd synthf spat wavefield architecture update

~ audible n(3) * spat channels
every localization vector source is three speakers (three channels xyz) wavefiled. These threefold sets can be spatialized in triangle configuration on a geodesic setup. Eg. a geodesic octahedron (order 2) 4 triangles per side (18 vertices,32 faces),  https://en.wikipedia.org/wiki/List_of_geodesic_polyhedra_and_Goldberg_polyhedra#/media/File%3ATetrakis_cuboctahedron.png,  could host max 5 (simplex) independent static spat sources, or 5(4) sources on an interchanging multichannel expansion (panned) on 32 virtual source sets.

First proof of concept 'Geodesic Octahedron' InSonic 2015

///if the intention is to use stereo sets instead of 3d wavefield sources, leave z channel unpluged and output only sets of x,y channel pairs. eg [0,1,3,4] for stereo 2d wavefield
//////////////

////////////

//////////////////



///////////////vfs synth on vf folder is a more complex synth

it utilizes a more comlex musical sequencers, two synth instrument instances, wavefield and spat compression
,different settings according to code variation, and other like inteference collision between the two instrument instances and the melodic variation.

Knobs are as follows:

tempo: temoclock of sequencer, slow to fast (1/16)

rz: rotation of timbral information tensor around the z axis, slow to fast

s_range: tonal range of scale tone factor (dorian or other, Scale.directory)

t_range: tonal range of temperament (16256 cents per octave)

overdrive: rectifier distortion range, low to high

drive: oscilator resonance filter, sine to saw

comp: compressor setting, high lowend cutt on small speaker to low and large

attack: percussve envelope  attacek time

decay: percussve decay  attacek time

rx: rotation of timbral information tensor around the x axis, slow to fast

ry: rotation of timbral information tensor around the y axis, slow to fast

fund: fundamental frequency scaler, octave temperament on power of two * 9/8

gain: total amp level (envelope)

revroom: reverb room size, none to large

revmix: reverb wet mix and softclip gain, low to high

fuse1: coordinates of timbral data tensor, fuse to less coordinates (interferance collision)

fuse2: coordinates of timbral data tensor, fuse to less coordinates, (fuse to one coordinate if fuse1 is max)

fuse: pan speed for spat

harm: spherical harmonic on timbral data tensor and cardioid

dist: perspective distance (extreme fisheye to fronal isometric perspective)
