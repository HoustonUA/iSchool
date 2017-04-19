//
//  UserService.h
//  iSchool
//
//  Created by Pavlo Ivanov on 4/10/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "TeacherModel.h"
@import Firebase;

@interface UserService : NSObject

- (void)getPupilProfileInfoWithUserId:(NSString *) userId
                            onSuccess:(void(^)(UserModel *userModel)) success;

- (void)getTeacherProfileInfoWithUserId:(NSString *) userId
                              onSuccess:(void(^)(TeacherModel *teacherModel)) success;

- (void)addPupilProfileDetailsWithUserModel:(UserModel *) userModel
                                  andUserId:(NSString *) userId
                                  onSuccess:(void(^)()) success;

- (void)getPersonTypeWithUserId:(NSString *) userId
                      onSuccess:(void(^)(NSString *userType)) success;

- (void)addUserToUsersListWithId:(NSString *) userId
                  withPersonType:(NSString *) personType
                       onSuccess:(void(^)()) success;

- (void)addTeacherProfileDetailsWithUserModel:(TeacherModel *) userModel
                                    andUserId:(NSString *) userId
                                    onSuccess:(void(^)()) success;

@end
