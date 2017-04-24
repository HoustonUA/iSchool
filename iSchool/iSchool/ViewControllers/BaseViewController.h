//
//  BaseViewController.h
//  iSchool
//
//  Created by Pavlo Ivanov on 4/24/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)showLoader;
- (void)hideLoader;

- (void)showAlertWithTitle:(NSString *) title
               withMessage:(NSString *) message
 andOKActionWithCompletion:(void(^)()) completion;

@end
