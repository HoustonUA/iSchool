//
//  Note+CoreDataProperties.m
//  
//
//  Created by Pavlo Ivanov on 4/20/17.
//
//

#import "Note+CoreDataProperties.h"

@implementation Note (CoreDataProperties)

+ (NSFetchRequest<Note *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Note"];
}

@dynamic content;
@dynamic title;

@end
