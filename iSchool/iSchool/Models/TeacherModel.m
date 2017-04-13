//
//  TeacherModel.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/13/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "TeacherModel.h"

@implementation TeacherModel

+ (EKObjectMapping *)objectMapping {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"name", @"surname", @"middlename", @"birthday",
                                          @"phone", @"subjects", @"isClassTeacher", @"classId"]];
    }];
}

@end
