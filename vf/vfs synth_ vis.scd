//image plotter
~lin=100;
~shad=8;
({
var w,u,size=1000,diameter=400,n=0,m=0,k=0;
var r_az = 0.0,r_el = 0.0,az,el,cp,protaz,protel;
var point,perspective,dist=600,depth=2,mag=1;
var rx = 0.0,ry = 0.0,rz = 0.0,rate=0.01;
var plane,pointx,pointy;
var d_o=4,lined=25,run = true,tilt=0.15pi;
var wave=12,sph,ratio1,ratio2,ratio3;

~verticef=~set;
w = Window("3d Plotter", Rect(400,100,size,size));
v = UserView(w, w.view.bounds).background_(Color.black);

v.drawFunc = {
Pen.translate(v.bounds.width/2,v.bounds.height/2);
///Pen.scale(0.5, 2);
~point_cloud=[];
d_o=1;
wave=(~controlBus_1.getSynchronous.abs+~controlBus_2.getSynchronous.abs)*~shad;
dist=~dist1*diameter;
lined=(~controlBus_1.getSynchronous.abs+~controlBus_2.getSynchronous.abs)*~lin;
n=0;
(~verticef).do {
//mag=(Cartesian(~magxf.[n],~magyf.[n],~magzf.[n]).rho/(2.sqrt));
point = Cartesian(~cx.[n],~cy.[n],~cz.[n])*diameter*mag;
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
Pen.width = perspective.clip(2,1.0)*d_o/wave;
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