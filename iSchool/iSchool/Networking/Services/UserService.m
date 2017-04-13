//
//  UserService.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/10/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "UserService.h"

@interface UserService ()

@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation UserService

- (void)getPupilProfileInfoWithUserId:(NSString *) userId
                            onSuccess:(void(^)(UserModel *userModel)) success {
    
    self.ref = [[FIRDatabase database] reference];
    [[[[self.ref child:@"users"] child:@"pupils"]child:userId] observeSingleEventOfType:FIRDataEventTypeValue
                                                                              withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                                                                                  UserModel *userModel = [EKMapper objectFromExternalRepresentation:snapshot.value withMapping:[UserModel objectMapping]];
                                                                                  success(userModel);
                                                                              }
                                                                        withCancelBlock:^(NSError * _Nonnull error) {
                                                                            NSLog(@"ERROR: %@", error);
                                                                        }];
    
}

- (void)getTeacherProfileInfoWithUserId:(NSString *) userId
                              onSuccess:(void(^)(TeacherModel *teacherModel)) success {
    
    self.ref = [[FIRDatabase database] reference];
    [[[[self.ref child:@"users"] child:@"teachers"]child:userId] observeSingleEventOfType:FIRDataEventTypeValue
                                                                                withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                                                                                    TeacherModel *teacherModel = [EKMapper objectFromExternalRepresentation:snapshot.value withMapping:[TeacherModel objectMapping]];
                                                                                    success(teacherModel);
                                                                                }
                                                                          withCancelBlock:^(NSError * _Nonnull error) {
                                                                              NSLog(@"ERROR: %@", error);
                                                                          }];
}

- (void)addPupilProfileDetailsWithUserModel:(UserModel *) userModel
                                  andUserId:(NSString *) userId
                                  onSuccess:(void(^)()) success {
    
    self.ref = [[FIRDatabase database] reference];
    
    [[[[self.ref child:@"users"] child:@"pupils"] child:userId]
     setValue:@{
                @"name"  :   userModel.name,
                @"surname"   :   userModel.surname,
                @"middlename"   :   userModel.middlename,
                @"birthday"     :   userModel.birthday,
                @"classId"      :   userModel.classId,
                @"parentOne"    :   userModel.parentOne,
                @"parentsPhone" :   userModel.parentsPhone,
                @"phone"        :   userModel.phone
                }];
    success();
}

@end
