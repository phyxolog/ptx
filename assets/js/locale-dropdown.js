var dropdown = document.getElementById("localeSelect")

function showLocalesList(event) {
	event.stopPropagation()
	getList().classList.remove("hidden")
}

function hideLocalesList() {
	getList().classList.add("hidden")
}

function getList() {
	return dropdown.querySelector(".ls-list")
}

if (dropdown) {
  dropdown.children[0].addEventListener("click", showLocalesList)
  document.addEventListener("click", hideLocalesList)
}