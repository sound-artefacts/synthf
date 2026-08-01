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
~controlBus_4 = Bus.control(s, 1);
~controlBus_5 = Bus.control(s, 1);
~controlBus_6 = Bus.control(s, 1);
~timbr_dur=(1/16);
~controlBus_x = Bus.control(s, 1);
~controlBus_y = Bus.control(s, 1);
~controlBus_z = Bus.control(s, 1);
s.waitForBoot{
Tdef(\drone, {

(
~sph=Spherical(pi,0,0.5pi.rand2);
{Out.kr(~controlBus_x.index,SinOsc.kr(0.01,~sph.x,pi))}.play;
{Out.kr(~controlBus_y.index,SinOsc.kr(0.01,~sph.y,pi))}.play;
{Out.kr(~controlBus_z.index,SinOsc.kr(0.01,~sph.z,pi))}.play;
);
////////////////////////////////////////////////////////////////////////////////////////// wavetable, scales, space,timbre///////////////////////////////////////
(
{
var az1=0,el1=0,az2=0,el2=0,angle=0;
var silver_r=(1+2.sqrt), g=((1+5.sqrt)/2), azimuth, elevation;

~azth=[]; ~elth=[];

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

    ~azth = ~azth ++ azimuth;
    ~elth = ~elth ++ elevation;

    az1=0; el1=0;
    az2=0; el2=0;
};
}.value;
);

~vertices = 32*32;
~count=[1,1,2,4,4,4];
~set=(~count.[0]*~count.[1]*~count.[2]*~count.[3]*~count.[4]*~count.[5]);
~fuse1=1;~fuse2=1;~harm=1;~mod=0;~fuse=1000;
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

~rotation=1;~rotationx=0;~rotationy=0;~rotationz=0;~rx=0;~ry=0;~rz=0;~rotationx1=0;~rotationy1=0;~rotationz1=0;
~azr=[];~elr=[];~magx=[];~magy=[];~magz=[];~qx=[];
~cx = [];~cy = [];~cz = [];
//g=7;s=7;
~tree= Routine({loop{
scale=~fuse;
scale1=~fuse1;
scale2=~fuse2;
harm=~harm;
anglex=~controlBus_x.getSynchronous;
angley=~controlBus_y.getSynchronous;
anglez=~controlBus_z.getSynchronous;
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
theta = ~azr[i];
phi = ~elr[i];
wave = amp*sin((waveFreq * theta) + (waveFreq * phi )- waveSpeed);
val * wave;
};
~magyb = ~magy.collect { |val, i|
theta = ~azr[i];
phi = ~elr[i];
wave = amp*sin((waveFreq * theta) + (waveFreq * phi )- waveSpeed);
val * wave;
};
~magzb = ~magz.collect { |val, i|
theta = ~azr[i];
phi = ~elr[i];
wave = amp*sin((waveFreq * theta) + (waveFreq * phi )- waveSpeed);
val * wave;
};
);

n=0;
~set.do{
var az, el,rr;
var x, y, z,rot,mag=1;

az = ~azr.[n];
el = ~elr.[n];
mag=1;
mag=Cartesian(~magx.[n],~magy.[n],~magz.[n]).rho;
rr=Spherical(1,az,el).rotateYZ(0.5pi);
rot=Spherical(mag,rr.theta,rr.phi).rotateYZ(~rx).rotateXZ(~ry).rotateXY(~rz);
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
0.1.wait;
(
{var sph,rot;
Routine({loop{

//sph=Cartesian(~rotationx,~rotationy,~rotationz);
//rot=Spherical(0.01,sph.theta,sph.phi);
/*(
~rx=(~rx +rot.x).wrap(0,2pi);
~ry=(~ry +rot.y).wrap(0,2pi);
~rz=(~rz +rot.z).wrap(0,2pi);
)*/
(
~rx=(~rx +(~rotationx1)).wrap(0,2pi);
~ry=(~ry +(~rotationy1)).wrap(0,2pi);
~rz=(~rz +(~rotationz1)).wrap(0,2pi);
);
(~timbr_dur).wait; // frame duration
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
~n=1.neg;~array=16256.collect{~n=~n+1;2.pow(~n/16256)};
~n=(0-(2pi/16256)); ~ph=16256.collect{~n=~n+(2pi/16256);};
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
~note=(5*5);
~note10=(5*5);
~num=[0,0,5,7,12,17,19,24,29,31,48,53,55,96];
//~note=13;
(
{
var nn=1.neg;
~scale=~note.collect{nn=nn+1;Scale.dorian.performDegreeToKey(nn,12)};
}.value;
);
~octaves=3;
(
{
var nn=1.neg,scale1,scale2;
~scale1=~note10.collect{nn=nn+1;Scale.minorPentatonic.performDegreeToKey(nn,12)};
nn=1.neg;
~scale2=~note10.collect{nn=nn+1;Scale.majorPentatonic.performDegreeToKey(nn,12)};
//~scale10=[scale1,scale2];
~scale10=[~scale1,~scale2];
}.value;
);
);

////spat
~az=[0pi,0.25pi,0.75pi.neg,pi];
~el=[0.125pi,0.125pi,0.125pi,0.125pi];
(
~az=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
		0.1.wait;
/////////////////////////////////////////////////////////////////////////////////////////////////////sound
(
SynthDef.new(\synth,{
arg gain=1,lowend=20,s_size=1,room=1,drive=0,au=0,sb=0,mag1=1,elosc=1,
c=0,timbr=1,az=0,el=0,dicay=2,attack=2,sc=20,ssc=1,mix=0,rect=16,s1,s2,s3,s4,
busArray = #[0,1,2,3],dist=1,harm=1,rx=0,ry=0,rz=0,mrange=1,lim=1;
var fund,fu=32,n=0,mod_x,mod_y,mod_z,phasex,phasey,phasez,low=0,tremolo=32;
var freq1,freq2,freq3,amp1,amp2,amp3,sig1,sig2,sig3,heavy,pen;
var b_x,b_y,b_z,polytope,env,expansion,sph1,sph2,envf,pan,pan11,pan22,pan33,pan44;
var g_ch1,g_ch2,g_ch3,g_ch4,mp,mps,mpf,x,y,z,mag_x,mag_y,mag_z,cm,cm1,cm2;
var s_x,s_y,s_z,threshold,c1,c2,c3,mp_x,mp_y,mp_z,mps_x,mps_y,mps_z,mpf_x,mpf_y,mpf_z;
var peak, times,signal,rip,enva,key,attackLen,sustainLen,decayLen,tx,ty,tz,view;
var vanish=2,perspective,revm,rot,r1,r2,r3,th,ph,aaz,eel,rrr,select,pan1,pan2,pan3,pan4,xc,yc,zc;
var synthx,synthy,freq;

//envf=EnvGen.ar(Env.new([0,0,pi,pi,2pi],[(dicay/2),(attack/2),(dicay/2),(attack/2)]),doneAction:0);
gain=gain*harm.reciprocal;
gain=gain*50;

signal = Signal.sineFill(~signalSizee, ~arraye, [0]);
signal = signal.rotate(signal.size div: 2);
peak = signal.abs.maxIndex.max(1);
rip = Env.perc(0.5,0.5).asSignal(~signalSizee);
rip = rip * (1 + (signal / tremolo));
rip = rip.normalize;
peak = peak.min(signal.size - 2).max(1);
times =Array.fill(peak, attack / peak) ++ Array.fill(signal.size - peak - 1, dicay / (signal.size - peak - 1));
enva = Env(rip.asArray, times);
env = EnvGen.ar(enva,doneAction:2)*gain;
//env = EnvGen.ar(Env.perc(attack,dicay,gain),doneAction:2);

expansion=2.pow(c.lag(0.01)/16256);
fund=(fu*(9/8))*expansion;
heavy=2.pow(drive.lag(0.01)/16256);

select=Spherical(~vertices,az,el);
//rrr=Spherical(pi,0.5pi,0.125pi);
rrr=Spherical(pi,Select.kr(select.x.abs.round(1),~azth),Select.kr(select.x.abs.round(1),~elth));

r1 = SinOsc.kr(rx.lag(0.1),rrr.x,mul:pi);
r2 = SinOsc.kr(ry.lag(0.1),rrr.y,mul:pi);
r3 = SinOsc.kr(rz.lag(0.1),rrr.z,mul:1);

//pan=LFNoise1.ar(elosc,pi);
pan=((r1+r2)*r3)/mix.reciprocal/2pi;
pan=pan.abs;
pan1=SinOsc.ar(pan,~az.[0]).range(pi.neg,pi).lag(0.01);
pan2=SinOsc.ar(pan,~az.[1]).range(pi.neg,pi).lag(0.01);
pan3=SinOsc.ar(pan,~az.[2]).range(pi.neg,pi).lag(0.01);
pan4=SinOsc.ar(pan,~az.[3]).range(pi.neg,pi).lag(0.01);
pan11=SinOsc.ar(pan,~el.[0]).range(0.5pi.neg,0.5pi).lag(0.01);
pan22=SinOsc.ar(pan,~el.[1]).range(0.5pi.neg,0.5pi).lag(0.01);
pan33=SinOsc.ar(pan,~el.[2]).range(0.5pi.neg,0.5pi).lag(0.01);
pan44=SinOsc.ar(pan,~el.[3]).range(0.5pi.neg,0.5pi).lag(0.01);

//aaz = (r1+r2).wrap(pi.neg,pi);
//eel = r3.lag(0.1);

th=(az*r3.lag(0.01)).wrap(pi.neg,pi);
ph=(el*r3.lag(0.01)).wrap(0.5pi.neg,0.5pi);

//th=az.lag(0.01);
//ph=el.lag(0.01);

x = (harm*cos(ph)*cos(th))+(cos(harm*ph)*cos(harm*th));
y = (harm*cos(ph)*sin(th))+(cos(harm*ph)*sin(harm*th));
z = (harm*sin(ph))+(sin(harm*ph));

xc = (harm*cos(el)*cos(az))+(cos(harm*ph)*cos(harm*az));
yc = (harm*cos(el)*sin(az))+(cos(harm*ph)*sin(harm*az));
zc = (harm*sin(el))+(sin(harm*el));

///osc
mp_x = (sc)  * x;
mp_y = (sc)  * y;
mp_z = (sc)  * z;

mps_x = (ssc) * xc;
mps_y = (ssc) * yc;
mps_z = (ssc) * zc;


mpf_x =pi* x;
mpf_y =pi* y;
mpf_z =pi* z;

//key=~num;
key=~scale;

b_x=2.pow(mp_x.round(1)/16256);
b_y=2.pow(mp_y.round(1)/16256);
b_z=2.pow(mp_z.round(1)/16256);

s_x=2.pow(Select.kr(mps_x.round(1).abs,key).asInteger /12);
s_y=2.pow(Select.kr(mps_y.round(1).abs,key).asInteger /12);
s_z=2.pow(Select.kr(mps_z.round(1).abs,key).asInteger /12);

freq1=(fund)*b_x*s_x;
freq2=(fund)*b_y*s_y;
freq3=(fund)*b_z*s_z;

amp1=b_x.reciprocal*expansion.reciprocal*s_x.reciprocal;
amp2=b_y.reciprocal*expansion.reciprocal*s_y.reciprocal;
amp3=b_z.reciprocal*expansion.reciprocal*s_z.reciprocal;

view=harm/dist;
perspective = view / (view + z + (view/vanish));
revm=perspective.linlin(0,0.5,0,1);

//phasex=(Complex(1,mod_x).theta*2)+envf;
//phasey=(Complex(1,mod_y).theta*2)+envf;
//phasez=(Complex(1,mod_z).theta*2)+envf;
//phasex=atan2(mod_x,mod_y);
//phasey=atan2(mod_y,mod_z);
//phasez=atan2(mod_z,mod_x);
phasex=mpf_x;
phasey=mpf_y;
phasez=mpf_z;

c1=FreeVerb.ar(BPF.ar((Osc.ar(~wt.bufnum,freq1,phase:phasex,mul:1200).abs*
SinOsc.ar(freq1,phase:phasex)),freq1,heavy,amp1),revm,room);
c2=FreeVerb.ar(BPF.ar((Osc.ar(~wt.bufnum,freq2,phase:phasey,mul:1200).abs*
SinOsc.ar(freq2,phase:phasey)),freq2,heavy,amp2),revm,room);
c3=FreeVerb.ar(BPF.ar((Osc.ar(~wt.bufnum,freq3,phase:phasez,mul:1200).abs*
SinOsc.ar(freq3,phase:phasez)),freq3,heavy,amp3),revm,room);

////rectifier
sig1=((((SinOsc.ar(freq1*(rect*2),phase:phasex,mul:amp1)).abs+(amp1))*
(SinOsc.ar(freq1*(rect),phase:phasex,mul:amp1))).abs+(amp1))*c1*5;
sig2=((((SinOsc.ar(freq2*(rect*2),phase:phasey,mul:amp2)).abs+(amp2))*
(SinOsc.ar(freq2*(rect),phase:phasey,mul:amp2))).abs+(amp2))*c2*5;
sig3=((((SinOsc.ar(freq3*(rect*2),phase:phasez,mul:amp3)).abs+(amp3))*
(SinOsc.ar(freq3*(rect),phase:phasez,mul:amp3))).abs+(amp3))*c3*5;

///distortion

//sig1=(sig1*mix.linexp(0,1,0.5,pi)).fold2(mrange);
//sig2=(sig2*mix.linexp(0,1,0.5,pi)).fold2(mrange);
sig3=(sig3*mix.linexp(0,1,0.5,pi)).fold2(mrange);


//////propagation
sig1=sig1*mp_x.sign*perspective;
sig2=sig2*mp_y.sign*perspective;
sig3=sig3*mp_z.sign;

///spectral compensation
//sig1=BRF.ar(c1,freq1/2,heavy);
//sig2=BRF.ar(c2,freq2/2,heavy);
//sig3=BRF.ar(c3,freq3/2,heavy);
//sig1=BRF.ar(c1,freq1*4,heavy);
//sig2=BRF.ar(c2,freq2*4,heavy);
//sig3=BRF.ar(c3,freq3*4,heavy);


////spherical harmonics
mag_x=((Complex(cos(az*harm),cos(az*harm)).rho/(2.sqrt))*(Complex(cos(el),cos(el)).rho/(2.sqrt)));
mag_y=((Complex(sin(az*harm),sin(az*harm)).rho/(2.sqrt))*(Complex(cos(el),cos(el)).rho/(2.sqrt)));
mag_z=(Complex(sin(el*harm),sin(el*harm)).rho/(2.sqrt));

c1=c1*mag_x;
c2=c2*mag_y;
c3=c3*mag_z;

/////compresion
sig1=Limiter.ar(HPF.ar(sig1,lowend),lim);
sig2=Limiter.ar(HPF.ar(sig2, lowend),lim);
sig3=Limiter.ar(HPF.ar(sig3, lowend),lim);

threshold=(((343/s_size)/fund).reciprocal.ampdb/2.sqrt).dbamp;
sig1=Compander.ar(sig1,c1,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);
sig2=Compander.ar(sig2,c2,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);
sig3=Compander.ar(sig3,c3,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);

/////spat

(
g_ch1=
(c1.abs.range(0.001,1)*cos(ph+pan11)*cos((th+pan1).wrap(pi.neg,pi))*
c1.range(0.001,1)*cos(~el.[0])*cos(~az.[0]))
+
(c2.abs.range(0.001,1)*cos(ph+pan11)*sin((th+pan1).wrap(pi.neg,pi))*
 c2.range(0.001,1)*cos(~el.[0])*sin(~az.[0]))
+
(c3.abs.range(0.001,1)*sin(ph+pan11)*
 c3.range(0.001,1)*sin(~el.[0]));

g_ch2=
(c1.abs.range(0.001,1)*cos(ph+pan22)*cos((th+pan2).wrap(pi.neg,pi))*
 c1.range(0.001,1)*cos(~el.[1])*cos(~az.[1]))
+
(c2.abs.range(0.001,1)*cos(ph+pan22)*sin((th+pan2).wrap(pi.neg,pi))*
 c2.range(0.001,1)*cos(~el.[1])*sin(~az.[1]))
+
(c3.abs.range(0.001,1)*sin(ph+pan22)*
 c3.range(0.001,1)*sin(~el.[1]));

g_ch3=
(c1.abs.range(0.001,1)*cos(ph+pan33)*cos((th+pan3).wrap(pi.neg,pi))*
 c1.range(0.001,1)*cos(~el.[2])*cos(~az.[2]))
+
(c2.abs.range(0.001,1)*cos(ph+pan33)*sin((th+pan3).wrap(pi.neg,pi))*
 c2.range(0.001,1)*cos(~el.[2])*sin(~az.[2]))
+
(c3.abs.range(0.001,1)*sin(ph+pan33)*
 c3.range(0.001,1)*sin(~el.[2]));

g_ch4=
(c1.abs.range(0.001,1)*cos(ph+pan44)*cos((th+pan4).wrap(pi.neg,pi))*
 c1.range(0.001,1)*cos(~el.[3])*cos(~az.[3]))
+
(c2.abs.range(0.001,1)*cos(ph+pan44)*sin((th+pan4).wrap(pi.neg,pi))*
 c2.range(0.001,1)*cos(~el.[3])*sin(~az.[3]))
+
(c3.abs.range(0.001,1)*sin(ph+pan44)*
 c3.range(0.001,1)*sin(~el.[3]));
);


////pan
//Out.ar(busArray.[0],LeakDC.ar(sig1*env));
//Out.ar(busArray.[1],LeakDC.ar(sig2*env));

//Out.ar(busArray.[0],LeakDC.ar(sig1*env*g_ch1));
//Out.ar(busArray.[0],LeakDC.ar(sig2*env*g_ch1));
//Out.ar(busArray.[1],LeakDC.ar(sig1*env*g_ch2));
//Out.ar(busArray.[1],LeakDC.ar(sig2*env*g_ch2));
//Out.ar(busArray.[2],LeakDC.ar(sig1*env*g_ch3));
//Out.ar(busArray.[2],LeakDC.ar(sig2*env*g_ch3));
//Out.ar(busArray.[3],LeakDC.ar(sig1*env*g_ch4));
//Out.ar(busArray.[3],LeakDC.ar(sig2*env*g_ch4));

//no pan mono
//Out.ar(busArray.[2],LeakDC.ar(sig3*env*mag_z))
//Out.ar(busArray.[0],LeakDC.ar(sig1*env)/2.sqrt);
//Out.ar(busArray.[0],LeakDC.ar(sig2*env)/2.sqrt);

///synth
synthx=Pulse.ar(freq1,mix.linexp(0,1,0.9999,0.5),env,env)*sig1;
synthy=Pulse.ar(freq2,mix.linexp(0,1,0.9999,0.5),env,env)*sig2;
synthx=(synthx*mix.linexp(0,1,0.5,pi)).fold2(mrange);
synthy=(synthy*mix.linexp(0,1,0.5,pi)).fold2(mrange);

Out.ar(busArray.[0],LeakDC.ar(synthx));
Out.ar(busArray.[1],LeakDC.ar(synthy));

Out.kr(~controlBus_1.index,Amplitude.kr((sig1*env)));
Out.kr(~controlBus_2.index,Amplitude.kr((sig2*env)));
Out.kr(~controlBus_3.index,Amplitude.kr((sig3*env)));

}).add;
);0.1.wait;
////second instrument
(
SynthDef.new(\synthb,{
arg gain=1,lowend=20,s_size=1,room=1,drive=0,au=0,sb=0,mag1=1,elosc=1,
c=0,timbr=1,az=0,el=0,dicay=2,attack=2,sc=20,ssc=1,mix=0,rect=16,s1,s2,s3,s4,
busArray = #[0,1,2,3],dist=1,harm=1,rx=0,ry=0,rz=0,mrange=1,lim=1;
var fund,fu=32,n=0,mod_x,mod_y,mod_z,phasex,phasey,phasez,low=0,tremolo=32;
var freq1,freq2,freq3,amp1,amp2,amp3,sig1,sig2,sig3,heavy,pen;
var b_x,b_y,b_z,polytope,env,expansion,sph1,sph2,envf,pan,pan11,pan22,pan33,pan44;
var g_ch1,g_ch2,g_ch3,g_ch4,mp,mps,mpf,x,y,z,mag_x,mag_y,mag_z,cm,cm1,cm2;
var s_x,s_y,s_z,threshold,c1,c2,c3,mp_x,mp_y,mp_z,mps_x,mps_y,mps_z,mpf_x,mpf_y,mpf_z;
var peak, times,signal,rip,enva,key,attackLen,sustainLen,decayLen,tx,ty,tz,view;
var vanish=2,perspective,revm,rot,r1,r2,r3,th,ph,aaz,eel,rrr,select,pan1,pan2,pan3,pan4,xc,yc,zc;
var synthx,synthy,freq;

//envf=EnvGen.ar(Env.new([0,0,pi,pi,2pi],[(dicay/2),(attack/2),(dicay/2),(attack/2)]),doneAction:0);
gain=gain*harm.reciprocal;
gain=gain*50;

signal = Signal.sineFill(~signalSizee, ~arraye, [0]);
signal = signal.rotate(signal.size div: 2);
peak = signal.abs.maxIndex.max(1);
rip = Env.perc(0.5,0.5).asSignal(~signalSizee);
rip = rip * (1 + (signal / tremolo));
rip = rip.normalize;
peak = peak.min(signal.size - 2).max(1);
times =Array.fill(peak, attack / peak) ++ Array.fill(signal.size - peak - 1, dicay / (signal.size - peak - 1));
enva = Env(rip.asArray, times);
env = EnvGen.ar(enva,doneAction:2)*gain;
//env = EnvGen.ar(Env.perc(attack,dicay,gain),doneAction:2);

expansion=2.pow(c.lag(0.01)/16256);
fund=(fu*(9/8))*expansion;
heavy=2.pow(drive.lag(0.01)/16256);

select=Spherical(~vertices,az,el);
//rrr=Spherical(pi,0.5pi,0.125pi);
rrr=Spherical(pi,Select.kr(select.x.abs.round(1),~azth),Select.kr(select.x.abs.round(1),~elth));

r1 = SinOsc.kr(rx.lag(0.1),rrr.x,mul:pi);
r2 = SinOsc.kr(ry.lag(0.1),rrr.y,mul:pi);
r3 = SinOsc.kr(rz.lag(0.1),rrr.z,mul:1);

//pan=LFNoise1.ar(elosc,pi);
pan=((r1+r2)*r3)/mix.reciprocal/2pi;
pan=pan.abs;
pan1=SinOsc.ar(pan,~az.[0]).range(pi.neg,pi).lag(0.01);
pan2=SinOsc.ar(pan,~az.[1]).range(pi.neg,pi).lag(0.01);
pan3=SinOsc.ar(pan,~az.[2]).range(pi.neg,pi).lag(0.01);
pan4=SinOsc.ar(pan,~az.[3]).range(pi.neg,pi).lag(0.01);
pan11=SinOsc.ar(pan,~el.[0]).range(0.5pi.neg,0.5pi).lag(0.01);
pan22=SinOsc.ar(pan,~el.[1]).range(0.5pi.neg,0.5pi).lag(0.01);
pan33=SinOsc.ar(pan,~el.[2]).range(0.5pi.neg,0.5pi).lag(0.01);
pan44=SinOsc.ar(pan,~el.[3]).range(0.5pi.neg,0.5pi).lag(0.01);

//aaz = (r1+r2).wrap(pi.neg,pi);
//eel = r3.lag(0.1);

th=(az*r3.lag(0.01)).wrap(pi.neg,pi);
ph=(el*r3.lag(0.01)).wrap(0.5pi.neg,0.5pi);

//th=az.lag(0.01);
//ph=el.lag(0.01);

x = (harm*cos(ph)*cos(th))+(cos(harm*ph)*cos(harm*th));
y = (harm*cos(ph)*sin(th))+(cos(harm*ph)*sin(harm*th));
z = (harm*sin(ph))+(sin(harm*ph));

xc = (harm*cos(el)*cos(az))+(cos(harm*ph)*cos(harm*az));
yc = (harm*cos(el)*sin(az))+(cos(harm*ph)*sin(harm*az));
zc = (harm*sin(el))+(sin(harm*el));

///osc
mp_x = (sc)  * x;
mp_y = (sc)  * y;
mp_z = (sc)  * z;

mps_x = (ssc) * xc;
mps_y = (ssc) * yc;
mps_z = (ssc) * zc;


mpf_x =pi* x;
mpf_y =pi* y;
mpf_z =pi* z;

//key=~num;
key=~scale;

b_x=2.pow(mp_x.round(1)/16256);
b_y=2.pow(mp_y.round(1)/16256);
b_z=2.pow(mp_z.round(1)/16256);

s_x=2.pow(Select.kr(mps_x.round(1).abs,key).asInteger /12);
s_y=2.pow(Select.kr(mps_y.round(1).abs,key).asInteger /12);
s_z=2.pow(Select.kr(mps_z.round(1).abs,key).asInteger /12);

freq1=(fund)*b_x*s_x;
freq2=(fund)*b_y*s_y;
freq3=(fund)*b_z*s_z;

amp1=b_x.reciprocal*expansion.reciprocal*s_x.reciprocal;
amp2=b_y.reciprocal*expansion.reciprocal*s_y.reciprocal;
amp3=b_z.reciprocal*expansion.reciprocal*s_z.reciprocal;

view=harm/dist;
perspective = view / (view + z + (view/vanish));
revm=perspective.linlin(0,0.5,0,1);

//phasex=(Complex(1,mod_x).theta*2)+envf;
//phasey=(Complex(1,mod_y).theta*2)+envf;
//phasez=(Complex(1,mod_z).theta*2)+envf;
//phasex=atan2(mod_x,mod_y);
//phasey=atan2(mod_y,mod_z);
//phasez=atan2(mod_z,mod_x);
phasex=mpf_x;
phasey=mpf_y;
phasez=mpf_z;

c1=FreeVerb.ar(BPF.ar((Osc.ar(~wt.bufnum,freq1,phase:phasex,mul:1200).abs*
SinOsc.ar(freq1,phase:phasex)),freq1,heavy,amp1),revm,room);
c2=FreeVerb.ar(BPF.ar((Osc.ar(~wt.bufnum,freq2,phase:phasey,mul:1200).abs*
SinOsc.ar(freq2,phase:phasey)),freq2,heavy,amp2),revm,room);
c3=FreeVerb.ar(BPF.ar((Osc.ar(~wt.bufnum,freq3,phase:phasez,mul:1200).abs*
SinOsc.ar(freq3,phase:phasez)),freq3,heavy,amp3),revm,room);

////rectifier
sig1=((((SinOsc.ar(freq1*(rect*2),phase:phasex,mul:amp1)).abs+(amp1))*
(SinOsc.ar(freq1*(rect),phase:phasex,mul:amp1))).abs+(amp1))*c1*5;
sig2=((((SinOsc.ar(freq2*(rect*2),phase:phasey,mul:amp2)).abs+(amp2))*
(SinOsc.ar(freq2*(rect),phase:phasey,mul:amp2))).abs+(amp2))*c2*5;
sig3=((((SinOsc.ar(freq3*(rect*2),phase:phasez,mul:amp3)).abs+(amp3))*
(SinOsc.ar(freq3*(rect),phase:phasez,mul:amp3))).abs+(amp3))*c3*5;

///distortion

//sig1=(sig1*mix.linexp(0,1,0.5,pi)).fold2(mrange);
//sig2=(sig2*mix.linexp(0,1,0.5,pi)).fold2(mrange);
sig3=(sig3*mix.linexp(0,1,0.5,pi)).fold2(mrange);


//////propagation
sig1=sig1*mp_x.sign*perspective;
sig2=sig2*mp_y.sign*perspective;
sig3=sig3*mp_z.sign;

///spectral compensation
//sig1=BRF.ar(c1,freq1/2,heavy);
//sig2=BRF.ar(c2,freq2/2,heavy);
//sig3=BRF.ar(c3,freq3/2,heavy);
//sig1=BRF.ar(c1,freq1*4,heavy);
//sig2=BRF.ar(c2,freq2*4,heavy);
//sig3=BRF.ar(c3,freq3*4,heavy);


////spherical harmonics
mag_x=((Complex(cos(az*harm),cos(az*harm)).rho/(2.sqrt))*(Complex(cos(el),cos(el)).rho/(2.sqrt)));
mag_y=((Complex(sin(az*harm),sin(az*harm)).rho/(2.sqrt))*(Complex(cos(el),cos(el)).rho/(2.sqrt)));
mag_z=(Complex(sin(el*harm),sin(el*harm)).rho/(2.sqrt));

c1=c1*mag_x;
c2=c2*mag_y;
c3=c3*mag_z;

/////compresion
sig1=Limiter.ar(HPF.ar(sig1,lowend),lim);
sig2=Limiter.ar(HPF.ar(sig2, lowend),lim);
sig3=Limiter.ar(HPF.ar(sig3, lowend),lim);

threshold=(((343/s_size)/fund).reciprocal.ampdb/2.sqrt).dbamp;
sig1=Compander.ar(sig1,c1,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);
sig2=Compander.ar(sig2,c2,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);
sig3=Compander.ar(sig3,c3,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);

/////spat

(
g_ch1=
(c1.abs.range(0.001,1)*cos(ph+pan11)*cos((th+pan1).wrap(pi.neg,pi))*
c1.range(0.001,1)*cos(~el.[0])*cos(~az.[0]))
+
(c2.abs.range(0.001,1)*cos(ph+pan11)*sin((th+pan1).wrap(pi.neg,pi))*
 c2.range(0.001,1)*cos(~el.[0])*sin(~az.[0]))
+
(c3.abs.range(0.001,1)*sin(ph+pan11)*
 c3.range(0.001,1)*sin(~el.[0]));

g_ch2=
(c1.abs.range(0.001,1)*cos(ph+pan22)*cos((th+pan2).wrap(pi.neg,pi))*
 c1.range(0.001,1)*cos(~el.[1])*cos(~az.[1]))
+
(c2.abs.range(0.001,1)*cos(ph+pan22)*sin((th+pan2).wrap(pi.neg,pi))*
 c2.range(0.001,1)*cos(~el.[1])*sin(~az.[1]))
+
(c3.abs.range(0.001,1)*sin(ph+pan22)*
 c3.range(0.001,1)*sin(~el.[1]));

g_ch3=
(c1.abs.range(0.001,1)*cos(ph+pan33)*cos((th+pan3).wrap(pi.neg,pi))*
 c1.range(0.001,1)*cos(~el.[2])*cos(~az.[2]))
+
(c2.abs.range(0.001,1)*cos(ph+pan33)*sin((th+pan3).wrap(pi.neg,pi))*
 c2.range(0.001,1)*cos(~el.[2])*sin(~az.[2]))
+
(c3.abs.range(0.001,1)*sin(ph+pan33)*
 c3.range(0.001,1)*sin(~el.[2]));

g_ch4=
(c1.abs.range(0.001,1)*cos(ph+pan44)*cos((th+pan4).wrap(pi.neg,pi))*
 c1.range(0.001,1)*cos(~el.[3])*cos(~az.[3]))
+
(c2.abs.range(0.001,1)*cos(ph+pan44)*sin((th+pan4).wrap(pi.neg,pi))*
 c2.range(0.001,1)*cos(~el.[3])*sin(~az.[3]))
+
(c3.abs.range(0.001,1)*sin(ph+pan44)*
 c3.range(0.001,1)*sin(~el.[3]));
);


////pan
//Out.ar(busArray.[0],LeakDC.ar(sig1*env));
//Out.ar(busArray.[1],LeakDC.ar(sig2*env));

//Out.ar(busArray.[0],LeakDC.ar(sig1*env*g_ch1));
//Out.ar(busArray.[0],LeakDC.ar(sig2*env*g_ch1));
//Out.ar(busArray.[1],LeakDC.ar(sig1*env*g_ch2));
//Out.ar(busArray.[1],LeakDC.ar(sig2*env*g_ch2));
//Out.ar(busArray.[2],LeakDC.ar(sig1*env*g_ch3));
//Out.ar(busArray.[2],LeakDC.ar(sig2*env*g_ch3));
//Out.ar(busArray.[3],LeakDC.ar(sig1*env*g_ch4));
//Out.ar(busArray.[3],LeakDC.ar(sig2*env*g_ch4));

//no pan mono
//Out.ar(busArray.[2],LeakDC.ar(sig3*env*mag_z))
//Out.ar(busArray.[0],LeakDC.ar(sig1*env)/2.sqrt);
//Out.ar(busArray.[0],LeakDC.ar(sig2*env)/2.sqrt);

///synth
synthx=Pulse.ar(freq1,mix.linexp(0,1,0.9999,0.5),env,env)*sig1;
synthy=Pulse.ar(freq2,mix.linexp(0,1,0.9999,0.5),env,env)*sig2;
synthx=(synthx*mix.linexp(0,1,0.5,pi)).fold2(mrange);
synthy=(synthy*mix.linexp(0,1,0.5,pi)).fold2(mrange);

Out.ar(busArray.[0],LeakDC.ar(synthx));
Out.ar(busArray.[1],LeakDC.ar(synthy));

Out.kr(~controlBus_1.index,Amplitude.kr((sig1*env)));
Out.kr(~controlBus_2.index,Amplitude.kr((sig2*env)));
Out.kr(~controlBus_3.index,Amplitude.kr((sig3*env)));

}).add;
);
1.wait;

/////////////////////////////////////////////////////////////////////////////////////////////////////////sequencer,pattern
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
var m3=1.neg,n=0,bank=4,rhythm=4,time=32.reciprocal,beat=1;
var durx=[],dury=[],durz=[],durx1=[],dury1=[],durz1=[];
var dx=[],dy=[],dz=[],bx,by,bz,durx2,dury2,durz2;

(
~azrth=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~elrth=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);

(
~kol=~vertices.rand;~kol1=~vertices.rand;~kol2=~vertices.rand;~kol3=~vertices.rand;
~azrth=[~azth.[~kol],~azth.[~kol1],~azth.[~kol2],~azth.[~kol3]];
~elrth=[~elth.[~kol],~elth.[~kol1],~elth.[~kol2],~elth.[~kol3]];
);

~dur=[];

bank.do{
   // m1=m2=m3=~vertices.rand;
m1=m1+1;m2=m2+1;m3=m3+1;
    bx=1.collect{
        var az, el, x, y, z;
        az = ~azrth.[m1];
        el = ~elrth.[m1];
        x = beat * cos(el) * cos(az);
        y = beat * cos(el) * sin(az);
        z = beat * sin(el);
        2.pow(x).round(time)};

   by=1.collect{
        var az, el, x, y, z;
        az = ~azrth.[m2];
        el = ~elrth.[m2];
        x = beat * cos(el) * cos(az);
        y = beat * cos(el) * sin(az);
        z = beat * sin(el);
        2.pow(y).round(time)};

    bz=1.collect{
        var az, el, x, y, z;
        az = ~azrth.[m3];
        el = ~elrth.[m3];
        x = beat * cos(el) * cos(az);
        y = beat * cos(el) * sin(az);
        z = beat * sin(el);
        2.pow(z).round(time)};

   // m1=1.neg; m2=1.neg; m3=1.neg;

    dx=dx++bx;
    dy=dy++by;
    dz=dz++bz;

   // bx=[]; by=[]; bz=[];
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
var iter = 5;
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
~gain=1;~drive=0;~c=0;~attack=0.01;~decay=1;~s_size=1;~lowend=20;~room=0;~sscb=26;~pan1=0.001;~pan2=0.001;
~gainb=1;~driveb=0;~cb=0;~attackb=0.01;~decayb=1;~s_sizeb=1;~lowendb=20;~roomb=0;~scb=1;~lim1=1;~lim2=1;
~incr1=0;~incr2=0;~sc=1;~gold=((1+5.sqrt)/2);~silver=(1+2.sqrt);~mixb=0;~rectb=16;~dist1=1;~dist2=1;~mr1=1;~mr2=1;
~incr=0;~ssc=26;~mix=0;~rect=16;~s=0;~azimuth=1;~elevation=1;~azimuth1=1;~elevation1=1;
~alternating=[0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1];~hor=0;~lat=0;~shape1=1;~shape2=1;
//~azar=[];~azar1=[];~elar=[];~elar1=[];~magar1=[];~magar2=[];
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
			//~dur=[1,1,1,1,1,1,1,1,1,1,1,1];
({
var a,b,c,d;
a=[~dur.[0]+~dur.[1]+~dur.[2]];
b=[~dur.[3]+~dur.[4]+~dur.[5]];
c=[~dur.[6]+~dur.[7]+~dur.[8]];
d=[~dur.[9]+~dur.[10]+~dur.[11]];
~durt=a++b++c++d;
}.value);
~clock = TempoClock(1);
~clockb = TempoClock(1);
			~dursum=~dur.sum;
(
{
Routine({loop{
~nn=~set.rand;
(~dursum*3).wait; // frame duration
};
}).play(~clock);
}.defer
);

//~nn=~set.rand;
~seqt= Pseq(~durt ,inf).asStream;
~seqt1= Pseq(~dur ,inf).asStream;
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
//~azar=[];~azar1=[];~elar=[];~elar1=[];~magar1=[];~magar2=[];
x=~nn;
x1=~nn;
//12.do{
//x=~nn.rand;
//x1=x;
px=~cx.[x];
py=~cy.[x];
pz=~cz.[x];
px1=~cx.[x1];
py1=~cy.[x1];
pz1=~cz.[x1];
//~shape1=1;
//~shape2=1;
/*~magar1=~magar1++(Cartesian(~magx.[x],~magy.[x],~magz.[x]).rho/(2.sqrt));
~magar2=~magar2++(Cartesian(~magx.[x1],~magy.[x1],~magz.[x1]).rho/(2.sqrt));
~azar=~azar++Cartesian(px,py,pz).theta;
~elar=~elar++Cartesian(px,py,pz).phi;
~azar1=~azar1++Cartesian(px1,py1,pz1).theta;
~elar1=~elar1++Cartesian(px1,py1,pz1).phi;*/
~shape1=(Cartesian(~magx.[x],~magy.[x],~magz.[x]).rho/(2.sqrt));
~shape2=(Cartesian(~magx.[x1],~magy.[x1],~magz.[x1]).rho/(2.sqrt));
~azimuth=Cartesian(px,py,pz).theta;
~elevation=Cartesian(px,py,pz).phi;
~azimuth1=Cartesian(px1,py1,pz1).theta;
~elevation1=Cartesian(px1,py1,pz1).phi;
//};
(~timbr_dur).wait; // frame duration
};
}).play(~clock);
}.defer
);
/*(
{
var n1=1.neg,timbr;
Routine({loop{
~timbrsm=~magar1;
~timbrsm1=~magar2;
~timbrsa=~azar1;
~timbrsa1=~azar1;
~timbrse=~elar;
~timbrse1=~elar1;
(~dursum).wait; // frame duration
};
}).play(~clock);
}.defer
)*/

/*(
{
var n1=1.neg,timbr;
Routine({loop{
n1=(n1+1).wrap(0,11);
timbr=Spherical(~timbrsm.[n1],~timbrsa.[n1],~timbrse.[n1]);
~azimuth=timbr.theta;
~elevation=timbr.phi;
~shape1=timbr.rho;
(~seqt1.next).wait; // frame duration
};
}).play(~clock);
}.defer
)*/
/*(
{
var n1=1.neg,timbr;
Routine({loop{
n1=(n1+1).wrap(0,11);
timbr=Spherical(~timbrsm1.[n1],~timbrsa1.[n1],~timbrse1.[n1]);
~azimuth1=timbr.theta;
~elevation1=timbr.phi;
~shape2=timbr.rho;
(~seqt1.next).wait; // frame duration
};
}).play(~clock);
}.defer
)*/

~pattern = Pdef(\1,
Pbind(\instrument, \synth,
\dur, Pseq(~dur ,inf),\s_size,Pfunc { ~s_size }, \lowend,Pfunc { ~lowend }, \room,Pfunc { ~room },
\gain,Pfunc { ~gain }, \sc, Pfunc { ~sc },\drive, Pfunc { ~drive },\dist, Pfunc { ~dist1 },
\au,Pseq([0,1,4,3,6,5,9],inf),\sb,Pseq(~alternating,inf),\elosc, Pfunc { ~pan1 },
\c, Pfunc { ~c },\mix, Pfunc{~mix},\rect,Pfunc{~rect},\mag1,Pfunc{~shape1},
\az, Pfunc{ ~azimuth},\el,Pfunc{ ~elevation},\harm,Pfunc{ ~harm},\rx,Pfunc{~rotationx1},\ry,Pfunc{ ~rotationy1},\rz,Pfunc{ ~rotationz1},\mrange,Pfunc{ ~mr1},\lim,Pfunc{ ~lim1},
\s1,Pfunc{(~vertices-1).rand.round(1).asInteger},\s2,Pfunc{(~vertices-1).rand.round(1).asInteger}
,\s3,Pfunc{(~vertices-1).rand.round(1).asInteger},\s4,Pfunc{(~vertices-1).rand.round(1).asInteger},
\attack,  Pfunc { ~attack }, \dicay, Pfunc { ~decay }, \ssc, Pfunc{~ssc};
));
~pattern.play(~clock);

~patternb =Pdef(\2,
Pbind(\instrument, \synthb,
\dur, Pseq(~dur ,inf),\s_size,Pfunc { ~s_sizeb }, \lowend,Pfunc { ~lowendb }, \room,Pfunc { ~roomb },
\gain,Pfunc { ~gainb }, \sc, Pfunc { ~scb },\drive, Pfunc { ~driveb },\dist, Pfunc { ~dist2},
\au,Pseq([0,1,4,3,6,5,9],inf),\sb,Pseq(~alternating.reverse,inf),\elosc, Pfunc { ~pan2 },
\c, Pfunc { ~cb },\mix, Pfunc{~mixb},\rect,Pfunc{~rectb},\mag1,Pfunc{~shape2},
\az, Pfunc{~azimuth1},\el,Pfunc{~elevation1},\harm,Pfunc{ ~harm},\rx,Pfunc{~rotationx},\ry,Pfunc{ ~rotationy},\rz,Pfunc{ ~rotationz},\mrange,Pfunc{ ~mr2},\lim,Pfunc{ ~lim2},
\s1,Pfunc{(~vertices-1).rand.round(1).asInteger},\s2,Pfunc{(~vertices-1).rand.round(1).asInteger}
,\s3,Pfunc{(~vertices-1).rand.round(1).asInteger},\s4,Pfunc{(~vertices-1).rand.round(1).asInteger},
\attack,  Pfunc { ~attackb }, \dicay, Pfunc { ~decayb }, \ssc, Pfunc{~sscb};
));
//~patternb.play(~clock);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////gui
(
{
var size=550,sk=(size/12),w,rol=0,sz=0.5,wd=3.5,shift=1;
var v1,v2,v3,p1,p2,p3,tx1=2,tx2=2,tx3=2;
var lined=40,run=true,g=((1+5.sqrt)/2);

w = Window("tws", Rect(50, 50, size, size)).front;
~vw1 = UserView(w, Rect(0,0,size,size)).background_(Color.black);
~logView1 = ListView( ~vw1, Rect(0, 0, size, size))
.background_(Color.black).stringColor_(Color.white)
.font_(Font('Arial', 18))
.items_([]);
~logItems1 = List.new;
~log1 = { |msg| {~logItems1.add(msg); if(~logItems1.size > 200) { ~logItems1.removeAt(0);  };
 ~logView1.items_(~logItems1.asArray); ~logView1.value_(~logItems1.size - 1); }.defer;};
//v1 = UserView(w, Rect(0,size,size,100)).background_(Color.black);
//v2 = UserView(w, Rect(0,650,size,100)).background_(Color.black);
//v3 = UserView(w, Rect(0,750,size,100)).background_(Color.black);

/*v1.drawFunc = {
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
{ while { run } {v3.background_(Color.black);tx3 = (tx3 + rol).wrap(0,550); v3.refresh; (0.03).wait } }.fork(AppClock);*/

(
~sl1=Knob.new(~vw1, Rect.new(50,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,1/32,8).round(1/16).postln;
~clock.tempo_(value);
~log1.(value.asString);
});
~st1=StaticText(~vw1,Rect(50,50+sk,sk+20,sk)).string_("tempo")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl2=Knob.new(~vw1, Rect.new(150,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.0001,1).postln;
//~rotation=value;
~rotationz1=value;
~log1.(value.asString);
});
~st2=StaticText(~vw1,Rect(150,50+sk,sk+20,sk)).string_("rz")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl3=Knob.new(~vw1, Rect.new(250,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linexp(0,1,1,~note).round(1).asInteger.postln;
~ssc=value1;
~log1.(value1.asString);
});
~st3=StaticText(~vw1,Rect(250,50+sk,sk+20,sk)).string_("s_range")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl4=Knob.new(~vw1, Rect.new(350,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value2=obj.value.linexp(0,1,1,16256*~octaves).round(1).asInteger.postln;
~sc=value2;
~log1.(value2.asString);
});
~st4=StaticText(~vw1,Rect(350,50+sk,sk+20,sk)).string_("t_range")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl5=Knob.new(~vw1, Rect.new(450,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value2=obj.value.linlin(0,1,1,8).postln;
~rect=value2;
~log1.(value2.asString);
});
~st5=StaticText(~vw1,Rect(450,50+sk,sk+20,sk)).string_("overdrive")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl6=Knob.new(~vw1, Rect.new(50,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linlin(0,1,(16256*4).neg,0).round(1).asInteger.postln;
~drive=value1;
~log1.(value1.asString);
});
~st6=StaticText(~vw1,Rect(50,(50+sk+50+25+sk),sk+20,sk)).string_("drive")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl7=Knob.new(~vw1, Rect.new(150,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linexp(0,1,0.03,0.3).postln;
~s_size=value1;
value2=obj.value.linexp(0,1,100,20).postln;
~lowend=value2;
~lim1=obj.value.linexp(0,1,0.01,1).postln;
~log1.(value2.asString);
});
~st7=StaticText(~vw1,Rect(150,(50+sk+50+25+sk),sk+20,sk)).string_("comp")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl8=Knob.new(~vw1, Rect.new(250,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value2=obj.value.linexp(0,1,0.01,8).postln;
~attack=value2;
~log1.(value2.asString);
});
~st8=StaticText(~vw1,Rect(250,(50+sk+50+25+sk),sk+20,sk)).string_("attack")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl9=Knob.new(~vw1, Rect.new(350,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linexp(0,1,0.01,16).postln;
~decay=value1;
~log1.(value1.asString);
});
~st9=StaticText(~vw1,Rect(350,(50+sk+50+25+sk),sk+20,sk)).string_("decay")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl10=Knob.new(~vw1, Rect.new(450,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linexp(0,1,0.0001,1).postln;
~incr1=value1;
~rotationx1=value1;
~log1.(value1.asString);
});
~st10=StaticText(~vw1,Rect(450,(50+sk+50+25+sk),sk+20,sk)).string_("rx")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl11=Knob.new(~vw1, Rect.new(50,(50+sk+50+sk+25+25+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value2=obj.value.linexp(0,1,0.0001,1).postln;
~incr2=value2;
~rotationy1=value2;
~log1.(value2.asString);
});
~st11=StaticText(~vw1,Rect(50,(50+sk+50+sk+25+25+sk+50),sk+20,sk)).string_("ry")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~s12=Knob.new(~vw1, Rect.new(150,(50+sk+50+sk+25+25+50), sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0,16256*~octaves).round(1).asInteger.postln;
~c=value;
~log1.(value.asString);
});
~st12=StaticText(~vw1,Rect(150,(50+sk+50+sk+25+25+sk+50),sk+20,sk)).string_("fund")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl13=Knob.new(~vw1, Rect.new(250,(50+sk+50+sk+25+25+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.001,2pi).postln;
~gain=value;
~log1.(value.asString);
});
~st13=StaticText(~vw1,Rect(250,(50+sk+50+sk+25+25+sk+50),sk+20,sk)).string_("gain")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl14=Knob.new(~vw1, Rect.new(350,(50+sk+50+sk+25+25+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.01,1).postln;
~room=value;
~log1.(value.asString);
});
~st14=StaticText(~vw1,Rect(350,(50+sk+50+sk+25+25+sk+50),sk+20,sk)).string_("room")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl15=Knob.new(~vw1, Rect.new(450,(50+sk+50+sk+25+25+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.01,1).postln;
~mix=value;
~log1.(value.asString);
});
~st15=StaticText(~vw1,Rect(450,(50+sk+50+sk+25+25+sk+50),sk+20,sk)).string_("fmix")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl16=Knob.new(~vw1, Rect.new(50,(50+sk+50+sk+25+25+sk+50+sk+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1.01,1000).postln;
~fuse1=value;
~log1.(value.asString);
});
~st16=StaticText(~vw1,Rect(50,(50+sk+50+sk+25+25+sk+50+sk+50+sk),sk+20,sk)).string_("fuse1")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~s117=Knob.new(~vw1, Rect.new(150,(50+sk+50+sk+25+25+sk+50+sk+50), sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1.01,1000).postln;
~fuse2=value;
~log1.(value.asString);
});
~s117=StaticText(~vw1,Rect(150,(50+sk+50+sk+25+25+sk+50+sk+50+sk),sk+20,sk)).string_("fuse2")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~s118=Knob.new(~vw1, Rect.new(250,(50+sk+50+sk+25+25+sk+50+sk+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,16256,1);
~fuse=value;
~pan1=obj.value.linexp(0,1,0.00001,20);
~mr1=obj.value.linexp(0,1,100.01,0.05).postln;
~log1.(~mr1.asString);
});
~s118=StaticText(~vw1,Rect(250,(50+sk+50+sk+25+25+sk+50+sk+50+sk),sk+20,sk)).string_("mrange")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~s119=Knob.new(~vw1, Rect.new(350,(50+sk+50+sk+25+25+sk+50+sk+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,1,7).round(1).postln;
~harm=value;
~log1.(value.asString);
});
~s119=StaticText(~vw1,Rect(350,(50+sk+50+sk+25+25+sk+50+sk+50+sk),sk+20,sk)).string_("harm")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl20=Knob.new(~vw1, Rect.new(450,(50+sk+50+sk+25+25+sk+50+sk+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value,v;
value=obj.value.linexp(0,1,100.01,0.01).postln;
~dist1=value;
~log1.(value.asString);
});
~sl20=StaticText(~vw1,Rect(450,(50+sk+50+sk+25+25+sk+50+sk+50+sk),sk+20,sk)).string_("distance")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
}.defer
);
(
{
var size=550,sk=(size/12),w,rol=0,sz=0.5,wd=2,shift=1;
var v1,v2,v3,p1,p2,p3,tx1=2,tx2=2,tx3=2;
var lined=40,run=true,g=((1+5.sqrt)/2);

w = Window("tws2", Rect(650, 50, size, size)).front;
~vw = UserView(w, Rect(0,0,size,size)).background_(Color.black);
~logView2 = ListView( ~vw, Rect(0, 0, size, size))
.background_(Color.black).stringColor_(Color.white)
.font_(Font('Arial', 18))
.items_([]);
~logItems2 = List.new;
~log2 = { |msg| {~logItems2.add(msg); if(~logItems2.size > 200) { ~logItems2.removeAt(0);  };
 ~logView2.items_(~logItems2.asArray); ~logView2.value_(~logItems2.size - 1); }.defer;};
v1 = UserView(w, Rect(0,size,size,100)).background_(Color.black);
v2 = UserView(w, Rect(0,650,size,100)).background_(Color.black);
v3 = UserView(w, Rect(0,750,size,100)).background_(Color.black);

/*v1.drawFunc = {
var x=0,y=0,n=0,m=0,k=0,t1x,br;
p1=[];
10.do {
5.do{
br=exp(Complex(0,1)*(~controlBus_4.getSynchronous*100)*pi).real.linlin(1.neg,1,0,1);
t1x=(~controlBus_4.getSynchronous*shift).reciprocal;
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
Pen.width = (~controlBus_4.getSynchronous).abs*wd;
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
br=exp(Complex(0,1)*(~controlBus_5.getSynchronous*100)*pi).real.linlin(1.neg,1,0,1);
Pen.fillColor = Color.white.alpha_(br*cos(x*pi));
Pen.strokeColor = Color.white.alpha_(br*cos(x*pi));
t1x=(~controlBus_5.getSynchronous*shift).reciprocal;
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
Pen.width = (~controlBus_5.getSynchronous).abs*wd;
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
br=exp(Complex(0,1)*(~controlBus_6.getSynchronous*100)*pi).real.linlin(1.neg,1,0,1);
Pen.fillColor = Color.white.alpha_(br*cos(x*pi));
Pen.strokeColor = Color.white.alpha_(br*cos(x*pi));
t1x=(~controlBus_6.getSynchronous*shift).reciprocal;
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
Pen.width = (~controlBus_6.getSynchronous).abs*wd;
(if(p3.[n].dist(p3.[m]) < lined){Pen.line( p3.[n], p3.[m])};);
m=m+1;k=k+1;
};n=n+1;
};
Pen.fillStroke;
};
{ while { run } {v3.background_(Color.black);tx3 = (tx3 + rol).wrap(0,550); v3.refresh; (0.03).wait } }.fork(AppClock);*/

(
~sl1b=Knob.new(~vw, Rect.new(50,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,1/32,8).round(1/16).postln;
~clock.tempo_(value);
~log2.(value.asString);
});
~st1b=StaticText(~vw,Rect(50,50+sk,sk+20,sk)).string_("tempo")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl2b=Knob.new(~vw, Rect.new(150,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.0001,1).postln;
//~rotation=value;
~rotationz=value;
~log2.(value.asString);
});
~st2b=StaticText(~vw,Rect(150,50+sk,sk+20,sk)).string_("rz")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl3b=Knob.new(~vw, Rect.new(250,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linexp(0,1,1,~note).round(1).asInteger.postln;
~sscb=value1;
~log2.(value1.asString);
});
~st3b=StaticText(~vw,Rect(250,50+sk,sk+20,sk)).string_("s_range")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl4b=Knob.new(~vw, Rect.new(350,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value2=obj.value.linexp(0,1,1,16256*~octaves).round(1).asInteger.postln;
~scb=value2;
~log2.(value2.asString);
});
~st4b=StaticText(~vw,Rect(350,50+sk,sk+20,sk)).string_("t_range")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl5b=Knob.new(~vw, Rect.new(450,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value2=obj.value.linlin(0,1,1,8).postln;
~rectb=value2;
~log2.(value2.asString);
});
~st5b=StaticText(~vw,Rect(450,50+sk,sk+20,sk)).string_("overdrive")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl6b=Knob.new(~vw, Rect.new(50,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linlin(0,1,(16256*4).neg,0).round(1).asInteger.postln;
~driveb=value1;
~log2.(value1.asString);
});
~st6b=StaticText(~vw,Rect(50,(50+sk+50+25+sk),sk+20,sk)).string_("drive")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl7b=Knob.new(~vw, Rect.new(150,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linexp(0,1,0.03,0.3).postln;
~s_sizeb=value1;
value2=obj.value.linexp(0,1,100,20).postln;
~lowendb=value2;
~lim2=obj.value.linexp(0,1,0.01,1).postln;
~log2.(value2.asString);
});
~st7b=StaticText(~vw,Rect(150,(50+sk+50+25+sk),sk+20,sk)).string_("comp")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl8b=Knob.new(~vw, Rect.new(250,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value2=obj.value.linexp(0,1,0.01,8).postln;
~attackb=value2;
~log2.(value2.asString);
});
~st8b=StaticText(~vw,Rect(250,(50+sk+50+25+sk),sk+20,sk)).string_("attack")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl9b=Knob.new(~vw, Rect.new(350,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linexp(0,1,0.01,16).postln;
~decayb=value1;
~log2.(value1.asString);
});
~st9b=StaticText(~vw,Rect(350,(50+sk+50+25+sk),sk+20,sk)).string_("decay")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl10b=Knob.new(~vw, Rect.new(450,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linexp(0,1,0.0001,1).postln;
~incr1=value1;
~rotationx=value1;
~log2.(value1.asString);
});
~st10b=StaticText(~vw,Rect(450,(50+sk+50+25+sk),sk+20,sk)).string_("rx")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl11b=Knob.new(~vw, Rect.new(50,(50+sk+50+sk+25+25+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value2=obj.value.linexp(0,1,0.0001,1).postln;
~incr2=value2;
~rotationy=value2;
~log2.(value2.asString);
});
~st11b=StaticText(~vw,Rect(50,(50+sk+50+sk+25+25+sk+50),sk+20,sk)).string_("ry")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~s12b=Knob.new(~vw, Rect.new(150,(50+sk+50+sk+25+25+50), sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0,16256*~octaves).round(1).asInteger.postln;
~cb=value;
~log2.(value.asString);
});
~st12b=StaticText(~vw,Rect(150,(50+sk+50+sk+25+25+sk+50),sk+20,sk)).string_("fund")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl13b=Knob.new(~vw, Rect.new(250,(50+sk+50+sk+25+25+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.001,2pi).postln;
~gainb=value;
~log2.(value.asString);
});
~st13b=StaticText(~vw,Rect(250,(50+sk+50+sk+25+25+sk+50),sk+20,sk)).string_("gain")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl14b=Knob.new(~vw, Rect.new(350,(50+sk+50+sk+25+25+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.01,1).postln;
~roomb=value;
~log2.(value.asString);
});
~st14b=StaticText(~vw,Rect(350,(50+sk+50+sk+25+25+sk+50),sk+20,sk)).string_("room")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl15b=Knob.new(~vw, Rect.new(450,(50+sk+50+sk+25+25+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.01,1).postln;
~mixb=value;
~log2.(value.asString);
});
~st15b=StaticText(~vw,Rect(450,(50+sk+50+sk+25+25+sk+50),sk+20,sk)).string_("fmix")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl16b=Knob.new(~vw, Rect.new(50,(50+sk+50+sk+25+25+sk+50+sk+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1.01,1000).postln;
~fuse1=value;
~log2.(value.asString);
});
~st16b=StaticText(~vw,Rect(50,(50+sk+50+sk+25+25+sk+50+sk+50+sk),sk+20,sk)).string_("fuse1")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~s117b=Knob.new(~vw, Rect.new(150,(50+sk+50+sk+25+25+sk+50+sk+50), sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1.01,1000).postln;
~fuse2=value;
~log2.(value.asString);
});
~s117b=StaticText(~vw,Rect(150,(50+sk+50+sk+25+25+sk+50+sk+50+sk),sk+20,sk)).string_("fuse2")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~s118b=Knob.new(~vw, Rect.new(250,(50+sk+50+sk+25+25+sk+50+sk+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,16256,1);
~fuse=value;
~pan2=obj.value.linexp(0,1,0.00001,20);
~mr2=obj.value.linexp(0,1,100.01,0.05).postln;
~log2.(~mr2.asString);
});
~s118b=StaticText(~vw,Rect(250,(50+sk+50+sk+25+25+sk+50+sk+50+sk),sk+20,sk)).string_("mrange")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~s119b=Knob.new(~vw, Rect.new(350,(50+sk+50+sk+25+25+sk+50+sk+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,1,7).round(1).postln;
~harm=value;
~log2.(value.asString);
});
~s119b=StaticText(~vw,Rect(350,(50+sk+50+sk+25+25+sk+50+sk+50+sk),sk+20,sk)).string_("harm")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl20b=Knob.new(~vw, Rect.new(450,(50+sk+50+sk+25+25+sk+50+sk+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value,v;
value=obj.value.linexp(0,1,100.01,0.01).postln;
~dist2=value;
~log2.(value.asString);
});
~sl20b=StaticText(~vw,Rect(450,(50+sk+50+sk+25+25+sk+50+sk+50+sk),sk+20,sk)).string_("distance")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
}.defer
);
}); Tdef(\drone).play;
}
)





/////space symmetric, for music keys, timbre or vbap
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////spaces
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////tetrahedron
(
~azimuth=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~elevation=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////cube
(
~azimuth=[45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad];
~elevation=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad];
)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////octahedron
(
~azimuth=[0.degrad,0.degrad,90.degrad,180.degrad,90.neg.degrad,0.degrad];
~elevation=[90.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,90.degrad];
)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////icosahedron
(
~azimuth=[90.degrad,90.neg.degrad,0.degrad,180.degrad,58.28.degrad,121.72.degrad,121.72.neg.degrad,58.neg.degrad,90.degrad,90.neg.degrad,0.degrad,180.degrad];
~elevation=[58.28.neg.degrad,58.28.neg.degrad,31.72.neg.degrad,31.72.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,58.28.degrad,58.28.degrad,31.72.degrad,31.72.degrad];
)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////dodecahedron
(
~azimuth=[45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,90.degrad,90.neg.degrad,0.degrad,180.degrad,45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,90.degrad,
	90.neg.degrad,69.09.degrad,110.91.degrad,110.91.neg.degrad,69.09.neg.degrad,0.degrad,180.degrad];

~elevation=[35.26.neg.degrad,35.26.neg.degrad,35.26.neg.degrad,35.26.neg.degrad,69.09.neg.degrad,69.09.neg.degrad,20.91.neg.degrad,20.91.neg.degrad,
	35.26.degrad,35.26.degrad,35.26.degrad,35.26.degrad,69.09.degrad,69.09.degrad,0.degrad,0.degrad,0.degrad,0.degrad,20.91.degrad,20.91.degrad]
)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////Rhombic dodecahedron
(
~azimuth=[0.degrad,45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,0.degrad,180.degrad,90.degrad,90.neg.degrad,0.degrad,
	45.degrad,135.neg.degrad,135.degrad,45.neg.degrad];
~elevation=[90.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,0.degrad
	,0.degrad,0.degrad,0.degrad,90.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad];
)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////cuboctahedron
(
~azimuth=[0.degrad,90.degrad,180.degrad,90.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,
	0.degrad,90.degrad,180.degrad,90.neg.degrad];
~elevation=[45.neg.degrad,45.neg.degrad,45.neg.degrad,45.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,
	45.degrad,45.degrad,45.degrad,45.degrad];
)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////Rhombic Triacontahedron
(
~azimuth=[0.degrad,0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,
	0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,
	0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,0.degrad];

~elevation=[90.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,52.6.degrad,52.6.degrad,52.6.degrad,52.6.degrad,52.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,10.8.degrad,10.8.degrad,10.8.degrad,10.8.degrad,10.8.degrad,90.degrad];

)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////icosidodecahedron
(
~azimuth=[18.degrad,90.degrad,162.degrad,126.neg.degrad,54.neg.degrad,54.degrad,126.degrad,162.neg.degrad,90.neg.degrad,18.neg.degrad,
	0.degrad,36.degrad,72.degrad,108.degrad,144.degrad,180.degrad,144.neg.degrad,108.neg.degrad,72.neg.degrad,36.neg.degrad,
	54.degrad,126.degrad,162.neg.degrad,90.neg.degrad,18.neg.degrad,18.degrad,90.degrad,162.degrad,126.neg.degrad,54.neg.degrad];

~elevation=[58.283.degrad,58.283.degrad,58.283.degrad,58.283.degrad,58.283.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,
37.717.degrad,37.717.degrad,37.717.degrad,37.717.degrad,37.717.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad];
)*/