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

@interface SubjectInfoViewController () <UITableViewDelegate, UITableViewDataSource, MarkTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (strong, nonatomic) UserModel *userModel;
@property (strong, nonatomic) NSArray *marksModels;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *cellColors;

@end

@implementation SubjectInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *customRedColor = [UIColor colorWithRed:219.f/255.f green:78.f/255.f blue:77.f/255.f alpha:1.0];
    UIColor *customBlueColor = [UIColor colorWithRed:102.f/255.f green:142.f/255.f blue:255.f/255.f alpha:1.0];
    self.cellColors = @[customRedColor, customBlueColor, [UIColor customYellowColor], [UIColor primaryColor], [UIColor orangeColor]];
    [self showLoader];
    [self setupUI];
    [self getMarksInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - MarkTableViewCellDelegate

- (void)alertDidTappedOkButton:(UIAlertController *)alertController {
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.tableView.estimatedRowHeight = 140.f;
    return 140.f;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.marksModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MarkTableViewCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    NSInteger temp = indexPath.row % 10;
    if(temp != 0 && temp >= 5) {
        temp -= 5;
    }
    cell.colorOfCell = [self.cellColors objectAtIndex:temp];
    [cell setupUI];
    [cell fillCellWithModel:[self.marksModels objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - Private

- (void)checkModels {
    if([self.marksModels count] == 0) {
        [self showAlertWithTitle:@"No marks"
                     withMessage:@"You have no marks"
       andOKActionWithCompletion:^{
           [self performSegueWithIdentifier:fromMarksListToListOfsubjectsSegueIdentifier sender:nil];
       }];
    }
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
            [self hideLoader];
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
