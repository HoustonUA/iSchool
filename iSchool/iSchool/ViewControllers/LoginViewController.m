//
//  LoginViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/9/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "LoginViewController.h"
#import "UserService.h"
@import Firebase;

static NSString *const fromLoginToPupilViewControllerSegueIdentifier = @"fromLoginToPupilViewControllerSegueIdentifier";

static NSString *const fromLoginToTeacherViewControllerSegueIdentifier = @"fromLoginToTeacherViewControllerSegueIdentifier";

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (strong, nonatomic) FIRAuth *handle;

- (IBAction)loginAction:(UIButton *)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupUI];
    self.handle = [[FIRAuth auth]
                   addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth, FIRUser *_Nullable user) {
                       [[NSUserDefaults standardUserDefaults] setObject:user.uid forKey:USER_ID];
                   }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[FIRAuth auth] removeAuthStateDidChangeListener:self.handle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma  mark - Private

- (void)setupUI {
    self.view.backgroundColor = [UIColor primaryColor];
    self.signInButton.layer.cornerRadius = 5.f;
    self.signInButton.backgroundColor = [UIColor customYellowColor];
}

#pragma mark - Navigation

- (IBAction)inwindToLogin:(UIStoryboardSegue *) segue {
    
}

#pragma mark - Actions

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)loginAction:(UIButton *)sender {
    
    NSString *loginString = self.loginTextField.text;
    NSString *passwordString = self.passwordTextField.text;
    
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Invalid email or password" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButtonAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertViewController addAction:okButtonAction];
    
    if(![loginString isEqualToString:@""] && ![passwordString isEqualToString:@""]) {
        [[FIRAuth auth] signInWithEmail:self.loginTextField.text
                               password:self.passwordTextField.text
                             completion:^(FIRUser *user, NSError *error) {
                                 if(!error) {
                                     [self getUserTypeWithId:user.uid withCimpletion:^(NSString *userType) {
                                         if([userType isEqualToString:@"pupil"]) {
                                             [self performSegueWithIdentifier:fromLoginToPupilViewControllerSegueIdentifier sender:self];
                                         } else if([userType isEqualToString:@"teacher"]) {
                                             [self performSegueWithIdentifier:fromLoginToTeacherViewControllerSegueIdentifier sender:self];
                                         }
                                     }];
                                 } else {
                                     [self presentViewController:alertViewController animated:YES completion:nil];
                                 }
                             }];
    } else {
        //-----!!!!!
        NSLog(@"Do alert with \"There are empty fields\"");
    }
}

#pragma mark - Networking

- (void)getUserTypeWithId:(NSString *) userId withCimpletion:(void(^)(NSString *userType)) completion{
    UserService *service = [UserService new];
    [service getPersonTypeWithUserId:userId onSuccess:^(NSString *userType) {
        if(completion) {
            completion(userType);
        }
    }];
}

@end
