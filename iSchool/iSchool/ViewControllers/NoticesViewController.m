//
//  NoticesViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/9/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "NoticesViewController.h"
#import "NoteModel.h"

static NSString *const fromNoticesListToNoticeDetailsSegueIdentitifer = @"fromNoticesListToNoticeDetailsSegueIdentitifer";

@interface NoticesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *notes;

- (IBAction)addNoticeAction:(UIBarButtonItem *)sender;

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
    //return self.notes.count;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NoticesViewController class]) forIndexPath:indexPath];
    
    //cell.textLabel.text = [[self.notes objectAtIndex:indexPath.row] title];
    cell.textLabel.text = @"Hi.";
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:fromNoticesListToNoticeDetailsSegueIdentitifer sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
}

#pragma mark - Actions

- (IBAction)addNoticeAction:(UIBarButtonItem *)sender {
    ///////
    
}
@end
