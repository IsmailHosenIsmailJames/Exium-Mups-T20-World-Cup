var element = document.querySelector('.Fh5muf');
if (element) {
    element.style.display = 'none';
}
var element = document.querySelector('.s2gQvd');
if (element) {
    element.style.display = 'none';
}
var listElement = document.querySelectorAll('.MjjYud');
for (let i = 1; i < listElement.length; i++) {
    listElement[i].style.display = 'none';
}
var keys = { 37: 1, 38: 1, 39: 1, 40: 1 };

function preventDefault(e) {
    e.preventDefault();
}

function preventDefaultForScrollKeys(e) {
    if (keys[e.keyCode]) {
        preventDefault(e);
        return false;
    }
}

// modern Chrome requires { passive: false } when adding event
var supportsPassive = false;
try {
    window.addEventListener("test", null, Object.defineProperty({}, 'passive', {
        get: function () { supportsPassive = true; }
    }));
} catch (e) { }

var wheelOpt = supportsPassive ? { passive: false } : false;
var wheelEvent = 'onwheel' in document.createElement('div') ? 'wheel' : 'mousewheel';

window.addEventListener('DOMMouseScroll', preventDefault, false); // older FF
window.addEventListener(wheelEvent, preventDefault, wheelOpt); // modern desktop
window.addEventListener('touchmove', preventDefault, wheelOpt); // mobile
window.addEventListener('keydown', preventDefaultForScrollKeys, false);

