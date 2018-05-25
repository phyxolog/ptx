// getting "show video" buttons
var videoButtons = document.getElementsByClassName("subaction")

// remembering count of button, just in case
var vbLength = videoButtons.length

// creating variable for modal DOM instance
var modal

// page locale; can be (and, probably, should be) fetched from somewhere, e. g. from html lang attribute
var locale = document.documentElement.getAttribute("lang") || "ru"

// setting event listeners
for (var i = 0; i < vbLength; i++) {
	var item = videoButtons[i]
	item.addEventListener("click", showVideoModal.bind(this, item.getAttribute("data-type")))
}

/**
 * Creates and appends video modal to the body
 * @param {string} type a type of video to show
 */
function showVideoModal(type) {
	modal = document.createElement("div")
	modal.setAttribute("class", "pt-video-modal")
	modal.innerHTML = `
		<div class="vm-inner-wrapper">
			<video autoplay controls src="/static/videos/${locale}/_pricing_${type}.mp4" />
		</div>
		<span class="vm-close-button"></span>
	`
	modal.addEventListener("click", hideVideoModal)
	modal.children[0].addEventListener("click", stopPropagation)
	document.body.appendChild(modal)
}

/**
 * Removes modal from DOM and clears it
 */
function hideVideoModal() {
	modal.remove()
	modal = undefined
}

/**
 * Cancels event bubbling (stops event propagation)
 * @param {Event} event event to cancel bubbling
 */
function stopPropagation(event) {
	event.stopPropagation()
}