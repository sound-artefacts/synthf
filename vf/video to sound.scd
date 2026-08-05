
(
s.options.numWireBufs = 1024*4;
s.options.numOutputBusChannels=4;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*32;
s.options.blockSize = 64;
s.options.maxNodes = 8192*2;
s.boot;
s.makeGui(w);
s.meter;
s.freqscope;
s.scope;

)

s.waitForBoot{

Buffer.freeAll;

	}
);
	////entire folder
/*(
		PathName.new("/Users/amimid/Desktop/screenplay/").files.do { |f|
    var img = Image.open(f.fullPath);

    if(img.notNil) {
        var width = img.width;
        var height = img.height;
        var color = img.getColor(0, 0).postln;

        width.postln;
        height.postln;
    };
};
)*/

///simple example
(
var img = Image.open("/Users/amimid/Documents/film/screenplay/DSC_0001.jpg");
var width = img.width;
var height = img.height;
var color = img.getColor(0, 0).postln; // returns a Color object
width.postln;
height.postln;
//[color.red, color.green, color.blue].postln;
)


	///iteration data draw
/*(
var img = Image.open("/Users/amimid/Desktop/1.png");
var c=0, color,xx=0,yy=0,r=[],g=[],b=[],h_count=0;
	c=(img.height/5).asInteger;
	h_count=(img.height/5).asInteger;
		~cx=[]; ~cy=[];  ~cz=[];

	5.do{

h_count.do {
				img.width.do {
         color = img.getColor(xx, yy);
		//[color.red, color.green, color.blue].postln;
			r=r++color.red;
			g=g++color.green;
         	b=b++color.blue;
xx=xx+1;
				};
				xx=0;
				yy=yy+1;
    };
        ~cx=~cx++(r.sum / r.size);
		~cy=~cy++(g.sum / g.size);
		~cz=~cz++(b.sum / b.size);
			r=[];g=[];b=[];
};
)*/


	////////folder routine read

	// (
	// 	~images = List.new;
	//
	// 	PathName.new("/Users/amimid/Desktop/screenplay/").files.do { |f|
	// 		var img;
	//
	// 		img = Image.open(f.fullPath);
	//
	// 		if(img.notNil) {
	// 			~images.add(img);
	// 		};
	// 	};
	//
	// 	~images.postln;
	// )

	/*(
				~cx=[]; ~cy=[];  ~cz=[];
		PathName.new("/Users/amimid/Documents/film/screenplay/").files.do { |f|

var img = Image.open(f.fullPath);
var c=0, color,xx=0,yy=0,r=[],g=[],b=[],h_count=0;
	c=(img.height/5).asInteger;
	h_count=(img.height/5).asInteger;


	5.do{

h_count.do {
				img.width.do {
         color = img.getColor(xx, yy);
		[color.red, color.green, color.blue].postln;
			r=r++color.red;
			g=g++color.green;
         	b=b++color.blue;
xx=xx+1;
				};
				xx=0;
				yy=yy+1;
    };
        ~cx=~cx++(r.sum / r.size);
		~cy=~cy++(g.sum / g.size);
		~cz=~cz++(b.sum / b.size);
			r=[];g=[];b=[];
};
	yy=0;
};
)*/

/////granular
	/*(
				~cx=[]; ~cy=[];  ~cz=[];
		PathName.new("/Users/amimid/Documents/film/screenplay/").files.do { |f|

var img = Image.open(f.fullPath);
var c=0, color,xx=0,yy=0,r=[],g=[],b=[],h_count=0;
	c=(img.height/5).asInteger;
	h_count=(img.height/5).asInteger;

img.height.do{
				img.width.do{
         color = img.getColor(xx, yy);
		[color.red, color.green, color.blue].postln;
			r=r++color.red;
			g=g++color.green;
         	b=b++color.blue;
xx=xx+1;
				};
				xx=0;
				yy=yy+1;
    };
        ~cx=~cx++r;
		~cy=~cy++g;
		~cz=~cz++b;
		//	r=[];g=[];b=[];
			yy=0;
};
)*/

)

/////one value per image
	/*(
				~cx=[]; ~cy=[];  ~cz=[];
	PathName.new("/Users/amimid/Desktop/untitled folder/").files.do { |f|

var img = Image.open(f.fullPath);
var c=0, color,xx=0,yy=0,r=[],g=[],b=[],h_count=0;


	img.height.do {
				img.width.do {
         color = img.getColor(xx, yy);
	[color.red, color.green, color.blue].postln;
			r=r++color.red;
			g=g++color.green;
         	b=b++color.blue;
xx=xx+1;
				};
				xx=0;
				yy=yy+1;
    };
        ~cx=~cx++(r.sum / r.size);
		~cy=~cy++(g.sum / g.size);
		~cz=~cz++(b.sum / b.size);
			r=[];g=[];b=[];
				yy=0;
};

)*/
////entropy, one value per image
(
				~cx=[]; ~cy=[];  ~cz=[];
	PathName.new("/Users/rohifes/Documents/Literary/sound artefacts/shots_image to sound/feed1/").files.do { |f|

var img = Image.open(f.fullPath);
var c=0, color,xx=0,yy=0,r=[],g=[],b=[],h_count=0;


	img.height.do {
				img.width.do {
         color = img.getColor(xx, yy);
	[color.red, color.green, color.blue].postln;
			r=r++color.red;
			g=g++color.green;
         	b=b++color.blue;
xx=xx+1;
				};
				xx=0;
				yy=yy+1;
    };
			r=r+0.0001;  g=g+0.0001;  b=b+0.0001;
	r=r/r.sum;   g=g/g.sum;   b=b/b.sum;
	r=r.neg*log2(r);  	g=g.neg*log2(g);  	b=b.neg*log2(b);

        ~cx=~cx++r.sum;
		~cy=~cy++g.sum;
		~cz=~cz++b.sum;
			r=[];g=[];b=[];
				yy=0;
};

)


(
~az=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
////// wavetables

		//oscillator table
		(
~n=1.neg;~array=992.collect{~n=~n+1;2.pow(~n/992)};
~n=(0-(pi/496)); ~ph=992.collect{~n=~n+(pi/496);};
~bufferSize = 4096*8;
~signalSize = 2048*8;
);


		(
~w1= Buffer.alloc(s,~bufferSize);
		{
	var signal,wt;
	signal=Signal.sineFill(~signalSize,~array,~ph);

wt = signal.asWavetable;
~w1.loadCollection(wt);
//signal.plot;
		}.value;
);


////scale
(
			{
				var nn=1.neg;
		~scalee=10.collect{nn=nn+1;Scale.majorPentatonic.performDegreeToKey(nn,12)};
			}.value;
		);

		(
			{
				var nn=1.neg;
		~scaleee=10.collect{nn=nn+1;Scale.minorPentatonic.performDegreeToKey(nn,12)};
			}.value;
		);

		~sc=[~scalee,~scaleee];
		////sound



(
SynthDef.new(\synth,{

	arg gain=1,low=992,x=1,pan=1,mix=0.3,a=1,panx=1,pany=1,panz=1,room=0.5,m=2,pon=1,
				fu=32,drive=1,spread=1,drone_amp=1,pann=0,dron=0,drone=1,theta=0,rx=0,ry=0,rz=0,qq=0.0000001,spirit=1,
				pneuma1=0,pneuma2=0,pneuma3=0,namp1=1,namp2=1,namp3=1,sc=7,mm=0,tone1=0,tone2=0,tone3=0,qqq=0;

	var rq=1,cloud=1,attack,decay,curve,band,azf=0,elf=0,q,r1,r2,r3,sq1,sq2,sq3;
	var rotationx,rotationy,rotationz,core=(9/8).rand;
	var lamdoma,freq1,freq2,freq3,fund,amp1,amp2,amp3,alpha,cell_az,cell_el,x_pos,y_pos,control1,control2,control3;
	var sig1,sig2,bank=6,out1,out2,band_osc1,band_osc2,threshold1,threshold2,threshold3,phase1,phase2,phase3;
	var band_osc3,band_osc4,band_osc5,band_osc6,sig3,out3,cell_tria,b_x,b_y,b_z,polytope,gain1,gain2,gain3,env,azimuth,elevation;
	var magx,magy,magz,magqx,magqy,mod_anglex,anglex,angley,anglez,phasex,phasey,phasez,rq1,rq2,rq3,rq4,rq5,rq6;
	var mod_angley,mod_anglez,mx,my,mz,mqx,mqy,mag,mq,lfo,sph;
	var loc1,loc2,loc3,g=((1+5.sqrt)/2),s=(1+2.sqrt),tensor,dr;
	var amb_w,amb_x,amb_y,amb_z,out,amb_sig1,amb_sig2,amb_sig3,axisx,axisy,axisz,cx,cy,cz;
	var axi1,axi2,axi3,ds1,ds2,ds3,f1,f2,f3,g1,g2,g3,sph_object,lfon,axis;
	var r_axis, r_v, r, axisr,spr,rot,i,j,k,level=200;
	var g_ch1,g_ch2,g_ch3,g_ch4,chan=2,nn=0,lllx,llly,lllz;
	var gn ,g_sum,g_avg ,ton1,ton2,ton3,laxis,sp,spl,g11,g22,g33,g44,mp;
		var pon1,pon2,pon3,pon4;

fund=fu*(9/8);
lamdoma=(x.lag(0.001)+a.lag(0.001))/x.lag(0.001);




	//env=EnvGen.ar(Env.sine(9),doneAction:2,levelScale:10);
env=10;

	//lllx=(Select.kr(mm.lag(0.001),~cx)+Select.kr(mm.lag(0.001)+1,~cx)+Select.kr(mm.lag(0.001)+2,~cx))/3;
	//llly=(Select.kr(mm.lag(0.001),~cy)+Select.kr(mm.lag(0.001)+1,~cy)+Select.kr(mm.lag(0.001)+2,~cy))/3;
	//lllz=(Select.kr(mm.lag(0.001),~cz)+Select.kr(mm.lag(0.001)+1,~cz)+Select.kr(mm.lag(0.001)+2,~cz))/3;
//	lllx=Select.kr(mm.lag(0.001),~cx);
	//llly=Select.kr(mm.lag(0.001),~cy);
	//lllz=Select.kr(mm.lag(0.001),~cz);

//	tone1=lllx.linlin(0,1,0,14).round(1);
	//tone2=llly.linlin(0,1,0,14).round(1);
	//tone3=lllz.linlin(0,1,0,14).round(1);


ton1=2.pow(Select.kr(tone1.lag(0.01), Select.kr(qqq.lag(0.01),~sc)) /12).round(0.0001)*2.pow(dron.lag(0.01)/992);
ton2=2.pow(Select.kr(tone2.lag(0.01), Select.kr(qqq.lag(0.01),~sc)) /12).round(0.0001)*2.pow(dron.lag(0.01)/992);
ton3=2.pow(Select.kr(tone3.lag(0.01), Select.kr(qqq.lag(0.01),~sc)) /12).round(0.0001)*2.pow(dron.lag(0.01)/992);

						lfo=2.pow(pan/992);
				lfon=2.pow(pann/992);
					band=pan;

				mq=(m.lag(0.001)+1);

						cloud.do{
//spr=Cartesian(Select.kr(nn+mm.lag(0.0001),~cx),Select.kr(nn+mm.lag(0.0001),~cy),Select.kr(nn+mm.lag(0.0001),~cz));
		spr=Cartesian(Select.kr(mm.lag(0.0001),~cx),Select.kr(mm.lag(0.0001),~cy),Select.kr(mm.lag(0.0001),~cz));
				sph_object=spr;



	axis=Spherical(1,(sph_object.theta+azf).wrap(pi,pi.neg),  (sph_object.phi+elf).wrap((pi/2),(pi/2).neg));
				polytope=Cartesian(axis.x,axis.y,axis.z);
		mp=Spherical(sc,sph_object.theta,  sph_object.phi);

//b_x=2.pow(Select.kr(mp.x, ~scalee) /12).round(0.0001)*lamdoma;
//b_y=2.pow(Select.kr(mp.y, ~scalee) /12).round(0.0001)*lamdoma;
//b_z=2.pow(Select.kr(mp.z, ~scalee) /12).round(0.0001)*lamdoma

b_x=2.pow(mp.x.round(0.0001) /992).round(0.0001)*lamdoma;
b_y=2.pow(mp.y.round(0.0001) /992).round(0.0001)*lamdoma;
b_z=2.pow(mp.z.round(0.0001) /992).round(0.0001)*lamdoma;

anglex=(exp(Complex(0,1)*polytope.theta).real*exp(Complex(0,1)*polytope.phi).real).round(0.00001);
angley=(exp(Complex(0,1)*polytope.theta).imag*exp(Complex(0,1)*polytope.phi).real).round(0.00001);
anglez=(exp(Complex(0,1)*polytope.phi).imag).round(0.00001);

phase1=(Complex(1,anglex).theta*4);
phase2=(Complex(1,angley).theta*4);
phase3=(Complex(1,anglez).theta*2);


//mod_anglex=SinOsc.ar(lfon,phase1).range(pi.neg,pi).lag(0.01);
//mod_angley=SinOsc.ar(lfon,phase2).range(pi.neg,pi).lag(0.01);
//mod_anglez=SinOsc.ar(lfon,phase3).range(35.264390.degrad,35.264390.degrad.neg).lag(0.01);

		 mod_anglex=(LPF.ar((Osc.ar(~w1.bufnum,lfon,phase:phase1,mul:level).abs*SinOsc.ar(lfon,phase:phase1)),lfon*2.pow(low.lag(0.01)/992),1).range(panx*1,1)+(LPF.ar((Osc.ar(~w1.bufnum,lfon/8,phase:phase1,mul:level).abs*SinOsc.ar(lfon/8,phase:phase1)),(lfon/8)*2.pow(low.lag(0.01)/992),(lfon/8).reciprocal))).range(pi.neg,pi).lag(0.01);

		mod_angley=(LPF.ar((Osc.ar(~w1.bufnum,lfon,phase:phase2,mul:level).abs*SinOsc.ar(lfon,phase:phase2)),lfon*2.pow(low.lag(0.01)/992),1).range(pany*1,1)+(LPF.ar((Osc.ar(~w1.bufnum,lfon/8,phase:phase2,mul:level).abs*SinOsc.ar(lfon/8,phase:phase2)),(lfon/8)*2.pow(low.lag(0.01)/992),(lfon/8).reciprocal))).range(pi.neg,pi).lag(0.01);

		mod_anglez=(LPF.ar((Osc.ar(~w1.bufnum,lfon,phase:phase3,mul:level).abs*SinOsc.ar(lfon,phase:phase3)),lfon*2.pow(low.lag(0.01)/992),1).range(panz*1,1)+(LPF.ar((Osc.ar(~w1.bufnum,lfon/8,phase:phase3,mul:level).abs*SinOsc.ar(lfon/8,phase:phase3)),(lfon/8)*2.pow(low.lag(0.01)/992),(lfon/8).reciprocal))).range(35.264390.degrad,35.264390.degrad.neg).lag(0.01);

					(
	magx=((Complex(cos(((polytope.theta+mod_anglex).round(0.00001)*m).wrap(pi.neg,pi)),cos((((polytope.theta+mod_anglex).round(0.00001)*m)).wrap(pi.neg,pi))).rho/(2.sqrt))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt));
				);

magy=((Complex(sin(((polytope.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi)),sin(((polytope.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi))).rho/(2.sqrt))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt));
				);

magz=((Complex(cos(((polytope.phi+mod_anglez).round(0.00001)*m).wrap((pi/2).neg,(pi/2))),cos(((polytope.phi).round(0.00001)*m).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

magqx=(((Complex(cos(((polytope.theta+mod_anglex)*mq).wrap(pi.neg,pi)),cos(((polytope.theta+mod_anglex)*mq).round(0.00001).wrap(pi.neg,pi))))*
(Complex(sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2))),sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt);



 magqy=((((Complex(sin(((polytope.theta.round(0.00001)+mod_angley)*mq).wrap(pi.neg,pi)),
sin(((polytope.theta.round(0.00001)+mod_angley)*mq).wrap(pi.neg,pi))))*
(Complex(sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),
cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt));
	);

					mx=(Cartesian(magx,0,0).rho);
					my=(Cartesian(0,magy,0).rho);
					mz=(Cartesian(0,0,magz).rho);
		mag=(Cartesian(mx,my,mz)) ;

		sph=Spherical(mag.rho,polytope.theta,polytope.phi);

loc1=mx;  loc2=magy;  loc3=magz;

phasex=Complex(1,sph.x).theta*4;
phasey=Complex(1,sph.y).theta*4;
phasez=Complex(1,sph.z).theta*2;


freq1=(fund)*b_x.lag(0.0001);
freq2=(fund)*b_y.lag(0.0001);
freq3=(fund)*b_z.lag(0.0001);

					dr=2.pow(drone.lag(0.1)/12);

		amp1=b_x.reciprocal;
amp2=b_y.reciprocal;
amp3=b_z.reciprocal;

f1=(fund)*b_x.lag(0.01)*dr;
f2=(fund)*b_y.lag(0.01)*dr;
f3=(fund)*b_z.lag(0.01)*dr;

g1=b_x.reciprocal*dr.reciprocal;
g2=b_y.reciprocal*dr.reciprocal;
g3=b_z.reciprocal*dr.reciprocal;

g1=b_x.reciprocal*dr.reciprocal;
g2=b_y.reciprocal*dr.reciprocal;
g3=b_z.reciprocal*dr.reciprocal;

band_osc1=SinOsc.kr(b_x*2.pow(band.lag(0.0001)/992),phase:phasex).exprange(496,16256);
band_osc2=SinOsc.kr(b_y*2.pow(band.lag(0.0001)/992),phase:phasey).exprange(496,16256);
band_osc3=SinOsc.kr(b_z*2.pow(band.lag(0.0001)/992),phase:phasez).exprange(496,16256);
band_osc4=SinOsc.kr(b_x*2.pow(band.lag(0.0001)/992),phase:phasex.neg).exprange(496,16256);
band_osc5=SinOsc.kr(b_y*2.pow(band.lag(0.0001)/992),phase:phasey.neg).exprange(496,16256);
band_osc6=SinOsc.kr(b_z*2.pow(band.lag(0.0001)/992),phase:phasez.neg).exprange(496,16256);

rq1=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_x*2.pow(band.lag(0.0001)/992),phase:phasex,mul:rq).exprange(0.1,1)]);
rq2=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_y*2.pow(band.lag(0.0001)/992),phase:phasey,mul:rq).exprange(0.1,1)]);
rq3=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_z*2.pow(band.lag(0.0001)/992),phase:phasez,mul:rq).exprange(0.1,1)]);
rq4=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_x*2.pow(band.lag(0.0001)/992),phase:phasex.neg,mul:rq).exprange(0.1,1)]);
rq5=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_y*2.pow(band.lag(0.0001)/992),phase:phasey.neg,mul:rq).exprange(0.1,1)]);
rq6=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_z*2.pow(band.lag(0.0001)/992),phase:phasez.neg,mul:rq).exprange(0.1,1)]);


control1=SinOsc.ar(freq1,phase:phasex,mul:amp1);
control2=SinOsc.ar(freq2,phase:phasey,mul:amp2);
control3=SinOsc.ar(freq3,phase:phasez,mul:amp3);


				//rectifier mod
ds1=((LPF.ar((Osc.ar(~w1.bufnum,f1,phase:phasex,mul:level).abs*
					SinOsc.ar(f1,phase:phasex)),f1*2.pow(low.lag(0.01)/992),g1)).range(panx*g1,g1)
					+BPF.ar(BrownNoise.ar(qq.sqrt.reciprocal),f1*dr,qq,g1/dr));
ds2=((LPF.ar((Osc.ar(~w1.bufnum,f2,phase:phasey,mul:level).abs*
					SinOsc.ar(f2,phase:phasey)),f2*2.pow(low.lag(0.01)/992),g2)).range(pany*g2,g2)
					+BPF.ar(BrownNoise.ar(qq.sqrt.reciprocal),f2*dr,qq,g2/dr));
ds3=((LPF.ar((Osc.ar(~w1.bufnum,f3,phase:phasez,mul:level).abs*
					SinOsc.ar(f3,phase:phasez)),f3*2.pow(low.lag(0.01)/992),g3)).range(panz*g3,g3)
					+BPF.ar(BrownNoise.ar(qq.sqrt.reciprocal),f3*dr,qq,g3/dr));


ds1 = (tanh((ds1*2.pow(drive/992)).softclip)) / (1 + (tanh((ds1*2.pow(drive/992)).softclip)).abs);
ds2 =  (tanh((ds2*2.pow(drive/992)).softclip)) / (1 + (tanh((ds2*2.pow(drive/992)).softclip)).abs);
ds3 =  (tanh((ds3*2.pow(drive/992)).softclip)) / (1 + (tanh((ds3*2.pow(drive/992)).softclip)).abs);

sig1=(LPF.ar((Osc.ar(~w1.bufnum,freq1,phase:phasex,mul:level).abs*SinOsc.ar(freq1,phase:phasex)),freq1*2.pow(low.lag(0.01)/992),amp1).range(panx*amp1,amp1)+(ds1));
sig2=(LPF.ar((Osc.ar(~w1.bufnum,freq2,phase:phasey,mul:level).abs*SinOsc.ar(freq2,phase:phasey)),freq2*2.pow(low.lag(0.01)/992),amp2).range(pany*amp2,amp2)+(ds2));
sig3=(LPF.ar((Osc.ar(~w1.bufnum,freq3,phase:phasez,mul:level).abs*SinOsc.ar(freq3,phase:phasez)),freq3*2.pow(low.lag(0.01)/992),amp3).range(panz*amp3,amp3)+(ds3));

	sig1=Select.ar(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
						[sig1,BPF.ar(BRF.ar(sig1,band_osc1.lag(0.1),rq1),band_osc4.lag(0.1),rq4)]);
	sig2=Select.ar(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
						[sig2,BPF.ar(BRF.ar(sig2,band_osc2.lag(0.1),rq2),band_osc5.lag(0.1),rq5)]);
	sig3=Select.ar(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
						[sig3,BPF.ar(BRF.ar(sig3,band_osc3.lag(0.1),rq3),band_osc6.lag(0.1),rq6)]);

threshold1=(((343/0.1)/fund).reciprocal.ampdb/2.sqrt).dbamp;
threshold2=(((343/0.1)/fund).reciprocal.ampdb/2.sqrt).dbamp;
threshold3=(((343/0.1)/fund).reciprocal.ampdb/2.sqrt).dbamp;

		sig1=HPF.ar(sig1,50);
		sig2=HPF.ar(sig2, 50);
		sig3=HPF.ar(sig3, 50);

		sig1=Compander.ar(sig1,control1,threshold1,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);
		sig2=Compander.ar(sig2,control2,threshold2,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);
		sig3=Compander.ar(sig3,control3,threshold3,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);

	///distortion


		sig1 = (tanh((sig1*2.pow(drive/992)).softclip)) / (1 + (tanh((sig1*2.pow(drive/992)).softclip)).abs);

		sig2 =  (tanh((sig2*2.pow(drive/992)).softclip)) / (1 + (tanh((sig2*2.pow(drive/992)).softclip)).abs);

	sig3 =  (tanh((sig3*2.pow(drive/992)).softclip)) / (1 + (tanh((sig3*2.pow(drive/992)).softclip)).abs);

	///final out

					gain1=gain*rq1.sqrt.reciprocal*cloud.reciprocal*env*namp1;
					gain2=gain*rq2.sqrt.reciprocal*cloud.reciprocal*env*namp2;
					gain3=gain*rq3.sqrt.reciprocal*cloud.reciprocal*env*namp3;

					sp=azf;
					spl=elf;



g_ch1 = (
   (Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).x *
							Spherical(mag.x,~az[0],~el[0]).x) +
 (Spherical(my.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).y *
							Spherical(mag.y,~az[0],~el[0]).y)+
  (Spherical(mz.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).z *
							Spherical(mag.z,~az[0],~el[0]).z)
);

g_ch2 = (
   (Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).x *
							Spherical(mag.x,~az[1],~el[1]).x)+
(Spherical(mz.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).y *
							Spherical(mag.y,~az[1],~el[1]).y)+
  (Spherical(mz.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).z *
							Spherical(mag.z,~az[1],~el[1]).z)
);

g_ch3 = (
  (Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).x *
							Spherical(mag.x,~az[2],~el[2]).x)+
   (Spherical(my.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).y *
							Spherical(mag.y,~az[2],~el[2]).y)+
  (Spherical(mz.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).z *
							Spherical(mag.z,~az[2],~el[2]).z)
);

g_ch4 = (
(Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).x *
							Spherical(mag.x,~az[3],~el[3]).x) +
 (Spherical(my.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).y *
							Spherical(mag.y,~az[3],~el[3]).y)+
   (Spherical(mz.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).z *
							Spherical(mag.z,~az[3],~el[3]).z)
					);

g_ch1 = g_ch1.pow(spread.reciprocal);
g_ch2 = g_ch2.pow(spread.reciprocal);
g_ch3 = g_ch3.pow(spread.reciprocal);
g_ch4 = g_ch4.pow(spread.reciprocal);


pon1=SinOsc.ar(pon*lfon,0).range(0.0001,1).lag(0.1);
pon2=SinOsc.ar(pon*lfon,0.25pi).range(0.0001,1).lag(0.1);
pon3=SinOsc.ar(pon*lfon,0.5pi).range(0.0001,1).lag(0.1);
pon4=SinOsc.ar(pon*lfon,0.75pi).range(0.0001,1).lag(0.1);

		/*(
Out.ar(0,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
	sig1* g_ch1.lag(0.1)*pon1,mix.lag(0.01),room.lag(0.01),mul:gain1)),0.9,0.01));
Out.ar(1,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig1* g_ch2.lag(0.1)*pon2,mix.lag(0.01),room.lag(0.01),mul:gain1)),0.9,0.01));
Out.ar(2,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig1* g_ch3.lag(0.1)*pon3,mix.lag(0.01),room.lag(0.01),mul:gain1)),0.9,0.01));
Out.ar(3,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig1* g_ch4.lag(0.1)*pon4,mix.lag(0.01),room.lag(0.01),mul:gain1)),0.9,0.01));

Out.ar(0,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig2* g_ch1.lag(0.1)*pon1,mix.lag(0.01),room.lag(0.01),mul:gain2)),0.9,0.01));
Out.ar(1,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig2* g_ch2.lag(0.1)*pon2,mix.lag(0.01),room.lag(0.01),mul:gain2)),0.9,0.01));
Out.ar(2,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig2* g_ch3.lag(0.1)*pon3,mix.lag(0.01),room.lag(0.01),mul:gain2)),0.9,0.01));
Out.ar(3,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig2* g_ch4.lag(0.1)*pon4,mix.lag(0.01),room.lag(0.01),mul:gain2)),0.9,0.01));

Out.ar(0,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig3* g_ch1.lag(0.1)*pon1,mix.lag(0.01),room.lag(0.01),mul:gain3)),0.9,0.01));
Out.ar(1,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig3* g_ch2.lag(0.1)*pon2,mix.lag(0.01),room.lag(0.01),mul:gain3)),0.9,0.01));
Out.ar(0,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig3* g_ch3.lag(0.1)*pon3,mix.lag(0.01),room.lag(0.01),mul:gain3)),0.9,0.01));
Out.ar(3,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig3* g_ch4.lag(0.1)*pon4,mix.lag(0.01),room.lag(0.01),mul:gain3)),0.9,0.01));
		)*/

									Out.ar(0,WhiteNoise.ar(0.00001)!4);
					///three channel
Out.ar(0,Pan2.ar(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:gain1*mx.lag(0.01))),0.9,0.01),
						SinOsc.ar(lfon*pon,0)));
Out.ar(0,Pan2.ar(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:gain2*my.lag(0.01))),0.9,0.01),SinOsc.ar(lfon*pon,90.degrad)));
//Out.ar(0,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:gain3*mz.lag(0.01))),0.9,0.01)!2);//
//
						//azf = (azf+(2pi-(2pi/s))).wrap(pi.neg,pi);
		azf=0;
		 //  elf = (elf+(pi-(pi/s))).wrap((pi/2).neg,(pi/2));
		elf=0;
nn=nn+1;
				};

}).add;);
(
(
~synth=Synth.new(\synth,[\gain,2,\drive,992*2,\fu,64*(9/8),\sc,992*4,\low,992*2,
	\pan,(992*16).neg,\mix,0.8,\room,0.7,\mm,0,\m,2,\tone1,0,\tone2,0,\tone3,0,
	\pann,(992*1.neg).neg,\x,2,\a,1,\spread,1,\pon,1,\qq,0.000001,\qqq,1.rand,\spirit,0.1,
	\pneuma,0,\namp,1,\drone,36.neg,\panx,0,\pany,0,\panz,0,\dron,0]).register;);

(
~r1 = Routine({
    var i,m,l=0;
    220.do{
					//	thisThread.randSeed = ~val.asInteger;
						//	TempoClock.default.tempo_(1);

		~synth.set(\mm,l.postln);

l=l+1;
      //  ~seq1.next.wait;
		(4).wait;

    };
	~synth.free;
		});
);
	~r1.play;
s.record(numChannels:2)
)


////durs
	/*	(
~azz=[0.degrad,0.degrad,90.degrad,180.degrad,90.neg.degrad,0.degrad];
~ell=[90.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,90.degrad];
);

	({var m1=1.neg, m2=1.neg, m3=1.neg,a,b,c,n=0,bank=4,time=32.reciprocal,beat=1,r=0;

			~dur1=[];~dur2=[];~dur3=[]; ~dx=[];~dy=[]; ~dz=[]; ~durx=[]; ~dury=[]; ~durz=[]; ~dur=[];
			~r1=0; ~r2=0; ~r3=0;

					1.do{
~x=bank.collect{
m1=m1+1;
					b=Spherical(beat,~azz.[m1],~ell.[m1]).rotate(~r1).tilt(~r2).tumble(~r3).x.round(0.00001);
	2.pow(b).round(time);
};
~y=bank.collect{
m2=m2+1;
	c=Spherical(beat,~azz.[m2],~ell.[m2]).rotate(~r1).tilt(~r2).tumble(~r3).y.round(0.00001);
	2.pow(c).round(time);
};
~z=bank.collect{
m3=m3+1;
	d=Spherical(beat,~azz.[m3],~ell.[m3]).rotate(~r1).tilt(~r2).tumble(~r3).z.round(0.00001);
	2.pow(d).round(time);
}; m1=1.neg; m2=1.neg; m3=1.neg; ~dx=~dx++~x; ~dy=~dy++~y;  ~dz=~dz++~z;   ~x=[]; ~y=[]; ~z=[];  r=r+90.degrad; };

				bank.do{ ~dur1=~dur1++~dx.[n];n=n+1;};n=0;
		//	~durx = ~dur1.collect { |x| if (x == 0) { Rest(2) } { x }};

		bank.do{ ~dur2=~dur2++~dy.[n];n=n+1;};n=0;
			//	~dury = ~dur2.collect { |x| if (x == 0) { Rest(2) } { x }};

		bank.do{ ~dur3=~dur3++~dz.[n];n=n+1;};n=0;
			//	~durz = ~dur3.collect { |x| if (x == 0) { Rest(2) } { x }};

			~dur=~dur++~dur1++~dur2++~dur3;

}.value;
);
*/
		////////2////sequencer
		/*(

			~seq1= Pseq(~dur, inf).asStream;
				~seq2 = Pseq(~dur2, inf).asStream;
				~seq3 = Pseq(~dur3, inf).asStream;
		//~system= Pseq(~r,inf).asStream;
			~tonb=0;
			~panwidth=1;
			~pass=992*1;
			~drive=992*2;
			~mox=0.7;
			~gg=1;
			~pon=0.01;
			~sphpan=(992*32).neg;
			~bband=(992*16).neg;
			~drn=0.1;
	~od=5.neg;
	~rev=0.8;
		//	thisThread.randSeed = 123;

~r1 = Routine({
    var i,m,l=0;
    60.do{
					//	thisThread.randSeed = ~val.asInteger;
							TempoClock.default.tempo_(1);

	~synth=Synth.new(\synth,[\gain,~gg,\drive,~drive,\fu,16,\sc,14,\low,~pass,\pan,~bband,\mix,~mox,\room,~rev,\pann,~sphpan,\x,2,\a,1,\spread,~panwidth,\pon,~pon,\pneuma,0,\namp,1,\drone,~od,\panx,0,
				\pany,0.1,\panz,0.1,\dron,~tonb,\mm,l]).register;

l=l+7;
      //  ~seq1.next.wait;
			(1).wait;

    }
		});


		)*/;


	~r1.play;
s.record;

	~r1.stop;



		TempoClock.default.tempo_(1/1);









/*
/tetrahedron
(
~az=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
//////cube
(
~az=[45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad];
)

/////octahedron

(
~az=[0.degrad,0.degrad,90.degrad,180.degrad,90.neg.degrad,0.degrad];
~el=[90.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,90.degrad];
)

//////icosahedron
(
~az=[90.degrad,90.neg.degrad,0.degrad,180.degrad,58.28.degrad,121.72.degrad,121.72.neg.degrad,58.neg.degrad,90.degrad,90.neg.degrad,0.degrad,180.degrad];
~el=[58.28.neg.degrad,58.28.neg.degrad,31.72.neg.degrad,31.72.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,58.28.degrad,58.28.degrad,31.72.degrad,31.72.degrad];
)

/////dodecahedron

(
~az=[45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,90.degrad,90.neg.degrad,0.degrad,180.degrad,45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,90.degrad,
	90.neg.degrad,69.09.degrad,110.91.degrad,110.91.neg.degrad,69.09.neg.degrad,0.degrad,180.degrad];

~el=[35.26.neg.degrad,35.26.neg.degrad,35.26.neg.degrad,35.26.neg.degrad,69.09.neg.degrad,69.09.neg.degrad,20.91.neg.degrad,20.91.neg.degrad,
	35.26.degrad,35.26.degrad,35.26.degrad,35.26.degrad,69.09.degrad,69.09.degrad,0.degrad,0.degrad,0.degrad,0.degrad,20.91.degrad,20.91.degrad]
)

/////Rhombic dodecahedron//// hull

(
~az=[0.degrad,45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,0.degrad,180.degrad,90.degrad,90.neg.degrad,0.degrad,
	45.degrad,135.neg.degrad,135.degrad,45.neg.degrad];
~el=[90.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,0.degrad
	,0.degrad,0.degrad,0.degrad,90.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad];
)

/////cuboctahedron//// core

(
~az=[0.degrad,90.degrad,180.degrad,90.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,
	0.degrad,90.degrad,180.degrad,90.neg.degrad];
~el=[45.neg.degrad,45.neg.degrad,45.neg.degrad,45.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,
	45.degrad,45.degrad,45.degrad,45.degrad];
)


///////////////Rhombic Triacontahedron//// hull
(
~az=[0.degrad,0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,
	0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,
	0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,0.degrad];

~el=[90.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,52.6.degrad,52.6.degrad,52.6.degrad,52.6.degrad,52.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,10.8.degrad,10.8.degrad,10.8.degrad,10.8.degrad,10.8.degrad,90.degrad];

)

///////icosidodecahedron//// core
(
~az=[18.degrad,90.degrad,162.degrad,126.neg.degrad,54.neg.degrad,54.degrad,126.degrad,162.neg.degrad,90.neg.degrad,18.neg.degrad,
	0.degrad,36.degrad,72.degrad,108.degrad,144.degrad,180.degrad,144.neg.degrad,108.neg.degrad,72.neg.degrad,36.neg.degrad,
	54.degrad,126.degrad,162.neg.degrad,90.neg.degrad,18.neg.degrad,18.degrad,90.degrad,162.degrad,126.neg.degrad,54.neg.degrad];

~el=[58.283.degrad,58.283.degrad,58.283.degrad,58.283.degrad,58.283.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,
37.717.degrad,37.717.degrad,37.717.degrad,37.717.degrad,37.717.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad];

)*/