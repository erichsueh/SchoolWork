/*
Remade May 2nd 2016
By: Eric Hsueh

This program takes 3 points and converts it into a radius

It has a few parts:

First is the variables, global counter keeps track of the # of clicks
clickedon keeps track on whether or not this is the first time click on the button so the points will be erased

canvus and ctx are both for the canvus

the variables can1x,can1y... are for the canvus clicks, 1 x, y is for the coordinates at the first click and so on

function initialize will initialize the canvus and the ctx when the html is first loaded, the html file will require the line:
	<body onLoad= initialize()>
for it to load and run properly

Function start event is when the tool is clicked on and called upon to start recording the three user inputed points
this function starts the event listener, disables the button so they can't click it while is active, as well checks if this is
the first time the user had clicked on the button (in order to save the original state if we needed to revert to it)

Every mouse click will call the function "mousedown", mouse down will record the coodintes of each mouse click
Using a case by case basis for which stage the computer is recording, ie ( case 0 = button click 1, case 1 = button click 2...
so on and so forth

After the third click of the mouse, the program wil call upon the function find math radius
Useing the formula taken from "http://www.regentsprep.org/regents/math/geometry/gcg6/RCir.htm"
We then have the radius we are looking for, it is currently presented as an alert under the "find radius function"
the variable radius is the radius we are looking for

The rest of the code is just the visual presentation, it will draw the arc according to the three points ad then spit out the radius

Function arc will draw a red arc for the user to see the visual

If the HTML file needs changing the only thing required is the initialize and the startevent function to be called

Known problems:
It is not exact, but it is close enough as it dosn't have a line detection mechanism to snap onto line already on the canvus

*/
//---------------------------------------------------------------------------------------------------------------------------

//variables
//global counter is for # of key presses
var globalcounter;

var clickedon = false;
var imageData
//canvus and ctx are both for the canvus
var canvus;
var ctx;

//the points on each of the 3 clicks
var can1x=0;
var can1y=0;
var can2x=0;
var can2y=0;
var can3x=0;
var can3y=0;

//when browser opens, initialize the canvus and ctx
function initialize()
{
	canvus  = document.getElementById("myCanvas");
	ctx = canvus.getContext("2d");	
}

//on button click, start recording 3 outputs
function startevent()
{
	
	globalcounter = 0;
	canvus.addEventListener("mousedown", doMouseDown, false);
	document.getElementById("arcbut").disabled = true;
	if (clickedon == false)
	{
		imageData = ctx.getImageData(0,0,canvus.width,canvus.height);
		clickedon = (true);
	}
	else
	{
		ctx.putImageData(imageData,0,0);
	}

}

//on button click, record each of the points
//the page.event needs to be -10 because the canvus is not centered at 0,0 but rather 10,10 on the html file
//change at your disgression
//each case represents a mouse click, ie: case 0 = click 1, case 1 = click2 and so on
function doMouseDown(event)
{
	if (globalcounter !== 3)
	{
		switch(globalcounter)
		{
			case 0:
				can1x = event.pageX - 10;
				can1y = event.pageY - 10;
				ctx.beginPath();
				ctx.strokeStyle = "#00ff00";
				ctx.moveTo(can1x,can1y);
				break;
			case 1:
				can2x = event.pageX - 10;
				can2y = event.pageY - 10;
				ctx.lineTo(can2x,can2y);
				ctx.stroke();
				break;
			case 2:
				can3x = event.pageX - 10;
				can3y = event.pageY - 10;
				ctx.beginPath();
				ctx.strokeStyle = "#00ff00";
				ctx.moveTo((can1x + can2x)/2 , (can1y + can2y)/2);
				ctx.lineTo(can3x,can3y);
				ctx.stroke();
				break;
		}
		globalcounter += 1;	
	}
	else
	{
		//when 3 button clicks have been recorded, remove listener and start the math portion
		canvus.removeEventListener("mousedown", doMouseDown, false);
		findmathradius()
		document.getElementById("arcbut").disabled = false;
	}
}

//after finding 3 points, find the center of the circle
//formula taken from http://www.regentsprep.org/regents/math/geometry/gcg6/RCir.htm

function findmathradius()
{	
	var slope1 = ((can1y - can3y)/(can1x - can3x));
	var slope2 = ((can2y - can3y)/(can2x - can3x));
	var centerx = (((slope1 * slope2 * (can2y - can1y)) + (slope1 * (can3x + can2x)) - (slope2 * (can1x + can3x))) / (2 * (slope1 - slope2)));
	var centery = (((can1y + can3y) / 2) - ((1 / slope1) * (centerx - ((can1x + can3x) / 2))));
	var radius = Math.sqrt((can1x - centerx) * (can1x - centerx) + (can1y - centery) * (can1y - centery));

	//start of cosine law to find angle of the triangle for drawing the arc
	var distance = Math.sqrt((can1x - can2x) * (can1x - can2x) + (can1y - can2y) * (can1y - can2y));
	
	// finding the angle of each of the points to compare for drawing later
	var anglepoint1 = Math.atan2(can1y - centery,can1x - centerx);
	var anglepoint2 = Math.atan2(can2y - centery,can2x - centerx);
	var anglepoint3 = Math.atan2(can3y - centery,can3x - centerx);
	var arcangle = Math.acos(((distance * distance) - 2 * (radius * radius)) / (-2 * radius * radius));	

	// determines which side the third point is and draws the arc on that side
	if (anglepoint1 <= anglepoint2)
	{
		if ((anglepoint1 < anglepoint3) && (anglepoint2 > anglepoint3))
		{
			arc(centerx,centery,radius,anglepoint1,anglepoint2);
		}
		else
		{
			arc(centerx,centery,radius,anglepoint2,anglepoint1);
		}
	}
	else
	{
		if ((anglepoint2 < anglepoint3) && (anglepoint1 > anglepoint3))
		{
			arc(centerx,centery,radius,anglepoint2,anglepoint1);	
		}
		else
		{
			arc(centerx,centery,radius,anglepoint1,anglepoint2);	
		}
	}
	alert("radius = " + radius)

}

//the function that draws the red arc
function arc(centerx,centery,radius,anglepoint1,anglepoint2)
{
	ctx.beginPath();
	ctx.strokeStyle = '#ff0000';
	ctx.arc(centerx,centery,radius,anglepoint1,anglepoint2);
	ctx.stroke();
}
