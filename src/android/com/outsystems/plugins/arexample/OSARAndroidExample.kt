package com.outsystems.plugins.arexample

import org.apache.cordova.CallbackContext
import org.apache.cordova.CordovaInterface
import org.apache.cordova.CordovaWebView
import org.json.JSONArray

class OSARAndroidExample {

    var callbackContext: CallbackContext? = null

    fun initialize(cordova: CordovaInterface, webView: CordovaWebView) {
        //super.initialize(cordova, webView)
    }

    fun execute(
        action: String,
        args: JSONArray,
        callbackContext: CallbackContext
    ): Boolean {
        this.callbackContext = callbackContext

        when (action) {
            "coolMethod" -> {
                doOpenAR(args)
            }
        }
        return true
    }

    private fun doOpenAR(args: JSONArray) {
        //TODO
    }

}


