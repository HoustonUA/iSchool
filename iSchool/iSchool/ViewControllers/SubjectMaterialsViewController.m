//
//  SubjectMaterialsViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/9/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "SubjectMaterialsViewController.h"
#import "SubjectMaterialTableViewCell.h"

@interface SubjectMaterialsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@end

@implementation SubjectMaterialsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setupUI {
    self.navItem.title = [NSString stringWithFormat:@"%@ Materials", self.navigationItemTitle];
}

#pragma mark - UITableViewDelegate



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubjectMaterialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SubjectMaterialsViewController class]) forIndexPath:indexPath];
    [cell fillCellWithModel:nil];
    
    return cell;
}

@end
