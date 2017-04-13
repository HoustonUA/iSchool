//
//  SubjectInfoViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/10/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "SubjectInfoViewController.h"
#import "MarkTableViewCell.h"
#import "ClassService.h"
#import "UserService.h"

@interface SubjectInfoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (strong, nonatomic) UserModel *userModel;
@property (strong, nonatomic) NSArray *marksModels;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SubjectInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self getMarksInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.marksModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MarkTableViewCell class]) forIndexPath:indexPath];
    
    [cell fillCellWithModel:[self.marksModels objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - Networking

- (void)getMarksInfo {
    
    dispatch_group_t serviceGroup = dispatch_group_create();
    dispatch_group_enter(serviceGroup);
    [self getProfileInfoWithCompletion:^{
        dispatch_group_leave(serviceGroup);
    }];
    
    dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
        [self getMarkOfUser:self.userModel withCompletion:^{
            [self.tableView reloadData];
        }];
    });
}

//- (void)getMarksInfoSemaphore {
//    
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//    [self getProfileInfoWithCompletion:^{
//        dispatch_semaphore_signal(semaphore);
//    }];
//    
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    
//    [self getMarkOfUser:self.userModel withCompletion:^{
//        [self.tableView reloadData];
//    }];
//}

- (void)getProfileInfoWithCompletion:(void(^)()) completion {
    UserService *service = [UserService new];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    [service getPupilProfileInfoWithUserId:userId onSuccess:^(UserModel *userModel) {
        self.userModel = userModel;
        if(completion) {
            completion();
        }
    }];
}

- (void)getMarkOfUser:(UserModel *) user withCompletion:(void(^)()) completion {
    ClassService *service = [ClassService new];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    [service getMarkForUser:userId fromClass:user.classId forSubject:self.selectedSubject onSuccess:^(NSMutableArray *marks) {
        self.marksModels = marks;
        if(completion) {
            completion();
        }
    }];
    
    
}

- (void)getTeacherOfClass:(NSString *) classId withCompletion:(void(^)()) completion {
    
}

#pragma mark - Private

- (void)setupUI{
    self.navigationItem.title = self.navigationItemTitle;
}

@end
