(
{
var x,y,t=0.5pi,n=3,fund=110,f1,f2;
t=MouseX.kr(0,2pi);
x=(n*cos(t))+cos(n*t);
y=(n*sin(t))+sin(n*t);
x.poll;
f1=2.pow(x.round(1)/12);
f2=2.pow(y.round(1)/12);
f1=1;
f2=2;
Out.ar(0,Pan2.ar(SinOsc.ar(fund*f1,f1*pi,f1.reciprocal),x.linlin((n+1).neg,(n+1),1.neg,1)));
Out.ar(0,Pan2.ar(SinOsc.ar(fund*f2,f2*pi,f2.reciprocal),y.linlin((n+1).neg,(n+1),1.neg,1)));
}.play;
)



mp_x = (sc)  * cos(el) * cos(az);
mp_y = (sc)  * cos(el) * sin(az);
mp_z = (sc)  * sin(el);

//sphere
	x = (n*cos(el)*cos(az))+(cos(n*el)*cos(n*az));
	y = (n*cos(el)*sin(az))+(cos(n*el)*sin(n*az));
	z = (n*sin(el))+(sin(n*el));


///sph coo
radius    = n + cos(n*t) * cos(t)
azimuth   = t
elevation = n*t
