//
//  ScheduleViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/9/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "ScheduleViewController.h"

@interface ScheduleViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    cell.textLabel.text = [NSString stringWithFormat:@"Row %ld", indexPath.row];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *daysInWeek = @[@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday"];
    return [daysInWeek objectAtIndex:section];
}

@end
