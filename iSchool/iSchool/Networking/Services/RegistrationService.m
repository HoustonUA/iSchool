//
//  RegistrationService.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/19/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "RegistrationService.h"
@import Firebase;

@interface RegistrationService ()

@property (strong, nonatomic) FIRDatabaseReference *databaseReference;

@end

@implementation RegistrationService

- (void)getUserTypeWithActivationKey:(NSString *) key
                           onSuccess:(void(^)(NSString *userType)) success {
    
    self.databaseReference = [[FIRDatabase database] reference];
    
    [[[self.databaseReference child:@"activationKeys"] child:key] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if(![snapshot.value isEqual:[NSNull null]]) {
            success(snapshot.value);
        } else {
            success(@"Error in regis");
        }
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"ERROR!!!: %@", error);
    }];
}

@end
