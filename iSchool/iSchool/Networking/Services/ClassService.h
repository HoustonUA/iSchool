//
//  ClassService.h
//  iSchool
//
//  Created by Pavlo Ivanov on 4/10/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassService : NSObject

- (void)getMarkForUser:(NSString *) userId
             fromClass:(NSString *) classId
            forSubject:(NSString *) subjectId
             onSuccess:(void(^)(NSMutableArray *markModel)) success;

- (void)getHomeworkForSubject:(NSString *) subjectId
                     forClass:(NSString *) classId
                    onSuccess:(void(^)(NSString *teacherName, NSString *homework)) success;

@end
