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

#pragma mark - GET

- (void)getMarkForUser:(NSString *) userId
             fromClass:(NSString *) classId
            forSubject:(NSString *) subjectId
             onSuccess:(void(^)(NSMutableArray *markModel)) success {
    
    self.databaseReference = [[FIRDatabase database] reference];
    
    [[[[[[self.databaseReference child:@"classes"] child:classId] child:@"journal"] child:userId] child:subjectId] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if(snapshot.value != [NSNull null]) {
            NSMutableArray *marks = [NSMutableArray array];
            for (NSDictionary *item in [snapshot.value allValues]) {
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

- (void)getClassesOnSuccess:(void(^)(NSArray *classList)) success {
    
    self.databaseReference = [[FIRDatabase database] reference];
    
    [[self.databaseReference child:@"classList"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        success(snapshot.value);
    } withCancelBlock:^(NSError * _Nonnull error) {
        
    }];
}

- (void)getPupilsIdsFromClass:(NSString *) classId
                   onSucccess:(void(^)(NSArray *pupilsIds)) success {
    
    self.databaseReference = [[FIRDatabase database] reference];
    [[[[self.databaseReference child:@"classes"] child:classId] child:@"pupils"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        success([snapshot.value allValues]);
    } withCancelBlock:^(NSError * _Nonnull error) {
        
    }];
}

- (void)getNameOfClass:(NSString *) classId
             onSuccess:(void(^)(NSString *className)) success {
    
    self.databaseReference = [[FIRDatabase database] reference];
    [[[[self.databaseReference child:@"classes"] child:classId] child:@"className"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        success(snapshot.value);
    } withCancelBlock:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - ADD

- (void)addPupil:(NSString *) userId
         toClass:(NSString *) classId
      onSucccess:(void(^)()) success {
    
    self.databaseReference = [[FIRDatabase database] reference];
    NSString *key = [[[[self.databaseReference child:@"classes"] child:classId] child:@"pupils"] childByAutoId].key;
    NSDictionary *userUpdate = @{
                                 [NSString stringWithFormat:@"/classes/%@/pupils/%@/", classId, key] : userId
                                 };
    [self.databaseReference updateChildValues:userUpdate];
}

- (void)addMarkWithModel:(MarkModel *) markModel
                forPupil:(NSString *) pupilId
              forSubject:(NSString *) subjectId
               fromClass:(NSString *) classId
               onSuccess:(void(^)()) success {
    
    self.databaseReference = [[FIRDatabase database] reference];
    
    NSString *key = [[[[[[self.databaseReference child:@"classes"] child:classId]
                        child:@"journal"] child:pupilId] child:subjectId] childByAutoId].key;
    NSDictionary *markInfo = @{
                               [NSString stringWithFormat:@"/classes/%@/journal/%@/%@/%@/date", classId, pupilId, subjectId, key]          :  markModel.date,
                               [NSString stringWithFormat:@"/classes/%@/journal/%@/%@/%@/teacherId", classId, pupilId, subjectId, key]      :   markModel.teacherId,
                               [NSString stringWithFormat:@"/classes/%@/journal/%@/%@/%@/mark", classId, pupilId, subjectId, key]           :   markModel.mark,
                               [NSString stringWithFormat:@"/classes/%@/journal/%@/%@/%@/wasOnLesson", classId, pupilId, subjectId, key]    :   [NSNumber numberWithBool:markModel.wasOnLesson]
                               };
    [self.databaseReference updateChildValues:markInfo];
}

@end
