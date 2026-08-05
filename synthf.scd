
(
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=4;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*8;
s.options.blockSize = 64;
s.options.maxNodes = 8192*2;
Quarks.install("MathLib");
Buffer.freeAll;
Window.closeAll;
s.makeGui(w);
//s.meter;
//s.freqscope;
//s.scope;
);
/////////copy paste image path in parentheses for graphics
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
~img_print = Image.open("/Users/rohifes/Documents/Literary/Portfolio/SuperCollider/2026/synth/synthf/image1.jpg");///////////////paste image image1.jpg
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
s.waitForBoot{
Tdef(\drone, {
////////////////////////////////////////////////////////////////////////////////////////// wavetable, scales, space,timbre
(
~az=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
(
~note=28;
(
{
var nn=1.neg;
~scalee=~note.collect{nn=nn+1;Scale.phrygian.performDegreeToKey(nn,12)};
}.value;
);
(
{
var nn=1.neg;
~scaleee=~note.collect{nn=nn+1;Scale.dorian.performDegreeToKey(nn,12)};
}.value;
);
~sc=[~scalee,~scaleee];
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
signal=Signal.sineFill(~signalSize,~array,[0],~ph);
wt = signal.asWavetable;
~wt.loadCollection(wt);
//signal.plot;
}.value;
);
(
{
var timbre,raz,rel,dif,n;
thisThread.randSeed = 689;
dif=366.collect{Spherical(1,2pi.rand2,pi.rand2)}; n=0; ~cx=[]; ~cy=[]; ~cz=[];
366.do{
~cx=~cx++dif.[n].x;
~cy=~cy++dif.[n].y;
~cz=~cz++dif.[n].z;
n=n+1;
};
}.value;
);

/////////////////////////////////////////////////////////////////////////////////////////////////////sound
(
SynthDef.new(\synth,{
arg gain=1,drive=0,c=0,az=0,el=0,scalee=0,dicay=0.5,attack=0.01,sc=20;
var fund,fu=128,n=0,mod_x,mod_y,mod_z,phasex,phasey,phasez,low=0;
var freq1,freq2,freq3,amp1,amp2,amp3,sig1,sig2,sig3,heavy;
var b_x,b_y,b_z,polytope,mp,env,expansion,sph1,sph2,xx,yy,zz;
var g_ch1,g_ch2,g_ch3,g_ch4;

~az=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
env=EnvGen.ar(Env.perc(attack,dicay,gain),doneAction:2);

expansion=2.pow(c.lag(0.001)/16256);
fund=(fu*(9/8))*expansion;
heavy=2.pow(drive.lag(0.001)/16256);

xx=Spherical(365,az,el).x.round(1).asInteger;
yy=Spherical(365,az,el).y.round(1).asInteger;
zz=Spherical(365,az,el).z.round(1).asInteger;
polytope=Cartesian(Select.kr(xx,~cx),Select.kr(yy,~cy),Select.kr(zz,~cz));
mp=Spherical(sc,polytope.theta, polytope.phi);

b_x=2.pow(Select.kr(mp.x.round(1), Select.kr(scalee.lag(0.001),~sc)) /12);
b_y=2.pow(Select.kr(mp.y.round(1), Select.kr(scalee.lag(0.001),~sc)) /12);
b_z=2.pow(Select.kr(mp.z.round(1), Select.kr(scalee.lag(0.001),~sc)) /12);
mod_x=polytope.x;
mod_y=polytope.y;
mod_z=polytope.z;
phasex=(Complex(1,mod_x).theta*4);
phasey=(Complex(1,mod_y).theta*4);
phasez=(Complex(1,mod_z).theta*2);

freq1=(fund)*b_x;
freq2=(fund)*b_y;
freq3=(fund)*b_z;
amp1=b_x.reciprocal*expansion.reciprocal;
amp2=b_y.reciprocal*expansion.reciprocal;
amp3=b_z.reciprocal*expansion.reciprocal;

sig1=LPF.ar((Osc.ar(~wt.bufnum,freq1,phase:phasex,mul:300).abs*SinOsc.ar(freq1,phase:phasex)),freq1*heavy,amp1);
sig2=LPF.ar((Osc.ar(~wt.bufnum,freq2,phase:phasey,mul:300).abs*SinOsc.ar(freq2,phase:phasey)),freq2*heavy,amp2);
sig3=LPF.ar((Osc.ar(~wt.bufnum,freq3,phase:phasez,mul:300).abs*SinOsc.ar(freq3,phase:phasez)),freq3*heavy,amp3);

g_ch1 = (
(Spherical(1,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).x *
Spherical(1,~az[0],~el[0]).x) +
(Spherical(1,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).y *
Spherical(1,~az[0],~el[0]).y)+
(Spherical(1,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).z *
Spherical(1,~az[0],~el[0]).z)
);
g_ch2 = (
(Spherical(1,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).x *
Spherical(1,~az[1],~el[1]).x)+
(Spherical(1,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).y *
Spherical(1,~az[1],~el[1]).y)+
(Spherical(1,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).z *
Spherical(1,~az[1],~el[1]).z)
);
g_ch3 = (
(Spherical(1,(polytope.theta).wrap(pi,pi.neg),(polytope.phi ).wrap(~el[2],~el[1])).x *
Spherical(1,~az[2],~el[2]).x)+
(Spherical(1,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).y *
Spherical(1,~az[2],~el[2]).y)+
(Spherical(1,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).z *
Spherical(1,~az[2],~el[2]).z)
);
g_ch4 = (
(Spherical(1,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).x *
Spherical(1,~az[3],~el[3]).x) +
(Spherical(1,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).y *
Spherical(1,~az[3],~el[3]).y)+
(Spherical(1,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).z *
Spherical(1,~az[3],~el[3]).z)
);

//Out.ar(0,sig1*env);Out.ar(1,sig2*env);Out.ar(0,(sig3*env*2.sqrt.reciprocal)!2);
(
Out.ar(0,sig1*env*g_ch1);Out.ar(1,sig1*env*g_ch2);Out.ar(2,sig1*env*g_ch3);Out.ar(3,sig1*env*g_ch4);
Out.ar(0,sig2*env*g_ch1);Out.ar(1,sig2*env*g_ch2);Out.ar(2,sig2*env*g_ch3);Out.ar(3,sig2*env*g_ch4);
Out.ar(0,sig3*env*g_ch1);Out.ar(1,sig3*env*g_ch2);Out.ar(2,sig3*env*g_ch3);Out.ar(3,sig3*env*g_ch4);
)

}).add;
);
1.wait;
/////////////////////////////////////////////////////////////////////////////////////////////////////////sequencer,pattern
(
(
(
~az=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
({
var m1=1.neg, m2=1.neg, m3=1.neg,a,b,c,n=0,bank=4,time=32.reciprocal,beat=1,r=0;
~r=0;~r1=0;	~r2=0;
(
~dur1=[];~dur2=[];~dur3=[]; ~dx=[];~dy=[]; ~dz=[]; ~durx=[]; ~dury=[]; ~durz=[]; ~dur=[];
3.do{
~x=bank.collect{
m1=m1+1;
b=Spherical(beat,~az.[m1],~el.[m1]).rotate(~r).tilt(~r1).tumble(~r2).x;
2.pow(b).round(time);
};
~y=bank.collect{
m2=m2+1;
c=Spherical(beat,~az.[m2],~el.[m2]).rotate(~r).tilt(~r1).tumble(~r2).y;
2.pow(c).round(time);
};
~z=bank.collect{
m3=m3+1;
d=Spherical(beat,~az.[m3],~el.[m3]).rotate(~r).tilt(~r1).tumble(~r2).z;
2.pow(d).round(time);
};
m1=1.neg; m2=1.neg; m3=1.neg; ~dx=~dx++~x; ~dy=~dy++~y;  ~dz=~dz++~z;   ~x=[]; ~y=[]; ~z=[];  r=r+90.degrad; };
bank.do{ ~dur1=~dur1++~dx.[n];n=n+1;};n=0;
bank.do{ ~dur2=~dur2++~dy.[n];n=n+1;};n=0;
bank.do{ ~dur3=~dur3++~dz.[n];n=n+1;};n=0;
~dur=~dur++~dur1++~dur2++~dur3;
)}.value);
);

~gain=0.83;~drive=0;~c=0;~az=0;~el=0;~scalee=0;~attack=0.01;~decay=1;~incr1=0;~incr2=0;
~gold=((1+5.sqrt)/2);~silver=(1+2.sqrt);~incr=0;~g=((1+5.sqrt)/2);~s=(1+2.sqrt);~ssc=26;
~seq= Pseq(~dur ,inf).asStream;
TempoClock.default.tempo_(0.01);

~pattern = Pdef(\1,
Pbind(\instrument, \synth,\dur, ~seq,\gain, Pfunc { ~gain }, \sc, Pfunc { ~ssc },\drive, Pfunc { ~drive },
\c, Pfunc { ~c },\az, Pseries(0, Pfunc{~incr1}, inf).collect(_.wrap(pi.neg, pi)).asStream,
\el, Pseries(0, Pfunc{~incr2}, inf).collect(_.wrap(0.5pi.neg, 0.5pi)).asStream,
\attack,  Pfunc { ~attack }, \dicay, Pfunc { ~decay },\scalee, Pfunc { ~scalee };
));
~pattern.play;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////gui
(
{
var size,sk,compass,n,scl,r;
size=1200; sk=(size/50); n=(2pi/9).neg; scl=(size/4); r=2;
w = Window("synthf", Rect(50, 50, size, size)).front;
~vw = UserView(w, w.view.bounds).drawFunc_({ ~img_print.drawInRect(~vw.bounds)});
compass=10.collect{n=n+(2pi/9); (exp(Complex(0,1)*n)*scl)};
(
~sl1=Knob.new(~vw, Rect.aboutPoint((compass.[0].real+(size/r)) @ (compass.[0].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1,28).round(1).asInteger;
~ssc=value;
});
);
(
~sl2=Knob.new(~vw, Rect.aboutPoint((compass.[1].real+(size/r)) @ (compass.[1].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,(16256*4).neg,(16256*2)).round(1).asInteger.postln;
~drive=value;
});
);
(
~sl3=Knob.new(~vw, Rect.aboutPoint((compass.[2].real+(size/r)) @ (compass.[2].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.001,5).postln;
~attack=value;
});
);
(
~sl4=Knob.new(~vw, Rect.aboutPoint((compass.[3].real+(size/r)) @ (compass.[3].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0,1).round(1).asInteger.postln;
~scalee=value;
});
);
(
~sl5=Knob.new(~vw, Rect.aboutPoint((compass.[4].real+(size/r)) @ (compass.[4].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0,16256*2).round(1).asInteger.postln;
~c=value;
});
);
(
~sl6=Knob.new(~vw, Rect.aboutPoint((compass.[5].real+(size/r)) @ (compass.[5].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.001,8).postln;
~decay=value;
});
);
(
~sl7=Knob.new(~vw, Rect.aboutPoint((compass.[6].real+(size/r))@ (compass.[6].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.1,128).postln;
TempoClock.default.tempo_(value);
});
);
(
~sl8=Knob.new(~vw, Rect.aboutPoint((compass.[7].real+(size/r))@ (compass.[7].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0.degrad,2pi-(2pi/~silver)).round((2pi/992).degrad).postln;
~incr1=value;
});
);
(
~sl9=Knob.new(~vw, Rect.aboutPoint((compass.[8].real+(size/r))@ (compass.[8].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0.degrad,pi-(pi/~silver)).round((pi/992).degrad).postln;
~incr2=value;
});
);
}.defer
)
);
}); Tdef(\drone).play;
}
)








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


