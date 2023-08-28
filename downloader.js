/* Paste this into your browser's JS console and wait for download. */

window.devicePixelRatio = 3; // Make Google deliver highres pictures

let downloadName = document.querySelector('meta[property="og:title"]').content;
let imgPayload = "";

function generateImgPayload (){
	let imgTags = document.getElementsByTagName("img");
	let checkURLString = "blob:https://drive.google.com/";
	let validImgTagCounter = 0;

	for (i = 0; i < imgTags.length; i++) {
		if (imgTags[i].src.substring(0, checkURLString.length) === checkURLString){
			validImgTagCounter++;
			console.log('imgTagSrc:' + imgTags[i].src);
			let img = imgTags[i];
			let canvas = document.createElement('canvas');
			let context = canvas.getContext("2d");

			canvas.width = img.naturalWidth;
			canvas.height = img.naturalHeight;
			//console.log("Width: " + img.naturalWidth + ", Height: " + img.naturalHeight);
			context.drawImage(img, 0, 0, img.naturalWidth, img.naturalHeight);
			//let imgDataURL = canvas.toDataURL(); // Uses default file type
			let imgDataURL = canvas.toDataURL('image/jpeg', 0.9); // Converts to JPEG

			if (imgPayload === "") {
				imgPayload = imgDataURL;
			} else {
				imgPayload = imgPayload + "\n" + imgDataURL;
			}
		}
	}

	let anchorElement = document.createElement("a");
	let file = new Blob([imgPayload], {type: 'text/plain'});

	url = URL.createObjectURL(file);
	anchorElement.href = url;
	anchorElement.download = downloadName.replace('.pdf', '')+'.imgpack';
	document.body.appendChild(anchorElement);
	anchorElement.click();
}

function getRandomInt(min, max) {
	return Math.floor(Math.random() * (max - min) + min);
}

let allElements = document.querySelectorAll("*");
let chosenElement;
let heightOfScrollableElement = 0;

for (i = 0; i < allElements.length; i++) {
	if ( allElements[i].scrollHeight>=allElements[i].clientHeight){
		if (heightOfScrollableElement < allElements[i].scrollHeight){
			//console.log(allElements[i]);
			//console.log(allElements[i].scrollHeight);
			heightOfScrollableElement = allElements[i].scrollHeight;
			chosenElement = allElements[i];
		}
	}
}

if (chosenElement.scrollHeight > chosenElement.clientHeight) {
	console.log("Auto Scroll");

	let scrollDistance = Math.round(chosenElement.clientHeight/2);
	//console.log("scrollHeight: " + chosenElement.scrollHeight);
	//console.log("scrollDistance: " + scrollDistance);

	let loopCounter = 0;
	function scrollLoop(remainingHeightToScroll, scrollToLocation) {
		loopCounter++;
		console.log(loopCounter);

		setTimeout(function() {
			if (remainingHeightToScroll === 0){
				scrollToLocation = scrollDistance;
				chosenElement.scrollTo(0, scrollToLocation);
				remainingHeightToScroll = chosenElement.scrollHeight - scrollDistance;
			} else {
				scrollToLocation = scrollToLocation + scrollDistance ;
				chosenElement.scrollTo(0, scrollToLocation);
				remainingHeightToScroll = remainingHeightToScroll - scrollDistance;
			}

			if (remainingHeightToScroll >= chosenElement.clientHeight){
				scrollLoop(remainingHeightToScroll, scrollToLocation)
			} else {
				setTimeout(function() {
					generateImgPayload();
				}, 1500);
			}

		}, getRandomInt(300,500) );
	}
	scrollLoop(0, 0);

} else {
	console.log("… done. Creating download.");
	setTimeout(function() {
		generateImgPayload();
	}, 1500);
}
