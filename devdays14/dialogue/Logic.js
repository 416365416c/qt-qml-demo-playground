.pragma library

var story = null //Do we really need this ref?
var initialised = false

function init(what) {
    if (!initialised) {
        story = what
        initialised = true
    }
}
