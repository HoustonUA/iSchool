//
//  BaseViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/24/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "BaseViewController.h"
#import "LoaderView.h"

@interface BaseViewController ()

@property (strong, nonatomic) LoaderView *loaderView;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLoadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Loader

- (void)setupLoadView {
    self.loaderView = [LoaderView loadFromNib];
}

- (void)showLoader {
    self.loaderView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:self.loaderView];
    NSLayoutConstraint *xConstraint = [NSLayoutConstraint constraintWithItem:self.loaderView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    NSLayoutConstraint *yConstraint = [NSLayoutConstraint constraintWithItem:self.loaderView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    [NSLayoutConstraint activateConstraints:@[xConstraint, yConstraint]];
    [self.view setUserInteractionEnabled:NO];
    [self.loaderView startAnimation];
}

- (void)hideLoader {
    [self.loaderView stopAnimation];
    [self.loaderView removeFromSuperview];
    [self.view setUserInteractionEnabled:YES];
}

#pragma mark - Alerts

- (void)showAlertWithTitle:(NSString *) title
               withMessage:(NSString *) message
 andOKActionWithCompletion:(void(^)()) completion {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okActionButton = [UIAlertAction actionWithTitle:@"OK"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               [self dismissViewControllerAnimated:YES completion:nil];
                                                               if(completion) {
                                                                   completion();
                                                               }
                                                           }];
    [alertController addAction:okActionButton];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
