DomReady.ready(function() {
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
    if (!isNaN(min)) {
        s += min * 60;
    }

    var hr =  parseFloat(t[t.length-3]);
    if (!isNaN(hr)) {
        s += hr * 3600;
    }

    return s;
}

function updateLinklist() {
    var a = document.getElementsByTagName("audio")[0];
    var highlightDuration = 20;

    var tableRowElements = document.getElementsByTagName("tr");
    var i = tableRowElements.length;
    while (i--) {
        var node = tableRowElements[i];
        var mediafragment = node.firstChild.firstChild.href.split('#')[1].split('&')[1];
        var time = timeToFloat(mediafragment.substring(2));
        if ((a.currentTime > time) && (a.currentTime < (time + highlightDuration))) {
            node.setAttribute("class", "highlight");
        }
        else {
            node.removeAttribute("class");
        }
    }
}
