//
//  JournalViewController.h
//  iSchool
//
//  Created by Pavlo Ivanov on 4/9/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef enum{
    toSubjectViewController = 0,
    toSchoolMaterialsViewController = 1
}cellActionType;

@interface JournalViewController : BaseViewController

@property (assign, nonatomic) cellActionType actionType;

@end
