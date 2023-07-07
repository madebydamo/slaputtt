function myRequire( url ) {
    var ajax = new XMLHttpRequest();
    ajax.open( 'GET', url, false ); // <-- the 'false' makes it synchronous
    ajax.onreadystatechange = function () {
        var script = ajax.response || ajax.responseText;
        if (ajax.readyState === 4) {
            switch( ajax.status) {
                case 200:
                    eval.apply(self, [script] );
                    console.log("script loaded: ", url);
                    break;
                default:
                    console.log("ERROR: script not loaded: ", url);
            }
        }
    };
    ajax.send(null);
}

function getMyGlobalScope() {
    return self;
}

console.log("Worker started");
myRequire("BackgroundGameSimulator.dart.js");
if(typeof require === "function") {
    console.log("no release");
    require(['BackgroundGameSimulator.dart.bootstrap']);
}