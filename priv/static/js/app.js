(function() {
  'use strict';

  var globals = typeof global === 'undefined' ? self : global;
  if (typeof globals.require === 'function') return;

  var modules = {};
  var cache = {};
  var aliases = {};
  var has = {}.hasOwnProperty;

  var expRe = /^\.\.?(\/|$)/;
  var expand = function(root, name) {
    var results = [], part;
    var parts = (expRe.test(name) ? root + '/' + name : name).split('/');
    for (var i = 0, length = parts.length; i < length; i++) {
      part = parts[i];
      if (part === '..') {
        results.pop();
      } else if (part !== '.' && part !== '') {
        results.push(part);
      }
    }
    return results.join('/');
  };

  var dirname = function(path) {
    return path.split('/').slice(0, -1).join('/');
  };

  var localRequire = function(path) {
    return function expanded(name) {
      var absolute = expand(dirname(path), name);
      return globals.require(absolute, path);
    };
  };

  var initModule = function(name, definition) {
    var hot = hmr && hmr.createHot(name);
    var module = {id: name, exports: {}, hot: hot};
    cache[name] = module;
    definition(module.exports, localRequire(name), module);
    return module.exports;
  };

  var expandAlias = function(name) {
    return aliases[name] ? expandAlias(aliases[name]) : name;
  };

  var _resolve = function(name, dep) {
    return expandAlias(expand(dirname(name), dep));
  };

  var require = function(name, loaderPath) {
    if (loaderPath == null) loaderPath = '/';
    var path = expandAlias(name);

    if (has.call(cache, path)) return cache[path].exports;
    if (has.call(modules, path)) return initModule(path, modules[path]);

    throw new Error("Cannot find module '" + name + "' from '" + loaderPath + "'");
  };

  require.alias = function(from, to) {
    aliases[to] = from;
  };

  var extRe = /\.[^.\/]+$/;
  var indexRe = /\/index(\.[^\/]+)?$/;
  var addExtensions = function(bundle) {
    if (extRe.test(bundle)) {
      var alias = bundle.replace(extRe, '');
      if (!has.call(aliases, alias) || aliases[alias].replace(extRe, '') === alias + '/index') {
        aliases[alias] = bundle;
      }
    }

    if (indexRe.test(bundle)) {
      var iAlias = bundle.replace(indexRe, '');
      if (!has.call(aliases, iAlias)) {
        aliases[iAlias] = bundle;
      }
    }
  };

  require.register = require.define = function(bundle, fn) {
    if (bundle && typeof bundle === 'object') {
      for (var key in bundle) {
        if (has.call(bundle, key)) {
          require.register(key, bundle[key]);
        }
      }
    } else {
      modules[bundle] = fn;
      delete cache[bundle];
      addExtensions(bundle);
    }
  };

  require.list = function() {
    var list = [];
    for (var item in modules) {
      if (has.call(modules, item)) {
        list.push(item);
      }
    }
    return list;
  };

  var hmr = globals._hmr && new globals._hmr(_resolve, require, modules, cache);
  require._cache = cache;
  require.hmr = hmr && hmr.wrap;
  require.brunch = true;
  globals.require = require;
})();

(function() {
var global = typeof window === 'undefined' ? this : window;
var __makeRelativeRequire = function(require, mappings, pref) {
  var none = {};
  var tryReq = function(name, pref) {
    var val;
    try {
      val = require(pref + '/node_modules/' + name);
      return val;
    } catch (e) {
      if (e.toString().indexOf('Cannot find module') === -1) {
        throw e;
      }

      if (pref.indexOf('node_modules') !== -1) {
        var s = pref.split('/');
        var i = s.lastIndexOf('node_modules');
        var newPref = s.slice(0, i).join('/');
        return tryReq(name, newPref);
      }
    }
    return none;
  };
  return function(name) {
    if (name in mappings) name = mappings[name];
    if (!name) return;
    if (name[0] !== '.' && pref) {
      var val = tryReq(name, pref);
      if (val !== none) return val;
    }
    return require(name);
  }
};
require.register("js/app.js", function(exports, require, module) {
"use strict";

require("./locale-dropdown");

require("./mobile-menu");

require("./switch");

require("./video-modal");

});

require.register("js/locale-dropdown.js", function(exports, require, module) {
"use strict";

var dropdown = document.getElementById("localeSelect");

function showLocalesList(event) {
	event.stopPropagation();
	getList().classList.remove("hidden");
}

function hideLocalesList() {
	getList().classList.add("hidden");
}

function getList() {
	return dropdown.querySelector(".ls-list");
}

if (dropdown) {
	dropdown.children[0].addEventListener("click", showLocalesList);
	document.addEventListener("click", hideLocalesList);
}

});

;require.register("js/mobile-menu.js", function(exports, require, module) {
"use strict";

var mmbutton = document.getElementById("menuButton");
var menuWrapper = document.getElementById("mainMenu");

mmbutton.addEventListener("click", toggleMobileMenu);

function toggleMobileMenu() {
	menuWrapper.classList.toggle("visible");
}

});

;require.register("js/switch.js", function(exports, require, module) {
"use strict";

var _switch = document.getElementById("switch");
var switchValue = true;

function toggleSwitch() {
	if (switchValue) {
		switchValue = false;
		_switch.parentElement.classList.add("monthly");
	} else {
		switchValue = true;
		_switch.parentElement.classList.remove("monthly");
	}
}

if (_switch) {
	_switch.addEventListener("click", toggleSwitch);
}

function click(e) {
	var target = e.target;
	var a = document.createElement("a");
	var plan = target.getAttribute("data-plan") === "trial" ? "trial" : target.getAttribute("data-plan") + "_" + (switchValue ? "year" : "month");
	a.href = "/auth/google?state=" + window.pricingStates[plan];
	a.click();
}

Array.from(document.querySelectorAll(".main-action")).forEach(function (el) {
	return el.addEventListener("click", click);
});

});

require.register("js/video-modal.js", function(exports, require, module) {
"use strict";

// getting "show video" buttons
var videoButtons = document.getElementsByClassName("subaction");

// remembering count of button, just in case
var vbLength = videoButtons.length;

// creating variable for modal DOM instance
var modal;

// page locale; can be (and, probably, should be) fetched from somewhere, e. g. from html lang attribute
var locale = document.documentElement.getAttribute("lang") || "ru";

// setting event listeners
for (var i = 0; i < vbLength; i++) {
	var item = videoButtons[i];
	item.addEventListener("click", showVideoModal.bind(undefined, item.getAttribute("data-type")));
}

/**
 * Creates and appends video modal to the body
 * @param {string} type a type of video to show
 */
function showVideoModal(type) {
	modal = document.createElement("div");
	modal.setAttribute("class", "pt-video-modal");
	modal.innerHTML = "\n\t\t<div class=\"vm-inner-wrapper\">\n\t\t\t<video autoplay controls src=\"/static/videos/" + locale + "/_pricing_" + type + ".mp4\" />\n\t\t</div>\n\t\t<span class=\"vm-close-button\"></span>\n\t";
	modal.addEventListener("click", hideVideoModal);
	modal.children[0].addEventListener("click", stopPropagation);
	document.body.appendChild(modal);
}

/**
 * Removes modal from DOM and clears it
 */
function hideVideoModal() {
	modal.remove();
	modal = undefined;
}

/**
 * Cancels event bubbling (stops event propagation)
 * @param {Event} event event to cancel bubbling
 */
function stopPropagation(event) {
	event.stopPropagation();
}

});

;require.register("___globals___", function(exports, require, module) {
  
});})();require('___globals___');

require('js/app');
//# sourceMappingURL=app.js.map