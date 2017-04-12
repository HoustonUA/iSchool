//
//  JournalViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/9/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

@import Firebase;
#import "JournalViewController.h"
#import "SubjectTableViewCell.h"
#import "SubjectsService.h"
#import "SubjectInfoViewController.h"
#import "SubjectMaterialsViewController.h"
#import "UserService.h"
#import "UserModel.h"
#import "ClassService.h"

static NSString *const fromSubjectsListToSubjectJournalSegueIdentifier = @"fromSubjectsListToSubjectJournalSegueIdentifier";
static NSString *const fromSubjectsToSubjectMaterialsSegueIdentifier = @"fromSubjectsToSubjectMaterialsSegueIdentifier";

@interface JournalViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *subjectsKeys;
@property (strong, nonatomic) NSArray *subjects;
@property (strong, nonatomic) NSString *nameOfSubject;
@property (strong, nonatomic) NSString *selectedSubjectKey;

@end

@implementation JournalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getSubjectsOfClass];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    [service getSubjectsOfClass:@"cid01" onSuccess:^(NSArray *subjectsKeys) {
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.nameOfSubject = [self.subjects objectAtIndex:indexPath.row];
    if(self.actionType == toSubjectViewController) {
        self.selectedSubjectKey = [self.subjectsKeys objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:fromSubjectsListToSubjectJournalSegueIdentifier sender:self];
    } else if(self.actionType == toSchoolMaterialsViewController) {
        [self performSegueWithIdentifier:fromSubjectsToSubjectMaterialsSegueIdentifier sender:self];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SubjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JournalViewController class]) forIndexPath:indexPath];
    
    [cell fillCellWithSubjectName:[self.subjects objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:fromSubjectsListToSubjectJournalSegueIdentifier]) {
        SubjectInfoViewController *vc = (SubjectInfoViewController *)segue.destinationViewController;
        vc.navigationItemTitle = self.nameOfSubject;
        vc.selectedSubject = self.selectedSubjectKey;
    } else if([segue.identifier isEqualToString:fromSubjectsToSubjectMaterialsSegueIdentifier]) {
        SubjectMaterialsViewController *vc = (SubjectMaterialsViewController *)segue.destinationViewController;
        vc.navigationItemTitle = self.nameOfSubject;
    }
}

- (IBAction)unwindToJournal:(UIStoryboardSegue *) segue {
}

@end
