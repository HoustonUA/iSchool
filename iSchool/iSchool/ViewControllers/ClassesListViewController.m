//
//  ClassesListViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/16/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "ClassesListViewController.h"
#import "ClassService.h"
#import "ClassSubjectsViewController.h"

static NSString *const fromClassesToClassSubjectsSegueIdentifier = @"fromClassesToClassSubjectsSegueIdentifier";

@interface ClassesListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *classesList;
@property (strong, nonatomic) NSArray *classIds;
@property (strong, nonatomic) NSString *selectedClassId;
@property (strong, nonatomic) NSString *selectedClassName;

@end

@implementation ClassesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.classesList = [NSMutableArray array];
    [self getClassesName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Networking

- (void)getClassesName {
    __block NSArray *lClassesIds;
    dispatch_group_t serviceGroup = dispatch_group_create();
    dispatch_group_enter(serviceGroup);
    [self getListOfClassesIdsWithCompletion:^(NSArray *classesIds) {
        lClassesIds = [[NSArray alloc] initWithArray:classesIds];
        dispatch_group_leave(serviceGroup);
    }];
    
    dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
        [self getClassesNamesFromIdsArra:lClassesIds withCompletion:^{
            [self.tableView reloadData];
        }];
    });
    
}

- (void)getListOfClassesIdsWithCompletion:(void(^)(NSArray *classesIds)) completion {
    
    ClassService *service = [ClassService new];
    [service getClassesOnSuccess:^(NSArray *classList) {
        self.classIds = [[NSArray alloc] initWithArray:classList];
        if(completion) {
            completion(classList);
        }
    }];
}

- (void)getClassesNamesFromIdsArra:(NSArray *) classesIds withCompletion:(void(^)()) completion {
    
    ClassService *service = [ClassService new];
    for (NSString *classId in classesIds) {
        [service getNameOfClass:classId onSuccess:^(NSString *className) {
            [self.classesList addObject:className];
            if(classId == classesIds.lastObject) {
                if(completion) {
                    completion();
                }
            }
        }];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedClassId = [self.classIds objectAtIndex:indexPath.row];
    self.selectedClassName = [self.classesList objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:fromClassesToClassSubjectsSegueIdentifier sender:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.classesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ClassesListViewController class]) forIndexPath:indexPath];
    
    cell.textLabel.text = [self.classesList objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ClassSubjectsViewController *vc = (ClassSubjectsViewController *)segue.destinationViewController;
    vc.className = self.selectedClassName;
    vc.classId = self.selectedClassId;
}


@end
