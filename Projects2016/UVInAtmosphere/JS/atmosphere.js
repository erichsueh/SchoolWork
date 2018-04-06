////// div : atmosphereContainer //////

////// images //////
// var backgroundImg = new Image();
// backgroundImg.src = "IMG/skyGraphic.png";
// var ozoneOverlayImg = new Image();
// ozoneOverlayImg.src = "IMG/ozoneOverlay.png";
// var altitudeBarImg = new Image();
// altitudeBarImg.src = "IMG/altitude.png";
// var dragItemImg = new Image();
// dragItemImg.src = "IMG/dragTarget.png"

////// canvas elements and contexts //////
// var backgroundCvs = document.getElementById('atmosphereBkgdCanvas');
// backgroundCtx = backgroundCvs.getContext('2d');
// var dragItemCvs = document.getElementById('dragItemCanvas');
// dragItemCtx = dragItemCvs.getContext('2d');

// event listeners for dragable slider
$(function(){
	$("#dragItem").draggable({
		axis:"y", 
		containment: "#atmosphereContainer",
		stop: function(){
			// resize the dragable item. Since JQuerry turns it into px, it must be converted back into %
			var atmosphereHeight = document.getElementById("atmosphereContainer").clientHeight; 
			var newTop = ($("#dragItem").position().top / atmosphereHeight) * 100 + "%";
			$("#dragItem").css({top: newTop});
			handleDragPercent();
		},
		drag: function(){
			handleDragPixel();
		}
	});
	
})


function handleDragPercent(){
	// updates the position of the slider, and checks which layer it's in
	// this one is used only when the slider stops, as the position of the slider is only changed into percentages when the slider stops moving
	var dragElem = document.getElementById("dragItem");
	var dragTop = dragElem.style.top;
	dragTop.replace(/%/g, ''); // removes "%" from the end of the string
	dragTop = parseFloat(dragTop);
	var previousIndex = currentLayerIndex
	if (dragTop < 12){
		currentLayerIndex = 0;
	} else if (dragTop < 37){
		currentLayerIndex = 1;
	} else if (dragTop < 65){
		currentLayerIndex = 2;
	} else if (dragTop < 86){
		currentLayerIndex = 3;
	} else {
		currentLayerIndex = 4;
	}
	if (previousIndex != currentLayerIndex){
		setLayer(layerList, dataList, currentLayerIndex);
	}
	
}

function handleDragPixel(){
	// updates the position of the slider, and checks which layer it's in
	// this one is called as the slider is moving, since it's position is in pixels
	var dragTop = $("#dragItem").position().top + 1;
	//convert to %
	var atmosphereHeight = document.getElementById("atmosphereContainer").clientHeight;
	var newTop = (dragTop / atmosphereHeight) * 100;

	var previousIndex = currentLayerIndex;
	if (newTop < 12){
		currentLayerIndex = 0;
	} else if (newTop < 37){
		currentLayerIndex = 1;
	} else if (newTop < 65){
		currentLayerIndex = 2;
	} else if (newTop < 86){
		currentLayerIndex = 3;
	} else {
		currentLayerIndex = 4;
	}
	if (previousIndex != currentLayerIndex){
		setLayer(layerList, dataList, currentLayerIndex);
	}
	
}





