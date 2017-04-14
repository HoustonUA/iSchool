//
//  RegistrationDetailsViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/14/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "RegistrationDetailsViewController.h"
#import "UserModel.h"
#import "UserService.h"
#import "ClassService.h"

static NSString *const fromRegistrationDetailedToLoginSegueIdentifier = @"fromRegistrationDetailedToLoginSegueIdentifier";

@interface RegistrationDetailsViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *surnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *middlenameTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *parentNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *parentPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *classTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIToolbar *toolbar;
@property (strong, nonatomic) NSString *selectedClassId;

@property (strong, nonatomic) NSArray *classList;

- (IBAction)selectRoleAction:(id)sender;
- (IBAction)confirmAction:(UIButton *)sender;

@end

@implementation RegistrationDetailsViewController

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Networking

- (void)addUserInfoFromModel:(UserModel *) model withCOmpletion:(void(^)()) completion{
    UserService *service = [UserService new];
    [service addPupilProfileDetailsWithUserModel:model andUserId:self.userId onSuccess:^{
        if(completion) {
            completion();
        }
    }];
}

- (void)getClassList {
    ClassService *service = [ClassService new];
    [service getClassesOnSuccess:^(NSArray *classList) {
        self.classList = [[NSArray alloc] initWithArray:classList];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pickerView reloadAllComponents];
        });
    }];
}

- (void)addPupilToClass {
    ClassService *service = [ClassService new];
    [service addPupil:self.userId toClass:self.selectedClassId onSucccess:^{
        
    }];
}

#pragma mark - Private

- (void)setupUI {
    self.classTextField.inputView = self.pickerView;
    self.classTextField.inputAccessoryView = self.toolbar;
}

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
    self.selectedClassId = self.classTextField.text;
    [self.classTextField resignFirstResponder];
}

- (void)cancelAction:(id) sender {
    self.classTextField.text = @"";
    [self.classTextField resignFirstResponder];
}

#pragma mark - PickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.classList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.classList objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.classTextField.text = [self.classList objectAtIndex:row];
}

#pragma mark - Actions

- (IBAction)selectRoleAction:(id)sender {
    
}

- (IBAction)confirmAction:(UIButton *)sender {
    UserModel *userModel = [UserModel new];
    userModel.name = self.nameTextField.text;
    userModel.surname = self.surnameTextField.text;
    userModel.middlename = self.middlenameTextField.text;
    userModel.birthday = [NSNumber numberWithInteger:[self.birthdayTextField.text integerValue]];
    userModel.classId = self.selectedClassId;
    userModel.parentOne = self.parentNameTextField.text;
    userModel.parentsPhone = self.parentPhoneTextField.text;
    userModel.phone = self.phoneTextField.text;
    
    [self addUserInfoFromModel:userModel withCOmpletion:nil];
    [self addPupilToClass];
    [self performSegueWithIdentifier:fromRegistrationDetailedToLoginSegueIdentifier sender:nil];
}
@end
