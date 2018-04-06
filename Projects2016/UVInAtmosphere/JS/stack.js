Stack = function(){
	this.itemsList = [];
}
Stack.prototype = 
{
	isEmpty: function(){
		return ! this.itemsList.length > 0;
	},
	push: function(item){
		this.itemsList.push(item);
	},
	pop: function(){
		return this.itemsList.pop();
	},
	peek: function(){
		return this.itemsList[this.itemsList.length - 1];
	},
	size: function(){
		return this.itemsList.length;
	}
}

// myStack = new Stack();
// console.log(myStack.isEmpty());
// myStack.push(14);
// myStack.push(32);
// myStack.push(17);
// console.log(myStack.isEmpty());
// console.log(myStack.size());
// console.log(myStack.peek());
// console.log(myStack.size());
// console.log(myStack.pop());
// myStack.pop();
// console.log(myStack.size());
// console.log(myStack.peek());
// console.log(myStack.pop());
// console.log(myStack.pop());
// console.log(myStack.size());
// console.log(myStack.isEmpty());
