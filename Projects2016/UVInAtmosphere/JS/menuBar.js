$(document).ready(function() {
	//sets hover for original menu bar
	$('.menu > li').bind('mouseover', openMenu);
	$('.menu > li').bind('mouseout', closeMenu);
	//sets hover for submenu if any deeper need to make another to keep look
	$('.submenu > li').bind('mouseover', openSubMenu);
	$('.submenu > li').bind('mouseout', closeSubMenu);

	//makes submenu visible
	function openMenu() {
			$(this).find('.submenu').css('visibility', 'visible');
	};

	//makes submenu invisible
	function closeMenu(){
			$(this).find('.submenu').css('visibility', 'hidden');
	};

	//repeat for submenu but need its own or will open with mouse over grandparent and not parent item
	function openSubMenu() {
			$(this).find('.sub_submenu').css('visibility', 'visible');
	};

	function closeSubMenu(){
			$(this).find('.sub_submenu').css('visibility', 'hidden');
	};

});

function focusThis(name)
{
	document.getElementById(name).focus();// = true;
}

function openInstructions(){
	var width = $("#appletContainer").width() * 0.23;
	var height = $("#appletContainer").height() * 0.48;
	var centerX = $("#appletContainer").width() / 2;
	var centerY = $("#appletContainer").height() / 2;
	$("#instDialog").dialog({
		width: width,
		height: height,
		left: centerX,
		top: centerY,
		appendTo: "#instructionDiv",
	});
}

function openAbout(){
	var width = $("#appletContainer").width() * 0.23;
	var height = $("#appletContainer").height() * 0.48;
	var centerX = $("#appletContainer").width() / 2;
	var centerY = $("#appletContainer").height() / 2; 
	$("#aboutDialog").dialog({
		width: width,
		height: height,
		left: centerX,
		top: centerY,
		appendTo: "#aboutDiv",
	});
}