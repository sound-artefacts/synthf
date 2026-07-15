///Quarks.install("MathLib");
(
(
s.options.numWireBufs = 1024*16;
s.options.numOutputBusChannels=9;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*256;
s.options.blockSize = 64;
s.options.maxNodes = 8192*2;
Buffer.freeAll;
Window.closeAll;
s.makeGui(w);
//s.meter;
//s.freqscope;
//s.scope;
);
~controlBus_1 = Bus.control(s, 1);
~controlBus_2 = Bus.control(s, 1);
~controlBus_3 = Bus.control(s, 1);
~timbr_dur=0.03;
s.waitForBoot{
Tdef(\drone, {
//~controlBus = Bus.control(s, 1);

////////////////////////////////////////////////////////////////////////////////////////// wavetable, scales, space,timbre///////////////////////////////////////
(
{
var az1=0,el1=0,az2=0,el2=0,angle=0;
var silver_r=(1+2.sqrt), g=((1+5.sqrt)/2), azimuth, elevation;

~az=[]; ~el=[];

32.do{
    azimuth = 32.collect{
        az1 = (az1 + (2pi-(2pi/silver_r))).wrap(pi.neg,pi);
        el1 = (el1 + (pi-(pi/g))).wrap((pi/2).neg,(pi/2));
        (az1 + angle).wrap(pi.neg,pi)
    };

    elevation = 32.collect{
        az2 = (az2 + (2pi-(2pi/silver_r))).wrap(pi.neg,pi);
        el2 = (el2 + (pi-(pi/g))).wrap((pi/2).neg,(pi/2));
        (el2 + angle).wrap((pi/2).neg,(pi/2))
    };

    angle = (angle + (2pi-(2pi/silver_r))).wrap(pi.neg,pi);

    ~az = ~az ++ azimuth;
    ~el = ~el ++ elevation;

    az1=0; el1=0;
    az2=0; el2=0;
};
}.value;
);
~vertices = 32*32;
~count=[1,1,5,5,5,5];
~set=(~count.[0]*~count.[1]*~count.[2]*~count.[3]*~count.[4]*~count.[5]);
~fuse1=1;~fuse2=1;~harm=1;~mod=0;~fuse=100;
({
var pla=0,az=0,el=0;
var sph,mag,r,run = true;
var scale=1,scale1=10,scale2=10,harm,perspective;
var axis=~count.[0],cloud=~count.[1],axis1=~count.[2],gravity1=~count.[3],axis2=~count.[4],gravity2=~count.[5];
var m_x=1,m_y=1,m_z=1,mq=m_x+1;
var sph1,sph2,sph3,sph4,sph7,sph6,sph11,sph22,sph33,sph44,sph77,sph66;
var sph_1,sph_2,sph_3,sph_4,sph_7,sph_6,sph_11,sph_22,sph_33,sph_44,sph_77,sph_66;
var az1=0,el1=0,az2=0,el2=0,az3=0,el3=0,az4=0,el4=0,az7=0,el7=0,az6=0,el6=0;
var az11=0,el11=0,az22=0,el22=0,az33=0,el33=0,az44=0,el44=0,az77=0,el77=0,az66=0,el66=0;
var az_1=0,el_1=0,az_2=0,el_2=0,az_3=0,el_3=0,az_4=0,el_4=0,az_7=0,el_7=0,az_6=0,el_6=0;
var azimuth,elevation,magnitudex,magnitudey,magnitudez,magnitudeqx;
var magx,magy,magz,magqx,rotation;
var angle=0,angle1=0,angle11=0;
var g=((1+5.sqrt)/2),s=(1+2.sqrt),ott=pi.rand2,temp,space,mod_el=0;
var waveSpeed = 0.5,waveFreq = 3,amp=0.5;
var n=0,rx=0,ry=0,rz=0;
var theta,phi,wave,anglex,angley,anglez;

~rotation=1;~rotationx=0;~rotationy=0;~rotationz=0;~rx=0;~ry=0;~rz=0;
~azr=[];~elr=[];~magx=[];~magy=[];~magz=[];~qx=[];
~cx = [];~cy = [];~cz = [];

~tree= Routine({loop{
scale=~fuse;
scale1=~fuse1;
scale2=~fuse2;
harm=~harm;
anglex=Spherical(1,pi.rand2,0.5pi.rand2).rotateXY(~mod).x*pi;
angley=Spherical(1,pi.rand2,0.5pi.rand2).rotateXY(~mod).y*pi;
anglez=Spherical(1,pi.rand2,0.5pi.rand2).rotateXY(~mod).z*pi;

m_x=m_y=m_z=harm;
mq=harm+1;
axis=~count.[0];cloud=~count.[1];axis1=~count.[2];
gravity1=~count.[3];axis2=~count.[4];gravity2=~count.[5];

az1=0; el1=0;az2=0; el2=0;
az3=0; el3=0;az4=0; el4=0;
az7=0; el7=0;az6=0; el6=0;
angle = 0;angle1 = 0;angle11 = 0;
az11=0; el11=0;az22=0; el22=0;
az33=0; el33=0;az44=0; el44=0;
az77=0; el77=0;az66=0; el66=0;
az_1=0; el_1=0;az_2=0; el_2=0;
az_3=0; el_3=0;az_4=0; el_4=0;
az_7=0; el_7=0;az_6=0; el_6=0;
pla = 0;

(
{
~azr=[];~elr=[];~magx=[];~magy=[];~magz=[];~magqx=[];
~cx = [];~cy = [];~cz = [];
axis.do{
//////////////////////////// AZ
cloud.do{
az1=(az1+(2pi-(2pi/s))).wrap(pi.neg,pi);
el1=(el1+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle1=angle;
sph1=Spherical(1,(az1+angle).wrap(pi.neg,pi),(el1+angle).wrap((pi/2).neg,(pi/2)));

axis1.do{
az11=sph1.theta;
el11=sph1.phi;

gravity1.do{
az11=(az11+(2pi-(2pi/s))).wrap(pi.neg,pi);
el11=(el11+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

angle11=angle1;
sph11=Spherical(1/scale1,(az11+angle1).wrap(pi.neg,pi),(el11+angle1).wrap((pi/2).neg,(pi/2)));
sph_1=(sph1.asCartesian+sph11.asCartesian);

axis2.do{
az_1=sph11.theta;
el_1=sph11.phi;

azimuth=gravity2.collect{
az_1=(az_1+(2pi-(2pi/s))).wrap(pi.neg,pi);
el_1=(el_1+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
sph_11=Spherical(1/scale2,(az_1+angle11).wrap(pi.neg,pi),(el_1+angle11).wrap((pi/2).neg,(pi/2)));
(sph_1+sph_11.asCartesian).asSpherical.theta
};
~azr=~azr++azimuth;
angle11=(angle11+(2pi-(2pi/s))).wrap(0,2pi);
};
};
angle1=(angle1+(2pi-(2pi/s))).wrap(0,2pi);
};
};

//////////////////////////// EL
cloud.do{
az2=(az2+(2pi-(2pi/s))).wrap(pi.neg,pi);
el2=(el2+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle1=angle;
sph2=Spherical(1,(az2+angle).wrap(pi.neg,pi),(el2+angle).wrap((pi/2).neg,(pi/2)));

axis1.do{
az22=sph2.theta;
el22=sph2.phi;

gravity1.do{
az22=(az22+(2pi-(2pi/s))).wrap(pi.neg,pi);
el22=(el22+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

angle11=angle1;
sph22=Spherical(1/scale1,(az22+angle1).wrap(pi.neg,pi),(el22+angle1).wrap((pi/2).neg,(pi/2)));
sph_2=(sph2.asCartesian+sph22.asCartesian);

axis2.do{
az_2=sph22.theta;
el_2=sph22.phi;

elevation=gravity2.collect{
az_2=(az_2+(2pi-(2pi/s))).wrap(pi.neg,pi);
el_2=(el_2+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
sph_22=Spherical(1/scale2,(az_2+angle11).wrap(pi.neg,pi),(el_2+angle11).wrap((pi/2).neg,(pi/2)));
(sph_2+sph_22.asCartesian).asSpherical.phi
};
~elr=~elr++elevation;
angle11=(angle11+(2pi-(2pi/s))).wrap(0,2pi);
};
};
angle1=(angle1+(2pi-(2pi/s))).wrap(0,2pi);
};
};
//////////////////////////// MAG X
cloud.do{
az3=(az3+(2pi-(2pi/s))).wrap(pi.neg,pi);
el3=(el3+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle1=angle;
sph3=Spherical(1,(az3+angle).wrap(pi.neg,pi),(el3+angle).wrap((pi/2).neg,(pi/2)));

axis1.do{
az33=sph3.theta;
el33=sph3.phi;

gravity1.do{
az33=(az33+(2pi-(2pi/s))).wrap(pi.neg,pi);
el33=(el33+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle11=angle1;
sph33=Spherical(1/scale1,(az33+angle1).wrap(pi.neg,pi),(el33+angle1).wrap((pi/2).neg,(pi/2)));
sph_3=(sph3.asCartesian+sph33.asCartesian);

axis2.do{
az_3=sph33.theta;
el_3=sph33.phi;

magnitudex=gravity2.collect{
az_3=(az_3+(2pi-(2pi/s))).wrap(pi.neg,pi);
el_3=(el_3+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
sph_33=Spherical(1/scale2,(az_3+angle11).wrap(pi.neg,pi),(el_3+angle11).wrap((pi/2).neg,(pi/2)));
magx=((Complex(cos(((sph3.theta+anglex)*m_x)),cos(((sph3.theta+anglex)*m_x))).rho/(2.sqrt))*
(Complex(cos((sph3.phi)),cos((sph3.phi))).rho/(2.sqrt)));

(Spherical(magx,sph3.theta,sph3.phi).asCartesian
+Spherical(magx/scale2,sph_33.theta,sph_33.phi).asCartesian).asSpherical.rho
};
~magx=~magx++magnitudex;
angle11=(angle11+(2pi-(2pi/s))).wrap(0,2pi);
};
};
angle1=(angle1+(2pi-(2pi/s))).wrap(0,2pi);
};
};
//////////////////////////// MAG Y
cloud.do{
az4=(az4+(2pi-(2pi/s))).wrap(pi.neg,pi);
el4=(el4+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle1=angle;
sph4=Spherical(1,(az4+angle).wrap(pi.neg,pi),(el4+angle).wrap((pi/2).neg,(pi/2)));

axis1.do{
az44=sph4.theta;
el44=sph4.phi;

gravity1.do{
az44=(az44+(2pi-(2pi/s))).wrap(pi.neg,pi);
el44=(el44+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle11=angle1;
sph44=Spherical(1/scale1,(az44+angle1).wrap(pi.neg,pi),(el44+angle1).wrap((pi/2).neg,(pi/2)));
sph_4=(sph4.asCartesian+sph44.asCartesian);

axis2.do{
az_4=sph44.theta;
el_4=sph44.phi;

magnitudey=gravity2.collect{
az_4=(az_4+(2pi-(2pi/s))).wrap(pi.neg,pi);
el_4=(el_4+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
sph_44=Spherical(1/scale2,(az_4+angle11).wrap(pi.neg,pi),(el_4+angle11).wrap((pi/2).neg,(pi/2)));
magy=((Complex(sin(((sph4.theta+angley)*m_x)),sin(((sph4.theta+angley)*m_x))).rho/(2.sqrt))*
(Complex(cos((sph4.phi)),cos((sph4.phi))).rho/(2.sqrt)));

(Spherical(magy,sph4.theta,sph4.phi).asCartesian
+Spherical(magy/scale2,sph_44.theta,sph_44.phi).asCartesian).asSpherical.rho
};
~magy=~magy++magnitudey;
angle11=(angle11+(2pi-(2pi/s))).wrap(0,2pi);
};
};
angle1=(angle1+(2pi-(2pi/s))).wrap(0,2pi);
};
};
//////////////////////////// MAG Z
cloud.do{
az7=(az7+(2pi-(2pi/s))).wrap(pi.neg,pi);
el7=(el7+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle1=angle;
sph7=Spherical(1,(az7+angle).wrap(pi.neg,pi),(el7+angle).wrap((pi/2).neg,(pi/2)));

axis1.do{
az77=sph7.theta;
el77=sph7.phi;

gravity1.do{
az77=(az77+(2pi-(2pi/s))).wrap(pi.neg,pi);
el77=(el77+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

angle11=angle1;
sph77=Spherical(1/scale1,(az77+angle1).wrap(pi.neg,pi),(el77+angle1).wrap((pi/2).neg,(pi/2)));
sph_7=(sph7.asCartesian+sph77.asCartesian);

axis2.do{
az_7=sph77.theta;
el_7=sph77.phi;

magnitudez=gravity2.collect{
az_7=(az_7+(2pi-(2pi/s))).wrap(pi.neg,pi);
el_7=(el_7+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
sph_77=Spherical(1/scale2,(az_7+angle11).wrap(pi.neg,pi),(el_7+angle11).wrap((pi/2).neg,(pi/2)));
magz=(Complex(sin(((sph7.phi+anglez)*m_z)),sin((sph7.phi*m_z))).rho/(2.sqrt));

(Spherical(magz,sph7.theta,sph7.phi).asCartesian
+Spherical(magz/scale2,sph_77.theta,sph_77.phi).asCartesian).asSpherical.rho
};
~magz=~magz++magnitudez;
angle11=(angle11+(2pi-(2pi/s))).wrap(0,2pi);
};
};
angle1=(angle1+(2pi-(2pi/s))).wrap(0,2pi);
};
};
/////////////////////////////////MAG QX
cloud.do{
az6=(az6+(2pi-(2pi/s))).wrap(pi.neg,pi);
el6=(el6+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle1=angle;
sph6=Spherical(1,(az6+angle).wrap(pi.neg,pi),(el6+angle).wrap((pi/2).neg,(pi/2)));

axis1.do{
az66=sph6.theta;
el66=sph6.phi;

gravity1.do{
az66=(az66+(2pi-(2pi/s))).wrap(pi.neg,pi);
el66=(el66+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle11=angle1;
sph66=Spherical(1/scale1,(az66+angle1).wrap(pi.neg,pi),(el66+angle1).wrap((pi/2).neg,(pi/2)));
sph_6=(sph6.asCartesian+sph66.asCartesian);

axis2.do{
az_6=sph66.theta;
el_6=sph66.phi;

magnitudeqx=gravity2.collect{
az_6=(az_6+(2pi-(2pi/s))).wrap(pi.neg,pi);
el_6=(el_6+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
sph_66=Spherical(1/scale2,(az_6+angle11).wrap(pi.neg,pi),(el_6+angle11).wrap((pi/2).neg,(pi/2)));
magqx=((((Complex(cos(((sph6.theta)*mq).wrap(pi.neg,pi)),cos(((sph6.theta)*mq).wrap(pi.neg,pi))))*
(Complex(sin((sph6.phi*(mq-1)).wrap((pi/2).neg,(pi/2))),sin((sph6.phi*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((sph6.phi).wrap((pi/2).neg,(pi/2))),cos((sph6.phi).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt));

(Spherical(magqx,sph6.theta,sph6.phi).asCartesian
+Spherical(magqx/scale2,sph_66.theta,sph_66.phi).asCartesian).asSpherical.rho
};
~magqx=~magqx++magnitudeqx;
angle11=(angle11+(2pi-(2pi/s))).wrap(0,2pi);
};
};
angle1=(angle1+(2pi-(2pi/s))).wrap(0,2pi);
};
};
angle=(angle+(2pi-(2pi/s))).wrap(0,2pi);
az1=0;el1=0;az2=0;el2=0;
az3=0;el3=0;az4=0;el4=0;
az7=0;el7=0;az6=0;el6=0;
};
}.value;
);
(
~magxb = ~magx.collect { |val, i|
theta = ~az[i];
phi = ~el[i];
wave = amp*sin((waveFreq * theta) + (waveFreq * phi )- waveSpeed);
val * wave;
};
~magyb = ~magy.collect { |val, i|
theta = ~az[i];
phi = ~el[i];
wave = amp*sin((waveFreq * theta) + (waveFreq * phi )- waveSpeed);
val * wave;
};
~magzb = ~magz.collect { |val, i|
theta = ~az[i];
phi = ~el[i];
wave = amp*sin((waveFreq * theta) + (waveFreq * phi )- waveSpeed);
val * wave;
};
);
n=0;
~set.do{
var az, el;
var x, y, z,rot,mag=1;

az = ~azr.[n];
el = ~elr.[n];
//mag=(Cartesian(~magx.[n],~magy.[n],~magz.[n]).rho)/2.sqrt;
rot=Spherical(mag,az,el).rotateYZ(~rx).rotateXZ(~ry).rotateXY(~rz);
//x = cos(el) * cos(az);
//y = cos(el) * sin(az);
//z = sin(el);
x=rot.x; y=rot.y; z=rot.z;
~cx = ~cx ++ x; ~cy = ~cy ++ y; ~cz = ~cz ++ z;
n = n + 1;
};
(~timbr_dur).wait;
};});
~tree.play
}.defer;
);

(
{
Routine({loop{
(
~rx=(~rx +~rotationx).wrap(0,2pi);
~ry=(~ry +~rotationy).wrap(0,2pi);
~rz=(~rz +~rotationz).wrap(0,2pi);
);
(0.01).wait; // frame duration
};
}).play;
}.defer
);
////envelope sig
		(
~ne=1.neg;~arraye=56.collect{~ne=~ne+1;2.pow(~ne/56)};
~signalSizee = 2048*1;
);

(
~n=1.neg;~array=992.collect{~n=~n+1;2.pow(~n/992)};
~n=(0-(2pi/992)); ~ph=992.collect{~n=~n+(2pi/992);};
~bufferSize = 4096*8;
~signalSize = 2048*8;
);
(
~wt= Buffer.alloc(s,~bufferSize);
{
var signal,wt;
signal=Signal.sineFill(~signalSize,~array,~ph);
wt = signal.asWavetable;
~wt.loadCollection(wt);
//signal.plot;
}.value;
);
(
~note=26;
~note10=26;
(
{
var nn=1.neg;
~scale=~note.collect{nn=nn+1;Scale.dorian.performDegreeToKey(nn,12)};
}.value;
);

(
{
var nn=1.neg,scale1,scale2;
scale1=~note10.collect{nn=nn+1;Scale.minorPentatonic.performDegreeToKey(nn,12)};
nn=1.neg;
scale2=~note10.collect{nn=nn+1;Scale.majorPentatonic.performDegreeToKey(nn,12)};
//~scale10=[scale1,scale2];
~scale10=[scale1,scale2];
}.value;
);
);

/////////////////////////////////////////////////////////////////////////////////////////////////////sound
(
SynthDef.new(\synth,{
arg gain=1,lowend=20,s_size=1,room=1,drive=0,au=0,sb=0,mag1=1,mag2=1,
c=0,az=0,el=0,az1=0,el1=0,dicay=2,attack=2,sc=20,ssc=1,mix=0,rect=16,s1,s2,s3,s4,
busArray = #[0,1,2,3,4,5,6,7,8];
var fund,fu=32,n=0,mod_x,mod_y,mod_z,phasex,phasey,phasez,low=0,sustain,tremolo=4;
var freq1,freq2,freq3,amp1,amp2,amp3,sig1,sig2,sig3,heavy,freq11,freq21,freq31,amp11,amp21,amp31;
var b_x,b_y,b_z,polytope,env,expansion,sph1,sph2,envf;
var g_ch1,g_ch2,g_ch3,g_ch4,a1,a2,a3,a4,mp,mps,mpf;
var s_x,s_y,s_z,threshold,c1,c2,c3,mp_x,mp_y,mp_z,mps_x,mps_y,mps_z,mpf_x,mpf_y,mpf_z;
var mp_x1,mp_y1,mp_z1,mps_x1,mps_y1,mps_z1,mpf_x1,mpf_y1,mpf_z1;
var peak, times,signal,rip,enva,key,attackLen,sustainLen,decayLen,tx,ty,tz;
var vanish=4,dist=(2/3),phasex1,phasey1,phasez1,s_x1,s_y1,s_z1,b_x1,b_y1,b_z1;
var c4,c5,c6,sig5,sig4,sig6;

//envf=EnvGen.ar(Env.new([0,0,pi,pi,2pi],[(dicay/2),(attack/2),(dicay/2),(attack/2)]),doneAction:0);

sustain=0.1;
////signal envelope
signal = Signal.sineFill(~signalSizee, ~arraye, [0]);
signal = signal.rotate(signal.size div: 2);
peak = signal.abs.maxIndex.max(1);
rip = Env.new([0,1,0],[0.25,0.5],[4.neg,1]).asSignal(~signalSizee);
rip = rip * (1 + (signal / tremolo));
rip = rip.normalize;
peak = peak.min(signal.size - 2).max(1);
attackLen = (peak / 2).floor;
sustainLen = peak - attackLen;
decayLen = signal.size - peak - 1;
times =Array.fill(attackLen, attack / attackLen)
 ++ Array.fill(sustainLen, sustain / sustainLen)
 ++ Array.fill(decayLen, dicay / decayLen);
enva = Env(rip.asArray, times);
env = EnvGen.ar(enva,doneAction:2)*gain;
//env=EnvGen.ar(Env.perc(attack,dicay,gain),doneAction:2);

expansion=2.pow(c.lag(0.01)/16256);
fund=(fu*(9/8))*expansion;
heavy=2.pow(drive.lag(0.01)/16256);

///osc
mp_x = (sc*mag1)  * cos(el) * cos(az);
mp_y = (sc*mag1)  * cos(el) * sin(az);
mp_z = (sc*mag1)  * sin(el);

mp_x1 = (sc*mag2)  * cos(el1) * cos(az1);
mp_y1 = (sc*mag2)  * cos(el1) * sin(az1);
mp_z1 = (sc*mag2)  * sin(el1);

mps_x = (ssc*mag1) * cos(el) * cos(az);
mps_y = (ssc*mag1) * cos(el) * sin(az);
mps_z = (ssc*mag1) * sin(el);

mps_x1 = (ssc*mag2) * cos(el1) * cos(az1);
mps_y1 = (ssc*mag2) * cos(el1) * sin(az1);
mps_z1 = (ssc*mag2) * sin(el1);

mpf_x =pi* cos(el) * cos(az);
mpf_y =pi* cos(el) * sin(az);
mpf_z =pi* sin(el);

mpf_x1 =pi* cos(el1) * cos(az1);
mpf_y1 =pi* cos(el1) * sin(az1);
mpf_z1 =pi* sin(el1);
//perspective
//mp_x=mp_x*((sc*dist)/((sc*dist)+mp_z+((sc*dist)/vanish)));
//mp_y=mp_y*((sc*dist)/((sc*dist)+mp_z+((sc*dist)/vanish)));
//mps_x=mps_x*((ssc*dist)/((ssc*dist)+mps_z+((ssc*dist)/vanish)));
//mps_y=mps_y*((ssc*dist)/((ssc*dist)+mps_z+((ssc*dist)/vanish)));
key=Select.kr(sb,~scale10);

b_x=2.pow(mp_x.round(1)/16256);
b_y=2.pow(mp_y.round(1)/16256);
b_z=2.pow(mp_z.round(1)/16256);

b_x1=2.pow(mp_x1.round(1)/16256);
b_y1=2.pow(mp_y1.round(1)/16256);
b_z1=2.pow(mp_z1.round(1)/16256);

s_x=2.pow(Select.kr(mps_x.round(1).abs,key).asInteger /12);
s_y=2.pow(Select.kr(mps_y.round(1).abs,key).asInteger /12);
s_z=2.pow(Select.kr(mps_z.round(1).abs,key).asInteger /12);

s_x1=2.pow(Select.kr(mps_x1.round(1).abs,key).asInteger /12);
s_y1=2.pow(Select.kr(mps_y1.round(1).abs,key).asInteger /12);
s_z1=2.pow(Select.kr(mps_z1.round(1).abs,key).asInteger /12);

freq1=(fund)*b_x*s_x;
freq2=(fund)*b_y*s_y;
freq3=(fund)*b_z*s_z;

freq11=(fund)*b_x1*s_x1;
freq21=(fund)*b_y1*s_y1;
freq31=(fund)*b_z1*s_z1;

amp1=b_x.reciprocal*expansion.reciprocal*s_x.reciprocal;
amp2=b_y.reciprocal*expansion.reciprocal*s_y.reciprocal;
amp3=b_z.reciprocal*expansion.reciprocal*s_z.reciprocal;

amp11=b_x1.reciprocal*expansion.reciprocal*s_x1.reciprocal;
amp21=b_y1.reciprocal*expansion.reciprocal*s_y1.reciprocal;
amp31=b_z1.reciprocal*expansion.reciprocal*s_z1.reciprocal;
//mod_x=mpf_x;
//mod_y=mpf_y;
//mod_z=mpf_z;
///simple  az/el wave phase relations
//phasex=b_x.reciprocal*s_x.reciprocal*pi;
//phasey=b_y.reciprocal*s_y.reciprocal*pi;
//phasez=b_z.reciprocal*s_z.reciprocal*pi;
///perspective phase relations
//for linear phase mapping use linlin
//for compresse exp smoother maping with more energe towards similar values use complex
//for rational relations between phases and symmetry matrices use atan2 relation insteadof maping
//here since signal is wavefield ratio phases with more sidebands and matrice symmetries may be usefull
//phasex=(Complex(1,mod_x).theta*2)+envf;
//phasey=(Complex(1,mod_y).theta*2)+envf;
//phasez=(Complex(1,mod_z).theta*2)+envf;
//phasex=atan2(mod_x,mod_y);
//phasey=atan2(mod_y,mod_z);
//phasez=atan2(mod_z,mod_x);
phasex=mpf_x;
phasey=mpf_y;
phasez=mpf_z;
phasex1=mpf_x1;
phasey1=mpf_y1;
phasez1=mpf_z1;

c1=FreeVerb.ar(BPF.ar((Osc.ar(~wt.bufnum,freq1,phase:phasex,mul:1200).abs*
SinOsc.ar(freq1,phase:phasex)),freq1,heavy,amp1),mix,room);
c2=FreeVerb.ar(BPF.ar((Osc.ar(~wt.bufnum,freq2,phase:phasey,mul:1200).abs*
SinOsc.ar(freq2,phase:phasey)),freq2,heavy,amp2),mix,room);
c3=FreeVerb.ar(BPF.ar((Osc.ar(~wt.bufnum,freq3,phase:phasez,mul:1200).abs*
SinOsc.ar(freq3,phase:phasez)),freq3,heavy,amp3),mix,room);

c4=(FreeVerb.ar(BPF.ar((Osc.ar(~wt.bufnum,freq11,phase:phasex1,mul:1200).abs*
SinOsc.ar(freq11,phase:phasex1)),freq11,heavy,amp11),mix,room));
c5=(FreeVerb.ar(BPF.ar((Osc.ar(~wt.bufnum,freq21,phase:phasey1,mul:1200).abs*
SinOsc.ar(freq21,phase:phasey1)),freq21,heavy,amp21),mix,room));
c6=(FreeVerb.ar(BPF.ar((Osc.ar(~wt.bufnum,freq31,phase:phasez1,mul:1200).abs*
SinOsc.ar(freq31,phase:phasez1)),freq31,heavy,amp31),mix,room));

////distortion rectifier
sig1=((((SinOsc.ar(freq1*(rect*2),phase:phasex,mul:amp1)).abs+(amp1))*
(SinOsc.ar(freq1*(rect),phase:phasex,mul:amp1))).abs+(amp1))*c1*10;
sig2=((((SinOsc.ar(freq2*(rect*2),phase:phasey,mul:amp2)).abs+(amp2))*
(SinOsc.ar(freq2*(rect),phase:phasey,mul:amp2))).abs+(amp2))*c2*10;
sig3=((((SinOsc.ar(freq3*(rect*2),phase:phasez,mul:amp3)).abs+(amp3))*
(SinOsc.ar(freq3*(rect),phase:phasez,mul:amp3))).abs+(amp3))*c3*10;

sig4=((((SinOsc.ar(freq11*(rect*2),phase:phasex1,mul:amp11)).abs+(amp11))*
(SinOsc.ar(freq11*(rect),phase:phasex1,mul:amp11))).abs+(amp11))*c4*10;
sig5=((((SinOsc.ar(freq21*(rect*2),phase:phasey1,mul:amp21)).abs+(amp21))*
(SinOsc.ar(freq21*(rect),phase:phasey1,mul:amp21))).abs+(amp21))*c5*10;
sig6=((((SinOsc.ar(freq31*(rect*2),phase:phasez1,mul:amp31)).abs+(amp31))*
(SinOsc.ar(freq31*(rect),phase:phasez1,mul:amp31))).abs+(amp3))*c6*10;

sig1=(sig1*mix.linlin(0,1,0.1,2)).softclip;
sig2=(sig2*mix.linlin(0,1,0.1,2)).softclip;
sig3=(sig3*mix.linlin(0,1,0.1,2)).softclip;

sig4=(sig4*mix.linlin(0,1,0.1,2)).softclip;
sig5=(sig5*mix.linlin(0,1,0.1,2)).softclip;
sig6=(sig6*mix.linlin(0,1,0.1,2)).softclip;

//////propagation
//sig1=sig1*mp_x.sign;
//sig2=sig2*mp_y.sign;
//sig3=sig3*mp_z.sign;

///spectral compensation
//sig1=BRF.ar(c1,freq1/2,heavy);
//sig2=BRF.ar(c2,freq2/2,heavy);
//sig3=BRF.ar(c3,freq3/2,heavy);
//sig1=BRF.ar(c1,freq1*4,heavy);
//sig2=BRF.ar(c2,freq2*4,heavy);
//sig3=BRF.ar(c3,freq3*4,heavy);

/////compresion
sig1=HPF.ar(sig1,lowend);
sig2=HPF.ar(sig2, lowend);
sig3=HPF.ar(sig3, lowend);
sig4=HPF.ar(sig4,lowend);
sig5=HPF.ar(sig5, lowend);
sig6=HPF.ar(sig6, lowend);

threshold=(((343/s_size)/fund).reciprocal.ampdb/2.sqrt).dbamp;
sig1=Compander.ar(sig1,c1,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);
sig2=Compander.ar(sig2,c2,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);
sig3=Compander.ar(sig3,c3,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);
sig4=Compander.ar(sig4,c4,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);
sig5=Compander.ar(sig5,c5,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);
sig6=Compander.ar(sig6,c6,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);
/////spat
(
a1=a2=a3=a4=1;
g_ch1=
(sig1.abs.range(0.001,1)*cos(el)*cos(az)*
 sig1.range(0.001,1)*cos(Select.kr(s1,~el)*a1)*cos(Select.kr(s1,~az)*a1))
+
(sig2.abs.range(0.001,1)*cos(el)*sin(az)*
 sig2.range(0.001,1)*cos(Select.kr(s1,~el)*a1)*sin(Select.kr(s1,~az)*a1))
+
(sig3.abs.range(0.001,1)*sin(el)*
 sig3.range(0.001,1)*sin(Select.kr(s1,~el)*a1));

g_ch2=
(sig1.abs.range(0.001,1)*cos(el)*cos(az)*
 sig1.range(0.001,1)*cos(Select.kr(s2,~el)*a2)*cos(Select.kr(s2,~az)*a2))
+
(sig2.abs.range(0.001,1)*cos(el)*sin(az)*
 sig2.range(0.001,1)*cos(Select.kr(s2,~el)*a2)*sin(Select.kr(s2,~az)*a2))
+
(sig3.abs.range(0.001,1)*sin(el)*
 sig3.range(0.001,1)*sin(Select.kr(s2,~el)*a2));

g_ch3=
(sig1.abs.range(0.001,1)*cos(el)*cos(az)*
 sig1.range(0.001,1)*cos(Select.kr(s3,~el)*a3)*cos(Select.kr(s3,~az)*a3))
+
(sig2.abs.range(0.001,1)*cos(el)*sin(az)*
 sig2.range(0.001,1)*cos(Select.kr(s3,~el)*a3)*sin(Select.kr(s3,~az)*a3))
+
(sig3.abs.range(0.001,1)*sin(el)*
 sig3.range(0.001,1)*sin(Select.kr(s3,~el)*a3));

g_ch4=
(sig1.abs.range(0.001,1)*cos(el)*cos(az)*
 sig1.range(0.001,1)*cos(Select.kr(s4,~el)*a4)*cos(Select.kr(s4,~az)*a4))
+
(sig2.abs.range(0.001,1)*cos(el)*sin(az)*
 sig2.range(0.001,1)*cos(Select.kr(s4,~el)*a4)*sin(Select.kr(s4,~az)*a4))
+
(sig3.abs.range(0.001,1)*sin(el)*
 sig3.range(0.001,1)*sin(Select.kr(s4,~el)*a4));
);

(
Out.ar(busArray.[0],LeakDC.ar(sig1*env));
Out.ar(busArray.[1],LeakDC.ar(sig2*env));
Out.ar(busArray.[2],LeakDC.ar(sig3*env));
);
(
Out.ar(busArray.[0],LeakDC.ar(sig4*env));
Out.ar(busArray.[1],LeakDC.ar(sig5*env));
Out.ar(busArray.[2],LeakDC.ar(sig6*env));
);
Out.kr(~controlBus_1.index,(sig1*env));
Out.kr(~controlBus_2.index,(sig2*env));
Out.kr(~controlBus_3.index,(sig3*env));
Out.kr(~controlBus_1.index,(sig4*env));
Out.kr(~controlBus_2.index,(sig5*env));
Out.kr(~controlBus_3.index,(sig6*env));
///comment out the above parentheses and uncomment the below to use the synth on
///threefold speaker wavefield quad spat (12ch)/// to puput stereo sets (x,y) not use z channel as ouput (2,5,etc), sig3.
/*(
Out.ar(busArray.[0],LeakDC.ar(sig1*env*g_ch1));
Out.ar(busArray.[1],LeakDC.ar(sig2*env*g_ch1));
Out.ar(busArray.[2],LeakDC.ar(sig3*env*g_ch1));
Out.ar(busArray.[3],LeakDC.ar(sig1*env*g_ch2));
Out.ar(busArray.[4],LeakDC.ar(sig2*env*g_ch2));
Out.ar(busArray.[5],LeakDC.ar(sig3*env*g_ch2));
Out.ar(busArray.[6],LeakDC.ar(sig1*env*g_ch3));
Out.ar(busArray.[7],LeakDC.ar(sig2*env*g_ch3));
Out.ar(busArray.[8],LeakDC.ar(sig3*env*g_ch3));
Out.ar(busArray.[9],LeakDC.ar(sig1*env*g_ch4));
Out.ar(busArray.[10],LeakDC.ar(sig2*env*g_ch4));
Out.ar(busArray.[11],LeakDC.ar(sig3*env*g_ch4));
)*/

}).add;
);
1.wait;
/////////////////////////////////////////////////////////////////////////////////////////////////////////sequencer,pattern
(
/*({
var m1=1.neg, m2=1.neg;
var m3=1.neg,n=0,bank=5,rhythm=4,time=32.reciprocal,beat=1;
var durx=[],dury=[],durz=[],durx1=[],dury1=[],durz1=[];
var dx=[],dy=[],dz=[],bx,by,bz,durx2,dury2,durz2,dur=[],dur1=[],dur2;

~azr=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~elr=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
~r=0;~r1=0;~r2=0;

~dur=[];

bank.do{
    m1=m2=m3=~vertices.rand;

    bx=1.collect{
        var az, el, x, y, z;
        az = ~az.[m1];
        el = ~el.[m1];
        x = beat * cos(el) * cos(az);
        y = beat * cos(el) * sin(az);
        z = beat * sin(el);
        2.pow(x).round(time)};

   by=1.collect{
        var az, el, x, y, z;
        az = ~az.[m2];
        el = ~el.[m2];
        x = beat * cos(el) * cos(az);
        y = beat * cos(el) * sin(az);
        z = beat * sin(el);
        2.pow(y).round(time)};

    bz=1.collect{
        var az, el, x, y, z;
        az = ~az.[m3];
        el = ~el.[m3];
        x = beat * cos(el) * cos(az);
        y = beat * cos(el) * sin(az);
        z = beat * sin(el);
        2.pow(z).round(time)};

    m1=1.neg; m2=1.neg; m3=1.neg;

    dx=dx++bx;
    dy=dy++by;
    dz=dz++bz;

    bx=[]; by=[]; bz=[];
};

n=0;
rhythm.do{ dur=dur++((dx.[n]*dz.[n])+(dy.[n]*dz.[n])); n=n+1;}; n=1;
(rhythm-1).do{ dur1=dur1++((dx.[n]*dz.[n])+(dy.[n]*dz.[n])); n=n+1;}; n=1;
dur2=[((dx.[4]*dz.[4])+(dy.[4]*dz.[4]))]++dur1.reverse;
~dur=~dur++dur++dur2;
}.value)*/
({
var m1=1.neg, m2=1.neg;
var m3=1.neg,n=0,bank=5,rhythm=4,time=32.reciprocal,beat=1;
var durx=[],dury=[],durz=[],durx1=[],dury1=[],durz1=[];
var dx=[],dy=[],dz=[],bx,by,bz,durx2,dury2,durz2;

~azr=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~elr=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
~r=0;~r1=0;~r2=0;

~dur=[];

bank.do{
    m1=m2=m3=~vertices.rand;

    bx=1.collect{
        var az, el, x, y, z;
        az = ~az.[m1];
        el = ~el.[m1];
        x = beat * cos(el) * cos(az);
        y = beat * cos(el) * sin(az);
        z = beat * sin(el);
        2.pow(x).round(time)};

   by=1.collect{
        var az, el, x, y, z;
        az = ~az.[m2];
        el = ~el.[m2];
        x = beat * cos(el) * cos(az);
        y = beat * cos(el) * sin(az);
        z = beat * sin(el);
        2.pow(y).round(time)};

    bz=1.collect{
        var az, el, x, y, z;
        az = ~az.[m3];
        el = ~el.[m3];
        x = beat * cos(el) * cos(az);
        y = beat * cos(el) * sin(az);
        z = beat * sin(el);
        2.pow(z).round(time)};

    m1=1.neg; m2=1.neg; m3=1.neg;

    dx=dx++bx;
    dy=dy++by;
    dz=dz++bz;

    bx=[]; by=[]; bz=[];
};

n=0;
rhythm.do{ durx=durx++dx.[n]; n=n+1;}; n=0;
rhythm.do{ dury=dury++dy.[n]; n=n+1;}; n=0;
rhythm.do{ durz=durz++dz.[n]; n=n+1;}; n=1;
(rhythm-1).do{ durx1=durx1++dx.[n]; n=n+1;}; n=1;
(rhythm-1).do{ dury1=dury1++dy.[n]; n=n+1;}; n=1;
(rhythm-1).do{ durz1=durz1++dz.[n]; n=n+1;}; n=0;
durx2=[dx.[4]]++durx1.reverse;
dury2=[dy.[4]]++dury1.reverse;
durz2=[dz.[4]]++durz1.reverse;
//~dur=~dur++durx++dury++durz++durx2++dury2++durz2;
~dur=~dur++durx++dury++durz;
}.value);
({
var dict = IdentityDictionary[\A -> "AB", \B -> "A"];
//These are the production rules of the L-system
var word = "A";
var string_temp = "";
var iter = 7;
//These are diction for the mapping of the alphabet to "artistic" parameters: degrees in a scale, beat occurrence, etc.
var dictnotes = IdentityDictionary[\A ->0, \B -> 1];  ///amount of 0 in A (array), is the value of Rest(A) for silent events, eg. if A=[0,0,0] then Rest(3)
 ~lseq=[];
//This iteration generates the system recursively
iter.do({
word.asArray.do({|i|string_temp = string_temp ++ dict[i.asSymbol];});
word = string_temp;string_temp = "";});
word.postln;
//Here we map the final system to the parameters as above
word.do({|i| ~lseq = ~lseq ++ dictnotes[i.asSymbol];});
~lseq.postln;
}.value);
~gain=1;~drive=0;~c=0;~attack=0.01;~decay=1;~s_size=1;~lowend=20;~room=0;
~incr1=0;~incr2=0;~sc=1;~gold=((1+5.sqrt)/2);~silver=(1+2.sqrt);
~incr=0;~ssc=26;~mix=0;~rect=16;~s=0;~azimuth=0;~elevation=0;~azimuth1=0;~elevation1=0;
~alternating=[0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1];~hor=0;~lat=0;~shape1=1;~shape2=1;
//~seq= Pseq([~dur.[0],Rest(~dur.[13.rand]),~dur.[1],Rest(~dur.[13.rand]),~dur.[2],Rest(~dur.[13.rand]),~dur.[3]] ,inf);
~tempo=1;
TempoClock.default.tempo_(1);
/*(
{
Routine({loop{
	~hor=(~hor+~incr1).wrap(pi.neg, pi);
	~lat=(~lat+~incr2).wrap(0.5pi.neg, 0.5pi);
(~timbr_dur).wait; // frame duration
};
}).play;
}.defer
)*/
//~c_az=0;
//~c_el=0.5pi.rand2;
//~c_az1=0.5pi;
//~c_el1=0.5pi.rand2;
~nn1=~set.rand;
~nn2=~set.rand;
(
{
var x,y,z,px,py,pz,x1,y1,z1,px1,py1,pz1;
Routine({loop{
//x = Spherical(~vertices-1,~hor,~lat).x.round(1).asInteger.abs;
//y = Spherical(~vertices-1,~hor,~lat).y.round(1).asInteger.abs;
//z = Spherical(~vertices-1,~hor,~lat).z.round(1).asInteger.abs;
//x = Spherical(~set-1,~c_az,~c_el).x.round(1).asInteger.abs;
//y = Spherical(~set-1,~c_az,~c_el).y.round(1).asInteger.abs;
//z = Spherical(~set-1,~c_az,~c_el).z.round(1).asInteger.abs;
//x1 = Spherical(~set-1,~c_az1,~c_el1).x.round(1).asInteger.abs;
//y1 = Spherical(~set-1,~c_az1,~c_el1).y.round(1).asInteger.abs;
//z1 = Spherical(~set-1,~c_az1,~c_el1).z.round(1).asInteger.abs;
x=y=z=~nn1;
x1=y1=z1=~nn2;
px=~cx.[x];
py=~cy.[y];
pz=~cz.[z];
px1=~cx.[x1];
py1=~cy.[y1];
pz1=~cz.[z1];
~shape1=1;
~shape2=1;
//~shape1=(Cartesian(~magx.[x],~magy.[x],~magz.[x]).rho/(2.sqrt));
//~shape2=(Cartesian(~magx.[x1],~magy.[x1],~magz.[x1]).rho/(2.sqrt));
~azimuth=Cartesian(px,py,pz).theta;
~elevation=Cartesian(px,py,pz).phi;
~azimuth1=Cartesian(px1,py1,pz1).theta;
~elevation1=Cartesian(px1,py1,pz1).phi;
(~timbr_dur).wait; // frame duration
};
}).play;
}.defer
);
~clock = TempoClock(1);
~pattern = Pdef(\1,
Pbind(\instrument, \synth,
\dur, Pseq(~dur ,inf),\s_size,Pfunc { ~s_size }, \lowend,Pfunc { ~lowend }, \room,Pfunc { ~room },
\gain,Pfunc { ~gain }, \sc, Pfunc { ~sc },\drive, Pfunc { ~drive },\timbre,Pfunc{~s},
\au,Pseq([0,1,4,3,6,5,9],inf),\sb,Pseq(~alternating*~lseq,inf),
\c, Pfunc { ~c },\mix, Pfunc{~mix},\rect,Pfunc{~rect},\mag1,Pfunc{~shape1},\mag2,Pfunc{~shape2},
\az, Pfunc{~azimuth},\el,Pfunc{~elevation},\az1, Pfunc{~azimuth1},\el1,Pfunc{~elevation1},
\s1,Pfunc{(~vertices-1).rand.round(1).asInteger},\s2,Pfunc{(~vertices-1).rand.round(1).asInteger}
,\s3,Pfunc{(~vertices-1).rand.round(1).asInteger},\s4,Pfunc{(~vertices-1).rand.round(1).asInteger},
\attack,  Pfunc { ~attack }, \dicay, Pfunc { ~decay }, \ssc, Pfunc{~ssc};
));
~pattern.play(~clock);

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////gui
(
{
var size=550,sk=(size/15),w,rol=0,sz=0.5,wd=5,shift=1;
var v1,v2,v3,p1,p2,p3,tx1=2,tx2=2,tx3=2;
var lined=50,run=true,g=((1+5.sqrt)/2);

w = Window("tws", Rect(50, 50, size, 850)).front;
~vw = UserView(w, Rect(0,0,size,size)).background_(Color.black);
v1 = UserView(w, Rect(0,size,size,100)).background_(Color.black);
v2 = UserView(w, Rect(0,650,size,100)).background_(Color.black);
v3 = UserView(w, Rect(0,750,size,100)).background_(Color.black);

v1.drawFunc = {
var x=0,y=0,n=0,m=0,k=0,t1x,br;
p1=[];
10.do {
5.do{
br=exp(Complex(0,1)*(~controlBus_1.getSynchronous*100)*pi).real.linlin(1.neg,1,0,1);
t1x=(~controlBus_1.getSynchronous*shift).reciprocal;
Pen.fillColor = Color.white.alpha_(br*cos(x*pi));
Pen.strokeColor = Color.white.alpha_(br*cos(x*pi));
Pen.addOval(Rect.aboutPoint(Point((x-tx1+t1x).wrap(0,550),y),sz,sz));
p1=p1++Point((x-tx1+t1x).wrap(0,550),y);
Pen.fillStroke;
y=(y+(10)).wrap(0,50);
};
x=(x+(55)).wrap(0,550);
y=0;
};
x=0;
////////mesh
p1=p1.scramble;
n = 0;m=0;k = 0;
(p1.size).do {
var m = n + 1;
(p1.size - n - 1).do {
Pen.fillColor = Color.white.alpha_(1);
Pen.strokeColor = Color.white.alpha_(1);
Pen.width = (~controlBus_1.getSynchronous).abs*wd;
(if(p1.[n].dist(p1.[m]) < lined){Pen.line( p1.[n], p1.[m])};);
m=m+1;k=k+1;
};n=n+1;
};
Pen.fillStroke;
};
{ while { run } {v1.background_(Color.black);tx1 = (tx1 + rol).wrap(0,550); v1.refresh; (0.03).wait } }.fork(AppClock);

v2.drawFunc = {
var x=0,y=0,n=0,m=0,k=0,t1x,br;
p2=[];
10.do {
5.do{
br=exp(Complex(0,1)*(~controlBus_2.getSynchronous*100)*pi).real.linlin(1.neg,1,0,1);
Pen.fillColor = Color.white.alpha_(br*cos(x*pi));
Pen.strokeColor = Color.white.alpha_(br*cos(x*pi));
t1x=(~controlBus_2.getSynchronous*shift).reciprocal;
Pen.addOval(Rect.aboutPoint(Point((x-tx2+t1x).wrap(0,550),y),sz,sz));
p2=p2++Point((x-tx2+t1x).wrap(0,550),y);
Pen.fillStroke;
y=(y+(10)).wrap(0,50);
};
x=(x+(55)).wrap(0,550);
y=0;
};
x=0;
////////mesh
p2=p2.scramble;
n = 0;m=0;k = 0;
(p2.size).do {
var m = n + 1;
(p2.size - n - 1).do {
Pen.fillColor = Color.white.alpha_(1);
Pen.strokeColor = Color.white.alpha_(1);
Pen.width = (~controlBus_2.getSynchronous).abs*wd;
(if(p2.[n].dist(p2.[m]) < lined){Pen.line( p2.[n], p2.[m])};);
m=m+1;k=k+1;
};n=n+1;
};
Pen.fillStroke;
};
{ while { run } {v2.background_(Color.black);tx2 = (tx2 + rol).wrap(0,550); v2.refresh; (0.03).wait } }.fork(AppClock);

v3.drawFunc = {
var x=0,y=0,n=0,m=0,k=0,t1x,br;
p3=[];
10.do {
5.do{
br=exp(Complex(0,1)*(~controlBus_3.getSynchronous*100)*pi).real.linlin(1.neg,1,0,1);
Pen.fillColor = Color.white.alpha_(br*cos(x*pi));
Pen.strokeColor = Color.white.alpha_(br*cos(x*pi));
t1x=(~controlBus_3.getSynchronous*shift).reciprocal;
Pen.addOval(Rect.aboutPoint(Point((x-tx3+t1x).wrap(0,550),y),sz,sz));
p3=p3++Point((x-tx3+t1x).wrap(0,550),y);
Pen.fillStroke;
y=(y+(10)).wrap(0,50);
};
x=(x+(55)).wrap(0,550);
y=0;
};
x=0;
////////mesh
p3=p3.scramble;
n = 0;m=0;k = 0;
(p3.size).do {
var m = n + 1;
(p3.size - n - 1).do {
Pen.fillColor = Color.white.alpha_(1);
Pen.strokeColor = Color.white.alpha_(1);
Pen.width = (~controlBus_3.getSynchronous).abs*wd;
(if(p3.[n].dist(p3.[m]) < lined){Pen.line( p3.[n], p3.[m])};);
m=m+1;k=k+1;
};n=n+1;
};
Pen.fillStroke;
};
{ while { run } {v3.background_(Color.black);tx3 = (tx3 + rol).wrap(0,550); v3.refresh; (0.03).wait } }.fork(AppClock);

(
~sl1=Knob.new(~vw, Rect.new(50,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1/16,16).round(1/64).postln;
~clock.tempo_(value);
});
~st1=StaticText(~vw,Rect(50,50+sk,sk,sk)).string_("tempo")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',11));
);
(
~sl2=Knob.new(~vw, Rect.new(150,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0,2pi-(2pi/~gold)).round(pi/4).postln;
//~rotation=value;
~rotationz=value;
});
~st2=StaticText(~vw,Rect(150,50+sk,sk,sk)).string_("rz")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',11));
);
(
~sl3=Knob.new(~vw, Rect.new(250,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linexp(0,1,1,~note).round(1).asInteger.postln;
~ssc=value1;
});
~st3=StaticText(~vw,Rect(250,50+sk,sk,sk)).string_("s_range")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',11));
);
(
~sl4=Knob.new(~vw, Rect.new(350,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value2=obj.value.linexp(0,1,1,16256/2).round(1).asInteger.postln;
~sc=value2;
});
~st4=StaticText(~vw,Rect(350,50+sk,sk,sk)).string_("t_range")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',11));
);
(
~sl5=Knob.new(~vw, Rect.new(450,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value2=obj.value.linlin(0,1,1,8).postln;
~rect=value2;
});
~st5=StaticText(~vw,Rect(450,50+sk,sk,sk)).string_("overdrive")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',11));
);
(
~sl6=Knob.new(~vw, Rect.new(50,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linlin(0,1,(16256*4).neg,(16256)).round(1).asInteger.postln;
~drive=value1;
});
~st6=StaticText(~vw,Rect(50,(50+sk+50+25+sk),sk,sk)).string_("drive")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',11));
);
(
~sl7=Knob.new(~vw, Rect.new(150,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linexp(0,1,0.05,0.5).postln;
~s_size=value1;
value2=obj.value.linexp(0,1,80,10).postln;
~lowend=value2;
});
~st7=StaticText(~vw,Rect(150,(50+sk+50+25+sk),sk,sk)).string_("comp")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',11));
);
(
~sl8=Knob.new(~vw, Rect.new(250,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value2=obj.value.linexp(0,1,0.01,1).postln;
~attack=value2;
});
~st8=StaticText(~vw,Rect(250,(50+sk+50+25+sk),sk,sk)).string_("attack")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',11));
);
(
~sl9=Knob.new(~vw, Rect.new(350,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linexp(0,1,1,8).postln;
~decay=value1;
});
~st9=StaticText(~vw,Rect(350,(50+sk+50+25+sk),sk,sk)).string_("decay")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',11));
);
(
~sl10=Knob.new(~vw, Rect.new(450,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linlin(0,1,0,2pi-(2pi/~silver)).round(pi/4).postln;
~incr1=value1;
~rotationx=value1;
});
~st10=StaticText(~vw,Rect(450,(50+sk+50+25+sk),sk,sk)).string_("rx")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',11));
);
(
~sl11=Knob.new(~vw, Rect.new(50,(50+sk+50+sk+25+25+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value2=obj.value.linlin(0,1,0,pi-(pi/~silver)).round(pi/4).postln;
~incr2=value2;
~rotationy=value2;
});
~st11=StaticText(~vw,Rect(50,(50+sk+50+sk+25+25+sk+50),sk,sk)).string_("ry")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',11));
);
(
~s12=Knob.new(~vw, Rect.new(150,(50+sk+50+sk+25+25+50), sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0,16256*3).round(1).asInteger.postln;
~c=value;
});
~st12=StaticText(~vw,Rect(150,(50+sk+50+sk+25+25+sk+50),sk,sk)).string_("fund")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',11));
);
(
~sl13=Knob.new(~vw, Rect.new(250,(50+sk+50+sk+25+25+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.001,2pi).postln;
~gain=value;
});
~st13=StaticText(~vw,Rect(250,(50+sk+50+sk+25+25+sk+50),sk,sk)).string_("gain")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',11));
);
(
~sl14=Knob.new(~vw, Rect.new(350,(50+sk+50+sk+25+25+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.01,1).postln;
~room=value;
});
~st14=StaticText(~vw,Rect(350,(50+sk+50+sk+25+25+sk+50),sk,sk)).string_("revroom")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',11));
);
(
~sl15=Knob.new(~vw, Rect.new(450,(50+sk+50+sk+25+25+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.01,1).postln;
~mix=value;
});
~st15=StaticText(~vw,Rect(450,(50+sk+50+sk+25+25+sk+50),sk,sk)).string_("revmix")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',11));
);
(
~sl16=Knob.new(~vw, Rect.new(50,(50+sk+50+sk+25+25+sk+50+sk+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1.01,1000).postln;
~fuse1=value;
});
~st16=StaticText(~vw,Rect(50,(50+sk+50+sk+25+25+sk+50+sk+50+sk),sk,sk)).string_("fuse1")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',11));
);
(
~s117=Knob.new(~vw, Rect.new(150,(50+sk+50+sk+25+25+sk+50+sk+50), sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1.01,1000).postln;
~fuse2=value;
});
~s117=StaticText(~vw,Rect(150,(50+sk+50+sk+25+25+sk+50+sk+50+sk),sk,sk)).string_("fuse2")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',11));
);
(
~s118=Knob.new(~vw, Rect.new(250,(50+sk+50+sk+25+25+sk+50+sk+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,16256,1).postln;
~fuse=value;
});
~s118=StaticText(~vw,Rect(250,(50+sk+50+sk+25+25+sk+50+sk+50+sk),sk,sk)).string_("fuse")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',11));
);
(
~s119=Knob.new(~vw, Rect.new(350,(50+sk+50+sk+25+25+sk+50+sk+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,1,4).round(1).postln;
~harm=value;
});
~s119=StaticText(~vw,Rect(350,(50+sk+50+sk+25+25+sk+50+sk+50+sk),sk,sk)).string_("harm")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',11));
);
(
~sl20=Knob.new(~vw, Rect.new(450,(50+sk+50+sk+25+25+sk+50+sk+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0,pi).postln;
~mod=value;
});
~sl20=StaticText(~vw,Rect(450,(50+sk+50+sk+25+25+sk+50+sk+50+sk),sk,sk)).string_("~mod")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',11));
);
}.defer
);
)
}); Tdef(\drone).play;
}
)




