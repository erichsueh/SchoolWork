function setupContainer(id, X, Y)
{
	container = document.getElementById(id);
	ratioX = X;
	ratioY = Y;
	resize();
}
function resize()
{
	container.style.position = "absolute";
	var w = window.innerWidth, h = window.innerHeight;
	// find limiting factor
	var newWidht, newHeight;
	if ((w * ratioY) > (h *ratioX)) // h is limiting
	{
		newHeight = h;
		container.style.height = h + "px";
		container.style.top = "0px";
		newWidht = h * (ratioX / ratioY);
		container.style.width = newWidht + "px";
		container.style.left = ((w - newWidht) / 2) + "px";
	}
	else // w is limiting
	{
		newWidht = w;
		container.style.width = w + "px";
		container.style.left = "0px";
		newHeight = w * 1 / (ratioX / ratioY);
		container.style.height = newHeight + "px";
		container.style.top = ((h - newHeight) / 2) + "px";
	}
	container.style.fontSize = newWidht / 100 + "px";
}
window.onresize = function()
{
	resize();
	
}

function fullScreen()
{
	document.documentElement.webkitRequestFullScreen();
}