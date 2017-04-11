//
//  ScheduleService.h
//  iSchool
//
//  Created by Pavlo Ivanov on 4/11/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleService : NSObject

- (void)getPupilScheduleWithClassIs:(NSString *) classId
                          onSuccess:(void(^)(NSDictionary *schedule)) success;

@end
