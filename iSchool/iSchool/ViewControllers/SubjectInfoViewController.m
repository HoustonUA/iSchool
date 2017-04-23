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

static NSString *const fromMarksListToListOfsubjectsSegueIdentifier = @"fromMarksListToListOfsubjectsSegueIdentifier";

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

#pragma mark - Private

- (void)checkModels {
    if([self.marksModels count] == 0) {
        [self showAlert];
    }
}

- (void)showAlert {
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"No marks" message:@"You have no marks" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButtonAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self performSegueWithIdentifier:fromMarksListToListOfsubjectsSegueIdentifier sender:nil];
    }];
    [alertViewController addAction:okButtonAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}

#pragma mark - Networking

- (void)getMarksInfo {
    
    dispatch_group_t serviceGroup = dispatch_group_create();
    dispatch_group_enter(serviceGroup);
    [self getProfileInfoWithCompletion:^{
        dispatch_group_leave(serviceGroup);
    }];
    
    dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
        [self getMarksModelsAndFill];
    });
}

- (void)getMarksModelsAndFill {
    dispatch_group_t serviceGroup = dispatch_group_create();
    dispatch_group_enter(serviceGroup);
    [self getMarkOfUser:self.userModel withCompletion:^{
        dispatch_group_leave(serviceGroup);
    }];
    
    dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
        [self getTeachersOfMarksWithCompletion:^{
            [self.tableView reloadData];
        }];
    });
}

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
        [self checkModels];
        if(completion) {
            completion();
        }
    }];
    
    
}

- (void)getTeachersOfMarksWithCompletion:(void(^)()) completion {
    
    UserService *service = [UserService new];
    for (MarkModel *model in self.marksModels) {
        [service getTeacherProfileInfoWithUserId:model.teacherId onSuccess:^(TeacherModel *teacherModel) {
            model.teacherId = [NSString stringWithFormat:@"%@ %@ %@", teacherModel.surname, teacherModel.name, teacherModel.middlename];
            if(model == self.marksModels.lastObject) {
                if(completion) {
                    completion();
                }
            }
        }];
    }
}

#pragma mark - Private

- (void)setupUI{
    self.navigationItem.title = self.navigationItemTitle;
}

@end
