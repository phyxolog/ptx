var mmbutton = document.getElementById("menuButton")
var menuWrapper = document.getElementById("mainMenu")

mmbutton.addEventListener("click", toggleMobileMenu)

function toggleMobileMenu() {
	menuWrapper.classList.toggle("visible")
}