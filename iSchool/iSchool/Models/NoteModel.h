//
//  NoteModel.h
//  iSchool
//
//  Created by Pavlo Ivanov on 4/12/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note+CoreDataProperties.h"

@interface NoteModel : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;

- (instancetype)initWithNoteManagedObject:(Note *)note;

@end
