//
//  MaterialsService.h
//  iSchool
//
//  Created by Pavlo Ivanov on 4/11/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaterialsService : NSObject

- (void)getMAterialsOfSubject:(NSString *) subjectId
                    onSuccess:(void(^)(NSArray *materials)) success
             onEmptyMAterials:(void(^)()) emptyMaterials;

@end
