var exec = require('cordova/exec');

exports.openARView = function (success, error, folderName) {
    exec(success, error, 'ARPlugin', 'openARView', [folderName]);
};
