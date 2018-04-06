Page = function(pageObj){
	//pageObj is the page JSON object
	this.pageNum = pageObj.pageNum; 
	this.titleName = pageObj.title;
	this.titleColor = pageObj.titleColor;
	this.buttonType = pageObj.buttonType;
	this.buttonText = pageObj.buttonText;
	this.buttonContent = pageObj.buttonContent;
	this.buttonLink = pageObj.buttonLink;
	this.mainText = pageObj.mainText;
	this.defaultImage = pageObj.defaultImage;

}
Page.prototype = 
{
	/// --- methods --- ///
	// makeTitle(): makes the background for the title and adds the appropriate text to the HTML element
	// makeMainText(): adds the appropriate text to the HTML element for the main text
	// makeButtonText(): adds text to the button that allows to show more information
	// removeButtonText(): removes the button's text from the button that allows to show more information
	// showShowButton(): displays the button that allows to show additional information
	// hideShowButton(): hides the button that allows to show additional information
	// makeButton(): checks to see if there is a button. if there is, then it adds the appropriate text
	// handleShowClick(): checks for button type, and calls appropriate handle for the button that allows to show additional info
	// showTextAnswer(): displays additional text information
	// showImageAnswer(): displays an image as additional information
	// hideImageAnswer(): hides the additional info image. This is used when loading a new page
	// removeTextAnswer(): removes the answer text
	// showOverlay(): loads and shows the overlay image over the sky background
	// hideOverlay(): hides the overlay image over the sky background
	// showDefaulImage(): shows the page's default image. if it doesn't have an image, than show the layer's blackbody curve. 

	makeTitle: function(){
		var canvas = document.getElementById("titleCanvas");
		var ctx = canvas.getContext('2d');
		var y = canvas.height;
		var x = canvas.width / 2;
		var radiusA = canvas.width / 30;
		var radiusB = canvas.width / 2;
		var grd = ctx.createRadialGradient(x, y, radiusA, x, y, radiusB);
		grd.addColorStop(0, "white");
		grd.addColorStop(1, this.titleColor);
		ctx.fillStyle = grd;
		ctx.fillRect(0, 0, canvas.width, canvas.height);
		var elem = document.getElementById("titleName");
		elem.innerHTML = this.titleName;
	},
	makeMainText: function(){
		var elem = document.getElementById("mainText");
		elem.innerHTML = this.mainText;
	},
	makeButtonText: function(){
		var elem = document.getElementById("showButtonText");
		elem.innerHTML = this.buttonText;
		elem.style.visibility = "visible";
	},
	removeButtonText: function(){
		// might not need this
		var elem = document.getElementById("showButtonText");
		elem.innerHTML = "";
		elem.style.visibility = "hidden";
	},
	showShowButton: function(){
		var elem = document.getElementById("showButton");
		elem.style.visibility = "visible";
	},
	hideShowButton: function(){
		var elem = document.getElementById("showButton");
		elem.style.visibility = "hidden";
	},
	makeButton: function(){
		if (this.buttonText != ""){
			this.makeButtonText();
			this.showShowButton();
		}
		else{
			this.removeButtonText();
			this.hideShowButton();
		}
	},
	handleShowClick: function(){
		if (this.buttonType == "textAnswer"){
			this.showTextAnswer();
		} else if (this.buttonType == "imageAnswer"){
			this.showImageAnswer();	
		}  else if (this.buttonType == "overlay"){
			this.showOverlay();
		} else if (this.buttonType == "link"){
			window.open(this.buttonContent)
		}
	},
	showTextAnswer: function(){
		this.hideImageAnswer();
		var elem = document.getElementById("extraText");
		elem.innerHTML = this.buttonContent;
	},
	showImageAnswer: function(){
		var elem = document.getElementById("extraImage");
		elem.src = this.buttonContent;
		elem.style.visibility = "visible";
	},
	hideImageAnswer: function(){
		var elem = document.getElementById("extraImage");
		elem.style.visibility = "hidden";
		// if (this.buttonLink != ""){
		// 	$("#extraImage").click(function(){
		// 		window.open(this.buttonLink);
		// 		console.log(this.buttonLink);
		// 	});
		// }
	},
	removeTextAnswer: function(){
		var elem = document.getElementById("extraText");
		elem.innerHTML = "";
	},
	showOverlay: function(){
		var elem = document.getElementById("overlayImage");
		elem.src = this.buttonContent;
		elem.style.visibility = "visible";
	},
	hideOverlay: function(){
		var elem = document.getElementById("overlayImage");
		elem.style.visibility = "hidden";
	},
	showDefaultImage: function(){
		var elem = document.getElementById("extraImage");
		if (this.defaultImage != ""){
			elem.style.visibility = "visible"
			elem.src = this.defaultImage;
			var butLink = this.buttonLink;
			// console.log(this.defaultImage);
			console.log(this.buttonLink);
			var canOpen = false;
			if (this.buttonLink != ""){
				console.log("true");
				elem.onclick = function(){window.open(butLink)};
			} else {
				elem.onclick = null;
			}
		}
		
		
	}

}

// var canvas = document.getElementById("titleCanvas");
// var ctx = canvas.getContext('2d');
// var y = canvas.height;
// var x = canvas.width / 2;
// var radiusA = canvas.width / 30;
// var radiusB = canvas.width / 2;
// var grd = ctx.createRadialGradient(x, y, radiusA, x, y, radiusB);
// grd.addColorStop(0,"white");
// grd.addColorStop(1,"red");
// ctx.fillStyle = grd;
// ctx.fillRect(0, 0, canvas.width, canvas.height);
// var elem = document.getElementById("titleName");
// elem.innerHTML = "Some Title";

// var elemA = document.getElementById("mainText");
// elemA.innerHTML = "Some sample text to fill some space. Some more really good text. This is truly pure Literature. ";

// var elemB = document.getElementById("showButtonText");
// elemB.innerHTML = "Show answer";

// var elemC = document.getElementById("extraText");
// elemC.innerHTML = "this is some answer filler text";




