var system = require('system');
var page = require('webpage').create();

if (system.args.length !== 2) {
    console.log('Usage: phantomjs shoot-page.js example.com:80');
    phantom.exit();
} else {
    var target = system.args[1].split(":")[0]
    var port = system.args[1].split(":")[1];
    var port = port? port : 80;
    var filename = target + ':' + port + '.png';

    switch (port) {
        case '80':
        case '8000':
        case '8080':
            protocol = 'http://';
            break;
        case '443':
        case '8443':
            protocol = 'https://';
            break;
    }
    var url = protocol + target + ":" + port;

    page.open(url, function(status) {
        if (status !== 'success') {
            console.log("Failed to capture: " + url);
        } else {
            page.render(filename);
            console.log('Captured: ' + url);
        }
        phantom.exit();
    });
}
