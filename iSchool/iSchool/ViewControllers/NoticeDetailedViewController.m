//
//  NoticeDetailedViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/9/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "NoticeDetailedViewController.h"

@interface NoticeDetailedViewController ()

@property (weak, nonatomic) IBOutlet UITextView *noticeContentTextView;
@property (weak, nonatomic) IBOutlet UITextField *noticeTitleTextfield;

@end

@implementation NoticeDetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma makr - Private

- (void)setupUI {
    self.view.backgroundColor = [UIColor primaryColor];
    self.noticeContentTextView.layer.cornerRadius = 10.f;
    self.noticeContentTextView.layer.borderWidth = 1.f;
    self.noticeContentTextView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.noticeTitleTextfield.layer.cornerRadius = 10.f;
    self.noticeTitleTextfield.layer.borderWidth = 1.f;
    self.noticeTitleTextfield.layer.borderColor = [UIColor darkGrayColor].CGColor;
}

@end
