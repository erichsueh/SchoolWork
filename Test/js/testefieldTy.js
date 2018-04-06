var canvus;
var ctx;
var paused;
var xder;
var yder;
var xvelocity;
var yvelocity;
var imageData;
var resetimg;
var resetted;

var qoverme;

var thetime;

var pixelratio;

var cwidth;
var cheight;

var cappedvelocity;

function initialize()
{
	canvus  = document.getElementById("myCanvas");
	ctx = canvus.getContext("2d");
	var emass = 9.10938356*Math.pow(10,-31);
	var echarge = 1.60217662 * Math.pow(10,-19);
	thetime = 0
	pixelratio = Math.pow(10,2.5)
	
	qoverme = Math.pow(10,12) *emass/echarge;
	// qoverme = 1;
	//alert(qoverme)
	
	cwidth = canvus.width
	cheight = canvus.height

	xder = 400;
	yder = 400;
	xvelocity = parseInt(document.getElementById("velocity").value);
	yvelocity = 0;
	cappedvelocity = Math.pow(xvelocity,2)
	resetimg = ctx.getImageData(0,0,canvus.width,canvus.height);
	resetted = true;
	ctx.beginPath();
	ctx.arc(xder,yder,1,0,Math.PI*2)
	ctx.stroke();
	//console.log(xvelocity,yvelocity,qoverme)
}

function start()
{
	paused = false;
	if (resetted == true)
	{
		imageData = resetimg;
		resetted = false;
		//xvelocity = parseInt(document.getElementById("velocity").value);
	}
	window.requestAnimationFrame(draw);

	//setInterval(draw,0.0001);
}

function pause()
{
	paused = true;
}

function reset()
{
	paused = true;
	xder = 400;
	yder = 400;
	xvelocity = parseInt(document.getElementById("velocity").value);
	cappedvelocity = Math.pow(xvelocity,2)
	yvelocity = 0;
	ctx.clearRect(0,0,canvus.width, canvus.height)
	// ctx.putImageData(resetimg,0,0); // just call clear canvus
	resetted = true;
	
	ctx.beginPath();
	ctx.arc(xder,yder,1,0,Math.PI*2)
	ctx.stroke();
}

function draw() // draws are sometimes still done after reseting. 
{
	//ctx.putImageData(imageData,0,0); // just don't clear the canvus between draw calls
	ctx.beginPath();
	ctx.moveTo(xder,yder);

	updateposition();
	
	ctx.lineTo(xder,yder);
	ctx.stroke(); 
	//imageData = ctx.getImageData(0,0,cwidth,cheight); // why keep this data?
	
	/*ctx.beginPath();
	ctx.arc(xder,yder,1,0,Math.PI*2)
	ctx.stroke();*//*
	if (!((xder > 0)&& (xder < canvus.width)&&(yder>0)&&(yder < canvus.height)))
	{
		reset()
		paused = false;
	}*/
	
	if (paused == false)
	{
		window.requestAnimationFrame(draw);	
	}
}

function updateposition()
{
	var sliderVal =100* parseFloat(document.getElementById("slider").value); // change to parseFloat because we need decimal points not ints.
	var accelx =  (yvelocity*sliderVal / qoverme);
	var accely = -(xvelocity*sliderVal / qoverme);
	//console.log(accelx,accely,xvelocity,yvelocity);
	//xvelocity = xvelocity + accelx;
	//yvelocity = yvelocity + accely;
	//console.log( Math.sqrt(Math.pow(xvelocity,2) + Math.pow(yvelocity,2)))
	
	var timeNow = Date.now(); // reduced the number of calls to Date.now();
	// if (thetime == 0)
	// {
	// 	var timedifference = 0;
	// }
	// else
	// {
	var timedifference = (timeNow - thetime)/10000;
	// }
	if (timedifference > 0.005) { // reseting delta
		//console.log("Resetting Delta");
		timedifference = 0.0016;
	}
	thetime = timeNow;
	//timedifference = 0.001
	// timedifference *= 100;
	
	//var newxvelocity = xvelocity + accelx*timedifference; // these should be calculated using an rk4 implementation instead of just euler
	if (Math.abs(accelx) < Math.abs(accely))
	{
		var newyvelocity = yvelocity + accely*timedifference;
		var newxvelocity = Math.sqrt(cappedvelocity - Math.pow(yvelocity,2));
	}
	else
	{
		var newxvelocity = xvelocity + accelx*timedifference;
		var newyvelocity = Math.sqrt(cappedvelocity - Math.pow(xvelocity,2));
	}

	var newyvelocity = yvelocity + accely*timedifference;
	var newxvelocity = Math.sqrt(cappedvelocity - Math.pow(yvelocity,2));
	if (isNaN(newyvelocity) || isNaN(newxvelocity))
	{
		console.log("ManBat")
	}
	//console.log(newyvelocity,newxvelocity, cappedvelocity)
	//yvelocity + accely*timedifference; // these should be calculated using an rk4 implementation instead of just euler
	
	// xder = xder + ((xvelocity + newxvelocity)*timedifference)/(2*pixelratio); // adding the old vel to the new vel?
	// yder = yder + ((yvelocity + newyvelocity)*timedifference)/(2*pixelratio); // adding the old vel to the new vel?
	xder = xder + (newxvelocity*timedifference)/(2*pixelratio);
	yder = yder + (newyvelocity*timedifference)/(2*pixelratio);
	xvelocity = newxvelocity;
	yvelocity = newyvelocity;
	/*
	var xstuff = rk4(xder,xvelocity,accelerationx,timedifference);
	var ystuff = rk4(yder,yvelocity,accelerationy,timedifference);
	xder = xstuff[0];
	xvelocity = xstuff[1];
	var ycappedvelocity = Math.sqrt(Math.pow(cappedvelocity,2) - Math.pow(xvelocity,2))
	yder = yder + (ycappedvelocity*timedifference)/(2*pixelratio);
	yvelocity = ycappedvelocity*/
	/*
	yder = ystuff[0];
	yvelocity = ystuff[1];
	console.log(Math.pow(xvelocity,2)+Math.pow(yvelocity,2))*/
}


function rk4(x, v, a, dt) 
{
  // Returns final (position, velocity) array after time dt has passed.
  //        x: initial position
  //        v: initial velocity
  //        a: acceleration function a(x,v,dt) (must be callable)
  //        dt: timestep
  var x1 = x;
  var v1 = v;
  var a1 = a(x1, v1, 0);

  var x2 = x + 0.5*v1*dt;
  var v2 = v + 0.5*a1*dt;
  var a2 = a(x2, v2, dt/2);

  var x3 = x + 0.5*v2*dt;
  var v3 = v + 0.5*a2*dt;
  var a3 = a(x3, v3, dt/2);

  var x4 = x + v3*dt;
  var v4 = v + a3*dt;
  var a4 = a(x4, v4, dt);

  var xf = x + (dt/6)*(v1 + 2*v2 + 2*v3 + v4)/pixelratio;
  var vf = v + (dt/6)*(a1 + 2*a2 + 2*a3 + a4);

  return [xf, vf];
}

function accelerationx(x,v,dt)
{
	var sliderVal = 100*parseFloat(document.getElementById("slider").value);
	var ax =  (yvelocity*sliderVal / qoverme);
	return ax;
}

function accelerationy(x,v,dt)
{
	var sliderVal = 100*parseFloat(document.getElementById("slider").value);
	var ay = -(xvelocity*sliderVal / qoverme);
	return ay;
}