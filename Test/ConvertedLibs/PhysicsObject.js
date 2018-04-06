/*
	WARNING: Not all functions have been converted yet
*/
var vectorMath3D = new vector(0,0,0);
var Physics = new physics();

var PhysicsObject = function() {

}
PhysicsObject.prototype.Bfield = function(ball, velocity, bfield, scale2) {
	var force;
	
	var accel = new vector(0, 0, 0);
	var gamma = Physics.gamma(vectorMath3D.mag(velocity) / scale2);
	//var c = 3E8;
	//gamma = 1/(Math.sqrt(1-((vectorMath3D.mag(velocity)/scale2)*(vectorMath3D.mag(velocity)/scale2))/(c*c)));
	force = vectorMath3D.mult(Physics.BForce(ball.q, bfield, velocity), 1);//, 1/gamma);

	accel = vectorMath3D.mult(force, 1 / (ball.mass * gamma));
	return accel;
}
PhysicsObject.prototype.Efield = function(ball, velocity, E, scale2) {
	var force;
	
	var accel = new vector(0, 0, 0);
	var gamma = 1;
	var c = Physics.c();
	gamma = 1 / (Math.sqrt(1 - ((vectorMath3D.mag(velocity) / scale2) * (vectorMath3D.mag(velocity) / scale2)) / (c * c)));
	
	force = vectorMath3D.mult(Physics.EForce(ball.q, E), 1 / (gamma * gamma * gamma));
	
	accel = vectorMath3D.mult(force, 1 / ball.mass);
	return accel;
}
PhysicsObject.prototype.RK4EB = function(ball,B,scale2,E) {
	
	var k1r;
	var k2r;
	var k3r;
	var k4r;
	var k1v;
	var k2v;
	var k3v;
	var k4v;
	
	
	var vtemp;
	var rtemp;
	var r_new;
	var v_new;
	var dt = ball.dt;
	var v_old;
	var r_old;
	v_old = ball.v_old;
	r_old = ball.r_old;
	
	/*r_old = ball.posStart;
	v_old = ball.v1Start;
	a_old = ball.aStart;
	trace(dt);*/
	
	
	//1st set of derivatives
	k1r = v_old;
	rtemp = vectorMath3D.add(r_old, vectorMath3D.mult(k1r, dt * 0.5));

	// var btemp = this.Bfield(ball, v_old, B, scale2);
	// console.log(btemp);
	
	k1v = vectorMath3D.add(this.Bfield(ball, v_old, B, scale2), this.Efield(ball, v_old, E, scale2));
	// console.log(k1v);
	vtemp =  vectorMath3D.add(v_old, vectorMath3D.mult(k1v, dt * 0.5));

	//2nd set of derivatives
	k2r = vtemp;
	rtemp =  vectorMath3D.add(r_old, vectorMath3D.mult(k2r, dt * 0.5));
	k2v = vectorMath3D.add(this.Bfield(ball, vtemp, B, scale2),this.Efield(ball, vtemp, E, scale2));
	vtemp = vectorMath3D.add(v_old, vectorMath3D.mult(k2v, dt * 0.5));

	//3rd set of derivatives
	k3r = vtemp;
	rtemp = vectorMath3D.add(r_old, vectorMath3D.mult(k3r, dt));
	k3v = vectorMath3D.add(this.Bfield(ball, vtemp, B, scale2), this.Efield(ball, vtemp, E, scale2));
	vtemp = vectorMath3D.add(v_old, vectorMath3D.mult(k3v, dt));

	//4th set of derivatives
	k4r = vtemp;
	k4v =vectorMath3D.add(this.Bfield(ball, vtemp, B, scale2), this.Efield(ball, vtemp, E, scale2));

	//combine the derivatives
	r_new = vectorMath3D.add(vectorMath3D.mult(vectorMath3D.add(vectorMath3D.add(vectorMath3D.add(vectorMath3D.mult(k2r,2),vectorMath3D.mult(k3r,2)),k1r),k4r),dt/6),r_old);
	v_new = vectorMath3D.add(vectorMath3D.mult(vectorMath3D.add(vectorMath3D.add(vectorMath3D.add(vectorMath3D.mult(k2v,2),vectorMath3D.mult(k3v,2)),k1v),k4v),dt/6),v_old);
	ball.xPos = r_new.x;
	ball.yPos = r_new.y;
	ball.z = r_new.z;
	ball.v_old = v_new;
	ball.r_old = r_new;
}