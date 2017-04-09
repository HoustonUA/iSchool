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
#import "SubjectJournalViewController.h"
#import "SubjectMaterialsViewController.h"

static NSString *const fromSubjectsListToSubjectJournalSegueIdentifier = @"fromSubjectsListToSubjectJournalSegueIdentifier";
static NSString *const fromSubjectsToSubjectMaterialsSegueIdentifier = @"fromSubjectsToSubjectMaterialsSegueIdentifier";

@interface JournalViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSArray *subjects;
@property (strong, nonatomic) NSString *nameOfSubject;

@end

@implementation JournalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getSubjectsWithCompletion:^{
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Networking

- (void)getSubjectsWithCompletion:(void(^)()) completion {
    SubjectsService *service = [SubjectsService new];
    [service getSubjectsOnSuccess:^(NSArray *subjects) {
        self.subjects = subjects;
        if(completion) {
            completion();
        }
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.nameOfSubject = [self.subjects objectAtIndex:indexPath.row];
    if(self.actionType == toSubjectViewController) {
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
        SubjectJournalViewController *vc = (SubjectJournalViewController *)segue.destinationViewController;
        vc.navigationItemTitle = self.nameOfSubject;
    } else if([segue.identifier isEqualToString:fromSubjectsToSubjectMaterialsSegueIdentifier]) {
        SubjectMaterialsViewController *vc = (SubjectMaterialsViewController *)segue.destinationViewController;
        vc.navigationItemTitle = self.nameOfSubject;
    }
}

@end
