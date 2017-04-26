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

static NSString *const twilioSID = @"AC676985c948d6aa025b8d2548d6be9e95";
static NSString *const twilioSecret = @"d32478f4030249ac7d99d26f4923a52c";

@implementation SendSMSService

- (void)sendSMSToParentWithPhoneNumber:(NSString *) number
                       isChildInSchool:(BOOL) isInSchool
                       onSuccess:(void(^)()) success {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/xml"];
    
    [manager.requestSerializer setValue:@"accountSid" forHTTPHeaderField:twilioSID];
    [manager.requestSerializer setValue:@"authToken" forHTTPHeaderField:twilioSecret];
    
    NSString *fromNumber = @"+13343848524";
    NSString *toNumber = @"+380931486130";//number;
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
//    NSDictionary *param = @{
//                            @"username" :   @"HoustonUA",
//                            @"password" :   @"151250197",
//                            @"message"  :   @"Ho+Pasha",
//                            @"msisdn"   :   @"380931925967"
//                            };
    
    //NSString *urlString = [NSString stringWithFormat:@"https://bulksms.vsms.net/eapi/submission/send_sms/2/2.0"];
    
    [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error in SMS:%@", error);
    }];
}

- (void)addNewOutgoingCallerIDWithNumber:(NSString *) number
                               onSuccess:(void(^)()) success {

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/xml"];
    
    NSString *urlstring = [NSString stringWithFormat:@"https://%@:%@@api.twilio.com/2010-04-01/Accounts/%@/OutgoingCallerIds", twilioSID, twilioSecret, twilioSID];

    NSString *userNumber = @"+380931486130";//number;
    
    NSDictionary *params = @{
                             @"PhoneNumber" :   userNumber
                             };
 
    [manager POST:urlstring parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"OKEY: %@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"ERROR ADD: %@",  [error.userInfo valueForKey:@"com.alamofire.serialization.response.error.data"]);
        NSData *errorData = [NSData dataWithData:[error.userInfo valueForKey:@"com.alamofire.serialization.response.error.data"]];
        NSString *dataString = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
        NSLog(@"ERROR: %@", dataString);
    }];
}

@end
