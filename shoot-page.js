var system = require('system');
var page = require('webpage').create();

if (system.args.length === 1) {
    console.log('Usage: phantomjs shoot-page.js http://example.com');
} else {
    var target = system.args[1]
    var filename = system.args[1] + '.png'
    console.log('Capturing: ' + target);
    page.open("http://" + target, function() {
        page.render(filename);
        phantom.exit();
    });
}
