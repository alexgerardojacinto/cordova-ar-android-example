import Foundation

@objc(OSARAndroidExample)
class OSARAndroidExample: CordovaImplementation {

    var callbackId:String=""

    @objc(coolMethod:)
    func coolMethod(command: CDVInvokedUrlCommand) {
        self.callbackId = command.callbackId
        print("called coolMethod!")
    }

}