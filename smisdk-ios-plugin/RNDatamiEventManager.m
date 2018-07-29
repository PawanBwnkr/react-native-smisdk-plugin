//
//  RNDatamiEventManager.m
//  RNDatamiSdk
//
//  Created by Sonali Sagar on 30/07/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "RNDatamiEventManager.h"
#import "SmiSdk.h"

@implementation RNDatamiEventManager

RCT_EXPORT_MODULE()

-(id)init {
  if(self = [super init]){
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SDSTATE_CHANGE_NOTIF
                                               object:nil];
  }

  return self;
}

-(NSArray<NSString *> *)supportedEvents
{
        return @[@"DATAMI_EVENT"];
}

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

@end
