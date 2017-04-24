//
//  LoaderView.h
//  iSchool
//
//  Created by Pavlo Ivanov on 4/24/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoaderView : UIView

+ (LoaderView *)loadFromNib;
- (void)startAnimation;
- (void)stopAnimation;

@end
