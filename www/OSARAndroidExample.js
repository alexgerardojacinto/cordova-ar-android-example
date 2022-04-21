var exec = require('cordova/exec');

exports.coolMethod = function (success, error, object) {
    exec(success, error, 'OSARAndroidExample', 'coolMethod', [object]);
};