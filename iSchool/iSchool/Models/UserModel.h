//
//  UserModel.h
//  iSchool
//
//  Created by Pavlo Ivanov on 4/10/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyMapping.h"

@interface UserModel : NSObject <EKMappingProtocol>

@property (strong, nonatomic) NSNumber *birthday;
@property (strong, nonatomic) NSString *classId;
@property (strong, nonatomic) NSString *middlename;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *parentOne;
@property (strong, nonatomic) NSString *parentsPhone;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *surname;

@end
