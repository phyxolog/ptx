var _switch = document.getElementById("switch")
var switchValue = true

function toggleSwitch() {
	if (switchValue) {
		switchValue = false
		_switch.parentElement.classList.add("monthly")
	} else {
		switchValue = true
		_switch.parentElement.classList.remove("monthly")
	}
}

if (_switch) {
  _switch.addEventListener("click", toggleSwitch)
}

function click(e) {
  var target = e.target;
  var a = document.createElement("a");
  var plan = target.getAttribute("data-plan") === "trial" ? "trial" : target.getAttribute("data-plan") + "_" + (switchValue ? "year" : "month");
  a.href = "/auth/google?state=" + window.pricingStates[plan];
  document.body.appendChild(a);
  a.click();
  a.remove();
}

Array.from(document.querySelectorAll(".main-action")).forEach(el => el.addEventListener("click", click));