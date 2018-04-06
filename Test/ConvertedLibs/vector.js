var vector = function(x, y, z) {
	this.x = x;
	this.y = y;
	this.z = z;
}
vector.prototype.length = function() {
	return this.mag(this)
};
vector.prototype.val = function() {
	return x + ", " + y + ", " + z;
};
vector.prototype.mag = function(v1) {
	return Math.sqrt(v1.x * v1.x + v1.y * v1.y + v1.z * v1.z);
};
vector.prototype.dot = function(v1, v2) {
	return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;
};
vector.prototype.cross = function(v1, v2) {
	var v = new vector(v1.y * v2.z - v1.z * v2.y, v1.z * v2.x - v1.x * v2.z, v1.x * v2.y - v1.y * v2.x);
	return v;
};
vector.prototype.angle = function(v1, v2) {
	return Math.acos(this.dot(v1, v2) / v1.length * v2.length);
};
vector.prototype.add = function(v1, v2) {
	var v = new vector(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z);
	return v;
};
vector.prototype.diff = function(v1, v2) {
	var v = new vector(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z);
	return v;
};
vector.prototype.mult = function(v1, a) {
	var v = new vector(a * v1.x, a * v1.y, a * v1.z);
	return v;
};
vector.prototype.norm = function(v1) {
	var l = this.mag(v1);
	var v = this.mult(v1, 1 / l);
	return v;
};
//////////////////////////////////
//Rotation Matrices
//////////////////////////////////
vector.prototype.rotX = function(v, a) {
	var cos = Math.cos(a);
	var sin = Math.sin(a);
	var v1 = new vector(v.x, v.y * cos + v.z * sin, -v.y * sin + (v.z * cos));
	return v1;
};
vector.prototype.rotY = function(v, a) {
	var cos = Math.cos(a);
	var sin = Math.sin(a);
	var v1 = new vector(v.x * cos - v.z * sin, v.y, v.x * sin + (v.z * cos));
	return v1;
};
vector.prototype.rotZ = function(v, a) {
	var cos = Math.cos(a);
	var sin = Math.sin(a);
	var v1 = new vector(v.x * cos + v.y * sin, -v.x * sin + v.y * cos, v.z);
	return v1;
};