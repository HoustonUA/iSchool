//
//  ScheduleService.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/11/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "ScheduleService.h"
@import Firebase;

@interface ScheduleService ()

@property (strong, nonatomic) FIRDatabaseReference *databaseReference;

@end

@implementation ScheduleService

- (void)getPupilScheduleWithClassIs:(NSString *) classId
                          onSuccess:(void(^)(NSDictionary *schedule)) success {
    
    self.databaseReference = [[FIRDatabase database] reference];
    [[[[self.databaseReference child:@"classes"] child:classId] child:@"schedule"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        success(snapshot.value);
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

@end
