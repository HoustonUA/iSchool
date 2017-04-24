//
//  LoaderView.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/24/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "LoaderView.h"

@interface LoaderView ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation LoaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 10.f;
    self.layer.masksToBounds = false;
}

+ (LoaderView *)loadFromNib {
    NSBundle *bundle = [NSBundle bundleForClass:[LoaderView class]];
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([LoaderView class]) bundle:bundle];
    LoaderView *loaderView = [nib instantiateWithOwner:nil options:nil].firstObject;
    return loaderView;
}

- (void)startAnimation {
    [self.spinner startAnimating];
}

- (void)stopAnimation {
    [self.spinner stopAnimating];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
