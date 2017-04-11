//
//  MaterialsService.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/11/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "MaterialsService.h"
#import "MaterialModel.h"
@import Firebase;

@interface MaterialsService ()

@property (strong, nonatomic) FIRDatabaseReference *databaseReference;

@end

@implementation MaterialsService

- (void)getMAterialsOfSubject:(NSString *)subjectId onSuccess:(void (^)(NSArray *materials))success {
    
    self.databaseReference = [[FIRDatabase database] reference];
    
    [[[self.databaseReference child:@"materials"] child:subjectId] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray *materials = [NSMutableArray array];
        for (NSDictionary *item in snapshot.value) {
            MaterialModel *model = [EKMapper objectFromExternalRepresentation:item withMapping:[MaterialModel objectMapping]];
            [materials addObject:model];
        }
        success(materials);
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

@end
