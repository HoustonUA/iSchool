//
//  ScheduleViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/9/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "ScheduleViewController.h"
#import "SubjectJournalViewController.h"
#import "ScheduleService.h"
#import "SubjectsService.h"

static NSString *const fromScheduleToSubjectInfoSegueIdentifier = @"fromScheduleToSubjectInfoSegueIdentifier";

@interface ScheduleViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *daysInWeek;
@property (strong, nonatomic) NSString *selectedSubject;
@property (strong, nonatomic) NSDictionary *scheduleDict;
@property (strong, nonatomic) NSDictionary *subjects;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *subjectsKeys;

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.subjectsKeys = [NSMutableArray array];
    self.daysInWeek = @[@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday"];
    [self getSchedule];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Networking

- (void)getSchedule {
    dispatch_group_t serviceGroup = dispatch_group_create();
    dispatch_group_enter(serviceGroup);
    [self getScheduleOfClass:@"cid01" withCompletion:^{
        dispatch_group_leave(serviceGroup);
    }];
    dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
        [self getSubjectsWithCompletion:^{
            [self.tableView reloadData];
        }];
    });
}

- (void)getScheduleOfClass:(NSString *) classId withCompletion:(void(^)()) completion {
    ScheduleService *service = [ScheduleService new];
    [service getPupilScheduleWithClassIs:classId onSuccess:^(NSDictionary *schedule) {
        self.scheduleDict = [[NSDictionary alloc] initWithDictionary:schedule];
        if(completion) {
            completion();
        }
    }];
}

- (void)getSubjectsWithCompletion:(void(^)()) completion {
    SubjectsService *service = [SubjectsService new];
    [service getSubjectsOnSuccess:^(NSDictionary *subjects) {
        self.subjects = [[NSDictionary alloc] initWithDictionary:subjects];
        if(completion) {
            completion();
        }
    }];
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.scheduleDict objectForKey:[[self.daysInWeek objectAtIndex:section] lowercaseString]] count];
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
    NSString *dayKey = [[self.daysInWeek objectAtIndex:indexPath.section] lowercaseString];
    NSString *subjectKey = [[self.scheduleDict objectForKey:dayKey] objectAtIndex:indexPath.row];
    cell.textLabel.text = [self.subjects objectForKey:subjectKey];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *dayKey = [[self.daysInWeek objectAtIndex:indexPath.section] lowercaseString];
    NSString *subjectKey = [[self.scheduleDict objectForKey:dayKey] objectAtIndex:indexPath.row];
    self.selectedSubject = [self.subjects objectForKey:subjectKey];
    [self performSegueWithIdentifier:fromScheduleToSubjectInfoSegueIdentifier sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:fromScheduleToSubjectInfoSegueIdentifier]) {
        SubjectJournalViewController *vc = (SubjectJournalViewController *)segue.destinationViewController;
        vc.navigationItemTitle = self.selectedSubject;
        vc.classId = @"cid01";
    }
}

@end
