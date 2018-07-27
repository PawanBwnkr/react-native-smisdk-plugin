
#import "RNSmisdkIosPlugin.h"

@implementation RNSmisdkIosPlugin

//- (dispatch_queue_t)methodQueue
//{
//    return dispatch_get_main_queue();
//}
RCT_EXPORT_MODULE()

-(NSArray<NSString *> *)supportedEvents
{
    return @[@"DATAMI_EVENT"];
}

RCT_EXPORT_METHOD(squareMe:(NSString *)number:(RCTResponseSenderBlock)callback) {
    int num = [number intValue];
    callback(@[[NSNull null], [NSNumber numberWithInt:(num*num)]]);
}



//RCT_EXPORT_METHOD(initSponsoredData)
//{
//  [SmiSdk initSponsoredData:@"dmi-dev-sdk-build-7b29616f0c08ec653263f3979424986b419e738f" userId:nil showSDMessage:YES];
//  [[NSNotificationCenter defaultCenter] addObserver:self
//                                           selector:@selector(handleNotification:)
//                                               name:SDSTATE_CHANGE_NOTIF
//                                             object:nil];
//}

- (void)handleNotification:(NSNotification *)notif {
    if([notif.name isEqualToString:SDSTATE_CHANGE_NOTIF])
    {
        SmiResult* sr =  notif.object;
        NSLog(@"receivedStateChage, sdState: %ld", (long)sr.sdState);
        [self sendEventWithName:@"DATAMI_EVENT" body:@{@"state": [NSNumber numberWithInteger:sr.sdState]}];
    }
    else
    {
        NSLog(@"Not a datami event");
        
    }
}

RCT_EXPORT_METHOD(getSDURL:(NSString *)url:(RCTResponseSenderBlock)callback) {
    NSString* apiKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"DATAMI_API_KEY"];
    if([apiKey length]) {
        SmiResult *sr = [SmiSdk getSDAuth:apiKey url:url userId:nil];
        NSLog(@"sr.url:%@ sr.state:%ld",sr.url,(long)sr.sdState);
        callback(@[sr.url, [NSNumber numberWithInt:sr.sdState], [NSNumber numberWithInt:sr.sdReason]]);
    }
    else{
        callback(@[[NSNull null], [NSNull null], [NSNull null]]);
    }
}

RCT_EXPORT_METHOD(getAnalytics:(RCTResponseSenderBlock)callback) {
    SmiAnalytics *analytics = [SmiSdk getAnalytics];
    NSTimeInterval wifiTm = analytics.fgWifiSessionTime;
    NSTimeInterval cellTm = analytics.fgCellularSessionTime;
    int64_t sdUsage = analytics.sdDataUsage;
    NSLog(@"Analytics:%f %f %lld",wifiTm,cellTm,sdUsage);
    callback(@[[NSNumber numberWithDouble:wifiTm],[NSNumber numberWithDouble:cellTm],[NSNumber numberWithLongLong:sdUsage]]);
    
}

RCT_EXPORT_METHOD(startSponsoredData) {
    [SmiSdk startSponsorData];
}

RCT_EXPORT_METHOD(stopSponsoredData) {
    [SmiSdk stopSponsorData];
}

RCT_EXPORT_METHOD(registerAppConfiguration:(NSURLSessionConfiguration*) aConfig) {
    [SmiSdk registerAppConfiguration:aConfig];
}

RCT_EXPORT_METHOD(updateUserId:(NSString*)userId) {
    [SmiSdk updateUserId:userId];
}

RCT_EXPORT_METHOD(updateTags:(NSArray *)tags) {
    [SmiSdk updateTag:tags];
}



@end
  
