////// div : infoPanelContainer //////

////// images //////


////// canvas elements and contexts //////
// var infoPanelCvs = document.getElementById('infoPanelCanvas');
// backgroundCtx = infoPanelCvs.getContext('2d');

var layersData;
////// JSON loader //////
function getData(myFile) // loads JSON data file 
// myData is the var to which the data is saved to
// myFile is the .json file. it is a string
{
	var xmlReq;
	if (window.XMLHttpRequest)
	{// code for IE7+, Firefox, Chrome, Opera, Safari
		xmlReq = new XMLHttpRequest();
	}
	else
	{// code for IE6, IE5
		xmlReq = new ActiveXObject("Microsoft.XMLHTTP");
	}
	xmlReq.onreadystatechange=function() // once data is loaded
	{
		if (xmlReq.readyState == 4 && xmlReq.status == 200)
		{
			console.log("Successfully collected Data");
			layersData = JSON.parse(xmlReq.responseText);
			//finalSetup();
			//do not attempt to access data untill data is loaded
			dataIsLoaded = true;

			// setupLayer(myData);
			initLayers(layerList, dataList, layersData);
			setLayer(layerList, dataList, currentLayerIndex);

		}
	};
	xmlReq.open("GET",myFile,true);
	xmlReq.send();
}


var layerData;
// getData("DATA/sample.json");
getData("DATA/layerData.json");


var firstLayer, secondLayer, thirdLayer, fourthLayer, fifthLayer; // update this line if JSON is modified
var first, second, third, fourth, fifth; // update this line if JSON is modified
var layerList = [firstLayer, secondLayer, thirdLayer, fourthLayer, fifthLayer]; // update this line if JSON is modified
var dataList = [first, second, third, fourth, fifth]; // update this line if JSON is modified
// var layerList = [firstLayer, secondLayer];
// var dataList = [first, second];

var currentLayerIndex = 0;



function setupLayer(layerData){
	var firstLayer = layerData.firstLayer;
	first = new AtmosphereLayer(firstLayer);
	first.initStacks(firstLayer);
	first.displayPage();
}

function initLayers(layers, data, layerData){
	//////////////////////////////////////////////////////
	////// update this function if JSON is modified //////
	//////////////////////////////////////////////////////
	
	// data[0] = layerData.firstLayer;
	// layers[0] = new AtmosphereLayer(data[0]);
	// data[1] = layerData.secondLayer;
	// layers[1] = new AtmosphereLayer(data[1]);
	var tempList = [layerData.firstLayer, layerData.secondLayer, layerData.thirdLayer, layerData.fourthLayer, layerData.fifthLayer];
	for (var j = 0; j < tempList.length; j++){
		data[j] = tempList[j];
		layers[j] = new AtmosphereLayer(data[j]);
	}

}
function setLayer(layers, data, layerIndex){
	layers[layerIndex].initStacks(data[layerIndex]);
	layers[layerIndex].displayPage()
}







