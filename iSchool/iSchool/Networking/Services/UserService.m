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

- (void)getUserProfileInfoWithUserId:(NSString *) userId
                           onSuccess:(void(^)(UserModel *userModel)) success {
    
    self.ref = [[FIRDatabase database] reference];
    [[[self.ref child:@"users"] child:[NSString stringWithFormat:@"%@", userId]] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        UserModel *userModel = [EKMapper objectFromExternalRepresentation:snapshot.value withMapping:[UserModel objectMapping]];
        success(userModel);
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"ERROR: %@", error);
    }];
    
}

@end
