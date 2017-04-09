//
//  SubjectsService.h
//  iSchool
//
//  Created by Pavlo Ivanov on 4/9/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Firebase;

@interface SubjectsService : NSObject

- (void)getSubjectsOnSuccess:(void(^)(NSArray *subjects)) success;

@end
