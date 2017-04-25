//
//  NetworkManager.h
//  iSchool
//
//  Created by Pavlo Ivanov on 4/9/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NetworkManager : AFHTTPSessionManager

+ (NetworkManager *)sharedManager;

@end
