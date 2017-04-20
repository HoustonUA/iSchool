//
//  TeacherRegistrationViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/19/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "TeacherRegistrationViewController.h"
#import "TeacherModel.h"
#import "ClassService.h"
#import "SubjectsService.h"
#import "UserService.h"
#import "CongratulationViewController.h"

static NSString *const fromTeacherRegistrationToLoginSegueIdentifier = @"fromTeacherRegistrationToLoginSegueIdentifier";
static NSString *const fromTeacherRegistrationToCongratulationsSegueIdentifier = @"fromTeacherRegistrationToCongratulationsSegueIdentifier";

@interface TeacherRegistrationViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *surnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *middlenameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;
@property (weak, nonatomic) IBOutlet UISwitch *isClassTeacher;
@property (weak, nonatomic) IBOutlet UITextField *classTextField;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

- (IBAction)submitAction:(UIButton *)sender;
- (IBAction)isClassTeacherAction:(UISwitch *)sender;

@property (strong, nonatomic) NSDictionary *classesDictionary;
@property (strong, nonatomic) NSDictionary *subjectsDictionary;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIToolbar *toolbar;
@property (strong, nonatomic) NSString *selectedClassId;
@property (strong, nonatomic) NSString *userName;

@end

@implementation TeacherRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPickerView];
    [self setupUI];
    [self getClassList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PickerView

- (void)setupPickerView {
    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolbar.userInteractionEnabled = YES;
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
    UIBarButtonItem *spaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolbar.items = @[cancelBarButtonItem, spaceBarButtonItem, doneBarButtonItem];
    self.toolbar = toolbar;
}

- (IBAction)doneAction:(id) sender {
    [self.classTextField resignFirstResponder];
}

- (void)cancelAction:(id) sender {
    self.classTextField.text = @"";
    [self.classTextField resignFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[self.classesDictionary allValues] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[self.classesDictionary allValues] objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedClassId = [[self.classesDictionary allKeys] objectAtIndex:row];
    self.classTextField.text = [[self.classesDictionary allValues] objectAtIndex:row];
}

#pragma mark - Networking

- (void)getClassList {
    ClassService *service = [ClassService new];
    [service getClassesOnSuccess:^(NSDictionary *classList) {
        self.classesDictionary = [[NSDictionary alloc] initWithDictionary:classList];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pickerView reloadAllComponents];
        });
    }];
}

- (void)getSubjectsWithCompletion:(void(^)()) completion {
    SubjectsService *service = [SubjectsService new];
    [service getAllSubjectsOnSuccess:^(NSDictionary *subjects) {
        self.subjectsDictionary = [[NSDictionary alloc] initWithDictionary:subjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completion) {
                completion();
            }
        });
    }];
}

- (void)addUserToUsersList {
    UserService *service = [UserService new];
    [service addUserToUsersListWithId:self.userId withPersonType:self.userType onSuccess:nil];
}

- (void)addTeacherToClass {
    ClassService *service = [ClassService new];
    [service addClassTeacherWithUserId:self.userId toClass:self.selectedClassId onSuccess:nil];
}

- (void)addTeacherToUsersFromModel:(TeacherModel *) model {
    UserService *service = [UserService new];
    [service addTeacherProfileDetailsWithUserModel:model andUserId:self.userId onSuccess:nil];
}

#pragma mark - Private

- (void)setupUI {
    self.classTextField.inputView = self.pickerView;
    self.classTextField.inputAccessoryView = self.toolbar;
    self.submitButton.backgroundColor = [UIColor customYellowColor];
    self.submitButton.layer.cornerRadius = 5.f;
    self.view.backgroundColor = [UIColor primaryColor];
}

- (TeacherModel *)fillModel {
    TeacherModel *model = [TeacherModel new];
    model.name = self.nameTextField.text;
    self.userName = self.nameTextField.text;
    model.surname = self.surnameTextField.text;
    model.middlename = self.middlenameTextField.text;
    model.phone = self.phoneTextField.text;
    model.birthday = self.birthdayTextField.text;
    //FIX
    model.subjects = @[@"pe"];
    model.isClassTeacher = self.isClassTeacher.isOn;
    model.classId = self.selectedClassId;
    
    return model;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:fromTeacherRegistrationToCongratulationsSegueIdentifier]) {
        CongratulationViewController *vc = (CongratulationViewController *)segue.destinationViewController;
        vc.userName = self.userName;
    }
}

#pragma mark - Actions

- (IBAction)submitAction:(UIButton *)sender {
    TeacherModel *model = [self fillModel];
    
    if(self.selectedClassId) {
        [self addTeacherToClass];
    }
    
    [self addUserToUsersList];
    [self addTeacherToUsersFromModel:model];
    [self performSegueWithIdentifier:fromTeacherRegistrationToCongratulationsSegueIdentifier sender:nil];
}

- (IBAction)isClassTeacherAction:(UISwitch *)sender {
    if(sender.on) {
        self.classTextField.enabled = YES;
    } else {
        self.classTextField.enabled = NO;
    }
}
@end
