//
//  SendSMSService.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/25/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "SendSMSService.h"
#import "NetworkManager.h"
#import "AFNetworking.h"

@implementation SendSMSService

- (void)sendSMSToParentWithPhoneNumber:(NSString *) number
                       isChildInSchool:(BOOL) isInSchool
                       onSuccess:(void(^)()) success {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/xml"];
    
    NSString *twilioSID = @"AC676985c948d6aa025b8d2548d6be9e95";
    NSString *twilioSecret = @"d32478f4030249ac7d99d26f4923a52c";
    NSString *fromNumber = @"+13343848524";
    NSString *toNumber = @"+380673128998";//number;
    NSString *message;
    
    isInSchool = YES;//TEMP
    if(isInSchool) {
        message = @"Your child is in school";
    } else {
        message = @"Your child left school";
    }
    
    NSDictionary *params = @{
                             @"From"    :   fromNumber,
                             @"To"      :   toNumber,
                             @"Body"    :   message
                             };
    
    NSString *urlString = [NSString
                           stringWithFormat:@"https://%@:%@@api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages/",
                           twilioSID, twilioSecret, twilioSID];
    
    [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error in SMS:%@", error);
    }];
}

@end
