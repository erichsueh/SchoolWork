var vectorMath = new vector(0,0,0); // used for math

var physics = function () {

}
physics.prototype.c = function() {
	return 3.0e8;
};
physics.prototype.h = function() {
	return 6.6260755e-34;
}

physics.prototype.G = function() {
	return 6.67e-11;
}

physics.prototype.q = function() {
	return 1.602e-19;
}

physics.prototype.me = function() {
	return 9.1093897e-31;
}

physics.prototype.mp = function() {
	return 1.6726231e-27;
}

physics.prototype.u = function() {
	return 1.66054e-27;
}

/////////////////////////////////////////////////////////////////////////////
//ELEMENTARY MECAHNICS
/////////////////////////////////////////////////////////////////////////////

physics.prototype.KineticEnergy = function(mass, vx, vy) {
	return 0.5 * mass * (vx * vx + vy * vy);
}

physics.prototype.Momentum = function(mass, vx, vy) {
	return mass * Math.sqrt(vx * vx + vy * vy);
}

physics.prototype.RotEnergy = function(I, w) {
	return 0.5 * I * w * w;
}

//Centripetal force
physics.prototype.Fcen = function(mass, vel, radius) {
	return mass * vel * vel / radius;
}

//ELECTROSTATICS
physics.prototype.Coulomb = function(k, q1, q2, rad) {
	return k * q1 * q2 / (rad * rad);
}

//Electric potential for a point charge
physics.prototype.Vpoint = function(k, q1, q2, rad) {
	return k * q1 * q2 / rad;
}

//3D vectorMath force on particle in E  field, returns vectorMath force
physics.prototype.EForce = function(q, E) {
	var F = vectorMath.mult(E, q);
	return(F);
}

// 3D vectorMath force on particle in B  field, returns vectorMath force
physics.prototype.BForce = function(q, v, B) {
	var F = vectorMath.cross(v, B);
	F = vectorMath.mult(F, q);
	
	// Lorentz returns combined E and B forces on particle, returns force
	return(F);
}
/////////////////////////////////////////////////////////////////////////////
//RELATIVISTIC PHYSICS
/////////////////////////////////////////////////////////////////////////////

//gamma function
physics.prototype.gamma = function(v) {
	var  c = this.c();
	return 1 / Math.sqrt(1 - Math.pow(v / c, 2));
}

physics.prototype.momR = function(v,mass) {
	return this.gamma(this.velE(v, mass)) * mass * this.velE(v, mass);
}

//velocity of particle of given mass and momentum
physics.prototype.velRel = function(m,p) {
	return p * this.c() / Math.sqrt( p * p + Math.pow(m * this.c(), 2));
}

//Relativistic Kinetic Energy - returns MeV by default, m in MeV/c^2
//v is expressed in v/c 
physics.prototype.Krel = function(v, m) {
	return m * (this.gamma(v * this.c()) - 1);
}

//Relativistic  TOTAL  Energy - returns MeV by default, m in MeV/c^2
//v is expressed in v/c
physics.prototype.Erel = function(v, m) {
	return m * this.gamma(v * this.c());
}
/////////////////////////////////////////////////////////////////////////////	
//SUBATOMIC PARTICLE PHYSICS
/////////////////////////////////////////////////////////////////////////////
// betaE returns the kinetic energy of the beta particle by accepting a number between
//0 and 1 and inverting the Kurie function for a Tritium nucleus
//Energy is in KeV units if the "KeV" flag is included - default is J
physics.prototype.betaE = function(n, unit) {
	if(unit == "KeV") {
		return -29.176 * Math.pow(n, 3) + 47.609 * n * n - 34.187 * n + 18.259;
	}
	else {
		return (-29.176 * Math.pow(n, 3) + 47.609 * n * n - 34.187 * n + 18.259) * 1.602e-16;
	}
}

//"Mommy"??? ...well, that's what is says <--
//momE returns the relativic velocity given particle mass and kinetic energy
physics.prototype.velE = function(E, mass, units) {
	var c = this.c();
	if (units == "v/c") {
		return Math.sqrt(1 - 1 / Math.pow(1 + E / (mass * c * c), 2));
	}
	else {
		return c * Math.sqrt(1 - 1 / Math.pow(1 + E / (mass * c * c), 2));
	}
}

//Compton Scattering from electron, li is wavelength in m and theta is
//scttering angle in degrees
physics.prototype.Compton = function(li, theta) {
	return li + this.h() * (1 - Math.cos(theta * Math.PI / 180)) / (this.me() * this.c());
}

//Momentum of scattered electron for a initial wavelength and scattering angle in degrees//
physics.prototype.Pe = function(li, theta) {
	var h1 = this.h() / li;
	var h2 = this.h() / this.Compton(li, theta);
	
	return Math.sqrt(h1 * h1 + h2 * h2 - 2 * h1 * h2 * Math.cos(Math.PI * theta / 180));
	
}
//Direction of scattered electron - in degrees//
physics.prototype.thetaE = function(li, theta) {
	var h1 = this.h() / this.Compton(li, theta);
	return(180 / Math.PI) * Math.asin(h1 * Math.sin(Math.PI * theta / 180) / this.Pe(li, theta));
}
////////////////////////////////////////////////////////
//////Photoelectric Effect Static Functions/////////////
///////////////////////////////////////////////////////
//Ek max for frequency and work function, w is in eV, f in H
physics.prototype.Ekf = function(f, w,units) {
	if (units == "eV") {
		return this.h() * f / this.q() - w;
	}
	else {
		return this.h() * f - w * this.q();
	}
}

//use this if you want to use wavelength in nm rather than frequency
physics.prototype.EkW = function(l, w,units) {
	if (units == "eV") {
		return this.h() * this.c() / (l * 1e-9 * this.q()) - w;
	}
	else {
		return this.h() * this.c() / (l * 1e-9) - w * this.q();
	}
}