//image plotter
~lin=60;
~shad=0.25;
~do=1;
~clp=3;
~da=500;
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
dist=~dist1*diameter;
lined=~lin;
n=0;


(~verticef).do {

rot=Spherical(1,~azr.[n],~elr.[n]);
rot=rot.rotateYZ(~controlBus_1.getSynchronous.reciprocal/2pi).rotateXZ(~controlBus_2.getSynchronous.reciprocal/2pi).rotateXY(~controlBus_3.getSynchronous.reciprocal/2pi);

x = (~harm*cos(rot.phi)*cos(rot.theta))+(cos(~harm*rot.phi)*cos(~harm*rot.theta));
y = (~harm*cos(rot.phi)*sin(rot.theta))+(cos(~harm*rot.phi)*sin(~harm*rot.theta));
z = (~harm*sin(rot.phi))+(sin(~harm*rot.phi));


px=((~cx.[n]*diameter*~harm.reciprocal)*x).clip2(diameter/~clp);
py=((~cy.[n]*diameter*~harm.reciprocal)*y).clip2(diameter/~clp);
pz=((~cz.[n]*diameter*~harm.reciprocal)*z).clip2(diameter/~clp);

point = Cartesian(px,py,pz);

//////remaping
plane=Complex(point.x,point.y);
cp=Polar(point.z,plane.theta);
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
}.defer)