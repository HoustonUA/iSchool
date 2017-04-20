//
//  RegistrationService.h
//  iSchool
//
//  Created by Pavlo Ivanov on 4/19/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegistrationService : NSObject

- (void)getUserTypeWithActivationKey:(NSString *) key
                           onSuccess:(void(^)(NSString *userType)) success;

@end
