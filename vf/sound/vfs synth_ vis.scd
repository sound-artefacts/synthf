(
//image plotter
~lin=60;
~shad=0.33;
~do=1;
~r=400;
~clp1=2;
~clp2=2;
~clp3=2;
~da=300;
~clpz=1000;
~scale=2000;
~rox=0;
~roy=0;
~roz=0;
//~harm=1;
({
var w,u,size=1000,diameter=300,n=0,m=0,k=0;
var r_az = 0.0,r_el = 0.0,az,el,cp,protaz,protel;
var point,perspective,dist=200,depth=2,mag=1;
var rx = 0.0,ry = 0.0,rz = 0.0,rate=0.01;
var plane,pointx,pointy,x,y,z,rr,rot;
var d_o=4,lined=25,run = true,tilt=0.15pi;
var wave=12,sph,ratio1,ratio2,ratio3,px,py,pz;

~verticef=~set;
w = Window("3d Plotter", Rect(400,100,size,size));
v = UserView(w, w.view.bounds).background_(Color.black);

v.drawFunc = {
Pen.translate(v.bounds.width/2,v.bounds.height/2);
///Pen.scale(0.5, 2);
diameter=~da;
~harm;
~point_cloud=[];
d_o=~do;
wave=~shad;
diameter=~r	;
dist=~dist1*diameter;
lined=~lin;
n=0;


(~verticef).do {

//rot=Spherical(1,~azr.[n],~elr.[n]);
rot=Cartesian(~cx.[n],~cy.[n],~cz.[n]);
//rot=rot.rotateYZ(~controlBus_1.getSynchronous.reciprocal/2pi/~scale).rotateXZ(~controlBus_2.getSynchronous.reciprocal/2pi/~scale).rotateXY(~controlBus_3.getSynchronous.reciprocal/2pi/~scale);

//x = (~harm*cos(rot.phi)*cos(rot.theta))+(cos(~harm*rot.phi)*cos(~harm*rot.theta));
///y = (~harm*cos(rot.phi)*sin(rot.theta))+(cos(~harm*rot.phi)*sin(~harm*rot.theta));
//z = (~harm*sin(rot.phi))+(sin(~harm*rot.phi));

px=((~cx.[n]*diameter)*1).clip2(diameter/~clp1);
py=((~cy.[n]*diameter)*1).clip2(diameter/~clp2);
pz=((~cz.[n]*diameter)*1).clip2(diameter/~clp3);

///////use fixed rotations for vanishing points and animated for contnious frame rotation
// X rotation
point = Cartesian(px,py,pz).rotateYZ(~rox);
// Y rotation
point = point.rotateXZ(~roy);
// Z rotation
point = point.rotateXY(~roz);

//point = Cartesian(px,py,pz);

//////remaping
//plane=Complex(point.x,point.y);
//cp=Polar(point.z,plane.theta);
cp=point;
////////////////////perspective
perspective = dist / (dist + point.z + (dist/depth));///remove (dist/2) for no depth
///color
Pen.fillColor = Color.white.alpha_(perspective.clip(0.1,1.0));
Pen.strokeColor = Color.white.alpha_(perspective.clip(0.1,1.0));
//////points
pointx=cp.x*perspective;
pointy=cp.y*perspective;
~point_cloud=~point_cloud++Point(pointx,pointy);
///point_oval
Pen.addOval(Rect.aboutPoint(Point(pointx,pointy),d_o*perspective,d_o*perspective));
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
Pen.width = perspective*wave;
Pen.fillColor = Color.white.alpha_(perspective.clip(0.1,1.0));
Pen.strokeColor = Color.white.alpha_(perspective.clip(0.1,1.0));
(if(~point_cloud[n].dist(~point_cloud[m]) < lined)
{Pen.line( ~point_cloud.[n], ~point_cloud.[m])};);
Pen.fillStroke;
m=m+1;k=k+1
};n=n+1;
};
)
};
{ while { run } {v.background_(Color.black); v.refresh; (~timbr_dur).wait } }.fork(AppClock);
w.front;
}.defer);

Routine({
inf.do {
(
~rox=(~rox +0.001).wrap(0,2pi);
~roy=(~roy +0.001).wrap(0,2pi);
~roz=(~roz +0.001).wrap(0,2pi);
);
{v.refresh}.defer;
(0.01).wait;
};
}).play;
)