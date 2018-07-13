package com.datami.smisdk_plugin;

import android.content.Context;
import android.util.Log;

import com.datami.smi.Analytics;
import com.datami.smi.SdStateChangeListener;
import com.datami.smi.SmiResult;
import com.datami.smi.SmiSdk;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.util.ArrayList;
import java.util.List;

public class SmiSdkReactModule extends ReactContextBaseJavaModule implements SdStateChangeListener {

    private Context mContext;
    private String TAG = "SmiSdkReactModule";
    private ReactApplicationContext mReactContext;

    public SmiSdkReactModule(ReactApplicationContext reactContext) {
        super(reactContext);
        mContext = reactContext;
        mReactContext = reactContext;
    }

    @Override
    public String getName() {
        return "SmiSdkReactModule";
    }

    @ReactMethod
    public void initSponsoredData(String sdkKey, String userId, boolean showNotification, boolean showMessaging,
                                  ReadableArray exclusionList, ReadableArray userTags){
        Log.d(TAG, "initSponsoredData()");
        int iconId = -1;
        if(showNotification)
        {
            Log.d(TAG, "setting icon id");
            iconId = mContext.getApplicationInfo().icon;

        }

        List<String> exclusionListJava = null;

        if( (exclusionList!=null) && (exclusionList.size()>0))
        {
            exclusionListJava = new ArrayList<String>();
            Log.i(TAG, "exclusion list length: "+exclusionList.size());
            for(int i=0; i<exclusionList.size(); i++)
            {
                Log.i(TAG, "exclusion doman: "+exclusionList.getString(i));
                exclusionListJava.add(exclusionList.getString(i));
            }
        }
        else
        {
            Log.i(TAG, "exclusionList not available.");
        }

        List<String> userTagsListJava = null;

        if( (userTags!=null) && (userTags.size()>0))
        {
            userTagsListJava = new ArrayList<String>();
            Log.i(TAG, "userTags list length: "+userTags.size());
            for(int i=0; i<userTags.size(); i++)
            {
                Log.i(TAG, "userTag: "+userTags.getString(i));
                userTagsListJava.add(userTags.getString(i));
            }
        }
        else
        {
            Log.i(TAG, "user Tags not available.");
        }
        Log.d(TAG, "icon id: " + iconId + ", showMessaging: " + showMessaging);
        SmiSdk.initSponsoredData(sdkKey, mReactContext, userId, iconId, showMessaging, exclusionListJava, userTagsListJava);
        SmiSdk.addSdStateChangeListener(this);
    }

    @Override
    public void onChange(SmiResult smiResult) {
        Log.d(TAG, "onChange:: " + smiResult.getSdState().name());
        // Create map for params
        WritableMap payload = Arguments.createMap();
        // Put data to map
        payload.putString("sd_state", smiResult.getSdState().name());
        payload.putString("sd_reason", smiResult.getSdReason().name());
        payload.putString("carrier_name", smiResult.getCarrierName());
        payload.putString("client_ip", smiResult.getClientIp());

        // Get EventEmitter from context and send event thanks to it
        mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit("onSdStateChange", payload);
        Log.d(TAG, "onChange --");
    }

    @ReactMethod
    public void getSDAuth(String sdkKey, String url, String userId, Callback smiResultCB){
        Log.d(TAG, "getSDAuth()");
        try {
            SmiResult result = SmiSdk.getSDAuth(sdkKey, mContext, url, userId);
            if(smiResultCB!=null){
                Log.d(TAG, "smiResultCB not null");
                String state = "sd_state: " + result.getSdState().name();
                String reason = "sd_reason: " + result.getSdReason().name();
                String carrier = "carrier_name: " + result.getCarrierName();
                String clientIp = "client_ip: " + result.getClientIp();
                String sdUrl = "url: " + result.getUrl();
                smiResultCB.invoke(state, reason, carrier, clientIp, sdUrl);
            }
        } catch (Exception e) {
            Log.e(TAG, "Exception: ", e);
        }
    }

    @ReactMethod
    public void getAnalytics(Callback smiAnalyticsCB)
    {
        if(mContext==null){
            Log.i(TAG, "Null app context");
            return;
        }
        Analytics smiAnalytics = SmiSdk.getAnalytics();
        if(smiAnalyticsCB!=null){
            String cst = "cellular_session_time: " + smiAnalytics.getCellularSessionTime();
            String dataUsage = "sd_data_usage: " + smiAnalytics.getSdDataUsage();
            String wst = "wifi_session_time: " + smiAnalytics.getWifiSessionTime();
            smiAnalyticsCB.invoke(cst, dataUsage, wst);
        }
    }

    @ReactMethod
    public void updateUserId(String id)
    {
        SmiSdk.updateUserId(id);
    }

    @ReactMethod
    public void updateUserTag(ReadableArray userTags)
    {
        List<String> userTagsJava = null;
        if( (userTags!=null) && (userTags.size()>0))
        {
            userTagsJava = new ArrayList<String>();
            Log.d(TAG, "userTags length: "+userTags.size());
            for(int i=0; i<userTags.size(); i++)
            {
                userTagsJava.add(userTags.getString(i));
            }
            SmiSdk.updateUserTag(userTagsJava);
        }
        else
        {
            Log.d(TAG, "userTags not available.");
        }
    }
}
