//
//  ClassSubjectsViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/16/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "ClassSubjectsViewController.h"
#import "ClassService.h"
#import "SubjectsService.h"
#import "ClassPupilsViewController.h"

static NSString *const fromClassSubjectsToPupilsListSegueIdentifier = @"fromClassSubjectsToPupilsListSegueIdentifier";

@interface ClassSubjectsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *subjectsKeys;
@property (strong, nonatomic) NSArray *subjects;
@property (strong, nonatomic) NSString *selectedSubjectName;
@property (strong, nonatomic) NSString *selectedSubjectKey;

@end

@implementation ClassSubjectsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getSubjectsOfClass];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)setupUI {
    self.navigationItem.title = [NSString stringWithFormat:@"Subjects of %@", self.className];
    self.view.backgroundColor = [UIColor primaryColor];
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ClassSubjectsViewController class]) forIndexPath:indexPath];
    
    cell.textLabel.text = [self.subjects objectAtIndex:indexPath.row];
    
    return  cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedSubjectKey = [self.subjectsKeys objectAtIndex:indexPath.row];
    self.selectedSubjectName = [self.subjects objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:fromClassSubjectsToPupilsListSegueIdentifier sender:self];
}

#pragma mark - Networking

- (void)getSubjectsOfClass {
    dispatch_group_t serviceGroup = dispatch_group_create();
    dispatch_group_enter(serviceGroup);
    [self getSubjectsKeysOfClassWithCompletion:^{
        dispatch_group_leave(serviceGroup);
    }];
    dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
        [self getSubjectsWithCompletion:^{
            [self.tableView reloadData];
        }];
    });
}

- (void)getSubjectsKeysOfClassWithCompletion:(void(^)()) completion {
    ClassService *service = [ClassService new];
    [service getSubjectsOfClass:self.classId onSuccess:^(NSArray *subjectsKeys) {
        self.subjectsKeys = [[NSArray alloc] initWithArray:subjectsKeys];
        if(completion) {
            completion();
        }
    }];
}

- (void)getSubjectsWithCompletion:(void(^)()) completion {
    SubjectsService *service = [SubjectsService new];
    [service getSubjectsWithKeys:self.subjectsKeys onSuccess:^(NSArray *subjects) {
        self.subjects = [[NSArray alloc] initWithArray:subjects];
        if(completion) {
            completion();
        }
    }];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ClassPupilsViewController *vc = (ClassPupilsViewController *)segue.destinationViewController;
    vc.subjectName = self.selectedSubjectName;
    vc.subjectId = self.selectedSubjectKey;
    vc.classId = self.classId;
}


@end
