/*
Cloud Chamber
*************
Created By: A.Martin
Last Edited:June 9, 2010 by Kristen Tjostheim
version 2.4 - added a "What's This?" Feature, applied new lesson format.
version 2.3 - Changed Menu Title, removed logo in applet, replaced logo in about menu, removed produced by, added splash page
version 2.2 - Added Calculator
version 2.1 - Added Neutron Decay
version 2.0 - Added Kaon Decay
- Added Data.txt file containing Alpha and Beta decays
version 1.1.2 - added new alpha and beta emitters
version 1.1.1 - added link to lseson/help.html files
version 1.0.1 - small bug fix with the particle day options. 
*************
*/
import mx.controls.Menu;
import mx.controls.MenuBar;
/****/
var appletName:String = "Cloud Chamber";
var author:String = "Andrew Martin, Brian Martin";
var date_str:String = "Version 2.4, 09/06/10";
var contact:String = "brian.martin@kingsu.ca";
//var producedBy:String = "The King's Center For Visualization In Science";
this.controls.help._visible = false;
/******/
var my_mb:MenuBar;
_root.controls.my_mb.setStyle("themeColor", 0x666666);
_root.controls.my_mb.setStyle("rollOverColor", 0xEEEEEE);
_root.controls.my_mb.setStyle("selectionColor", 0xEEEEEE);
_root.controls.my_mb.setStyle("textSelectedColor", 0x000000);
var my_menu2:Menu = controls.my_mb.addMenu("Options");
var my_menu3:Menu = controls.my_mb.addMenu("Resources");
var my_menu:Menu = controls.my_mb.addMenu("Help");

//Add menubar dropdown Menus
var mass_obj:Object = my_menu2.addMenuItem({label:"Decay", instanceName:"massInstance"});
var adv_obj:Object = my_menu2.addMenuItem({label:"Advanced Settings", instanceName:"advancedInstance"});
var calc_obj:Object = my_menu2.addMenuItem({label:"Calculator", instanceName:"calculatorInstance"});

my_menu.addMenuItem({label:"About", instanceName:"aboutInstance"});
//my_menu.addMenuItem({label:"Applet Help", instanceName:"AppletHelpInstance"});
my_menu.addMenuItem({label:"What's This?", instanceName:"whatsInstance"});

my_menu3.addMenuItem({label:"Sample Problems", instanceName:"problemInstance"});
my_menu3.addMenuItem({label:"Exploration", instanceName:"exploreInstance"});
my_menu3.addMenuItem({label:"Links to Literature", instanceName:"literatureInstance"});

mass_obj.addMenuItem({type:"radio", groupName:"massGroup", label:"Beta", instanceName:"BetaInstance", selected:true});
mass_obj.addMenuItem({type:"radio", groupName:"massGroup", label:"Pair Production", instanceName:"PairInstance"});
mass_obj.addMenuItem({type:"radio", groupName:"massGroup", label:"Alpha", instanceName:"alphaInstance"});
mass_obj.addMenuItem({type:"radio", groupName:"massGroup", label:"Kaon", instanceName:"KaonInstance"});
mass_obj.addMenuItem({type:"radio", groupName:"massGroup", label:"Neutron", instanceName:"NeutronInstance"});
mass_obj.addMenuItem({type:"radio", groupName:"massGroup", label:"Random", instanceName:"randomInstance"});
var mbListener:Object = new Object();
mbListener.change = function(evt_obj:Object) {
	var menuItem_obj:Object = evt_obj.menuItem;
	switch (menuItem_obj.attributes.instanceName) {
	case "aboutInstance" :
		_root.controls.help._visible = true;
		break;
	case "whatsInstance" :
		_root.stoper();
		whats.swapDepths(_root.getNextHighestDepth());	
		whats._visible = true;
		whats.onRelease = function(){
			whats._visible = false;
			_root.restarter();
		}
		break;
	}
};
my_menu.addEventListener("change", mbListener);
var mbListener2:Object = new Object();
/**********************
Case statements for the menus
*************************/
mbListener2.change = function(evt_obj:Object) {
	var menuItem_obj2:Object = evt_obj.menuItem;
	switch (menuItem_obj2.attributes.instanceName) {
	case "randomInstance" :
		randomBool = true;
		randomMode();
		decay = "Click to Reveal";
		isotope = "?";
		break;
	case "BetaInstance" :
		randomBool = false;
		decay = "Beta";
		init();
		_root.onEnterFrame = continues;
		functionOn = continues;
		checkIsotope();
		break;
	case "PairInstance" :
		randomBool = false;
		decay = "Pair Production";
		init();
		initPair();
		_root.onEnterFrame = pairProduction;
		functionOn = pairProduction;
		checkIsotope();
		break;
	case "alphaInstance" :
		randomBool = false;
		decay = "Alpha";
		init();
		initAlpha();
		_root.onEnterFrame = alpha;
		functionOn = alpha;
		checkIsotope();
		break;
	case "KaonInstance" :
		randomBool = false;
		decay = "Kaon";
		initKaon();
		_root.onEnterFrame = KaonDecay;
		functionOn = KaonDecay;
		checkIsotope();
		break;
	case "NeutronInstance" :
		randomBool = false;
		decay = "Neutron";
		initNeutron();
		_root.onEnterFrame = NeutronDecay;
		functionOn = NeutronDecay;
		checkIsotope();
		break;
	case "advancedInstance" :
		_root.controls.advanced._visible = true;
		_root.controls.advanced.combo.dropdown.swapDepths(_root.getNextHighestDepth());
		_root.controls.advanced.comboBeta.dropdown.swapDepths(_root.getNextHighestDepth());
		_root.stoper();
		_root.controls.image_btn.enabled = false;
		_root.controls.measure_btn.enabled = false;
		_root.controls.resume_btn.enabled = false;
		break;
	case "calculatorInstance" :
		_root.controls.calculator._visible = true;
		break;
	}
};
my_menu2.addEventListener("change", mbListener2);

var mbListener3:Object = new Object();

mbListener3.change = function(evt_obj:Object) {
	var menuItem_obj3:Object = evt_obj.menuItem;
	switch (menuItem_obj3.attributes.instanceName) {
	case "exploreInstance" :
		getURL("resources/explore.html", "_blank");
		break;
	case "problemInstance" :
		getURL("resources/problems.html", "_blank");
		break;
	case "literatureInstance" :
		getURL("resources/literature.html", "_blank");
		break;
	}
}

my_menu3.addEventListener("change", mbListener3);

var mass:Number = 9.1E-31;
var q:Number = -1;
_root.createEmptyMovieClip("path", _root.getNextHighestDepth());
_root.createEmptyMovieClip("path2", _root.getNextHighestDepth());
_root.createEmptyMovieClip("Kaon", -1003);
_root.createEmptyMovieClip("Pion", -1004);
_root.createEmptyMovieClip("Electron", -1005);
_root.createEmptyMovieClip("Positron", -1006);
_root.createEmptyMovieClip("Electron2", -1007);
_root.createEmptyMovieClip("Positron2", -1008);
_root.createEmptyMovieClip("KaonLine0", -1009);
_root.createEmptyMovieClip("KaonLine1", -1010);
_root.createEmptyMovieClip("ElectronLine0", -1011);
_root.createEmptyMovieClip("PositronLine0", -1012);
_root.createEmptyMovieClip("ElectronLine1", -1013);
_root.createEmptyMovieClip("PositronLine1", -1014);
_root.createEmptyMovieClip("Electron2Line0", -1015);
_root.createEmptyMovieClip("Positron2Line0", -1016);
_root.createEmptyMovieClip("Electron2Line1", -1017);
_root.createEmptyMovieClip("Positron2Line1", -1018);
_root.createEmptyMovieClip("tree0", -1000);
_root.createEmptyMovieClip("tree1", -1001);
_root.createEmptyMovieClip("cursor_mc", _root.getNextHighestDepth());
cursor_mc.moveTo(0, 0);
cursor_mc.lineTo(0, 1);
cursor_mc._visible = false;
var measure:radiusmeasure1 = new radiusmeasure1();
var vpX:Number = Stage.width/2;
var vpY:Number = Stage.height/2;
var dt:Number;
var zoom:Number = 1.1000;
var bfield:vector = new vector(0, 0, .001);
var efield:vector = new vector(0, 0, 0);
var count:Number = 0;
var count2:Number = 0;
var count3:Number = 0;
var count4:Number = 0;
var array1:Array = new Array();
var array2:Array = new Array();
var array3:Array = new Array();
var path2Arrayx:Array = new Array();
var path2Arrayy:Array = new Array();
var path2Arrayz:Array = new Array();
var kaonx:Array = new Array();
var kaony:Array = new Array();
var kaonz:Array = new Array();
var pionx:Array = new Array();
var piony:Array = new Array();
var pionz:Array = new Array();
var electronx:Array = new Array();
var electrony:Array = new Array();
var electronz:Array = new Array();
var positronx:Array = new Array();
var positrony:Array = new Array();
var positronz:Array = new Array();
var electron2x:Array = new Array();
var electron2y:Array = new Array();
var electron2z:Array = new Array();
var positron2x:Array = new Array();
var positron2y:Array = new Array();
var positron2z:Array = new Array();
var j:Number = 0;
var unit:vector = new vector();
var mag:Number;
var unit2:vector = new vector();
var mag2:Number;
var txt_colour:Number = 0xF7F7F7;
var i:Number = 0;
var bool:Boolean = true;
var decay:String = "Beta";
var scale:Number = 1000;
var bfieldtext:String = bfield.z+" T";
var av:Number = 6.0221415E23;
var drawSwitch:Boolean = false;
var functionOn:Function;
var isotope:String;
var randomBool:Boolean = false;
var drawCount:Number = 0;
var KaonDone:Boolean = false;

//Array of data for the combo boxes
for (var k:Number = 0; k < 7; k++){
	var data1:Object = new Object();
	data1.Decay = "Alpha";
	data1.Charge = 2;
	Data.push(data1);
}
for (var j:Number = 0; j < 7; j++){
	var data1:Object = new Object();
	data1.Decay = "Beta";
	Data.push(data1);
}
Data[0].Name = "Americium-243";
Data[0].Energy = 5.28;

Data[1].Name = "Thorium-232";
Data[1].Energy = 4.05;

Data[2].Name = "Uranium-235";
Data[2].Energy = 4.6;

Data[3].Name = "Uranium-238";
Data[3].Energy = 4.2;

Data[4].Name = "Radium-226";
Data[4].Energy = 4.9;

Data[5].Name = "Polonium-210";
Data[5].Energy = 5.41;

Data[6].Name = "Polonium-212";
Data[6].Energy = 8.95;

Data[7].Name = "Tritium";
Data[7].Energy = 1;
Data[7].Charge = -1;

Data[8].Name = "Sodium";
Data[8].Energy = 100;
Data[8].Charge = 1;

Data[9].Name = "Cobalt";
Data[9].Energy = 17.6666666666667;
Data[9].Charge = -1;

Data[10].Name = "Strontium";
Data[10].Energy = 30.3333333333333;
Data[10].Charge = -1;

Data[11].Name = "Copper-64";
Data[11].Energy = 36.7;
Data[11].Charge = 1;

Data[12].Name = "Carbon-11";
Data[12].Energy = 53.8;
Data[12].Charge = 1;


Data[13].Name = "Carbon-14";
Data[13].Energy = 8.7;
Data[13].Charge = -1;


//********Calculator stuff************////
_root.controls.calculator.calculatorBack.useHandCursor = false;
_root.controls.calculator._visible = false;
_root.controls.calculator.massInput.selectable = false;
_root.controls.calculator.chargeInput.selectable = false;

var calcMass:Number = 0.511;
var calcCharge:Number = 1;
//************************************/

/************************
Formats the style of my menus and buttons
*************************/
_root.controls.advanced.combo.setStyle("themeColor", 0x333333);
_root.controls.advanced.combo.setStyle("rollOverColor", 0xEEEEEE);
_root.controls.advanced.combo.setStyle("selectionColor", 0xEEEEEE);
_root.controls.advanced.combo.setStyle("textSelectedColor", 0x000000);
_root.controls.advanced.comboBeta.setStyle("themeColor", 0x333333);
_root.controls.advanced.comboBeta.setStyle("rollOverColor", 0xEEEEEE);
_root.controls.advanced.comboBeta.setStyle("selectionColor", 0xEEEEEE);
_root.controls.advanced.comboBeta.setStyle("textSelectedColor", 0x000000);
_root.controls.advanced.start_btn.setStyle("themeColor", 0x333333);
_root.controls.image_btn.setStyle("themeColor", 0x333333);
_root.controls.measure_btn.setStyle("themeColor", 0x333333);
_root.controls.resume_btn.setStyle("themeColor", 0x333333);
_root.controls.calculator.particleGroup.setStyle("themeColor", 0x333333);
_root.controls.advanced.energy_cb.setStyle("themeColor", 0x111111);
_root.controls.advanced.energy_cb.setStyle("color", 0x000000);
_root.controls.advanced.energy_cb.setStyle("fontFamily", "Arial");
_root.controls.advanced.energy_cb.setStyle("fontSize", 12);
_root.controls.advanced.bfieldz.borderColor = 0x777777;
_root.controls.advanced._visible = false;
_root.controls.advanced.dragTester.useHandCursor = false;
_root.controls.help.help_back.useHandCursor = false;

_root.controls.measure_btn.enabled = false;
_root.controls.resume_btn.enabled = false;
/*************************/
for (var z:Number = 0; z<datalength; z++) {	
	if (Data[z].Decay == "Alpha") {
		_root.controls.advanced.combo.addItem({data:Data[z], label:Data[z].Name});
	} else if (Data[z].Decay == "Beta") {
		_root.controls.advanced.comboBeta.addItem({data:Data[z], label:Data[z].Name});
	}
}
/***********************/
checkIsotope();
init();
starter();
//****************
//****************
/************** Initialize functions****************/
function init() {
	count = 0;
	count2 = 0;
	array1 = new Array();
	array2 = new Array();
	array3 = new Array();
	//starting position of path
	path.x = Math.random()*150;
	path.y = 240;
	path.z = 0;
	path.mass = mass;
	//Initial energy and velocity.
	path.etest = betaEnergy();
	path.energy = path.etest*_root.controls.advanced.comboBeta.value.Energy;
	path.vx = Physics.velE(path.energy, path.mass)*scale;
	path.vy = 0;
	path.vz = 0;
	//Charge Sign
	path.q = _root.controls.advanced.comboBeta.value.Charge;
	path.q = path.q*1.6E-19;
	path.dt = 1E-10*1000/scale/(1+3*_root.controls.advanced.comboBeta.value.Energy/100);
	tree.moveTo(path.x, path.y);
	//These below are important for the RK4 initial values.
	path.r_old = new vector(path.x, path.y, path.z);
	path.v_old = new vector(path.vx, path.vy, path.vz);
	controls.swapDepths(_root.getNextHighestDepth());
	bfieldtext = bfield.z+" T";
	drawSwitch = false;
}
function initPair() {
	path.energy = (Math.random()*9+1)*1000000*1.6E-19/2;
	path.vtot = Physics.velE(path.energy, path.mass)*scale;
	path.vx = (Math.random()*4+96)/100*path.vtot;
	path.vy = Math.sqrt(path.vtot*path.vtot-path.vx*path.vx);
	path.r_old = new vector(path.x, path.y, path.z);
	path.v_old = new vector(path.vx, path.vy, path.vz);
	path2arrayx = new Array();
	path2arrayy = new Array();
	path2arrayz = new Array();
	path2.x = path.x;
	path2.y = 240;
	path2.z = 0;
	path2.mass = mass;
	path2.energy = path.energy;
	path2.vx = path.vx;
	path2.vy = 0;
	path2.vz = 0;
	path.dt = 1E-10*1000/scale/4;
	path2.dt = path.dt;
	path2.q = -1*path.q;
	path2.r_old = new vector(path.x, path.y, path.z);
	path2.v_old = new vector(path.vx, path.vy, path.vz);
}
function initAdvanced() {
	bfield.z = _root.controls.advanced.bfieldz.text*1;
	checkIsotope();
	onEnterFrame = functionOn;
}
function initAlpha() {
	path.mass = 6.64465598E-27;
	path.energy = (_root.controls.advanced.combo.value.Energy)*1E6*1.6E-19;
	path.vx = Physics.velE(path.energy, path.mass)*scale;
	path.dt = 1E-10*1000/scale*2;
	path.q = 1.6E-19*2;
	path.r_old = new vector(path.x, path.y, path.z);
	path.v_old = new vector(path.vx, path.vy, path.vz);
}
function initKaon() {
	count = 0;
	//starting position of path
	Kaon.x = 0;
	Kaon.y = 240;
	Kaon.z = 0;
	Kaon.mass = 1.602E-19*493.7*1E6/(3E8*3E8);
	//Initial energy and velocity.
	Kaon.energy = 110E6*1.602E-19;
	Kaon.vx = .5*3E8*scale;
	Kaon.vy = 0;
	Kaon.vz = 0;
	//Charge Sign
	Kaon.q = 1.602E-19;
	Kaon.dt = .1E-10*1000/scale/(1+3*_root.controls.advanced.comboBeta.value.Energy/100);
	Kaon.r_old = new vector(Kaon.x, Kaon.y, Kaon.z);
	Kaon.v_old = new vector(Kaon.vx, Kaon.vy, Kaon.vz);
	Pion.x = 0;
	Pion.y = 0;
	Pion.z = 0;
	Pion.mass = 1.602E-19*139*1E6/(3E8*3E8);
	Pion.energy = 110E6*1.602E-19;
	Pion.vx = .6*3E8*scale;
	Pion.vy = .72*3E8*scale;
	Pion.vz = 0;
	Pion.q = 1.602E-19;
	Pion.dt = .1E-10*1000/scale/(1+3*_root.controls.advanced.comboBeta.value.Energy/100);
	Pion.r_old = new vector(Pion.x, Pion.y, Pion.z);
	Pion.v_old = new vector(Pion.vx, Pion.vy, Pion.vz);
	Positron.x = 0;
	Positron.y = 0;
	Positron.z = 0;
	Positron.mass = mass;
	Positron.vx = Math.cos(.75)*.96*3E8*scale;
	Positron.vy = -1*Math.sin(.75)*.96*3E8*scale;
	Positron.vz = 0;
	Positron.q = 1.602E-19;
	Positron.dt = .1E-10*1000/scale/(1+3*_root.controls.advanced.comboBeta.value.Energy/100);
	Positron.r_old = new vector(Positron.x, Positron.y, Positron.z);
	Positron.v_old = new vector(Positron.vx, Positron.vy, Positron.vz);
	Electron.x = 0;
	Electron.y = 0;
	Electron.z = 0;
	Electron.mass = mass;
	Electron.vx = Math.cos(.75)*.96*3E8*scale;
	Electron.vy = -1*Math.sin(.75)*.96*3E8*scale;
	Electron.vz = 0;
	Electron.q = -1*1.602E-19;
	Electron.dt = .1E-10*1000/scale/(1+3*_root.controls.advanced.comboBeta.value.Energy/100);
	Electron.r_old = new vector(Electron.x, Electron.y, Electron.z);
	Electron.v_old = new vector(Electron.vx, Electron.vy, Electron.vz);
	Positron2.x = 0;
	Positron2.y = 0;
	Positron2.z = 0;
	Positron2.mass = mass;
	Positron2.vx = Math.cos(1.17)*.96*3E8*scale;
	Positron2.vy = -1*Math.sin(1.17)*.96*3E8*scale;
	Positron2.vz = 0;
	Positron2.q = 1.602E-19;
	Positron2.dt = .1E-10*1000/scale/(1+3*_root.controls.advanced.comboBeta.value.Energy/100);
	Positron2.r_old = new vector(Positron2.x, Positron2.y, Positron2.z);
	Positron2.v_old = new vector(Positron2.vx, Positron2.vy, Positron2.vz);
	Electron2.x = 0;
	Electron2.y = 0;
	Electron2.z = 0;
	Electron2.mass = mass;
	Electron2.vx = Math.cos(1.17)*.96*3E8*scale;
	Electron2.vy = -1*Math.sin(1.17)*.96*3E8*scale;
	Electron2.vz = 0;
	Electron2.q = -1*1.602E-19;
	Electron2.dt = .1E-10*1000/scale/(1+3*_root.controls.advanced.comboBeta.value.Energy/100);
	Electron2.r_old = new vector(Electron2.x, Electron2.y, Electron2.z);
	Electron2.v_old = new vector(Electron2.vx, Electron2.vy, Electron2.vz);
	controls.swapDepths(_root.getNextHighestDepth());
	bfieldtext = bfield.z+" T";
	drawCount = 0;
	drawOn = false;
	randomNum = (Math.round(Math.random()*10))/10*100+50;
	randomNum2 = (Math.round(Math.random()*10))/10*100+50;
	randomNum3 = (Math.round(Math.random()*10))/10*100+50;
	KaonDone = true;
}
function initNeutron() {
	path.q = -1*1.602E-19;
	path.energy = betaEnergy(Math.random())*20;
	path.vtot = Physics.velE(path.energy, path.mass)*scale;
	path.vx = 0;
	path.vy = path.vtot;
	path.r_old = new vector(path.x, path.y, path.z);
	path.v_old = new vector(path.vx, path.vy, path.vz);
	path.mass = mass;
	path2arrayx = new Array();
	path2arrayy = new Array();
	path2arrayz = new Array();
	path2.x = path.x;
	path2.y = 240;
	path2.z = 0;
	path2.mass = 1.673E-27;
	path2.energy = path.energy;
	path2.vx = path.vtot*Physics.gamma(path.vtot/scale)*(.511/938.3);
	path2.vy = 0;
	path2.vz = 0;
	path.dt = 1E-10*1000/scale/4;
	path2.dt = path.dt*1000;
	path2.q = -1*path.q;
	path2.r_old = new vector(path.x, path.y, path.z);
	path2.v_old = new vector(path2.vx, path2.vy, path2.vz);
}
//*******************************************
//*******************************************
/*******     OnEnterFrame Functions   ********
Depending on which decay is happening, these are the onEnterFrame functions.
-'continues 'is the Beta decay
-functions first calcuate the path and store it in an array. A bool switch
is then turned on when the path is done calculating, the path is then drawn.
***********************************************/
function starter() {
	onEnterFrame = continues;
}
function continues() {
	var thing:PhysicsObject = new PhysicsObject();
	if (count<800) {
		for (var f:Number = 0; f<10; f++) {
			//calls the RK4 method to apply the B-Field and new velocity.
			thing.RK4EB(path, bfield, scale, efield);
			//stores positions in arrays
			array1[count] = path.x;
			array2[count] = path.y;
			array3[count] = path.z;
			//This is the subtraction of energy to create an inward spiral.
			//Energy is decreasing by the fraction 99.5/100. These are just test numbers
			//and can be removed.
			if (_root.controls.advanced.energy_cb.selected == true) {
				unit = vectorMath.norm(path.v_old);
				mag = vectorMath.mag(path.v_old)*(100-Math.random()*.5)/100;
				path.v_old.x = mag*unit.x;
				path.v_old.y = mag*unit.y;
				path.v_old.z = mag*unit.z;
			}
			//trace(path.v_old.x);                   
			count++;
		}
		if (path.x>Stage.width || path.x<0 || path.y>Stage.height || path.y<0) {
			drawSwitch = true;
		}
	} else {
		drawSwitch = true;
	}
	tree0._alpha -= 1.5;
	tree1._alpha -= 1.5;
	PositronLine0._alpha -= 1.5;
	ElectronLine0._alpha -= 1.5;
	PositronLine1._alpha -= 1.5;
	ElectronLine1._alpha -= 1.5;
	Positron2Line0._alpha -= 1.5;
	Electron2Line0._alpha -= 1.5;
	Positron2Line1._alpha -= 1.5;
	Electron2Line1._alpha -= 1.5;
	KaonLine0._alpha -= 1.5;
	KaonLine1._alpha -= 1.5;
	//This is the draw function. Does all the drawing in one frame, so it looks as
	//if the line appears instantly.
	if (drawSwitch) {
		if (bool) {
			if (i == 0) {
				i = 1;
			} else {
				i = 0;
			}
			bool = false;
			var tree:MovieClip = this["tree"+i];
			tree.clear();
			tree.moveTo(array1[0], array2[0]);
			tree._alpha = 100;
			tree.lineStyle(Math.random()*3+1, 0xBBBBBB, 100);
			count2++;
		}
		while (count2<count) {
			//tree.clear();
			tree.lineStyle(Math.random()*3+1, 0xBBBBBB, 100);
			tree.lineTo(array1[count2], array2[count2]);
			count2++;
			tree.moveTo(array1[count2-1], array2[count2-1]);
		}
		//Starts a new cycle after the line is drawn.
		var rand:Number = randRange(1, 100);
		if (rand<2) {
			init();
			bool = true;
			checkRandom();
		}
	}
}
function pairProduction() {
	var thing:PhysicsObject = new PhysicsObject();
	var thing2:PhysicsObject = new PhysicsObject();
	if (count<450) {
		for (var f:Number = 0; f<10; f++) {
			//calls the RK4 method to apply the B-Field and new velocity.
			thing.RK4EB(path, bfield, scale, efield);
			thing2.RK4EB(path2, bfield, scale, efield);
			//stores positions in arrays
			array1[count] = path.x;
			array2[count] = path.y;
			array3[count] = path.z;
			path2arrayx[count] = path2.x;
			path2arrayy[count] = path2.y;
			path2arrayz[count] = path2.z;
			//This is the subtraction of energy to create an inward spiral.
			if (_root.controls.advanced.energy_cb.selected == true) {
				unit = vectorMath.norm(path.v_old);
				mag = vectorMath.mag(path.v_old)*(100-Math.random()*.3)/100;
				path.v_old.x = mag*unit.x;
				path.v_old.y = mag*unit.y;
				path.v_old.z = mag*unit.z;
				unit2 = vectorMath.norm(path2.v_old);
				mag = vectorMath.mag(path.v_old)*(100-Math.random()*.3)/100;
				path2.v_old.x = mag*unit2.x;
				path2.v_old.y = mag*unit2.y;
				path2.v_old.z = mag*unit2.z;
			}
			count++;
		}
		if (path.x>Stage.width || path.x<0 || path.y>Stage.height || path.y<0) {
			drawSwitch = true;
		}
	} else {
		drawSwitch = true;
	}
	//Decreases alpha value of the line drawn before.
	tree0._alpha -= 2;
	tree1._alpha -= 2;
	PositronLine0._alpha -= 1.5;
	ElectronLine0._alpha -= 1.5;
	PositronLine1._alpha -= 1.5;
	ElectronLine1._alpha -= 1.5;
	Positron2Line0._alpha -= 1.5;
	Electron2Line0._alpha -= 1.5;
	Positron2Line1._alpha -= 1.5;
	Electron2Line1._alpha -= 1.5;
	KaonLine0._alpha -= 1.5;
	KaonLine1._alpha -= 1.5;
	//This is the draw function. Does all the drawing in one frame, so it looks as
	//if the line appears instantly.
	if (drawSwitch) {
		if (bool) {
			if (i == 0) {
				i = 1;
			} else {
				i = 0;
			}
			bool = false;
			var tree:MovieClip = this["tree"+i];
			tree.clear();
			tree.moveTo(array1[0], array2[0]);
			tree._alpha = 100;
			tree.lineStyle(Math.random()*3+1, 0xBBBBBB, 100);
			count2++;
		}
		while (count2<count) {
			//tree.clear();
			tree.lineStyle(Math.random()*3+1, 0xBBBBBB, 100);
			tree.lineTo(array1[count2], array2[count2]);
			tree.moveTo(path2arrayx[count2-1], path2arrayy[count2-1]);
			tree.lineTo(path2arrayx[count2], path2arrayy[count2]);
			count2++;
			tree.moveTo(array1[count2-1], array2[count2-1]);
		}
		//Starts a new cycle after the line is drawn.
		var rand:Number = randRange(1, 50);
		if (rand<2) {
			init();
			initPair();
			bool = true;
			checkRandom();
		}
	}
}
function alpha() {
	var thing:PhysicsObject = new PhysicsObject();
	if (count<450) {
		for (var f:Number = 0; f<10; f++) {
			//calls the RK4 method to apply the B-Field and new velocity.
			thing.RK4EB(path, bfield, scale, efield);
			//stores positions in arrays
			array1[count] = path.x;
			array2[count] = path.y;
			array3[count] = path.z;
			//This is the subtraction of energy to create an inward spiral.
			//Energy is decreasing by the fraction 99.5/100. These are just test numbers
			//and can be removed.
			if (_root.controls.advanced.energy_cb.selected == true) {
				unit = vectorMath.norm(path.v_old);
				mag = vectorMath.mag(path.v_old)*(100-Math.random()*.5)/100;
				path.v_old.x = mag*unit.x;
				path.v_old.y = mag*unit.y;
				path.v_old.z = mag*unit.z;
			}
			count++;
		}
		if (path.x>Stage.width || path.x<0 || path.y>Stage.height || path.y<0) {
			drawSwitch = true;
		}
	} else {
		drawSwitch = true;
	}
	tree0._alpha -= 1;
	tree1._alpha -= 1;
	PositronLine0._alpha -= 1.5;
	ElectronLine0._alpha -= 1.5;
	PositronLine1._alpha -= 1.5;
	ElectronLine1._alpha -= 1.5;
	Positron2Line0._alpha -= 1.5;
	Electron2Line0._alpha -= 1.5;
	Positron2Line1._alpha -= 1.5;
	Electron2Line1._alpha -= 1.5;
	KaonLine0._alpha -= 1.5;
	KaonLine1._alpha -= 1.5;
	//This is the draw function. Does all the drawing in one frame, so it looks as
	//if the line appears instantly.
	if (drawSwitch) {
		if (bool) {
			if (i == 0) {
				i = 1;
			} else {
				i = 0;
			}
			bool = false;
			var tree:MovieClip = this["tree"+i];
			tree.clear();
			tree.moveTo(array1[0], array2[0]);
			tree._alpha = 100;
			tree.lineStyle(Math.random()*3+1, 0xBBBBBB, 100);
			count2++;
		}
		while (count2<count) {
			//tree.clear();
			tree.lineStyle(Math.random()*3+1, 0xBBBBBB, 100);
			tree.lineTo(array1[count2], array2[count2]);
			count2++;
			tree.moveTo(array1[count2-1], array2[count2-1]);
		}
		//Starts a new cycle after the line is drawn.
		var rand:Number = randRange(1, 100);
		if (rand<2) {
			init();
			initAlpha();
			bool = true;
			checkRandom();
		}
	}
}
function KaonDecay() {
	var kaonObject:PhysicsObject = new PhysicsObject();
	var electronObject:PhysicsObject = new PhysicsObject();
	var positronObject:PhysicsObject = new PhysicsObject();
	var electronObject2:PhysicsObject = new PhysicsObject();
	var positronObject2:PhysicsObject = new PhysicsObject();
	var pionObject:PhysicsObject = new PhysicsObject();
	if (count<250) {
		for (var f:Number = 0; f<5; f++) {
			//calls the RK4 method to apply the B-Field and new velocity.
			if (Kaon.x<(randomNum+50)) {
				kaonObject.RK4EB(Kaon, bfield, scale, efield);
				kaonx[count] = Kaon.x;
				kaony[count] = Kaon.y;
				//kaonz[count] = Kaon.z;
				KaonCount = count;
				Pion.x = Kaon.x;
				Pion.y = Kaon.y;
				Pion.r_old = new vector(Pion.x, Pion.y, Pion.z);
			} else {
				if (KaonDone) {
					Electron.x = Kaon.x+randomNum3*Math.cos(.75);
					Electron.y = Kaon.y-randomNum3*Math.sin(.75);
					Positron.x = Kaon.x+randomNum3*Math.cos(.75);
					Positron.y = Kaon.y-randomNum3*Math.sin(.75);
					Electron.r_old = new vector(Electron.x, Electron.y, Electron.z);
					Positron.r_old = new vector(Positron.x, Positron.y, Positron.z);
					Electron2.x = Kaon.x+randomNum2*Math.cos(1.17);
					Electron2.y = Kaon.y-randomNum2*Math.sin(1.17);
					Positron2.x = Kaon.x+randomNum2*Math.cos(1.17);
					Positron2.y = Kaon.y-randomNum2*Math.sin(1.17);
					Electron2.r_old = new vector(Electron2.x, Electron2.y, Electron2.z);
					Positron2.r_old = new vector(Positron2.x, Positron2.y, Positron2.z);
					KaonDone = false;
				}
				pionObject.RK4EB(Pion, bfield, scale, efield);
				positronObject.RK4EB(Positron, bfield, scale, efield);
				electronObject.RK4EB(Electron, bfield, scale, efield);
				positronObject2.RK4EB(Positron2, bfield, scale, efield);
				electronObject2.RK4EB(Electron2, bfield, scale, efield);
				kaonx[count] = Pion.x;
				kaony[count] = Pion.y;
				electronx[count] = Electron.x;
				electrony[count] = Electron.y;
				positrony[count] = Positron.y;
				positronx[count] = Positron.x;
				electron2x[count] = Electron2.x;
				electron2y[count] = Electron2.y;
				positron2y[count] = Positron2.y;
				positron2x[count] = Positron2.x;
				if (_root.controls.advanced.energy_cb.selected == true) {
					unit = vectorMath.norm(Electron.v_old);
					mag = vectorMath.mag(Electron.v_old)*(100-Math.random()*.1)/100;
					Electron.v_old.x = mag*unit.x;
					Electron.v_old.y = mag*unit.y;
					Electron.v_old.z = mag*unit.z;
					unit2 = vectorMath.norm(path2.v_old);
					mag = vectorMath.mag(path.v_old)*(100-Math.random()*.1)/100;
					path2.v_old.x = mag*unit2.x;
					path2.v_old.y = mag*unit2.y;
					path2.v_old.z = mag*unit2.z;
				}
			}
			count++;
			if (count == 250) {
				drawOn = true;
			}
		}
	}
	PositronLine0._alpha -= 1.5;
	ElectronLine0._alpha -= 1.5;
	PositronLine1._alpha -= 1.5;
	ElectronLine1._alpha -= 1.5;
	Positron2Line0._alpha -= 1.5;
	Electron2Line0._alpha -= 1.5;
	Positron2Line1._alpha -= 1.5;
	Electron2Line1._alpha -= 1.5;
	KaonLine0._alpha -= 1.5;
	KaonLine1._alpha -= 1.5;
	tree0._alpha -= 1.5;
	tree1._alpha -= 1.5;
	if (drawOn) {
		if (i == 0) {
			i = 1;
		} else {
			i = 0;
		}
		var KaonLine:MovieClip = this["KaonLine"+i];
		var PositronLine:MovieClip = this["PositronLine"+i];
		var ElectronLine:MovieClip = this["ElectronLine"+i];
		var PositronLine2:MovieClip = this["Positron2Line"+i];
		var ElectronLine2:MovieClip = this["Electron2Line"+i];
		KaonLine.clear();
		PositronLine.clear();
		ElectronLine.clear();
		PositronLine2.clear();
		ElectronLine2.clear();
		KaonLine._alpha = 100;
		PositronLine._alpha = 100;
		ElectronLine._alpha = 100;
		PositronLine2._alpha = 100;
		ElectronLine2._alpha = 100;
		KaonLine.moveTo(kaonx[0], kaony[0]);
		while (drawCount<count-1) {
			KaonLine.lineStyle(Math.random()*3+1, 0xBBBBBB, 100);
			KaonLine.lineTo(kaonx[drawCount+1], kaony[drawCount+1]);
			drawCount++;
		}
		KaonCount++;
		ElectronLine.moveTo(electronx[KaonCount], electrony[KaonCount]);
		PositronLine.moveTo(positronx[KaonCount], positrony[KaonCount]);
		ElectronLine2.moveTo(electron2x[KaonCount], electron2y[KaonCount]);
		PositronLine2.moveTo(positron2x[KaonCount], positron2y[KaonCount]);
		while (KaonCount<count-1) {
			PositronLine.lineStyle(Math.random()*3+1, 0xBBBBBB, 100);
			PositronLine.lineTo(positronx[KaonCount+1], positrony[KaonCount+1]);
			ElectronLine.lineStyle(Math.random()*3+1, 0xBBBBBB, 100);
			ElectronLine.lineTo(electronx[KaonCount+1], electrony[KaonCount+1]);
			PositronLine2.lineStyle(Math.random()*3+1, 0xBBBBBB, 100);
			PositronLine2.lineTo(positron2x[KaonCount+1], positron2y[KaonCount+1]);
			ElectronLine2.lineStyle(Math.random()*3+1, 0xBBBBBB, 100);
			ElectronLine2.lineTo(electron2x[KaonCount+1], electron2y[KaonCount+1]);
			KaonCount++;
		}
		/*duplicateMovieClip(ElectronLine, "ElectronDup", _root.getNextHighestDepth());
		duplicateMovieClip(PositronLine, "PositronDup", _root.getNextHighestDepth());
		duplicateMovieClip(ElectronLine2, "ElectronDup2", _root.getNextHighestDepth());
		duplicateMovieClip(PositronLine2, "PositronDup2", _root.getNextHighestDepth());
		duplicateMovieClip(KaonLine, "KaonDup", _root.getNextHighestDepth());*/
		drawOn = false;
	}
	PositronLine0._alpha -= 1;
	ElectronLine0._alpha -= 1;
	PositronLine1._alpha -= 1;
	ElectronLine1._alpha -= 1;
	Positron2Line0._alpha -= 1;
	Electron2Line0._alpha -= 1;
	Positron2Line1._alpha -= 1;
	Electron2Line1._alpha -= 1;
	KaonLine0._alpha -= 1;
	KaonLine1._alpha -= 1;
	tree0._alpha -= 1;
	tree1._alpha -= 1;
	if (drawOn == false && count == 250) {
		var rand:Number = randRange(1, 50);
		if (rand<2) {
			initKaon();
		}
	}
}
function NeutronDecay() {
	var thing:PhysicsObject = new PhysicsObject();
	var thing2:PhysicsObject = new PhysicsObject();
	if (count<450) {
		for (var f:Number = 0; f<10; f++) {
			//calls the RK4 method to apply the B-Field and new velocity.
			thing.RK4EB(path, bfield, scale, efield);
			thing2.RK4EB(path2, bfield, scale, efield);
			//stores positions in arrays
			array1[count] = path.x;
			array2[count] = path.y;
			array3[count] = path.z;
			path2arrayx[count] = path2.x;
			path2arrayy[count] = path2.y;
			path2arrayz[count] = path2.z;
			//This is the subtraction of energy to create an inward spiral.
			//Energy is decreasing by the fraction 99.5/100. These are just test numbers
			//and can be removed.
			if (_root.controls.advanced.energy_cb.selected == true) {
				unit = vectorMath.norm(path.v_old);
				mag = vectorMath.mag(path.v_old)*(100-Math.random()*.2)/100;
				path.v_old.x = mag*unit.x;
				path.v_old.y = mag*unit.y;
				path.v_old.z = mag*unit.z;
				unit2 = vectorMath.norm(path2.v_old);
				mag = vectorMath.mag(path2.v_old)*(100-Math.random()*.2)/100;
				path2.v_old.x = mag*unit2.x;
				path2.v_old.y = mag*unit2.y;
				path2.v_old.z = mag*unit2.z;
			}
			count++;
		}
		if (path.x>Stage.width || path.x<0 || path.y>Stage.height || path.y<0) {
			drawSwitch = true;
		}
	} else {
		drawSwitch = true;
	}
	//Decreases alpha value of the line drawn before.
	tree0._alpha -= 2;
	tree1._alpha -= 2;
	PositronLine0._alpha -= 1.5;
	ElectronLine0._alpha -= 1.5;
	PositronLine1._alpha -= 1.5;
	ElectronLine1._alpha -= 1.5;
	Positron2Line0._alpha -= 1.5;
	Electron2Line0._alpha -= 1.5;
	Positron2Line1._alpha -= 1.5;
	Electron2Line1._alpha -= 1.5;
	KaonLine0._alpha -= 1.5;
	KaonLine1._alpha -= 1.5;
	//This is the draw function. Does all the drawing in one frame, so it looks as
	//if the line appears instantly.
	if (drawSwitch) {
		if (bool) {
			if (i == 0) {
				i = 1;
			} else {
				i = 0;
			}
			bool = false;
			var tree:MovieClip = this["tree"+i];
			tree.clear();
			tree.moveTo(array1[0], array2[0]);
			tree._alpha = 100;
			tree.lineStyle(Math.random()*3+1, 0xBBBBBB, 100);
			count2++;
		}
		while (count2<count) {
			//tree.clear();
			tree.lineStyle(Math.random()*3+1, 0xBBBBBB, 100);
			tree.lineTo(array1[count2], array2[count2]);
			tree.moveTo(path2arrayx[count2-1], path2arrayy[count2-1]);
			tree.lineTo(path2arrayx[count2], path2arrayy[count2]);
			count2++;
			tree.moveTo(array1[count2-1], array2[count2-1]);
		}
		//Starts a new cycle after the line is drawn.
		var rand:Number = randRange(1, 50);
		if (rand<2) {
			init();
			initNeutron();
			bool = true;
			checkRandom();
		}
	}
}
/*********************************************
********************** Functions Below    *************************/
function randomMode() {
	var rand:Number = randRange(1, 3);
	if (rand == 1) {
		init();
		_root.onEnterFrame = continues;
	} else if (rand == 2) {
		init();
		initPair();
		_root.onEnterFrame = pairProduction;
	} else if (rand == 3) {
		init();
		initAlpha();
		_root.onEnterFrame = alpha;
	}
	decay = "Click to Reveal";
	isotope = "?";
}
function randRange(min:Number, max:Number):Number {
	var randomNum:Number = Math.round(Math.random()*(max-min+1)+(min-.5));
	return randomNum;
}
function measurer() {
	measure.measure("m", scale, txt_colour, false);
}
function stoper() {
	_root.controls.measure_btn.enabled = true;
	_root.controls.resume_btn.enabled = true;
	if (onEnterFrame != null) {
		functionOn = onEnterFrame;
	}
	onEnterFrame = null;
}
function restarter() {
	_root.controls.measure_btn.enabled = false;
	_root.controls.resume_btn.enabled = false;
	onEnterFrame = functionOn;
}
function betaEnergy():Number {
	if (Math.random()<.1) {
		return Math.random()*2*1000*1.6E-19;
	} else {
		return Physics.betaE(Math.random());
	}
}
_root.cursor_mc.onMouseMove = function() {
	this._x = _root._xmouse;
	this._y = _root._ymouse;
};
onMouseDown = function () {
	if (decay == "Click to Reveal") {
		if (_root.cursor_mc.hitTest(_root.controls.decay_mc)) {
			stoper();
			if (functionOn == continues) {
				decay = "Beta";
				checkIsotope();
			} else if (functionOn == alpha) {
				decay = "Alpha";
				checkIsotope();
			} else if (functionOn == pairProduction) {
				decay = "Pair Production";
				checkIsotope();
			}
		}
	}
	_root.controls.advanced.dragTester.onPress = function() {
		_root.controls.advanced.startDrag();
		_root.controls.advanced.swapDepths(_root.getNextHighestDepth());
	};
	_root.controls.help.help_back.onPress = function() {
		_root.controls.help.startDrag();
		_root.controls.help.swapDepths(_root.getNextHighestDepth());
	};
	_root.controls.calculator.calculatorBack.onPress = function() {
		_root.controls.calculator.startDrag();
		_root.controls.calculator.swapDepths(_root.getNextHighestDepth());
	};
};
onMouseUp = function () {
	_root.controls.advanced.stopDrag();
	_root.controls.calculator.stopDrag();
	_root.controls.help.stopDrag();
};
function checkIsotope() {
	if (decay == "Beta") {
		isotope = _root.controls.advanced.comboBeta.selectedItem.label;
	} else if (decay == "Alpha") {
		isotope = _root.controls.advanced.combo.selectedItem.label;
	} else {
		isotope = "N/A";
	}
}
function checkRandom() {
	if (randomBool) {
		randomMode();
	}
}
flashistListener = new Object();
flashistListener.click = function(evt) {
	_root.controls.calculator.fadeBox._visible = true;
	_root.controls.calculator.massInput.selectable = false;
	_root.controls.calculator.chargeInput.selectable = false;
	switch (evt.target.selection.data) {
	case "proton" :
		calcMass = 938.3;
		calcCharge = 1;
		
		break;
	case "electron":
		calcMass = .511;
		calcCharge = 1;
		
		
		break;
	case "positron":
		calcMass = .511;
		calcCharge = 1;
		
		break;
	case "alpha":
		calcMass = 4.00153*931.494;
		calcCharge = 2;
		
		break;
	case "user":
		_root.controls.calculator.fadeBox._visible = false;
		_root.controls.calculator.massInput.selectable =true;
	_root.controls.calculator.chargeInput.selectable = true;
		calcMass = _root.controls.calculator.massInput.text*1;
		calcCharge = _root.controls.calculator.chargeInput.text*1;
		
		break;
	}
};
_root.controls.calculator.particleGroup.addEventListener("click", flashistListener);
function Calculator(){
	var velOutput:Number = Physics.getVel(calcMass*1.6E-19*1E6/(3E8*3E8), calcCharge*1.602E-19,_root.controls.calculator.BFieldInput.text*1,_root.controls.calculator.radiusInput.text*1)
	_root.controls.calculator.velocityOutput.text = Math.round(100*velOutput)/100;
	_root.controls.calculator.kEnergyOutput.text = Math.round(1000*Physics.Krel(velOutput,calcMass))/1000;
	_root.controls.calculator.tEnergyOutput.text = Math.round(1000*Physics.Erel(velOutput, calcMass))/1000;

}