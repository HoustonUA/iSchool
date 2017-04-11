//
//  SubjectsService.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/9/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "SubjectsService.h"

@interface SubjectsService ()

@property (strong, nonatomic) FIRDatabaseReference *databaseReference;

@end

@implementation SubjectsService

- (void)getAllSubjectsOnSuccess:(void (^)(NSDictionary *))success {
    self.databaseReference = [[FIRDatabase database] reference];
    [[self.databaseReference child:@"subjects"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *response = snapshot.value;
        success(response);
    }];
}

- (void)getSubjectsWithKeys:(NSArray *) subjectsKeys
                  onSuccess:(void(^)(NSArray *subjects)) success {
    self.databaseReference = [[FIRDatabase database] reference];
    
    [[self.databaseReference child:@"subjects"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray *subjects = [NSMutableArray array];
        for (NSString *subjectKey in subjectsKeys) {
            NSString *subjectName = [snapshot.value valueForKey:subjectKey];
            [subjects addObject:subjectName];
        }
        success(subjects);
    } withCancelBlock:^(NSError * _Nonnull error) {
        
    }];
}

@end
