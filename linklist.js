DomReady.ready(function() {
    addClickHandlers();

    var a = document.getElementsByTagName("audio")[0];
    a.addEventListener("timeupdate", updateLinklist, true);

    var timestamp = document.location.hash.split('#')[1]
    if (typeof timestamp !== typeof undefined) {
        a.addEventListener("loadedmetadata", function(){
            jumpTo(timestamp)
            a.removeEventListener("loadedmetadata")
        }, true)
    }
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
    if (!isNaN(min)) {
        s += min * 60;
    }

    var hr =  parseFloat(t[t.length-3]);
    if (!isNaN(hr)) {
        s += hr * 3600;
    }

    return s;
}

function addClickHandlers() {
    var tableRowElements = collectionToArray(document.getElementsByTagName("tr"));
    for (e in tableRowElements) {
        var timecodeNode = tableRowElements[e].firstChild.firstChild;
        var time = tableRowElements[e].id.substring(2);
        timecodeNode.setAttribute("onclick", "jumpTo('" + time + "')");
    }
}

function updateLinklist() {
    var a = document.getElementsByTagName("audio")[0];
    var highlightDuration = 20;

    var tableRowElements = document.getElementsByTagName("tr");
    var i = tableRowElements.length;
    while (i--) {
        var node = tableRowElements[i];
        var nodeTime = timeToFloat(node.id.substring(2));
        console.log(node, nodeTime);
        if ((a.currentTime > nodeTime) && (a.currentTime < (nodeTime + highlightDuration))) {
            node.setAttribute("class", "highlight");
        }
        else {
            node.removeAttribute("class");
        }
    }
}

function jumpTo(timestamp) {
    var a = document.getElementsByTagName("audio")[0];
    a.currentTime = timeToFloat(timestamp)
}
