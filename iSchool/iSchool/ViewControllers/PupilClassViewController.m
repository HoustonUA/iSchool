//
//  PupilClassViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/16/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "PupilClassViewController.h"
#import "ClassService.h"
#import "UserService.h"

@interface PupilClassViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *classTeacherNameLabel;

@property (strong, nonatomic) NSMutableArray *classPupils;
@property (strong, nonatomic) NSString *classId;

@end

@implementation PupilClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showLoader];
    self.classPupils = [NSMutableArray array];
    self.classId = [[NSUserDefaults standardUserDefaults] objectForKey:PUPIL_CLASS_ID];
    [self setupUI];
    [self getPupils];
    [self getClassTeacherFullName];
    [self getClassName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setupUI {
    self.view.backgroundColor = [UIColor primaryColor];
}

#pragma mark - Networking

- (void)getClassName {
    ClassService *service = [ClassService new];
    [service getNameOfClass:self.classId onSuccess:^(NSString *className) {
        self.classNameLabel.text = className;
    }];
}

- (void)getClassTeacherFullName {
    __block NSString *lTeacherUserId;
    dispatch_group_t serviceGroup = dispatch_group_create();
    dispatch_group_enter(serviceGroup);
    [self getTeacherUserIdWithCompletion:^(NSString *teacherUserId) {
        lTeacherUserId = teacherUserId;
        dispatch_group_leave(serviceGroup);
    }];
    
    dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
        [self getTeacherNameWithUserId:lTeacherUserId];
    });
}

- (void)getTeacherUserIdWithCompletion:(void(^)(NSString *teacherUserId)) completion {
    ClassService *service = [ClassService new];
    [service getTeacherIdOfClass:self.classId onSuccess:^(NSString *teacherId) {
        if(completion) {
            completion(teacherId);
        }
    }];
}

- (void)getTeacherNameWithUserId:(NSString *) userId {
    UserService *service = [UserService new];
    [service getTeacherProfileInfoWithUserId:userId onSuccess:^(TeacherModel *teacherModel) {
        self.classTeacherNameLabel.text = [NSString stringWithFormat:@"%@ %@ %@",
                                           teacherModel.surname, teacherModel.name, teacherModel.middlename];
        [self hideLoader];
    }];
}

- (void)getPupils {
    __block NSArray *lPupilsIds;
    dispatch_group_t serviceGroup = dispatch_group_create();
    dispatch_group_enter(serviceGroup);
    [self getPupilsIdsWithCompletion:^(NSArray *pupilsIds) {
        lPupilsIds = [[NSArray alloc] initWithArray:pupilsIds];
        dispatch_group_leave(serviceGroup);
    }];
    
    dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
        [self getPupilsFullNamesFromIds:lPupilsIds withCompletion:^{
            [self.tableView reloadData];
        }];
    });
}

- (void)getPupilsIdsWithCompletion:(void(^)(NSArray *pupilsIds)) completion {
    ClassService *service = [ClassService new];
    [service getPupilsIdsFromClass:self.classId onSucccess:^(NSArray *pupilsIds) {
        if(completion) {
            completion(pupilsIds);
        }
    }];
}

- (void)getPupilsFullNamesFromIds:(NSArray *) pupilsIds withCompletion:(void(^)()) completion {
    UserService *service = [UserService new];
    for (NSString *pupilId in pupilsIds) {
        [service getPupilProfileInfoWithUserId:pupilId onSuccess:^(UserModel *userModel) {
            [self.classPupils addObject:[NSString stringWithFormat:@"%@ %@", userModel.surname, userModel.name]];
            if(pupilId == pupilsIds.lastObject) {
                if(completion) {
                    completion();
                }
            }
        }];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.classPupils.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PupilClassViewController class]) forIndexPath:indexPath];
    
    cell.textLabel.text = [self.classPupils objectAtIndex:indexPath.row];
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Pupils";
}

@end
