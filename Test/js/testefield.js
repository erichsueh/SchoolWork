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

function initialize()
{
	canvus  = document.getElementById("myCanvas");
	ctx = canvus.getContext("2d");
	var emass = 9.10938356*Math.pow(10,-31);
	var echarge = 1.60217662 * Math.pow(10,-19);
	thetime = 0
	pixelratio = Math.pow(10,4)
	
	//qoverme = Math.pow(10,12) *emass/echarge;
	qoverme = 1;
	//alert(qoverme)
	
	xder = 400;
	yder = 400;
	xvelocity = parseInt(document.getElementById("velocity").value);
	yvelocity = 0;
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
	ctx.putImageData(resetimg,0,0);
	resetted = true;
	
	ctx.beginPath();
	ctx.arc(xder,yder,1,0,Math.PI*2)
	ctx.stroke();
}

function draw()
{
	//ctx.putImageData(imageData,0,0);
	ctx.beginPath();
	ctx.moveTo(xder,yder);

	updateposition();
	
	ctx.lineTo(xder,yder);
	ctx.stroke(); 
	//imageData = ctx.getImageData(0,0,canvus.width,canvus.height);
	
	ctx.beginPath();
	ctx.arc(xder,yder,1,0,Math.PI*2)
	ctx.stroke();
	/*if (!((xder > 0)&& (xder < canvus.width)&&(yder>0)&&(yder < canvus.height)))
	{
		alert("outside")
		reset()
	}*/
	
	if (paused == false)
	{
		window.requestAnimationFrame(draw);	
	}
}
/*
function updateposition()
{
	var accelx =  (yvelocity*parseInt(document.getElementById("slider").value) / qoverme);
	var accely = -(xvelocity*parseInt(document.getElementById("slider").value) / qoverme);
	//console.log(accelx,accely,xvelocity,yvelocity);
	//xvelocity = xvelocity + accelx;
	//yvelocity = yvelocity + accely;
	//console.log( Math.sqrt(Math.pow(xvelocity,2) + Math.pow(yvelocity,2)))
	if (thetime == 0)
	{
		var timedifference = 0;
	}
	else
	{
		var timedifference = (Date.now() - thetime)/1000;
	}
	console.log(timedifference)
	thetime = Date.now();

	var newxvelocity = xvelocity + accelx*timedifference;
	var newyvelocity = yvelocity + accely*timedifference;
	
	xder = xder + ((xvelocity + newxvelocity)*timedifference)/(2*pixelratio);
	yder = yder + ((yvelocity + newyvelocity)*timedifference)/(2*pixelratio);
	xvelocity = newxvelocity;
	yvelocity = newyvelocity;

}*/

function updateposition()
{
	var 10*sliderVal = parseFloat(document.getElementById("slider").value); // change to parseFloat because we need decimal points not ints.
	sliderVal = sliderVal/10
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
	var timedifference = (timeNow - thetime)/1000;
	// }
	if (timedifference > 0.5) { // reseting delta
		//console.log("Resetting Delta");
		timedifference = 0.016;
	}
	thetime = timeNow;
	// timedifference *= 100;

	var newxvelocity = xvelocity + accelx*timedifference; // these should be calculated using an rk4 implementation instead of just euler
	var newyvelocity = yvelocity + accely*timedifference; // these should be calculated using an rk4 implementation instead of just euler
	
	// xder = xder + ((xvelocity + newxvelocity)*timedifference)/(2*pixelratio); // adding the old vel to the new vel?
	// yder = yder + ((yvelocity + newyvelocity)*timedifference)/(2*pixelratio); // adding the old vel to the new vel?
	xder = xder + (newxvelocity*timedifference)/(2*pixelratio);
	yder = yder + (newyvelocity*timedifference)/(2*pixelratio);
	xvelocity = newxvelocity;
	yvelocity = newyvelocity;

}