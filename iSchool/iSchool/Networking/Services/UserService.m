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
    [[[[self.ref child:@"users"] child:@"teachers"] child:userId] observeSingleEventOfType:FIRDataEventTypeValue
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
                @"name"         :   userModel.name,
                @"surname"      :   userModel.surname,
                @"middlename"   :   userModel.middlename,
                @"birthday"     :   userModel.birthday,
                @"classId"      :   userModel.classId,
                @"parentOne"    :   userModel.parentOne,
                @"parentsPhone" :   userModel.parentsPhone,
                @"phone"        :   userModel.phone
                }];
    success();
}

- (void)getPersonTypeWithUserId:(NSString *) userId
                      onSuccess:(void(^)(NSString *userType)) success {
    
    self.ref = [[FIRDatabase database] reference];
    
    [[[self.ref child:@"usersList"] child:userId] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        success(snapshot.value);
    }];
}

- (void)addUserToUsersListWithId:(NSString *) userId
                  withPersonType:(NSString *) personType
                       onSuccess:(void(^)()) success {
    
    self.ref = [[FIRDatabase database] reference];
    
    [[[self.ref child:@"usersList"] child:userId] setValue:personType];
}

- (void)addTeacherProfileDetailsWithUserModel:(TeacherModel *) userModel
                                    andUserId:(NSString *) userId
                                    onSuccess:(void(^)()) success {
    
    self.ref = [[FIRDatabase database] reference];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                   initWithDictionary:@{
                                                        @"name"             :   userModel.name,
                                                        @"surname"          :   userModel.surname,
                                                        @"middlename"       :   userModel.middlename,
                                                        @"birthday"         :   userModel.birthday,
                                                        @"subjects"         :   userModel.subjects,
                                                        @"isClassTeacher"   :   [NSNumber numberWithBool:userModel.isClassTeacher],
                                                        @"phone"            :   userModel.phone
                                                        }];
    
    if(userModel.classId) {
        [params setObject:userModel.classId forKey:@"classId"];
    } else {
        [params setObject:@"No class" forKey:@"classId"];
    }
    
    [[[[self.ref child:@"users"] child:@"teachers"] child:userId]
     setValue:params];
    if(success) {
        success();
    }
}

- (void)getParentPasswordOfPupilWithUserId:(NSString *) userId
                                 onSuccess:(void(^)(NSString *password)) success {
    
    self.ref = [[FIRDatabase database] reference];
    [[[[[self.ref child:@"users"] child:@"pupils"] child:userId] child:@"parentPassword"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        success(snapshot.value);
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
