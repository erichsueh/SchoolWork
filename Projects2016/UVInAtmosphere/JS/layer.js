AtmosphereLayer = function(layerName){
	this.layerName = layerName;
	this.mainStack;
	this.secondStack;
	this.currentPage;
}
AtmosphereLayer.prototype = 
{
	/// --- methods --- ///
	// iniStacks(layerName): initializes the stacks, and populates the main stack
	// nextPage(): moves the current page object to the secondary stack, and loads the next page in the main stack
	// previousPage(): moves the first page object from the secondary stack onto the main stack, and loads the page object
	// nextButton(): determines whether or not to display the next and previous buttons, based on the size of main stack
	// backButton(): determines whether or not to display the next and previous buttons, based on the size of the secondary stack
	// displayPage(): resets the answers, and loads and displays the current page


	initStacks: function(layerName){
		// the Stack ADT is located in stack.js
		this.mainStack = new Stack();
		this.secondStack = new Stack();

		for (var j = layerName.length -1 ; j >= 0; j--){
			this.mainStack.push(new Page(layerName[j])); // push pages onto the main stack
		}
	},
	nextPage: function(){
		this.secondStack.push(this.mainStack.pop());
		this.displayPage();
	},
	previousPage: function(){
		this.mainStack.push(this.secondStack.pop());
		this.displayPage();
	},
	nextButton: function(){
		var elem = document.getElementById("forwardButton");
		if (this.mainStack.size() > 1){
			elem.style.visibility = "visible";
		} else {
			elem.style.visibility = "hidden";
		}
	},
	backButton: function(){
		var elem = document.getElementById("backButton");
		if (! this.secondStack.isEmpty()){
			elem.style.visibility = "visible";
		} else {
			elem.style.visibility = "hidden";
		}
	},
	displayPage: function(){
		this.currentPage = this.mainStack.peek();

		// reset the additional info/answers
		this.currentPage.removeTextAnswer(); 
		this.currentPage.hideImageAnswer();
		this.currentPage.hideOverlay();

		// initialize the page
		this.currentPage.makeTitle();
		this.currentPage.makeMainText();
		this.currentPage.makeButton();
		this.currentPage.showDefaultImage();

		this.nextButton();
		this.backButton();
	}
}





