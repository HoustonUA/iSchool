//
//  JournalViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/9/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "JournalViewController.h"
#import "SubjectTableViewCell.h"

static NSString *const fromSubjectsListToSubjectJournalSegueIdentifier = @"fromSubjectsListToSubjectJournalSegueIdentifier";
static NSString *const fromSubjectsToSubjectMaterialsSegueIdentifier = @"fromSubjectsToSubjectMaterialsSegueIdentifier";

@interface JournalViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation JournalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.actionType == toSubjectViewController) {
        [self performSegueWithIdentifier:fromSubjectsListToSubjectJournalSegueIdentifier sender:self];
    } else if(self.actionType == toSchoolMaterialsViewController) {
        [self performSegueWithIdentifier:fromSubjectsToSubjectMaterialsSegueIdentifier sender:self];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SubjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JournalViewController class]) forIndexPath:indexPath];
    
    [cell fillCellWithSubjectName:@"Fizra"];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
}

@end
