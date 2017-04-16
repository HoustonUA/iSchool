//
//  ClassPupilsViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/16/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "ClassPupilsViewController.h"
#import "UserService.h"
#import "ClassService.h"
#import "PupilMarksViewController.h"

static NSString *const fromClassPupilsToPupilMarksSegueIdentifier = @"fromClassPupilsToPupilMarksSegueIdentifier";

@interface ClassPupilsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;

@property (strong, nonatomic) NSMutableArray *classPupils;
@property (strong, nonatomic) NSArray *classPupuilsIds;
@property (strong, nonatomic) NSString *selectedPupilId;
@property (strong, nonatomic) NSString *selectedPupilsName;

@end

@implementation ClassPupilsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.classPupils = [NSMutableArray array];
    [self getPupils];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)setupUI {
    self.navigationItem.title = self.subjectName;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedPupilId = [self.classPupuilsIds objectAtIndex:indexPath.row];
    self.selectedPupilsName = [self.classPupils objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:fromClassPupilsToPupilMarksSegueIdentifier sender:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.classPupils.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ClassPupilsViewController class]) forIndexPath:indexPath];
    
    cell.textLabel.text = [self.classPupils objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Networking

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
        self.classPupuilsIds = [[NSArray alloc] initWithArray:pupilsIds];
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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PupilMarksViewController *vc = (PupilMarksViewController *)segue.destinationViewController;
    vc.classId = self.classId;
    vc.subjectId = self.subjectId;
    vc.pupilUserId = self.selectedPupilId;
    vc.pupilName = self.selectedPupilsName;
}


@end
