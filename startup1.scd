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

~vertices = 1024;

{
var nn=1.neg, n=0;
var difaz, difel;

difaz = ~vertices.collect{
    nn = nn + 1;
    ~az.[nn]
};

nn = 1.neg;

difel = ~vertices.collect{
    nn = nn + 1;
    ~el.[nn]
};

~cx = [];
~cy = [];
~cz = [];

~vertices.do{
    var az, el;
    var x, y, z;

    az = difaz.[n];
    el = difel.[n];

    // explicit spherical -> cartesian (radius = 1)
    x = cos(el) * cos(az);
    y = cos(el) * sin(az);
    z = sin(el);

    ~cx = ~cx ++ x;
    ~cy = ~cy ++ y;
    ~cz = ~cz ++ z;

    n = n + 1;
};
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
			//minorPentatonic
(
{
var nn=1.neg,scale1,scale2;
scale1=~note10.collect{nn=nn+1;Scale.dorian.performDegreeToKey(nn,12)};
nn=1.neg;
scale2=~note10.collect{nn=nn+1;Scale.dorian.performDegreeToKey(nn,12)};
~scale10=[scale1,scale2];
}.value;
);
);

~s=0;
/////////////////////////////////////////////////////////////////////////////////////////////////////sound
(
SynthDef.new(\synth,{
arg gain=1,lowend=20,s_size=1,room=1,drive=0,au=0,sb=0,timbre=0,
c=0,az=0,el=0,dicay=2,attack=2,sc=20,ssc=1,mix=0,rect=16,
busArray = #[0,1,2,3,4,5,6,7,8,9,10,11];
var fund,fu=24,n=0,mod_x,mod_y,mod_z,phasex,phasey,phasez,low=0,sustain,tremolo=10000;
var freq1,freq2,freq3,amp1,amp2,amp3,sig1,sig2,sig3,heavy;
var b_x,b_y,b_z,polytope,env,expansion,sph1,sph2,xx,yy,zz,envf;
var g_ch1,g_ch2,g_ch3,g_ch4,s1,s2,s3,s4,a1,a2,a3,a4,mp,mps,mpf,px,py,pz,ptheta,pphi;
var s_x,s_y,s_z,threshold,c1,c2,c3,mp_x,mp_y,mp_z,mps_x,mps_y,mps_z,mpf_x,mpf_y,mpf_z;
var peak, times,signal,rip,enva,key,attackLen,sustainLen,decayLen,tx,ty,tz;
var vanish=4,dist=1;

s1=Rand(0, ~vertices-1).round(1).asInteger;s2=Rand(0, ~vertices-1).round(1).asInteger;
s3=Rand(0, ~vertices-1).round(1).asInteger;s4=Rand(0, ~vertices-1).round(1).asInteger;

//env=EnvGen.ar(Env.perc(attack,dicay,gain),doneAction:2);
//envf=EnvGen.ar(Env.new([0,0,pi,pi,2pi],[(dicay/2),(attack/2),(dicay/2),(attack/2)]),doneAction:0);

sustain=0.25;
key=Select.kr(sb,~scale10);

////signal envelope
signal = Signal.sineFill(~signalSizee, ~arraye, [0]);
signal = signal.rotate(signal.size div: 2);
peak = signal.abs.maxIndex.max(1);
rip = Env.new([0,1,1,0],[0.25,0.25,0.5],[4.neg,0,4.neg]).asSignal(~signalSizee);
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

expansion=2.pow(c.lag(0.01)/16256);
fund=(fu*(9/8))*expansion;
heavy=2.pow(drive.lag(0.01)/16256);

xx = (~vertices * cos(el) * cos(az)).round(1).asInteger.abs;
yy = (~vertices * cos(el) * sin(az)).round(1).asInteger.abs;
zz = (~vertices * sin(el)).round(1).asInteger.abs;
px=Select.kr(xx,~cx);
py=Select.kr(yy,~cy);
pz=Select.kr(zz,~cz);

ptheta=atan2(py,px);
pphi=atan2(pz,(px.squared+py.squared).sqrt);

///osc
mp_x = sc  * cos(pphi) * cos(ptheta);
mp_y = sc  * cos(pphi) * sin(ptheta);
mp_z = sc  * sin(pphi);

mps_x = ssc * cos(pphi) * cos(ptheta);
mps_y = ssc * cos(pphi) * sin(ptheta);
mps_z = ssc * sin(pphi);

mpf_x =pi* cos(pphi) * cos(ptheta);
mpf_y =pi* cos(pphi) * sin(ptheta);
mpf_z =pi* sin(pphi);

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
sig1=((((SinOsc.ar(freq1*(rect*2),phase:phasex,mul:amp1/(rect*2))).abs+(amp1))*
(SinOsc.ar(freq1*(rect),phase:phasex,mul:amp1/(rect)))).abs+(amp1))*c1*10;
sig2=((((SinOsc.ar(freq2*(rect*2),phase:phasey,mul:amp2/(rect*2))).abs+(amp2))*
(SinOsc.ar(freq2*(rect),phase:phasey,mul:amp2))).abs+(amp2/(rect)))*c2*10;
sig3=((((SinOsc.ar(freq3*(rect*2),phase:phasez,mul:amp3/(rect*2))).abs+(amp3))*
(SinOsc.ar(freq3*(rect),phase:phasez,mul:amp3/(rect)))).abs+(amp3))*c3*10;

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
(sig1.abs.range(0.001,1)*cos(pphi)*cos(ptheta)*
 sig1.range(0.001,1)*cos(Select.kr(s1,~el)*a1)*cos(Select.kr(s1,~az)*a1))
+
(sig2.abs.range(0.001,1)*cos(pphi)*sin(ptheta)*
 sig2.range(0.001,1)*cos(Select.kr(s1,~el)*a1)*sin(Select.kr(s1,~az)*a1))
+
(sig3.abs.range(0.001,1)*sin(pphi)*
 sig3.range(0.001,1)*sin(Select.kr(s1,~el)*a1));

g_ch2=
(sig1.abs.range(0.001,1)*cos(pphi)*cos(ptheta)*
 sig1.range(0.001,1)*cos(Select.kr(s2,~el)*a2)*cos(Select.kr(s2,~az)*a2))
+
(sig2.abs.range(0.001,1)*cos(pphi)*sin(ptheta)*
 sig2.range(0.001,1)*cos(Select.kr(s2,~el)*a2)*sin(Select.kr(s2,~az)*a2))
+
(sig3.abs.range(0.001,1)*sin(pphi)*
 sig3.range(0.001,1)*sin(Select.kr(s2,~el)*a2));

g_ch3=
(sig1.abs.range(0.001,1)*cos(pphi)*cos(ptheta)*
 sig1.range(0.001,1)*cos(Select.kr(s3,~el)*a3)*cos(Select.kr(s3,~az)*a3))
+
(sig2.abs.range(0.001,1)*cos(pphi)*sin(ptheta)*
 sig2.range(0.001,1)*cos(Select.kr(s3,~el)*a3)*sin(Select.kr(s3,~az)*a3))
+
(sig3.abs.range(0.001,1)*sin(pphi)*
 sig3.range(0.001,1)*sin(Select.kr(s3,~el)*a3));

g_ch4=
(sig1.abs.range(0.001,1)*cos(pphi)*cos(ptheta)*
 sig1.range(0.001,1)*cos(Select.kr(s4,~el)*a4)*cos(Select.kr(s4,~az)*a4))
+
(sig2.abs.range(0.001,1)*cos(pphi)*sin(ptheta)*
 sig2.range(0.001,1)*cos(Select.kr(s4,~el)*a4)*sin(Select.kr(s4,~az)*a4))
+
(sig3.abs.range(0.001,1)*sin(pphi)*
 sig3.range(0.001,1)*sin(Select.kr(s4,~el)*a4));
);

(
Out.ar(busArray.[0],LeakDC.ar(sig1*env));
Out.ar(busArray.[1],LeakDC.ar(sig2*env));
Out.ar(busArray.[2],LeakDC.ar(sig3*env));
);

Out.kr(~controlBus_1.index,(sig1*env));
Out.kr(~controlBus_2.index,(sig1*env));
Out.kr(~controlBus_3.index,(sig1*env));
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
~dur=~dur++durx++dury++durz++durx2++dury2++durz2;
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
~incr=0;~ssc=26;~mix=0;~rect=16;
~alternating=[0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1];
//~seq= Pseq([~dur.[0],Rest(~dur.[13.rand]),~dur.[1],Rest(~dur.[13.rand]),~dur.[2],Rest(~dur.[13.rand]),~dur.[3]] ,inf);
TempoClock.default.tempo_(0.01);
~timbr_dur=8;

(
{
Routine({loop{
	~s=~vertices.rand;
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
\az, Pseries(0, Pfunc{~incr1}, inf).collect(_.wrap(pi.neg, pi)),
\el, Pseries(0, Pfunc{~incr2}, inf).collect(_.wrap(0.5pi.neg, 0.5pi)),
\attack,  Pfunc { ~attack }, \dicay, Pfunc { ~decay }, \ssc, Pfunc{~ssc};
));
~pattern.play;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////gui
(
{
var size=550,sk=(size/10),w,rol=2,sz=0.5,wd=0.5;
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
t1x=(~controlBus_1.getSynchronous*550);
Pen.addOval(Rect.aboutPoint(Point((x-tx1+t1x).wrap(0,550),y),sz,sz));
p1=p1++Point((x-tx1+t1x).wrap(0,550),y);
y=(y+(10)).wrap(0,50);
};
x=(x+(11)).wrap(0,550);
y=0;
};
x=0;
////////mesh
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
{ while { run } {v1.background_(Color.black);tx1 = (tx1 + rol).wrap(0,550); v1.refresh; (0.01).wait } }.fork(AppClock);

v2.drawFunc = {
var x=0,y=0,n=0,m=0,k=0,t1x;
Pen.fillColor = Color.white.alpha_(1);
Pen.strokeColor = Color.white.alpha_(1);
p2=[];
50.do {
5.do{
t1x=(~controlBus_2.getSynchronous*550);
Pen.addOval(Rect.aboutPoint(Point((x-tx2+t1x).wrap(0,550),y),sz,sz));
p2=p2++Point((x-tx2+t1x).wrap(0,550),y);
y=(y+(10)).wrap(0,50);
};
x=(x+(11)).wrap(0,550);
y=0;
};
x=0;
////////mesh
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
{ while { run } {v2.background_(Color.black);tx2 = (tx2 + rol).wrap(0,550); v2.refresh; (0.01).wait } }.fork(AppClock);

v3.drawFunc = {
var x=0,y=0,n=0,m=0,k=0,t1x;
Pen.fillColor = Color.white.alpha_(1);
Pen.strokeColor = Color.white.alpha_(1);
p3=[];
50.do {
5.do{
t1x=(~controlBus_3.getSynchronous*550);
Pen.addOval(Rect.aboutPoint(Point((x-tx3+t1x).wrap(0,550),y),sz,sz));
p3=p3++Point((x-tx3+t1x).wrap(0,550),y);
y=(y+(10)).wrap(0,50);
};
x=(x+(11)).wrap(0,550);
y=0;
};
x=0;
////////mesh
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
{ while { run } {v3.background_(Color.black);tx3 = (tx3 + rol).wrap(0,550); v3.refresh; (0.01).wait } }.fork(AppClock);
(
~sl1=Knob.new(~vw, Rect.new(50,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1/16,32).round(1/64).postln;
TempoClock.default.tempo_(value);
~timbr_dur=value/16;
});
~st1=StaticText(~vw,Rect(50,50+sk,sk,sk)).string_("tempo")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',14));
);
(
~sl2=Knob.new(~vw, Rect.new(150,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linexp(0,1,1,~note).round(1).asInteger.postln;
~ssc=value1;
value2=obj.value.linexp(0,1,1,16256/2).round(1).asInteger.postln;
~sc=value2;
});
~st2=StaticText(~vw,Rect(150,50+sk,sk,sk)).string_("range")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',14));
);
(
~sl3=Knob.new(~vw, Rect.new(250,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linlin(0,1,(16256*4).neg,(16256)).round(1).asInteger.postln;
~drive=value1;
value2=obj.value.linlin(0,1,1,8).postln;
~rect=value2;
});
~st3=StaticText(~vw,Rect(250,50+sk,sk,sk)).string_("drive")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',14));
);
(
~sl4=Knob.new(~vw, Rect.new(350,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linexp(0,1,0.05,0.5).postln;
~s_size=value1;
value2=obj.value.linexp(0,1,80,10).postln;
~lowend=value2;
});
~st4=StaticText(~vw,Rect(350,50+sk,sk,sk)).string_("comp")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',14));
);
(
~sl5=Knob.new(~vw, Rect.new(450,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linexp(0,1,1,16).postln;
~decay=value1;
value2=obj.value.linexp(0,1,0.01,1).postln;
~attack=value2;
});
~st5=StaticText(~vw,Rect(450,50+sk,sk,sk)).string_("env")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',14));
);
(
~sl6=Knob.new(~vw, Rect.new(50,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linlin(0,1,0.degrad,2pi-(2pi/~silver)).round((2pi/992).degrad).postln;
~incr1=value1;
value2=obj.value.linlin(0,1,0.degrad,pi-(pi/~gold)).round((pi/992).degrad).postln;
~incr2=value2;
});
~st6=StaticText(~vw,Rect(50,50+sk+50+25+sk,sk,sk)).string_("tone")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',14));
);
(
~s7=Knob.new(~vw, Rect.new(150,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0,16256*3).round(1).asInteger.postln;
~c=value;
});
~st7=StaticText(~vw,Rect(150,50+sk+50+25+sk,sk,sk)).string_("fund")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',14));
);
(
~sl8=Knob.new(~vw, Rect.new(250,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.001,2pi).postln;
~gain=value;
});
~st8=StaticText(~vw,Rect(250,50+sk+50+25+sk,sk,sk)).string_("gain")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',14));
);
(
~sl9=Knob.new(~vw, Rect.new(350,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.01,1).postln;
~room=value;
});
~st9=StaticText(~vw,Rect(350,50+sk+50+25+sk,sk,sk)).string_("revroom")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',14));
);
(
~sl10=Knob.new(~vw, Rect.new(450,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.01,1).postln;
~mix=value;
});
~st10=StaticText(~vw,Rect(450,50+sk+50+25+sk,sk,sk)).string_("revmix")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',14));
);
}.defer
);
)
}); Tdef(\drone).play;
}
)




