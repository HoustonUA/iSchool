//
//  MaterialModel.h
//  iSchool
//
//  Created by Pavlo Ivanov on 4/11/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyMapping.h"

@interface MaterialModel : NSObject <EKMappingProtocol>

@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *bookName;
@property (strong, nonatomic) NSString *downloadUrl;
@property (strong, nonatomic) NSString *imageUrl;

@end
