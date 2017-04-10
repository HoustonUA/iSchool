//
//  ScheduleViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/9/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "ScheduleViewController.h"
#import "SubjectJournalViewController.h"

static NSString *const fromScheduleToSubjectInfoSegueIdentifier = @"fromScheduleToSubjectInfoSegueIdentifier";

@interface ScheduleViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *daysInWeek;
@property (strong, nonatomic) NSString *selectedDay;

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.daysInWeek = @[@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ScheduleViewController class]) forIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.daysInWeek objectAtIndex:section];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.textLabel.text = [NSString stringWithFormat:@"Row %ld", indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedDay = [self.daysInWeek objectAtIndex:indexPath.section];
    [self performSegueWithIdentifier:fromScheduleToSubjectInfoSegueIdentifier sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:fromScheduleToSubjectInfoSegueIdentifier]) {
        SubjectJournalViewController *vc = (SubjectJournalViewController *)segue.destinationViewController;
        vc.navigationItemTitle = self.selectedDay;
    }
}

@end
