///Quarks.install("MathLib");
(
(
s.options.numWireBufs = 1024*16;
s.options.numOutputBusChannels=12;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*256;
s.options.blockSize = 64;
s.options.maxNodes = 8192*2;
Buffer.freeAll;
Window.closeAll;
//s.makeGui(w);
//s.meter;
//s.freqscope;
//s.scope;
);
s.waitForBoot{
Tdef(\drone, {
/////axis array
(
{
var az1=0,el1=0,az2=0,el2=0,angle=0;
var silver_r=(1+2.sqrt), g=((1+5.sqrt)/2), azimuth, elevation;

~azi=[]; ~eli=[];
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
~azi = ~azi ++ azimuth;
~eli = ~eli ++ elevation;
az1=0; el1=0; az2=0; el2=0;
};
}.value;
~vertices = 1024;
);
	1.wait;
////animation buses
(
(
~controlBus_s = Bus.control(s, 1);
~controlBus_s1 = Bus.control(s, 1);
~controlBus_s2 = Bus.control(s, 1);
~controlBus_r = Bus.control(s, 1);
~controlBus_shx = Bus.control(s, 1);
~controlBus_shy = Bus.control(s, 1);
~controlBus_shz = Bus.control(s, 1);
~controlBus_wx = Bus.control(s, 1);
~controlBus_wy = Bus.control(s, 1);
~controlBus_wz = Bus.control(s, 1);
~controlBus_points = Bus.control(s, 1);
~controlBus_sh = Bus.control(s, 1);
~scale=Buffer.alloc(s,2048);
~scale1= Buffer.alloc(s,2048);
~scale2= Buffer.alloc(s,2048);
~rotation= Buffer.alloc(s,2048);
~harmx= Buffer.alloc(s,2048);
~harmy= Buffer.alloc(s,2048);
~harmz= Buffer.alloc(s,2048);
~wx= Buffer.alloc(s,2048);
~wy= Buffer.alloc(s,2048);
~wz= Buffer.alloc(s,2048);
~sh= Buffer.alloc(s,2048);
~ps= Buffer.alloc(s,2048);
);
(
{
var signal,wt;
signal=Env([2000,2000],[1]);
wt = signal.asSignal(1024).asWavetable;
~scale.loadCollection(wt);
//signal.plot;
}.value;
{
var signal,wt;
signal=Env([1,1000,1000],[1,1],[8,0]);
wt = signal.asSignal(1024).asWavetable;
~scale1.loadCollection(wt);
//signal.plot;
}.value;
{
var signal,wt;
signal=Env([1,1,1000],[1,1],[0,8]);
wt = signal.asSignal(1024).asWavetable;
~scale2.loadCollection(wt);
//signal.plot;
}.value;
{
var signal,wt,r;
r=(2pi-(2pi/((1+5.sqrt)/2)));
signal=Env([r/4,0.001,r/8],[1,1],[4.neg,4]);
wt = signal.asSignal(1024).asWavetable;
~rotation.loadCollection(wt);
//signal.plot;
}.value;
{
var signal,wt;
signal=Env([1.5,1.5,10000],[1,1],[128,16]);
wt = signal.asSignal(1024).asWavetable;
~ps.loadCollection(wt);
//signal.plot;
}.value;
{
var signal,wt;
signal=Env([1,2,4],[1,1],[128,128]);
wt = signal.asSignal(1024).asWavetable;
~sh.loadCollection(wt);
//signal.plot;
}.value;
);
(
SynthDef.new(\run,{
arg cor=0;
var p,az,el,f1,f2,f3,f=0.1;
az=Select.kr(cor,~azi);
el=Select.kr(cor,~eli);
p=Spherical(992,az,el);
f1=2.pow(p.x.round(1)/992)*0.1;
f2=2.pow(p.y.round(1)/992)*0.1;
f3=2.pow(p.x.round(1)/992)*0.1;
Out.kr(~controlBus_s.index,(Osc.kr(~scale.bufnum,f).abs));
Out.kr(~controlBus_s1.index,(Osc.kr(~scale1.bufnum,f).abs));
Out.kr(~controlBus_s2.index,(Osc.kr(~scale2.bufnum,f).abs));
Out.kr(~controlBus_r.index,(Osc.kr(~rotation.bufnum,f).abs));
Out.kr(~controlBus_shx.index,(SinOsc.kr(f1,f1.reciprocal*2pi,1).range(pi.neg,pi)));
Out.kr(~controlBus_shy.index,(SinOsc.kr(f2,f2.reciprocal*2pi,1).range(pi.neg,pi)));
Out.kr(~controlBus_shz.index,(SinOsc.kr(f3,f3.reciprocal*2pi,1).range(0.5pi.neg,0.5pi)));
Out.kr(~controlBus_wx.index,(SinOsc.kr(f1,f1.reciprocal*2pi,0.01).range(pi.neg,pi)));
Out.kr(~controlBus_wy.index,(SinOsc.kr(f2,f2.reciprocal*2pi,0.01).range(pi.neg,pi)));
Out.kr(~controlBus_wz.index,(SinOsc.kr(f3,f3.reciprocal*2pi,0.01).range(pi.neg,pi)));
//Out.kr(~controlBus_wx.index,(Amplitude.kr(InFeedback.ar(0)))); ////distribution control array period feedback
//Out.kr(~controlBus_wy.index,(Amplitude.kr(InFeedback.ar(1))));
//Out.kr(~controlBus_wz.index,(Amplitude.kr(InFeedback.ar(2))));
Out.kr(~controlBus_points.index,(Osc.kr(~ps.bufnum,f).abs));
Out.kr(~controlBus_sh.index,(Osc.kr(~sh.bufnum,f).abs));
}).add;
);
);
	1.wait;
////animation routine
~count=[2,2,2,2,2,2];
~animation=Synth.new(\run).register;
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
var theta,phi,wave,anglex,angley,anglez,ratio1,ratio2,ratio3;

~az=[];~el=[];~magx=[];~magy=[];~magz=[];~qx=[];

~tree= Routine({loop{
scale=~controlBus_s.getSynchronous;
scale1=~controlBus_s1.getSynchronous;
scale2=~controlBus_s2.getSynchronous;
rotation=~controlBus_r.getSynchronous;
harm=~controlBus_sh.getSynchronous;
anglex=~controlBus_shx.getSynchronous;
angley=~controlBus_shy.getSynchronous;
anglez=~controlBus_shz.getSynchronous;
//ratio=~controlBus_wx.getSynchronous+~controlBus_wy.getSynchronous+~controlBus_wz.getSynchronous;
ratio1=~controlBus_wx.getSynchronous;
ratio2=~controlBus_wy.getSynchronous;
ratio3=~controlBus_wz.getSynchronous;
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
~az=[];~el=[];~magx=[];~magy=[];~magz=[];~magqx=[];~azimuth=[];~elevation=[];
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
~az=~az++azimuth;
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
~el=~el++elevation;
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
/*(
(~count.[0]*~count.[1]*~count.[2]*~count.[3]*~count.[4]*~count.[5]).do{
az=~az.[pla];
el=~el.[pla];
mag=(Cartesian(~magx.[pla],~magy.[pla],~magz.[pla]).rho)/2.sqrt;
pla=pla+1;
sph=Spherical((mag+scale.rand).wrap(1,mag),az,el).asCartesian;
sph=sph.rotateYZ(0.5pi).asSpherical;
~azimuth=~azimuth++[sph.theta];
~elevation=~elevation++[sph.phi];
})*/
(0.03).wait;
};};
);
}.value
);
	1.wait;
~tree.play;

//lining
/*(
(
~controlBusx = Bus.control(s, 1);
~controlBusy = Bus.control(s, 1);
~controlBusz = Bus.control(s, 1);
);
(
SynthDef.new(\coo,{
arg cor=0;
var p,az,el,f1,f2,f3;
/*az=Select.kr(cor,~az);
el=Select.kr(cor,~el);
p=Spherical(992,az,el);
f1=2.pow(p.x.round(1)/992)*1;
f2=2.pow(p.y.round(1)/992)*1;
f3=2.pow(p.x.round(1)/992)*1;*/
Out.kr(~controlBusx.index, InFeedback.ar(0));
Out.kr(~controlBusy.index, InFeedback.ar(1));
Out.kr(~controlBusz.index, InFeedback.ar(2));
}).add;
);///line data in routine
/*(
{
~thread=Synth(\coo);
Routine({loop{
	~thread.set(\cor,~az.size.rand);
        (0.01).wait; // frame duration
};
}).play;
}.defer
);*/*/
//////l-system thread
/*({
var dict = IdentityDictionary[\A -> "AB", \B -> "A"];
//These are the production rules of the L-system
var word = "A";
var string_temp = "";
var iter = 18;
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
~lseq.size;////check for sequence size >= vertices count
4.do{~lseq=~lseq*~lseq.size.collect{2.rand}};
}.value);*/
(
{
Routine({loop{
	~animation.set(\cor,~vertices.rand);
        (5).wait; // frame duration
};
}).play;
}.defer
);

///image plotter
({
var w,u,size=1000,diameter=400,n=0,m=0,k=0;
var r_az = 0.0,r_el = 0.0,az,el,cp,protaz,protel;
var point,perspective,dist=400,depth=2,mag=1;
var rx = 0.0,ry = 0.0,rz = 0.0,rate=0.01;
var plane,pointx,pointy;
var d_o=1,lined=8,run = true,tilt=0.15pi;
var wave=25,sph;
~vertice=(~count.[0]*~count.[1]*~count.[2]*~count.[3]*~count.[4]*~count.[5]);
w = Window("3d Plotter", Rect(100,100,size,size));
v = UserView(w, w.view.bounds).background_(Color.black);
v.drawFunc = {
Pen.translate(v.bounds.width/2,v.bounds.height/2);
///Pen.scale(0.5, 2);
~point_cloud=[];
d_o=~controlBus_points.getSynchronous;
n=0;
(~vertice).do {
az=~az.[n];el=~el.[n];
mag=(Cartesian(~magx.[n],~magy.[n],~magz.[n]).rho/(2.sqrt));
///mag=(Cartesian(~magx.[n],~magy.[n],~magz.[n]).rho/(2.sqrt))+(Cartesian(~qx.[n],~qy.[n],0).rho/(2.sqrt));
///cloud assignment and distortion
protaz=(az + r_az).wrap(pi.neg,pi);
protel=(el + r_el).wrap(0.5pi.neg,0.5pi);
point = Spherical(diameter*mag,protaz,protel).asCartesian;
///rotations
point=point.rotateYZ(rx).rotateXZ(ry).rotateXY(rz);
//point=point.rotateYZ(tilt);
//////remaping
plane=Complex(point.x,point.y);
cp=Polar(point.z,plane.theta);
cp=point;
////////////////////perspective
perspective = dist / (dist + point.z + (dist/depth));///remove (dist/2) for no depth
///color
Pen.width = perspective.clip(2,1.0)*d_o/wave;
Pen.fillColor = Color.white.alpha_(perspective.clip(0.1,1.0));
Pen.strokeColor = Color.white.alpha_(perspective.clip(0.1,1.0));
//Pen.strokeColor = Color.new(0.999.rand,0.999.rand,0.999.rand);
//////points
pointx=cp.x*perspective;
pointy=cp.y*perspective;
~point_cloud=~point_cloud++Point(pointx,pointy);
///point_oval
Pen.addOval(Rect.aboutPoint(Point(pointx,pointy),d_o*perspective,d_o*perspective));
///rectangle
//Pen.addRect(Rect.aboutPoint(Point(pointx,pointy),d_o*perspective*,d_o*perspective*));
Pen.fillStroke;
n=n+1;
};
n=0;
////////mesh
(
n = 0;m=0;k = 0;
(~point_cloud.size).do {
var m = n + 1;
(~point_cloud.size - n - 1).do {
Pen.width = perspective.clip(2,1.0)*d_o/wave;
Pen.fillColor = Color.white.alpha_(perspective.clip(0.1,1.0));
Pen.strokeColor = Color.white.alpha_(perspective.clip(0.1,1.0));
///sequence exclusion
//compound exclusion, based on sequence and point distance
//if( (~lseq.[k] == 0) and: { ~point_cloud[n].dist(~point_cloud[m]) < (diameter/lined) }) {Pen.line( ~point_cloud.[n], ~point_cloud.[m])};
//automaton threading
/*~sseq=((~controlBusx.getSynchronous*
~controlBusz.getSynchronous)+(~controlBusy.getSynchronous*
~controlBusz.getSynchronous)).round(rate);*/
/*(if( (~sseq == 0) and: { ~point_cloud[n].dist(~point_cloud[m]) < (diameter/lined) })
{Pen.line( ~point_cloud.[n], ~point_cloud.[m])};);*/
(if(~point_cloud[n].dist(~point_cloud[m]) < lined)
{Pen.line( ~point_cloud.[n], ~point_cloud.[m])};);
Pen.fillStroke;
//~c_dsitance=~point_cloud.[n].dist(~point_cloud.[m]);
m=m+1;k=k+1
};n=n+1;
};
)
};
{ while { run } {v.background_(Color.black); v.refresh; (0.01).wait } }.fork(AppClock);
w.front;
Routine({
inf.do {
r_az = r_az + 0;
r_el = r_el + 0;
(
rx=(rx +~controlBus_r.getSynchronous).wrap(0,2pi);
ry=(ry +~controlBus_r.getSynchronous).wrap(0,2pi);
rz=(rz +~controlBus_r.getSynchronous).wrap(0,2pi);
);
{v.refresh}.defer;
(1/8).wait;
};
}).play;
}.defer)
}); Tdef(\drone).play;
}
)




































/////sound
/*///Quarks.install("MathLib");
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
(
{
var az1=0,el1=0,az2=0,el2=0,angle=0;
var silver_r=(1+2.sqrt), g=((1+5.sqrt)/2), azimuth, elevation;
var nn=1.neg, n=0;
var difaz, difel,rx=0,ry=0,rz=0;
~vertices = 32*32;
~rotation=0;
~tree= Routine({loop{
~azr=[]; ~elr=[]; ~cx = [];~cy = [];~cz = [];
angle=0;
nn=1.neg; n=0;

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

    ~azr = ~azr ++ azimuth;
    ~elr = ~elr ++ elevation;

    az1=0; el1=0;
    az2=0; el2=0;
};

difaz = ~vertices.collect{
    nn = nn + 1;
    ~azr.[nn]
};
nn = 1.neg;
difel = ~vertices.collect{
    nn = nn + 1;
    ~elr.[nn]
};

~vertices.do{
var az, el;
var x, y, z,rot;

az = difaz.[n];
el = difel.[n];
rot=Spherical(1,az,el).rotateYZ(rx).rotateXZ(ry).rotateXY(rz);
//x = cos(el) * cos(az);
//y = cos(el) * sin(az);
//z = sin(el);
x=rot.x; y=rot.y; z=rot.z;
~cx = ~cx ++ x; ~cy = ~cy ++ y; ~cz = ~cz ++ z;
n = n + 1;
};
(
rx=(rx +~rotation).wrap(0,2pi);
ry=(ry +~rotation).wrap(0,2pi);
rz=(rz +~rotation).wrap(0,2pi);
);
(4).wait;
};});
~tree.play
}.value;
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
arg gain=1,lowend=20,s_size=1,room=1,drive=0,au=0,sb=0,
c=0,az=0,el=0,dicay=2,attack=2,sc=20,ssc=1,mix=0,rect=16,s1,s2,s3,s4,
busArray = #[0,1,2,3,4,5,6,7,8];
var fund,fu=16,n=0,mod_x,mod_y,mod_z,phasex,phasey,phasez,low=0,sustain,tremolo=4;
var freq1,freq2,freq3,amp1,amp2,amp3,sig1,sig2,sig3,heavy;
var b_x,b_y,b_z,polytope,env,expansion,sph1,sph2,envf;
var g_ch1,g_ch2,g_ch3,g_ch4,a1,a2,a3,a4,mp,mps,mpf;
var s_x,s_y,s_z,threshold,c1,c2,c3,mp_x,mp_y,mp_z,mps_x,mps_y,mps_z,mpf_x,mpf_y,mpf_z;
var peak, times,signal,rip,enva,key,attackLen,sustainLen,decayLen,tx,ty,tz;
var vanish=4,dist=1;

//envf=EnvGen.ar(Env.new([0,0,pi,pi,2pi],[(dicay/2),(attack/2),(dicay/2),(attack/2)]),doneAction:0);

sustain=0.1;
key=Select.kr(sb,~scale10);
////signal envelope
signal = Signal.sineFill(~signalSizee, ~arraye, [0]);
signal = signal.rotate(signal.size div: 2);
peak = signal.abs.maxIndex.max(1);
rip = Env.new([0,1,0],[0.25,0.5],[16.neg,4.neg]).asSignal(~signalSizee);
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
mp_x = sc  * cos(el) * cos(az);
mp_y = sc  * cos(el) * sin(az);
mp_z = sc  * sin(el);

mps_x = ssc * cos(el) * cos(az);
mps_y = ssc * cos(el) * sin(az);
mps_z = ssc * sin(el);

mpf_x =pi* cos(el) * cos(az);
mpf_y =pi* cos(el) * sin(az);
mpf_z =pi* sin(el);

b_x=2.pow(mp_x.round(1)/16256);
b_y=2.pow(mp_y.round(1)/16256);
b_z=2.pow(mp_z.round(1)/16256);

s_x=2.pow(Select.kr(mps_x.round(1).abs,key).asInteger /12);
s_y=2.pow(Select.kr(mps_y.round(1).abs,key).asInteger /12);
s_z=2.pow(Select.kr(mps_z.round(1).abs,key).asInteger /12);

fund=fund;

freq1=(fund)*b_x*s_x;
freq2=(fund)*b_y*s_y;
freq3=(fund)*b_z*s_z;
amp1=b_x.reciprocal*expansion.reciprocal*s_x.reciprocal;
amp2=b_y.reciprocal*expansion.reciprocal*s_y.reciprocal;
amp3=b_z.reciprocal*expansion.reciprocal*s_z.reciprocal;

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

c1=FreeVerb.ar(BPF.ar((Osc.ar(~wt.bufnum,freq1,phase:phasex,mul:1200).abs*
SinOsc.ar(freq1,phase:phasex)),freq1,heavy,amp1),mix,room);
c2=FreeVerb.ar(BPF.ar((Osc.ar(~wt.bufnum,freq2,phase:phasey,mul:1200).abs*
SinOsc.ar(freq2,phase:phasey)),freq2,heavy,amp2),mix,room);
c3=FreeVerb.ar(BPF.ar((Osc.ar(~wt.bufnum,freq3,phase:phasez,mul:1200).abs*
SinOsc.ar(freq3,phase:phasez)),freq3,heavy,amp3),mix,room);

////distortion rectifier
sig1=((((SinOsc.ar(freq1*(rect*2),phase:phasex,mul:amp1)).abs+(amp1))*
(SinOsc.ar(freq1*(rect),phase:phasex,mul:amp1))).abs+(amp1))*c1*10;
sig2=((((SinOsc.ar(freq2*(rect*2),phase:phasey,mul:amp2)).abs+(amp2))*
(SinOsc.ar(freq2*(rect),phase:phasey,mul:amp2))).abs+(amp2))*c2*10;
sig3=((((SinOsc.ar(freq3*(rect*2),phase:phasez,mul:amp3)).abs+(amp3))*
(SinOsc.ar(freq3*(rect),phase:phasez,mul:amp3))).abs+(amp3))*c3*10;

sig1=(sig1*mix.linlin(0,1,0.1,2)).softclip;
sig2=(sig2*mix.linlin(0,1,0.1,2)).softclip;
sig3=(sig3*mix.linlin(0,1,0.1,2)).softclip;

//////propagation
sig1=sig1*mp_x.sign;
sig2=sig2*mp_y.sign;
sig3=sig3*mp_z.sign;

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
//sig3=HPF.ar(sig3, lowend);
threshold=(((343/s_size)/fund).reciprocal.ampdb/2.sqrt).dbamp;
sig1=Compander.ar(sig1,c1,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);
sig2=Compander.ar(sig2,c2,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);
sig3=Compander.ar(sig3,c3,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);

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

Out.kr(~controlBus_1.index,(sig1*env));
Out.kr(~controlBus_2.index,(sig2*env));
Out.kr(~controlBus_3.index,(sig3*env));
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
~incr=0;~ssc=26;~mix=0;~rect=16;~s=0;~azimuth=0;~elevation=0;
~alternating=[0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1];~hor=0;~lat=0;
//~seq= Pseq([~dur.[0],Rest(~dur.[13.rand]),~dur.[1],Rest(~dur.[13.rand]),~dur.[2],Rest(~dur.[13.rand]),~dur.[3]] ,inf);
TempoClock.default.tempo_(0.01);
~timbr_dur=0.01;
(
{
Routine({loop{
	~hor=(~hor+~incr1).wrap(pi.neg, pi);
	~lat=(~lat+~incr2).wrap(0.5pi.neg, 0.5pi);
(~timbr_dur).wait; // frame duration
};
}).play;
}.defer
);
(
{
var x,y,z,px,py,pz;
Routine({loop{
x = Spherical(~vertices-1,~hor,~lat).x.round(1).asInteger.abs;
y = Spherical(~vertices-1,~hor,~lat).y.round(1).asInteger.abs;
z = Spherical(~vertices-1,~hor,~lat).z.round(1).asInteger.abs;
px=~cx.[x];
py=~cy.[y];
pz=~cz.[z];
~azimuth=Cartesian(px,py,pz).theta;
~elevation=Cartesian(px,py,pz).phi;
(~timbr_dur).wait; // frame duration
};
}).play;
}.defer
);

~pattern = Pdef(\1,
Pbind(\instrument, \synth,
\dur, Pseq(~dur ,inf),\s_size,Pfunc { ~s_size }, \lowend,Pfunc { ~lowend }, \room,Pfunc { ~room },
\gain,Pfunc { ~gain }, \sc, Pfunc { ~sc },\drive, Pfunc { ~drive },\timbre,Pfunc{~s},
\au,Pseq([0,1,4,3,6,5,9],inf),\sb,Pseq(~alternating*~lseq,inf),
\c, Pfunc { ~c },\mix, Pfunc{~mix},\rect,Pfunc{~rect},
\az, Pfunc{~azimuth},\el,Pfunc{~elevation},
\s1,Pfunc{(~vertices-1).rand.round(1).asInteger},\s2,Pfunc{(~vertices-1).rand.round(1).asInteger}
,\s3,Pfunc{(~vertices-1).rand.round(1).asInteger},\s4,Pfunc{(~vertices-1).rand.round(1).asInteger},
\attack,  Pfunc { ~attack }, \dicay, Pfunc { ~decay }, \ssc, Pfunc{~ssc};
));
~pattern.play;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////gui
(
{
var size=550,sk=(size/15),w,rol=0,sz=0.5,wd=4;
var v1,v2,v3,p1,p2,p3,tx1=0,tx2=0,tx3=0;
var lined=15,run=true,g=((1+5.sqrt)/2);

w = Window("tws", Rect(50, 50, size, size+65)).front;
~vw = UserView(w, Rect(0,0,size,(size+150)/2)).background_(Color.black);
v1 = UserView(w, Rect(0,(size+150)/2,size,(size+150)/8)).background_(Color.black);
v2 = UserView(w, Rect(0,((size+150)/2)+((size+150)/8),size,((size+150)/8))).background_(Color.black);
v3 = UserView(w, Rect(0,((size+150)/2)+(((size+150)/8)*2),size,((size+150)/8))).background_(Color.black);

v1.drawFunc = {
var x=0,y=0,n=0,m=0,k=0,t1x;
Pen.fillColor = Color.white.alpha_(1);
Pen.strokeColor = Color.white.alpha_(1);
p1=[];
50.do {
5.do{
t1x=(~controlBus_1.getSynchronous*250);
Pen.addOval(Rect.aboutPoint(Point((x-tx1+t1x).wrap(0,550),y),sz,sz));
p1=p1++Point((x-tx1+t1x).wrap(0,550),y);
y=(y+(10)).wrap(0,50);
};
x=(x+(11)).wrap(0,550);
y=0;
};
x=0;
////////mesh
p1=p1.scramble;
n = 0;m=0;k = 0;
(p1.size).do {
var m = n + 1;
(p1.size - n - 1).do {
Pen.width = (~controlBus_1.getSynchronous).abs*wd;
(if(p1.[n].dist(p1.[m]) < lined){Pen.line( p1.[n], p1.[m])};);
m=m+1;k=k+1;
};n=n+1;
};
Pen.fillStroke;
};
{ while { run } {v1.background_(Color.black);tx1 = (tx1 + rol).wrap(0,550); v1.refresh; (0.03).wait } }.fork(AppClock);

v2.drawFunc = {
var x=0,y=0,n=0,m=0,k=0,t1x;
Pen.fillColor = Color.white.alpha_(1);
Pen.strokeColor = Color.white.alpha_(1);
p2=[];
50.do {
5.do{
t1x=(~controlBus_2.getSynchronous*250);
Pen.addOval(Rect.aboutPoint(Point((x-tx2+t1x).wrap(0,550),y),sz,sz));
p2=p2++Point((x-tx2+t1x).wrap(0,550),y);
y=(y+(10)).wrap(0,50);
};
x=(x+(11)).wrap(0,550);
y=0;
};
x=0;
////////mesh
p2=p2.scramble;
n = 0;m=0;k = 0;
(p2.size).do {
var m = n + 1;
(p2.size - n - 1).do {
Pen.width = (~controlBus_2.getSynchronous).abs*wd;
(if(p2.[n].dist(p2.[m]) < lined){Pen.line( p2.[n], p2.[m])};);
m=m+1;k=k+1;
};n=n+1;
};
Pen.fillStroke;
};
{ while { run } {v2.background_(Color.black);tx2 = (tx2 + rol).wrap(0,550); v2.refresh; (0.03).wait } }.fork(AppClock);

v3.drawFunc = {
var x=0,y=0,n=0,m=0,k=0,t1x;
Pen.fillColor = Color.white.alpha_(1);
Pen.strokeColor = Color.white.alpha_(1);
p3=[];
50.do {
5.do{
t1x=(~controlBus_3.getSynchronous*250);
Pen.addOval(Rect.aboutPoint(Point((x-tx3+t1x).wrap(0,550),y),sz,sz));
p3=p3++Point((x-tx3+t1x).wrap(0,550),y);
y=(y+(10)).wrap(0,50);
};
x=(x+(11)).wrap(0,550);
y=0;
};
x=0;
////////mesh
p3=p3.scramble;
n = 0;m=0;k = 0;
(p3.size).do {
var m = n + 1;
(p3.size - n - 1).do {
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
value=obj.value.linexp(0,1,1/16,32).round(1/64).postln;
TempoClock.default.tempo_(value);
});
~st1=StaticText(~vw,Rect(50,50+sk,sk,sk)).string_("tempo")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',10));
);
(
~sl2=Knob.new(~vw, Rect.new(150,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.000001.degrad,2pi-(2pi/~silver)).postln;
~rotation=value;
});
~st2=StaticText(~vw,Rect(150,50+sk,sk,sk)).string_("timbre")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',10));
);
(
~sl3=Knob.new(~vw, Rect.new(250,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linexp(0,1,1,~note).round(1).asInteger.postln;
~ssc=value1;
});
~st3=StaticText(~vw,Rect(250,50+sk,sk,sk)).string_("s_range")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',10));
);
(
~sl4=Knob.new(~vw, Rect.new(350,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value2=obj.value.linexp(0,1,1,16256/2).round(1).asInteger.postln;
~sc=value2;
});
~st4=StaticText(~vw,Rect(350,50+sk,sk,sk)).string_("t_range")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',10));
);
(
~sl5=Knob.new(~vw, Rect.new(450,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value2=obj.value.linlin(0,1,1,8).postln;
~rect=value2;
});
~st5=StaticText(~vw,Rect(450,50+sk,sk,sk)).string_("overdrive")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',10));
);
(
~sl6=Knob.new(~vw, Rect.new(50,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linlin(0,1,(16256*4).neg,(16256)).round(1).asInteger.postln;
~drive=value1;
});
~st6=StaticText(~vw,Rect(50,(50+sk+50+25+sk),sk,sk)).string_("drive")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',10));
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
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',10));
);
(
~sl8=Knob.new(~vw, Rect.new(250,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value2=obj.value.linexp(0,1,0.01,1).postln;
~attack=value2;
});
~st8=StaticText(~vw,Rect(250,(50+sk+50+25+sk),sk,sk)).string_("attack")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',10));
);
(
~sl9=Knob.new(~vw, Rect.new(350,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linexp(0,1,1,16).postln;
~decay=value1;
});
~st9=StaticText(~vw,Rect(350,(50+sk+50+25+sk),sk,sk)).string_("decay")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',10));
);
(
~sl10=Knob.new(~vw, Rect.new(450,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linlin(0,1,0.degrad,2pi-(2pi/~silver)).round((2pi/992).degrad).postln;
~incr1=value1;
});
~st10=StaticText(~vw,Rect(450,(50+sk+50+25+sk),sk,sk)).string_("az")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',10));
);
(
~sl11=Knob.new(~vw, Rect.new(50,(50+sk+50+sk+25+25+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value2=obj.value.linlin(0,1,0.degrad,pi-(pi/~gold)).round((pi/992).degrad).postln;
~incr2=value2;
});
~st11=StaticText(~vw,Rect(50,(50+sk+50+sk+25+25+sk+50),sk,sk)).string_("el")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',10));
);
(
~s12=Knob.new(~vw, Rect.new(150,(50+sk+50+sk+25+25+50), sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0,16256*3).round(1).asInteger.postln;
~c=value;
});
~st12=StaticText(~vw,Rect(150,(50+sk+50+sk+25+25+sk+50),sk,sk)).string_("fund")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',10));
);
(
~sl13=Knob.new(~vw, Rect.new(250,(50+sk+50+sk+25+25+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.001,2pi).postln;
~gain=value;
});
~st13=StaticText(~vw,Rect(250,(50+sk+50+sk+25+25+sk+50),sk,sk)).string_("gain")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',10));
);
(
~sl14=Knob.new(~vw, Rect.new(350,(50+sk+50+sk+25+25+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.01,1).postln;
~room=value;
});
~st14=StaticText(~vw,Rect(350,(50+sk+50+sk+25+25+sk+50),sk,sk)).string_("revroom")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',10));
);
(
~sl15=Knob.new(~vw, Rect.new(450,(50+sk+50+sk+25+25+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.01,1).postln;
~mix=value;
});
~st15=StaticText(~vw,Rect(450,(50+sk+50+sk+25+25+sk+50),sk,sk)).string_("revmix")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',10));
);
}.defer
);
)
}); Tdef(\drone).play;
}
)




*/







































































































































































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