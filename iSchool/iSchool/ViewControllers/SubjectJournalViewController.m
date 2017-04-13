//
//  SubjectJournalViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/9/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "SubjectJournalViewController.h"
#import "ClassService.h"
#import "UserService.h"

@interface SubjectJournalViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeworkLabel;
@property (weak, nonatomic) IBOutlet UITextView *homeworkTextView;
@property (weak, nonatomic) IBOutlet UIView *homeworkLabelContainerView;
@property (strong, nonatomic) NSString *teacherId;

@end

@implementation SubjectJournalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getHomeworkInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Networking

- (void)getHomeworkInfo {
    dispatch_group_t serviceGroup = dispatch_group_create();
    dispatch_group_enter(serviceGroup);
    [self getHomeworkWithCompletion:^{
        dispatch_group_leave(serviceGroup);
    }];
    
    dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
        [self getTeachersOfHomeworkWithCompletion:nil];
    });
}

- (void)getHomeworkWithCompletion:(void(^)()) completion {
    ClassService *service = [ClassService new];
    [service getHomeworkForSubject:[self.navigationItemTitle lowercaseString] forClass:self.classId onSuccess:^(NSString *teacherName, NSString *homework) {
        self.teacherId = teacherName;
        self.homeworkTextView.text = homework;
        if(completion) {
            completion();
        }
    }];
}

- (void)getTeachersOfHomeworkWithCompletion:(void(^)()) completion {
    
    UserService *service = [UserService new];
    [service getTeacherProfileInfoWithUserId:self.teacherId onSuccess:^(TeacherModel *teacherModel) {
        self.teacherNameLabel.text = [NSString stringWithFormat:@"%@ %@ %@", teacherModel.surname, teacherModel.name, teacherModel.middlename];
        if(completion) {
            completion();
        }
    }];
}

#pragma mark - Private

- (void)setupUI {
    self.navigationItem.title = [NSString stringWithFormat:@"%@ Journal", self.navigationItemTitle];
    self.homeworkTextView.layer.cornerRadius = 10.f;
    self.homeworkTextView.layer.borderWidth = 1.f;
    self.homeworkTextView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.view.backgroundColor = [UIColor primaryColor];
    self.teacherLabel.backgroundColor = [UIColor clearColor];
    self.teacherNameLabel.backgroundColor = [UIColor clearColor];
    self.homeworkLabelContainerView.backgroundColor = [UIColor mainColor];
    self.homeworkLabelContainerView.layer.cornerRadius = 7.f;
}

@end
