package com.yapily.ipisp;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;

import java.util.List;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  String paymentJWT;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    getPaymentJWT(getIntent());
    new MethodChannel(getFlutterView(), "app.channel.yapily.data")
            .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                getPaymentJWT(getIntent());
                if (methodCall.method.contentEquals("getPaymentJWT")) {
                  Log.d("PAYMENTJWT","It is the consent one");
                  result.success(paymentJWT);
                  paymentJWT = null;
                }
              }
            });
  }


  @Override
  protected void onNewIntent(Intent intent) {
    super.onNewIntent(intent);
    getPaymentJWT(intent);
  }


  private void getPaymentJWT(Intent intent) {
    Log.d("PAYMENTJWT","with datastring "+getIntent().getData());
    if(intent.getData()==null) {
      Log.d("PAYMENTJWT","non data submitted");
      return;
    }
    Uri data = intent.getData();

    if(data.toString().contains("?")) {
      String[] datas = data.toString().split("\\?");
      paymentJWT = datas[1].replace("payment=","");
      Log.d("PAYMENTJWT","found "+paymentJWT);
    }
  }

}
