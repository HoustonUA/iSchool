//
//  TeacherModel.h
//  iSchool
//
//  Created by Pavlo Ivanov on 4/13/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyMapping.h"

@interface TeacherModel : NSObject <EKMappingProtocol>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *surname;
@property (strong, nonatomic) NSString *middlename;
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSArray *subjects;
@property (assign, nonatomic) BOOL isClassTeacher;
@property (strong, nonatomic) NSString *classId;

@end
