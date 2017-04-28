//
//  PupilMarksViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/16/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "PupilMarksViewController.h"
#import "ClassService.h"
#import "MarkModel.h"
#import "UserService.h"
#import "MarkTableViewCell.h"
#import "AddMarkViewController.h"

static NSString *const fromMarksToMarkAddSegueIdentifier = @"fromMarksToMarkAddSegueIdentifier";

@interface PupilMarksViewController () <UITabBarDelegate, UITableViewDataSource, UITableViewDelegate, MarkTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)addMarkAction:(UIBarButtonItem *)sender;

@property (strong, nonatomic) NSArray *marksModels;
@property (strong, nonatomic) NSArray *cellColors;

@end

@implementation PupilMarksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *customRedColor = [UIColor colorWithRed:219.f/255.f green:78.f/255.f blue:77.f/255.f alpha:1.0];
    UIColor *customBlueColor = [UIColor colorWithRed:102.f/255.f green:142.f/255.f blue:255.f/255.f alpha:1.0];
    self.cellColors = @[customRedColor, customBlueColor, [UIColor customYellowColor], [UIColor primaryColor], [UIColor orangeColor]];
    [self setupUI];
    [self getMarksModels];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - MarkTableViewCellDelegate

- (void)alertDidTappedOkButton:(UIAlertController *)alertController {
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

#pragma mark - Private

- (void)setupUI {
    self.navigationItem.title = self.pupilName;
}

#pragma mark - Networking

- (void)getMarksModels {
    dispatch_group_t serviceGroup = dispatch_group_create();
    dispatch_group_enter(serviceGroup);
    [self getMarkOfUserWithCompletion:^{
        dispatch_group_leave(serviceGroup);
    }];
    
    dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
        [self getTeachersOfMarksWithCompletion:^{
            [self.tableView reloadData];
        }];
    });
}

- (void)getMarkOfUserWithCompletion:(void(^)()) completion {
    ClassService *service = [ClassService new];
    [service getMarkForUser:self.pupilUserId fromClass:self.classId forSubject:self.subjectId onSuccess:^(NSMutableArray *marks) {
        self.marksModels = [[NSArray alloc] initWithArray:marks];
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:fromMarksToMarkAddSegueIdentifier]) {
        AddMarkViewController *vc = (AddMarkViewController *)segue.destinationViewController;
        vc.pupilUserId = self.pupilUserId;
        vc.subjectId = self.subjectId;
        vc.classId = self.classId;
    }
}

- (IBAction)unwindToPupilMarks:(UIStoryboardSegue *) segue {
    [self getMarksModels];    
}

#pragma mark - Actions

- (IBAction)addMarkAction:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:fromMarksToMarkAddSegueIdentifier sender:nil];
}

@end
