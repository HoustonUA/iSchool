//
//  MaterialModel.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/11/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "MaterialModel.h"

@implementation MaterialModel

+ (EKObjectMapping *)objectMapping {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"author", @"bookName", @"downloadUrl", @"imageUrl"]];
    }];
}

@end
