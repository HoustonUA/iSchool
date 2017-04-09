//
//  NoticesViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/9/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "NoticesViewController.h"

static NSString *const fromNoticesListToNoticeDetailsSegueIdentitifer = @"fromNoticesListToNoticeDetailsSegueIdentitifer";

@interface NoticesViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation NoticesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NoticesViewController class]) forIndexPath:indexPath];
    
    cell.textLabel.text = @"Hi allseuqwhejkhqwkjehlksjhdlkajshdlakjshdasdasdasdasdasdasl";
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:fromNoticesListToNoticeDetailsSegueIdentitifer sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
}

@end
