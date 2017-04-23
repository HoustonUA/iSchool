//
//  NoticeDetailedViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/9/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "NoticeDetailedViewController.h"
#import "AppDelegate.h"

@interface NoticeDetailedViewController ()

@property (weak, nonatomic) IBOutlet UITextView *noticeContentTextView;
@property (weak, nonatomic) IBOutlet UITextField *noticeTitleTextfield;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

- (IBAction)saveAction:(UIButton *)sender;

@end

@implementation NoticeDetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self fillView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma makr - Private

- (void)setupUI {
    self.view.backgroundColor = [UIColor primaryColor];
    self.noticeContentTextView.layer.cornerRadius = 10.f;
    self.noticeContentTextView.layer.borderWidth = 1.f;
    self.noticeContentTextView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.noticeTitleTextfield.layer.cornerRadius = 10.f;
    self.noticeTitleTextfield.layer.borderWidth = 1.f;
    self.noticeTitleTextfield.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.saveButton.backgroundColor = [UIColor customYellowColor];
    self.saveButton.layer.cornerRadius = 5.f;
}

- (void)fillView {
    if(self.noteObject != nil) {
        self.noticeTitleTextfield.text = self.noteObject.title;
        self.noticeContentTextView.text = self.noteObject.content;
    }
}

- (IBAction)saveAction:(UIButton *)sender {
    __weak AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedContext = appDelegate.persistentContainer.viewContext;
    
    Note *note = [[Note alloc] initWithEntity:[Note entity] insertIntoManagedObjectContext:managedContext];
    note.title = self.noticeTitleTextfield.text;
    note.content = self.noticeContentTextView.text;
    NSError *error = nil;
    [managedContext save:&error];
    if(error) {
        NSLog(@"Save error: %@", error);
    }
}
@end
