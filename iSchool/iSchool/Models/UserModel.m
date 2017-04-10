//
//  UserModel.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/10/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (EKObjectMapping *)objectMapping {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"birthday", @"classId", @"middlename", @"name", @"parentOne",
                                          @"parentsPhone", @"phone", @"surname"]];
    }];
}

@end
