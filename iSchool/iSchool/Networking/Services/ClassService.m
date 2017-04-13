//
//  ClassService.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/10/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "ClassService.h"
#import "MarkModel.h"
@import Firebase;

@interface ClassService ()

@property (strong, nonatomic) FIRDatabaseReference *databaseReference;

@end

@implementation ClassService

- (void)getMarkForUser:(NSString *) userId
             fromClass:(NSString *) classId
            forSubject:(NSString *) subjectId
             onSuccess:(void(^)(NSMutableArray *markModel)) success {
    
    self.databaseReference = [[FIRDatabase database] reference];
    
    [[[[[[self.databaseReference child:@"classes"] child:classId] child:@"journal"] child:userId] child:subjectId] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if(snapshot.value != [NSNull null]) {
            NSMutableArray *marks = [NSMutableArray array];
            for (NSDictionary *item in snapshot.value) {
                MarkModel *markModel = [EKMapper objectFromExternalRepresentation:item withMapping:[MarkModel objectMapping]];
                [marks addObject:markModel];
            }
            success(marks);
        }
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"sakdlkajsd;");
    }];
}

- (void)getHomeworkForSubject:(NSString *) subjectId
                     forClass:(NSString *) classId
                    onSuccess:(void(^)(NSString *teacherName, NSString *homework)) success {
    
    self.databaseReference = [[FIRDatabase database] reference];
    
    [[[[[self.databaseReference child:@"classes"] child:classId] child:@"subjects"] child:subjectId] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString *homework;
        if([snapshot.value valueForKey:@"homework"] == [NSNull null]) {
            homework = @"No homework";
        } else {
            homework = [snapshot.value valueForKey:@"homework"];
        }
        NSString *teacherName = [snapshot.value valueForKey:@"teacher"];
        success(teacherName, homework);
    } withCancelBlock:^(NSError * _Nonnull error) {
        
    }];
}

- (void)getSubjectsOfClass:(NSString *) classId
                 onSuccess:(void(^)(NSArray *subjectsKeys)) success {
    
    self.databaseReference = [[FIRDatabase database] reference];
    
    [[[[self.databaseReference child:@"classes"] child:classId] child:@"subjects"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        success([snapshot.value allKeys]);
    } withCancelBlock:^(NSError * _Nonnull error) {
        
    }];
}

- (void)getTeacherIdOfClass:(NSString *)classId onSuccess:(void (^)(NSString *))success {
    
    self.databaseReference = [[FIRDatabase database] reference];
    
    [[[[self.databaseReference child:@"classes"] child:classId] child:@"classTeacher"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        success(snapshot.value);
    } withCancelBlock:^(NSError * _Nonnull error) {
        
    }];
}

@end
