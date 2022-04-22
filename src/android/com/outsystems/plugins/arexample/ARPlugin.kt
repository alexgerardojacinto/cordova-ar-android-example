package com.outsystems.plugins.arexample

import android.content.Intent
import com.google.ar.core.examples.java.helloar.ArTradeActivity
import org.apache.cordova.CallbackContext
import org.apache.cordova.CordovaInterface
import org.apache.cordova.CordovaWebView
import org.json.JSONArray

class ARPlugin: CordovaImplementation(){

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
            "openARView" -> {
                doOpenAR(args)
            }
        }
        return true
    }

    private fun doOpenAR(args: JSONArray) {
        //TODO

        val intent = Intent(cordova.activity, ArTradeActivity::class.java)

        val objToShow = args.getString(0)

        if(objToShow == "beer"){
            intent.putExtra("obj_path", "www/beer/beer.obj")
            intent.putExtra("texture_path", "www/beer/beer.png")
            cordova.activity.startActivityForResult(intent, 1)
        }
        else if(objToShow == "chair"){
            intent.putExtra("obj_path", "www/chair/chair.obj")
            intent.putExtra("texture_path", "www/chair/chair.png")
            cordova.activity.startActivityForResult(intent, 1)
        }
        else{//do nothing
            return
        }
    }

}


