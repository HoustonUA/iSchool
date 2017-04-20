//
//  ClassService.h
//  iSchool
//
//  Created by Pavlo Ivanov on 4/10/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MarkModel.h"

@interface ClassService : NSObject

- (void)getMarkForUser:(NSString *) userId
             fromClass:(NSString *) classId
            forSubject:(NSString *) subjectId
             onSuccess:(void(^)(NSMutableArray *markModel)) success;

- (void)getHomeworkForSubject:(NSString *) subjectId
                     forClass:(NSString *) classId
                    onSuccess:(void(^)(NSString *teacherName, NSString *homework)) success;

- (void)getSubjectsOfClass:(NSString *) classId
                 onSuccess:(void(^)(NSArray *subjectsKeys)) success;

- (void)getTeacherIdOfClass:(NSString *) classId
                  onSuccess:(void(^)(NSString *teacherId)) success;

- (void)getClassesOnSuccess:(void(^)(NSDictionary *classList)) success;

- (void)addPupil:(NSString *) userId
         toClass:(NSString *) classId
      onSucccess:(void(^)()) success;

- (void)getPupilsIdsFromClass:(NSString *) classId
                   onSucccess:(void(^)(NSArray *pupilsIds)) success;

- (void)getNameOfClass:(NSString *) classId
             onSuccess:(void(^)(NSString *className)) success;

- (void)addMarkWithModel:(MarkModel *) markModel
                forPupil:(NSString *) pupilId
              forSubject:(NSString *) subjectId
               fromClass:(NSString *) classId
               onSuccess:(void(^)()) success;

- (void)addClassTeacherWithUserId:(NSString *) userId
                          toClass:(NSString *) classId
                        onSuccess:(void(^)()) success;

@end
