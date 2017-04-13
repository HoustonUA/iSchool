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

@interface RegistrationDetailsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *surnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *middlenameTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *parentNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *parentPhoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;


- (IBAction)selectRoleAction:(id)sender;
- (IBAction)confirmAction:(UIButton *)sender;

@end

@implementation RegistrationDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)addUserInfoFromModel:(UserModel *) model {
    UserService *service = [UserService new];
    [service addPupilProfileDetailsWithUserModel:model andUserId:self.userId onSuccess:^{
        NSLog(@"All is ok");
    }];
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
    userModel.classId = @"cid01";
    userModel.parentOne = self.parentNameTextField.text;
    userModel.parentsPhone = self.parentPhoneTextField.text;
    userModel.phone = self.phoneTextField.text;
    
    [self addUserInfoFromModel:userModel];
}
@end
