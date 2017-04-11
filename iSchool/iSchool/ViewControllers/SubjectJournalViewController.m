//
//  SubjectJournalViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/9/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "SubjectJournalViewController.h"
#import "ClassService.h"

@interface SubjectJournalViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeworkLabel;
@property (weak, nonatomic) IBOutlet UITextView *homeworkTextView;
@property (weak, nonatomic) IBOutlet UIView *homeworkLabelContainerView;

@end

@implementation SubjectJournalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getHomework];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Networking

- (void)getHomework {
    ClassService *service = [ClassService new];
    [service getHomeworkForSubject:[self.navigationItemTitle lowercaseString] forClass:self.classId onSuccess:^(NSString *teacherName, NSString *homework) {
        self.teacherNameLabel.text = teacherName;
        self.homeworkTextView.text = homework;
    }];
}

#pragma mark - Private

- (void)setupUI {
    self.navigationItem.title = [NSString stringWithFormat:@"%@ Journal", self.navigationItemTitle];
    self.homeworkTextView.layer.cornerRadius = 10.f;
    self.homeworkTextView.layer.borderWidth = 3.f;
    self.homeworkTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.view.backgroundColor = [UIColor primaryColor];
    self.teacherLabel.backgroundColor = [UIColor clearColor];
    self.teacherNameLabel.backgroundColor = [UIColor clearColor];
    self.homeworkLabelContainerView.backgroundColor = [UIColor mainColor];
    self.homeworkLabelContainerView.layer.cornerRadius = 7.f;
}

@end
