//
//  SubjectMaterialsViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/9/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "SubjectMaterialsViewController.h"
#import "SubjectMaterialTableViewCell.h"
#import "MaterialsService.h"

@interface SubjectMaterialsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic) NSArray *materialModels;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SubjectMaterialsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self getMaterialsOfSubjectWithCompletion:^{
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setupUI {
    self.navItem.title = [NSString stringWithFormat:@"%@ Materials", self.navigationItemTitle];
}

#pragma mark - Networking

- (void)getMaterialsOfSubjectWithCompletion:(void(^)()) completion {
    
    MaterialsService *service = [MaterialsService new];
    [service getMAterialsOfSubject:[self.navigationItemTitle lowercaseString] onSuccess:^(NSArray *materials) {
        self.materialModels = [[NSArray alloc] initWithArray:materials];
        if(completion) {
            completion();
        }
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [(SubjectMaterialTableViewCell *)cell fillCellWithModel:[self.materialModels objectAtIndex:indexPath.row]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.materialModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubjectMaterialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SubjectMaterialsViewController class]) forIndexPath:indexPath];
    
    return cell;
}

@end
