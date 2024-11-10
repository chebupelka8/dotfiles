<h4>forEach for NodeList</h4>
```javascript
// В современных браузерах метод forEach реализован для NodeList.prototype
// но в Internet Explorer (IE) такого нет

if (!NodeList.prototype.forEach) {
	NodeList.prototype.forEach = function(callback, thisArg) {
		thisArg = thisArg || window;
		
		for (let i = 0; i < this.length; i++) {
			callback.call(thisArg, this[i], i, this);
		}
	}
}

// тепер можно использовать это так
document.querySelectorAll("label").forEach(function(entry) {
	console.log(entry);
});
```