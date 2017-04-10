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
    
    [[[[[[self.databaseReference child:@"classes"] child:classId] child:@"journal"] child:subjectId] child:userId] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
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

@end
