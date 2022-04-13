import Foundation

@objc(OSARAndroidExample)
class OSARAndroidExample: CordovaImplementation {

    @objc(coolMethod:)
    func coolMethod(command: CDVInvokedUrlCommand) {
        self.callbackId = command.callbackId
        print("called coolMethod!")
    }

}