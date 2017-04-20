//
//  Note+CoreDataClass.m
//  
//
//  Created by Pavlo Ivanov on 4/20/17.
//
//

#import "Note+CoreDataClass.h"

@implementation Note

- (void)fillNoteWithNoteModel:(NoteModel *) model {
    self.title = model.title;
    self.content = model.content;
}

@end
