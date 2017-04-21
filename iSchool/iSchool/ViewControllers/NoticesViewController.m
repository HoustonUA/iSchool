//
//  NoticesViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/9/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "NoticesViewController.h"
#import "NoteModel.h"
#import "AppDelegate.h"
#import "NoticeDetailedViewController.h"
#import "Note+CoreDataClass.h"

static NSString *const fromNoticesListToNoticeDetailsSegueIdentitifer = @"fromNoticesListToNoticeDetailsSegueIdentitifer";

@interface NoticesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) NSInteger selectedNoteIndex;
@property (strong, nonatomic) NSMutableArray *notes;

- (IBAction)addNoticeAction:(UIBarButtonItem *)sender;

@end

@implementation NoticesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    __weak AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedContext = appDelegate.persistentContainer.viewContext;
    NSError *error = nil;
    self.notes = [[NSMutableArray alloc] initWithArray:[managedContext executeFetchRequest:[Note fetchRequest] error:&error]];
    if(error) {
        NSLog(@"Fetch error: %@", error);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NoticesViewController class]) forIndexPath:indexPath];
    
    Note *note = [self.notes objectAtIndex:indexPath.row];
    cell.textLabel.text = note.title;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedNoteIndex = indexPath.row;
    [self performSegueWithIdentifier:fromNoticesListToNoticeDetailsSegueIdentitifer sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:fromNoticesListToNoticeDetailsSegueIdentitifer]) {
        NoticeDetailedViewController *vc = (NoticeDetailedViewController *)segue.destinationViewController;
        vc.noteObject = [self.notes objectAtIndex:self.selectedNoteIndex];
    }
}

#pragma mark - Actions

- (IBAction)addNoticeAction:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:fromNoticesListToNoticeDetailsSegueIdentitifer sender:nil];
}
@end
