//
//  UserService.h
//  iSchool
//
//  Created by Pavlo Ivanov on 4/10/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
@import Firebase;

@interface UserService : NSObject

- (void)getUserProfileInfoWithUserId:(NSString *) userId
                           onSuccess:(void(^)(UserModel *userModel)) success;

@end
