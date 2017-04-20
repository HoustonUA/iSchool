//
//  NoteModel.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/12/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "NoteModel.h"
#import "Note+CoreDataProperties.h"

@implementation NoteModel

- (instancetype)initWithNoteManagedObject:(Note *)note {
    self = [super init];
    if (self) {
        _title = note.title;
        _content = note.content;
    }
    return self;
}

@end
