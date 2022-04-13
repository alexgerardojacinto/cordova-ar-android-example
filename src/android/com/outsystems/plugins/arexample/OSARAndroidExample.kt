package com.outsystems.plugins.arexample

import android.content.Intent
import com.google.ar.core.examples.java.helloar.ArTradeActivity
import org.apache.cordova.CallbackContext
import org.apache.cordova.CordovaInterface
import org.apache.cordova.CordovaWebView
import org.json.JSONArray

class OSARAndroidExample : CordovaImplementation(){

    override var callbackContext: CallbackContext? = null

    override fun initialize(cordova: CordovaInterface, webView: CordovaWebView) {
        super.initialize(cordova, webView)
    }

    override fun areGooglePlayServicesAvailable(): Boolean {
        TODO("Not yet implemented")
    }

    override fun execute(
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

        val intent = Intent(cordova.activity, ArTradeActivity::class.java)

        cordova.activity.startActivityForResult(intent, 1)

    }

}


