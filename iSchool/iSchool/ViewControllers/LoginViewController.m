//
//  LoginViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/9/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "LoginViewController.h"
@import Firebase;

static NSString *const fromLoginToPupilViewControllerSegueIdentifier = @"fromLoginToPupilViewControllerSegueIdentifier";

static NSString *const fromLoginToTeacherViewControllerSegueIdentifier = @"fromLoginToTeacherViewControllerSegueIdentifier";

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) FIRAuth *handle;

- (IBAction)loginAction:(UIButton *)sender;
- (IBAction)registrationAction:(UIButton *)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupUI];
    self.handle = [[FIRAuth auth]
                   addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth, FIRUser *_Nullable user) {
                       [[NSUserDefaults standardUserDefaults] setObject:user.uid forKey:@"userId"];
                   }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[FIRAuth auth] removeAuthStateDidChangeListener:self.handle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - Private

- (void)setupUI {
    self.view.backgroundColor = [UIColor primaryColor];
}

#pragma mark - Navigation

- (IBAction)inwindToLogin:(UIStoryboardSegue *) segue {
    
}

#pragma mark - Actions

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)loginAction:(UIButton *)sender {
    
    NSString *inputText = self.loginTextField.text;
    
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Invalid email or password" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButtonAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertViewController addAction:okButtonAction];
    
    if(![inputText isEqualToString:@""]) {
        [[FIRAuth auth] signInWithEmail:self.loginTextField.text
                               password:self.passwordTextField.text
                             completion:^(FIRUser *user, NSError *error) {
                                 if(!error) {
                                     [self performSegueWithIdentifier:fromLoginToPupilViewControllerSegueIdentifier sender:self];
                                 } else {
                                     [self presentViewController:alertViewController animated:YES completion:nil];
                                 }
                             }];
    } else if([inputText isEqualToString:@"pupil"]) {
        
    }
    else {
        [self performSegueWithIdentifier:fromLoginToTeacherViewControllerSegueIdentifier sender:self];
    }
}

- (IBAction)registrationAction:(UIButton *)sender {
//    [[FIRAuth auth]
//     createUserWithEmail:self.loginTextField.text
//     password:self.passwordTextField.text
//     completion:^(FIRUser *_Nullable user,
//                  NSError *_Nullable error) {
//     }];
}

@end
