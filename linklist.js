DomReady.ready(function() {
    addClickHandlers();

    var a = document.getElementsByTagName("audio")[0];
    a.addEventListener("timeupdate", updateLinklist, true);
});

function collectionToArray(collection) {
    var array = [];
    var i = collection.length;
    while (i--) {
        array.push(collection[i]);
    }
    return array;
}

function timeToFloat(timeString) {
    var t = timeString.split(":");
    var s = 0;

    var sec = parseFloat(t[t.length-1]);
    if (!isNaN(sec)) {
        s += sec;
    } else {
        s = Number.NaN;
    }

    var min = parseFloat(t[t.length-2]);
    if (!isNaN(min)) { s += min * 60; }

    return s;
}

function addClickHandlers() {
    var listElements = collectionToArray(document.getElementsByTagName("li"));
    for (e in listElements) {
        var timecodeNode = listElements[e].firstChild.nextSibling;
        var timeOffset = timeToFloat(listElements[e].id);
        timecodeNode.setAttribute("onclick", "jumpTo(" + timeOffset + ")");
    }
}

function updateLinklist() {
    var a = document.getElementsByTagName("audio")[0];
    var highlightDuration = 20;

    var listElements = document.getElementsByTagName("li");
    var i = listElements.length;
    while (i--) {
        var node = listElements[i];
        var nodeTime = timeToFloat(node.id);
        if ((a.currentTime > nodeTime) && (a.currentTime < (nodeTime + highlightDuration))) {
            node.setAttribute("class", "highlight");
        }
        else {
            node.removeAttribute("class");
        }
    }
}

function jumpTo(timeOffset) {
    var a = document.getElementsByTagName("audio")[0];
    a.currentTime = timeOffset
}
