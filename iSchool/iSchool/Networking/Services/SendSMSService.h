//
//  SendSMSService.h
//  iSchool
//
//  Created by Pavlo Ivanov on 4/25/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendSMSService : NSObject

- (void)sendSMSToParentWithPhoneNumber:(NSString *) number
                       isChildInSchool:(BOOL) isInSchool
                             onSuccess:(void(^)()) success;

@end
