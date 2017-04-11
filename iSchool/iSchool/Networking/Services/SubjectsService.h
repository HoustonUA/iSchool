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

- (void)getAllSubjectsOnSuccess:(void(^)(NSDictionary *subjects)) success;

- (void)getSubjectsWithKeys:(NSArray *) subjectsKeys
                  onSuccess:(void(^)(NSArray *subjects)) success;

@end
