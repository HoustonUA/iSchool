//
//  Note+CoreDataClass.h
//  
//
//  Created by Pavlo Ivanov on 4/20/17.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class NoteModel;
NS_ASSUME_NONNULL_BEGIN

@interface Note : NSManagedObject

- (void)fillNoteWithNoteModel:(NoteModel *) model;

@end

NS_ASSUME_NONNULL_END

#import "Note+CoreDataProperties.h"
