/*
	Version 3.2
	Edited by: Darren Eymundson
	May 10-12, 2010
	
	Changes in v3.2 May 12, 2010
	 - Added in an instructions box
	 - Added a positron
	 - Fixed layering for the scale rulers
	 - Added splash page and start button.
	 
	Changes in v3.1 May 10-11, 2010
	 - Removed measure button
	 - Added Tools menu 
	 	- Contains a radius measure and a ruler.
	 - Reorganized GUI and made button layout consistent with Particle in a Magnetic Field DLO
	 - Changed E-field arrow to an arrow2D object.
	 
	Version 3.0
	Edited by: Darren Eymundson, Kristen Tjostheim
	May 7, 2010
	Changes in v3.0:
	 - Upgrade to AS3
	 - Use of ffComponents
*/
//version 2.0 edited by David Dykstra
	//Created multiple path ability that toggles on and off and changes color
		//menu item
		//clear button
	//fixed Icons and library paths

// 2d magnetic and electric field
//created: june 2006
// by: Andrew Martin
/*****************/
//  1.3.3 - Added alpha particle and changed unit on E to MN/C
//  1.3.2 - Fixed magnetic field directions
//	1.3.1 - Fixed about menu layering.
//	1.3- added about menu- August 22, 2006.

///*********************************************/
// Last Modified August 16,2006.
/*Modifications:
		- Close buttons changed
		- "Don't show this again" checkbox added
		-dropshadows added

*/
/*******************************************/
// modified: july 21,2006
//Modifications:
//	Restart button now restarts from the position it was in before.
//	Start exits advanced mode but restart no longer does.								
//	Fixed a few bugs with the advanced settings menu.
//	Added functions to replace repeated lines of code.
//  Graphics for magnetic and electric fields now resize when movie is in pause.
//	Added tooltips.
//	Disabled dragging of advanced settings window.
/************************************************/
//imports://
import gui.menu.MenuItem;
import gui.menu.MenuEvent;
import gui.slider.*;
import gui.arrow2D;
import vectorgraphics.*;
import math.*;
import tools.radiusMeasure;
import tools.scaleRuler;

import fl.events.SliderEvent;
import flash.display.*;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Matrix;


//*******Menu Bar*******\\

var options:MenuItem = menuBar.addMenuItem("Options");
var tools:MenuItem = menuBar.addMenuItem("Tools");
var resources:MenuItem = menuBar.addMenuItem("Resources");
var help:MenuItem = menuBar.addMenuItem("Help");

//Options Menu
var options_multi:MenuItem = options.addMenuItem("Multiple Paths", "check");
var options_random:MenuItem = options.addMenuItem("Random Mode");
var options_particle:MenuItem = options.addMenuItem("Particle");
var options_advanced:MenuItem = options.addMenuItem ("Advanced Settings");
//Particle SubMenu
var particle_e:MenuItem = options_particle.addMenuItem("Electron", "radio");
var particle_E:MenuItem = options_particle.addMenuItem("Positron", "radio");
var particle_p:MenuItem = options_particle.addMenuItem("Proton", "radio");
var particle_u:MenuItem = options_particle.addMenuItem("Muon", "radio");
var particle_a:MenuItem = options_particle.addMenuItem("Alpha", "radio");
particle_e.selected = true;//so it starts with electrons.

//Tools Menu
var tools_radiusmeasure:MenuItem = tools.addMenuItem("Measure Radius", "check");
var tools_ruler:MenuItem = tools.addMenuItem("Ruler", "check");

//Resources Menu
var resources_exploration:MenuItem = resources.addMenuItem("Exploration");

//Help Menu
var help_instructions:MenuItem = help.addMenuItem("Instructions");
var help_about:MenuItem = help.addMenuItem("About");
var help_whats:MenuItem = help.addMenuItem("What's This?");

//Menu Bar Listeners
options_multi.addEventListener(MenuEvent.ITEM_SELECTED, multiLines);
options_random.addEventListener(MenuEvent.ITEM_SELECTED, randomSet);
options_particle.addEventListener(MenuEvent.CHILD_SELECTED, pProperties);
options_advanced.addEventListener(MenuEvent.ITEM_SELECTED, openAdvanced);

tools_radiusmeasure.addEventListener(MenuEvent.ITEM_SELECTED, measureRadius);
tools_ruler.addEventListener(MenuEvent.ITEM_SELECTED, useRuler);

resources_exploration.addEventListener(MenuEvent.ITEM_SELECTED, openExplore);

help_instructions.addEventListener(MenuEvent.ITEM_SELECTED, openInstructions);
help_about.addEventListener(MenuEvent.ITEM_SELECTED, openAbout);
help_whats.addEventListener(MenuEvent.ITEM_SELECTED, function(e:MenuEvent){whatsThisPage.visible = !whatsThisPage.visible});


//********Variables*********\\
var mass:Number = 9.1E-31;
var q:Number = -1;
var scale2:Number = 100000;
var scale2a:Number = 1e6;
var scaler:Number = 100000;
var field:Boolean = true;
var selectedMeasureRadius:uint = 0;
var rev:String;
var advStart:Boolean = false;
var advReset:Boolean = false;
var down = false;
//var xmouse:Number;
//var ymouse:Number;
var settingsx:Number;
var settingsy:Number;
/*var upperboundstart:Number = 135;
var lowerboundstart:Number = 345;
var leftboundstart:Number = 292;
var rightboundstart:Number = 349;
var upperbound:Number;
var lowerbound:Number;
var leftbound:Number;
var rightbound:Number;*/
var fl:Number = 400;
var vpX:Number = 0;// this.stage.width/2;
var vpY:Number = 0;//this.stage.height/2;
var top:Number = -100;
var bottom:Number = 100;
var left:Number = -100;
var right:Number = 100;
var front:Number = 100;
var back:Number = -100;
var radius:Number = 10;
var numBalls:Number = 1;
var reset:Boolean = false;
var resetballx:Number;
var resetbally:Number;
var resetballz:Number;
var dt:Number;
var zoom:Number = 1.1000;
var angle:Number = 0;
var angle2:Number = 0;
var angle3:Number = 0;
var bfield:vector = new vector(0, 0, 0);
var efield:vector = new vector(0, 0, 0);
var count:Number = 0;
var beginx:Number;
var beginy:Number;
var angley:Number = .000;
var anglex:Number = .00;
var anglez:Number = .00;
var m:Number = 0;
var r_old:vector;
var v_old:vector;
var arrowarrayx:Array;
var arrowarrayy:Array;
var arrowarrayz:Array;
var unit3:vector;
var unit4:vector;
var colours:Array = [0x000000, 0xFF0000, 0x00FF00, 0x0000FF, 0xFFFF00, 0xFF00FF, 0x00FFFF];
var colourIndex:Number = -1;//since it will start by +=1, so want to start at 0;
var multiOn:Boolean = false;
//keep track of old inputs incase cancel
var xIn:String = "0";
var yIn:String = "0";
var vxIn:String = "15000";
var vyIn:String = "0";
var bzIn:String = "1";

//to keep track of velocity slider
var oldSliderValue:Number = velocitySlider.value;
//the current ball we will be working with
var ball:MovieClip = new Ball();
var tree:MovieClip = new MovieClip();
var eForceArrow:arrow2D = new arrow2D(new vec2D(0,0), new vec2D(0,0), Math.PI/5, 0, 3, 0xEE0000, 0.30);
drawings.addChild(eForceArrow);
var ruler1:scaleRuler = new scaleRuler(drawings, scale2, 1, scaleRuler.HORIZONTAL);
var ruler2:scaleRuler = new scaleRuler(drawings, scale2, 1, scaleRuler.VERTICAL);
//ruler1.parent.setChildIndex(ruler1.parent.getChildAt(ruler1.parent.numChildren-1), 2);
//ruler2.parent.setChildIndex(ruler2.parent.getChildAt(ruler2.parent.numChildren-1), 2);
ruler1.visible = ruler2.visible = false;
drawings.addChild(tree);//so that won't have issue with overlaying menu bar.

var trees:Array = new Array();
var balls:Array = new Array();//to keep track of multiple balls/lines.

var radMeas:radiusMeasure = new radiusMeasure("m", scale2);
drawings.addChild(radMeas);

//intial settings
whatsThisPage.visible = false;
scaleText.text = String(scaler)+" px/m";
particleText.text = "Electron";
advancedText.text = "Normal Mode";
settingsWindow.visible = false;
measureBox.visible = false;
revealBut.enabled = false;
fieldIn.alpha = 0;
fieldOut.alpha = 0.5; //0.5*magneticSlider.value;
velocitySlider.value = 15000;
drawings.backgroundDrawings.alpha = 0;//so can see through
restartBut.enabled = false; //so that you don't restart before you've started


//advanced settings window
//making the content of the window move with and be placed inside the window itself
settingsWindowContent.x -= settingsWindow.x;
settingsWindowContent.y -= settingsWindow.y;
settingsWindow.addChild(settingsWindowContent);

settingsWindowContent.startBut.addEventListener(MouseEvent.CLICK, begin);
settingsWindowContent.cancelBut.addEventListener(MouseEvent.CLICK, cancel);


//BUTTON AND SLIDER FORMATS
var sliderTitle:TextFormat = new TextFormat("Arial", 12);
var sliderLabel:TextFormat = new TextFormat("Arial", 10);
var buttonFormat:TextFormat = new TextFormat("Arial", 16);


velocitySlider.titleTextFormat = sliderTitle;
velocitySlider.labelTextFormat = sliderLabel;
magneticSlider.titleTextFormat = sliderTitle;
magneticSlider.labelTextFormat = sliderLabel;
electricSlider.titleTextFormat = sliderTitle;
electricSlider.labelTextFormat = sliderLabel;

startBut.setStyle("textFormat", buttonFormat);
startBut.setStyle("disabledTextFormat", buttonFormat);
startBut.setStyle("icon", playIc);
restartBut.setStyle("textFormat", buttonFormat);
restartBut.setStyle("disabledTextFormat", buttonFormat);
restartBut.setStyle("icon", resetIc);
stopBut.setStyle("textFormat", buttonFormat);
stopBut.setStyle("icon", stopIc);
clearBut.setStyle("textFormat", buttonFormat);
revealBut.setStyle("textFormat", buttonFormat);
revealBut.setStyle("disabledTextFormat", buttonFormat);

//MENU FUNCTIONS
function multiLines(e:MenuEvent):void
{
	multiOn = e.target.selected;
	advancedText.text = (multiOn)?"Multi Mode":"Normal Mode";
}
function randomSet(e:MenuEvent):void
{
		revealBut.enabled = true;
		particleText.text = "?";
		scaleText.text = " ?";
		switch (Math.round(Math.random()*3))
		{
			case 1:
				mass = 9.1E-31;
				q = -1;
				scaler = 100000;
				rev = "Electron";
			break;
			case 2:
				mass = 1.67E-27;
				q = 1;
				scaler = 1000;
				rev = "Proton";
			break;
			case 3:
				mass = 1.88353109E-28;
				q = -1;
				scaler = 10000;
				rev = "Muon";
			break;
		}
}
//particle property functions
function pProperties(e:MenuEvent):void
{
	if(particle_e.selected)
	{
		mass = 9.1E-31;
		q = -1;
		scaler = 100000;
		particleText.text = "Electron";
	}
	if(particle_E.selected)
	{
		mass = 9.1E-31;
		q = 1;
		scaler = 100000;
		particleText.text = "Positron";
	}
	else if(particle_p.selected)
	{
		mass = 1.67E-27;
		q = 1;
		scaler = 1000;
		particleText.text = "Proton";
	} 
	else if(particle_u.selected)
	{
		mass = 1.88353109E-28;
		q = -1;
		scaler = 10000;
		particleText.text = "Muon";
	} 
	else if(particle_a.selected)
	{
		mass = 6.68E-27;
		q = 2;
		scaler = 1000;
		particleText.text = "Alpha";
	}
	scaleText.text = String(scaler)+" px/m";
	revealBut.enabled = false;
	radMeas.scale = scaler;
	ruler1.pixelsToMetresRatio = ruler2.pixelsToMetresRatio = scaler;
}
function measureRadius(e:MenuEvent):void
{
	measureBox.visible = !measureBox.measureCheck.selected && selectedMeasureRadius%2 != 1;
	radMeas.scale = scaler;
	radMeas.toggleActivate();
	selectedMeasureRadius ++;
}
function useRuler(e:MenuEvent):void
{
	ruler1.pixelsToMetresRatio = ruler2.pixelsToMetresRatio = scaler;
	ruler1.visible = !ruler1.visible;
	ruler2.visible = ruler1.visible;
}
function openAdvanced(e:MenuEvent):void
{
	settingsWindow.visible = true;
}
function openExplore(e:MenuEvent):void
{
	navigateToURL(new URLRequest("resources/lessons.html"));
}	
function openInstructions(e:MenuEvent):void{
	instructions.visible = true;
}
function openAbout(e:MenuEvent):void
{
	aboutWindow.visible = true;
}

//instructions window code
instructions.closeInstructions.addEventListener(MouseEvent.CLICK, hideInstructions);
function hideInstructions(e:MouseEvent):void{
	instructions.visible = false;
}
instructions.titleBar.addEventListener(MouseEvent.MOUSE_DOWN, dragInstructions);
instructions.titleBar.addEventListener(MouseEvent.MOUSE_UP, stopDragInstructions);

function dragInstructions(e:MouseEvent):void{
	instructions.startDrag();
}
function stopDragInstructions(e:MouseEvent):void{
	instructions.stopDrag();
}

//buttons:
startBut.addEventListener(MouseEvent.CLICK, begin);
stopBut.addEventListener(MouseEvent.CLICK, stopper);
restartBut.addEventListener(MouseEvent.CLICK, restart);
clearBut.addEventListener(MouseEvent.CLICK, clearIt);
revealBut.addEventListener(MouseEvent.CLICK, reveals);
whatsThisPage.addEventListener(MouseEvent.CLICK, function(e:MouseEvent){whatsThisPage.visible = !whatsThisPage.visible});

function begin(e:MouseEvent):void
{
	//make init a non-mouse event so that can be called with restart button as well
	init();
	restartBut.enabled = true;//so that you can now restart your path	
}

function init():void
{
	//so that they don't start a new one until done with the old one.
	startBut.enabled = false;
	if(settingsWindow.visible)
	{
		settingsWindow.visible = false;
		advStart = advReset = true;
		magneticSlider.value = Number(settingsWindowContent.bzText.text);
		velocitySlider.value = Number(settingsWindowContent.vxText.text);
		electricSlider.value = Number(settingsWindowContent.eyText.text);
	}
	//put each ball into the array so seperate
	for (var i:Number = 0; i<numBalls; i++) 
	{
		drawings.addChild(ball);//so won't go over menu
		ball.name = "ball"+i;

		//ball.x = -10;
		//Three cases: we are using advanced settings, we are resetting the ball, or we are simply starting the run.
		//Creates new initial values based on user inputs into the advanced menu.
		if (advStart && advReset) 
		{
			trace("advanced");
			ball.xPos = Number(settingsWindowContent.xText.text);
			ball.yPos = -1*Number(settingsWindowContent.yText.text);
			ball.z = 0;
			ball.vx = Number(settingsWindowContent.vxText.text)*scale2*1000;
			ball.vy = -1*Number(settingsWindowContent.vyText.text)*scale2*1000;
			ball.vz = 0;
			bfield = new vector(0, 0, Number(settingsWindowContent.bzText.text));
			efield = new vector(scale2*scale2a*settingsWindowContent.exText.text, -1*scale2*scale2a*settingsWindowContent.eyText.text, 0);
			field = false;
			changeE();
			advancedText.text = "Advanced Mode";

			//initial position of the tree marking
			tree.graphics.moveTo(ball.x*fl/(fl+ball.z)*zoom+vpX, ball.y*fl/(fl+ball.z)*zoom+vpY);
		} 
		else if (reset) 
		{
			trace("reset");
			ball.xPos = resetballx;
			ball.yPos = resetbally;
			ball.z = 0;
			
			scale2 = scaler;
			
			ball.vx = velocitySlider.value*1000*scale2;
			ball.vy = 0;
			ball.vz = 0;
			
			reset = false;//so that the ball doesn't reset if we push the start button after this
		} 
		else 
		{
			//this gives a random starting position of the particle left of centre
			//from 175 to 225 pixels
			ball.xPos = Math.random()*50-225;
			if (particleText.text == "Electron" || particleText.text == "Muon")//to randomize the height of the starting position (changed to fit new screen)
				ball.yPos = Math.random()*90;
			else//reverse the randomization for negatively charged particles.
				ball.yPos = Math.random()*-90;
				
			ball.z = 0;

			scale2 = scaler;
			
			ball.vx = velocitySlider.value*1000*scale2;
			ball.vy = 0;
			ball.vz = 0;
		}
		//To have a reference incase the reset button is pushed
		resetballx = ball.xPos;
		resetbally = ball.yPos;

		//universal properties of the ball
		ball._velocity = (ball.vx, ball.vy);
		ball._radius = 10;
		ball._mass = mass;
		ball._q = 1.6E-19*q;
		ball.dt = 5/(Math.sqrt(ball.vx*ball.vx+ball.vy*ball.vy))*((velocitySlider.value*1000/30E8)+.01)*10;

		//***These are for the initial values in the RK4 method.
		ball.r_old = new vector(ball.xPos, ball.yPos, ball.z);
		ball.v_old = new vector(ball.vx, ball.vy, 0);
		
		if (multiOn) 
		{
			colourIndex++;
			tree.graphics.lineStyle(1, colours[colourIndex%7]);
		}
		else//createEmptyMovieClip("tree", 2);
			tree.graphics.lineStyle(1, 0x000000);
			
		tree.beginx = ball.xPos;
		tree.beginy = ball.yPos;
		tree.graphics.moveTo(ball.xPos+vpX, ball.yPos+vpY);
		tree.beginz = ball.z;

		field = !advStart;
		advStart = false;
		balls.push(ball);
		ball.x = vpX+ball.xPos;
		ball.y = vpY+ball.yPos;
		
		balls.push(ball);
	}
	addEventListener(Event.ENTER_FRAME, continues);
}
function continues(e:Event):void
{
			
	//Loop is only necessary if more balls(particles) were added.    
	for (var i:Number = 0; i<numBalls; i++) 
	{
		ball = balls[i];

		var thing:object2D = new object2D(ball.xPos, ball.yPos);	

		//setting up old positions to be used in RK4
		ball.r_old = new vector(ball.xPos, ball.yPos, 0);
		ball.v_old = new vector(ball.vx, ball.vy, 0);
		//This allows the magnetic field to be varied during the movie.
		if (field) 
		{
			bfield = new vector(0, 0, magneticSlider.value);
			efield = new vector(0, -1*scale2*scale2a*electricSlider.value, 0);
		}
		
		//Applies BField and EField using the RK4 method. 
		thing.RK4EB(ball, bfield, scale2, efield);
		
		//This in only used in 3d code, so really this does not do anything, but it is still necessary as everything is written in 3d.
		if (ball.z<=-fl){
			ball.visible = false;
	}else {
			ball.visible = true;
			var scale:Number = fl/(fl+ball.z);
			ball.scaleX = ball.scaleY=scale;
			ball.x = vpX+ball.xPos;
			ball.y = vpY+ball.yPos;
		}
		//This draws a line every 5 calculations.
		//This is done so Flash does not slow down by drawing too many lines on the screen.
		//It does not affect the accuracy of the balls path, only the smoothness of the lines on the screen.
		if (m<count) 
		{
			if (multiOn)
				tree.graphics.lineStyle(1, colours[colourIndex%7], 100);
			else
				tree.graphics.lineStyle(1, 0x000000, 100);
				
			tree.graphics.lineTo(ball.x, ball.y);
			m += 3;
		}
		count ++;
		//put the menuBar above the graphics
		//Boundary conditions.
		if ((ball.x<-drawings.backgroundDrawings.width/2) || (ball.x>drawings.backgroundDrawings.width/2) || (ball.y<-drawings.backgroundDrawings.height/2) || (ball.y>drawings.backgroundDrawings.height/2)) 
		{
			//so that it stops moving
			removeEventListener(Event.ENTER_FRAME, continues);
			ball.visible = false;
			startBut.enabled = true;
		}
	}
}

function stopper(e:MouseEvent):void
{
	removeEventListener(Event.ENTER_FRAME, continues);
	startBut.enabled = true;
}
function clearIt(e:MouseEvent):void
{
	removeEventListener(Event.ENTER_FRAME, continues);
	tree.graphics.clear();
	colourIndex = -1;
	startBut.enabled = true;
	restartBut.enabled = false;
	ball.visible = false;
	radMeas.deactivate();
}

function cancel(e:MouseEvent):void
{
	settingsWindow.visible = false;
	settingsWindowContent.xText.text = xIn;
	settingsWindowContent.yText.text = yIn;
	settingsWindowContent.vxText.text = vxIn;
	settingsWindowContent.vyText.text = vyIn;
	settingsWindowContent.bzText.text = bzIn;	
}

function restart(e:Event):void
{
	removeEventListener(Event.ENTER_FRAME, continues);
	ball.visible = false;
	if (!multiOn) 
		tree.graphics.clear();
	reset = true;
	advReset = true;
	init();
}

function reveals(e:MouseEvent):void
{
	particleText.text = rev;
	scaleText.text = scaler+" px/m";
}
//for instructions on window content
settingsWindowContent.xText.addEventListener(MouseEvent.MOUSE_OVER, toolTips);
settingsWindowContent.yText.addEventListener(MouseEvent.MOUSE_OVER, toolTips);
settingsWindowContent.vxText.addEventListener(MouseEvent.MOUSE_OVER, toolTips);
settingsWindowContent.vyText.addEventListener(MouseEvent.MOUSE_OVER, toolTips);
settingsWindowContent.bzText.addEventListener(MouseEvent.MOUSE_OVER, toolTips);
settingsWindowContent.exText.addEventListener(MouseEvent.MOUSE_OVER, toolTips);
settingsWindowContent.eyText.addEventListener(MouseEvent.MOUSE_OVER, toolTips);

function toolTips(e:MouseEvent):void
{
	if(e.target == settingsWindowContent.xText || e.target == settingsWindowContent.yText || e.target == settingsWindowContent.exText || e.target == settingsWindowContent.eyText)
		settingsWindowContent.toolTipsText.text = "Value between -100 and 100.";
	else if(e.target == settingsWindowContent.vxText || e.target == settingsWindowContent.vyText)
		settingsWindowContent.toolTipsText.text = "Value between -300,000 and 300,000.";
	else if(e.target == settingsWindowContent.bzText)
		settingsWindowContent.toolTipsText.text = "Value between -2 and 2.";
}
//SLIDER
//putting in a slider function
magneticSlider.addEventListener(SliderEvent.VALUE_CHANGING, changeB);
function changeB(e:SliderEvent):void
{
	if(magneticSlider.value >= 0)
	{
		fieldIn.alpha = 0;
		fieldOut.alpha = 0.5*magneticSlider.value;
	}
	else if(magneticSlider.value < 0)
	{
		fieldIn.alpha = -0.5*magneticSlider.value;
		fieldOut.alpha = 0;
	}
}
electricSlider.addEventListener(SliderEvent.VALUE_CHANGING, changeE);
function changeE(e:SliderEvent=null):void
{
	if(field)
		efield = new vector(0, -1*scale2*scale2a*electricSlider.value, 0);
	eForceArrow.headLength = 25*vectorMath3D.mag(efield)/(1E8*scale2);
	eForceArrow.baseLine = new vec2D(100*(efield.x/(1E8*scale2)), 100*(efield.y/(1E8*scale2)));
}