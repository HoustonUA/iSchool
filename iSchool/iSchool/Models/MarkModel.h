//
//  MarkModel.h
//  iSchool
//
//  Created by Pavlo Ivanov on 4/10/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyMapping.h"

@interface MarkModel : NSObject <EKMappingProtocol>

@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSNumber *mark;
@property (strong, nonatomic) NSString *teacherId;

@end
