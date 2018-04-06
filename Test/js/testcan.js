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
	//drawcircle();
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
		//ctx.clearRect(0,0,canvus.width,canvus.height);
	}

}

//on button click, record each of the points
//each case represents a mouse click, ie: case 0 = click 1, case 1 = click2 and so on
function doMouseDown(event)
{
	if (globalcounter !== 3)
	{
		switch(globalcounter)
		{
			case 0:
				can1x = event.pageX -10;
				can1y = event.pageY -10;
				//alert("X= " + can1x + " Y=" + can1y +"  "+ globalcounter);
				ctx.beginPath();
				ctx.strokeStyle = "#00ff00";
				ctx.moveTo(can1x,can1y);
				break;
			case 1:
				can2x = event.pageX -10;
				can2y = event.pageY -10;
				//alert("X= " + can2x + " Y=" + can2y +"  "+ globalcounter);
				ctx.lineTo(can2x,can2y);
				ctx.stroke();
				break;
			case 2:
				can3x = event.pageX -10;
				can3y = event.pageY -10;
				//alert("X= " + can3x + " Y=" + can3y +"  "+ globalcounter);
				ctx.beginPath();
				ctx.strokeStyle = "#00ff00";
				ctx.moveTo((can1x + can2x)/2 , (can1y + can2y)/2);
				ctx.lineTo(can3x,can3y);
				ctx.stroke();
				break;
		}
		//alert("X= " + canvus_x + " Y=" + canvus_y +"  "+ globalcounter);
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
	//testing to make sure the formula is correct
	//can1x = 5;
	//can1y = 5;
	//can2x = 2;
	//can2y = -4;
	//can3x = 6;
	//can3y = -2;
	
	var slope1 = ((can1y - can3y)/(can1x-can3x));
	var slope2 = ((can2y - can3y)/(can2x-can3x));
	//alert("the slopes are" + slope1 + " " + slope2)
	var centerx = (( (slope1*slope2*(can2y-can1y)) + (slope1*(can3x+can2x)) - (slope2 *(can1x+can3x))) / (2*(slope1-slope2)));
	var centery = (((can1y+can3y)/2)-((1/slope1)*(centerx - ((can1x+can3x)/2))) );
	var radius = Math.sqrt((can1x-centerx)*(can1x-centerx) + (can1y-centery)*(can1y-centery));
	//alert("X = "+ centerx + " Y= " + centery + " radius =  " + radius);
	//start of cosine law to find angle of the triangle
	var distance = Math.sqrt((can1x-can2x)*(can1x-can2x)+(can1y-can2y)*(can1y-can2y));
	//alert("distance = " + distance)
	var anglepoint1 = Math.atan2(can1y-centery,can1x-centerx);
	var anglepoint2 = Math.atan2(can2y-centery,can2x-centerx);
	var anglepoint3 = Math.atan2(can3y-centery,can3x-centerx);
	var arcangle = Math.acos(((distance*distance) - 2*(radius*radius)) / (-2 * radius * radius) );	
	//alert("arcangle = " + arcangle + " test = " +((distance*distance) - 2*(radius*radius)) / (-2 * radius * radius)) 
	//alert("arcangle = " + arcangle + " invarcangle" + ((2*Math.PI) - arcangle))
	//alert(anglepoint1+ "  " +anglepoint2 + "  " +anglepoint3);
	if (anglepoint1 <= anglepoint2)
	{
		if ((anglepoint1< anglepoint3)&& (anglepoint2 > anglepoint3))
		{
			arc(centerx,centery,radius,anglepoint1,anglepoint2);
			//alert("1 arclength = " + (((2*Math.PI) - arcangle)) * radius)
		}
		else
		{
			arc(centerx,centery,radius,anglepoint2,anglepoint1);
			//alert("2 arclength = " + arcangle * radius)
		}
	}
	else
		if ((anglepoint2 < anglepoint3)&&(anglepoint1 > anglepoint3))
		{
			arc(centerx,centery,radius,anglepoint2,anglepoint1);	
			//alert("3 arclength = " + (((2*Math.PI) - arcangle)) * radius)
		}
		else
		{
			arc(centerx,centery,radius,anglepoint1,anglepoint2);	
			//alert("4 arclength = " + arcangle * radius)
		}

	// checking if the third point is between the first green line
	

	/*if ((anglepoint1 >= 0)&&(anglepoint2 >= 0))
	{
		if (((anglepoint1<anglepoint3) && (anglepoint2 > anglepoint3))||((anglepoint1>anglepoint3) && (anglepoint2 < anglepoint3)))
		{
			alert("arclength = " + arcangle * radius)
		}
		else
		{
			alert("arclength = " + (((2*Math.PI) - arcangle)) * radius)
		}
	}
	else if((anglepoint1 <= 0)&&(anglepoint2 <= 0))
		if (((anglepoint1<anglepoint3) && (anglepoint2 > anglepoint3))||((anglepoint1>anglepoint3) && (anglepoint2 < anglepoint3)))
		{
			alert("arclength = " + arcangle * radius)
		}
		else
		{
			alert("arclength = " + (((2*Math.PI) - arcangle)) * radius)
		}
	else if ((Math.abs(anglepoint1)> Math.PI/2)&&(Math.abs(anglepoint2)>Math.PI/2))
	{
		if (((anglepoint3 > 0)&&(anglepoint2 > 0)&&(anglepoint3 > anglepoint2))||
			((anglepoint3 > 0)&&(anglepoint1 > 0)&&(anglepoint3 > anglepoint1))||
			((anglepoint3 < 0)&&(anglepoint1 < 0)&&(anglepoint3 < anglepoint1))||
			((anglepoint3 < 0)&&(anglepoint2 < 0)&&(anglepoint3 < anglepoint2)))
		{
			alert("between arclength = " + arcangle * radius)
		}
		else
		{
			alert("not arclength = " + (((2*Math.PI) - arcangle)) * radius)
		}
	}
	else if ((Math.abs(anglepoint1)< Math.PI/2)&&(Math.abs(anglepoint2)<Math.PI/2))
	{
		if (((anglepoint3 > 0)&&(anglepoint2 > 0)&&(anglepoint3 > anglepoint2))||
			((anglepoint3 > 0)&&(anglepoint1 > 0)&&(anglepoint3 > anglepoint1))||
			((anglepoint3 < 0)&&(anglepoint1 < 0)&&(anglepoint3 < anglepoint1))||
			((anglepoint3 < 0)&&(anglepoint2 < 0)&&(anglepoint3 < anglepoint2)))
		{
			alert("not arclength = " + (((2*Math.PI) - arcangle)) * radius)	
		}
		else
		{
			alert("between arclength = " + arcangle * radius)
		}
	}
	else
	{
		alert("thrisdf")
	}*/
	//arc(centerx,centery,radius,anglepoint1,anglepoint2);
/*
	ctx.beginPath();
	ctx.strokeStyle = '#ff0000';
	ctx.arc(centerx,centery,radius,anglepoint1,anglepoint2);
	ctx.stroke();
	//alert("arclength = " + arcangle * radius)
*/
}

function arc(centerx,centery,radius,anglepoint1,anglepoint2)
{
	ctx.beginPath();
	ctx.strokeStyle = '#ff0000';
	ctx.arc(centerx,centery,radius,anglepoint1,anglepoint2);
	ctx.stroke();
}

//draws random circle for testing
function drawcircle()
{
	ctx.beginPath();
	ctx.strokeStyle = "#000000";
	ctx.arc(95,50,40,0,2*Math.PI);
	ctx.stroke();
}