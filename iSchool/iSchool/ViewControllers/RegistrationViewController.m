//
//  RegistrationViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/13/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "RegistrationViewController.h"
#import "RegistrationDetailsViewController.h"
#import "RegistrationService.h"
#import "TeacherRegistrationViewController.h"
@import Firebase;

static NSString *const fromFirstRegistrationStepToSecondSegueIdentifier = @"fromFirstRegistrationStepToSecondSegueIdentifier";
static NSString *const fromRegistrationToTeacherDetailedRegistrationSegueIdentifier = @"fromRegistrationToTeacherDetailedRegistrationSegueIdentifier";

@interface RegistrationViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *activationKeyTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *userType;
@property (strong, nonatomic) UIAlertController *alertController;

- (IBAction)nextButton:(UIButton *)sender;

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Networking

- (void)getUserTypeWithKey:(NSString *) key andCompletion:(void(^)(NSString *userType)) completion {
    RegistrationService *service = [RegistrationService new];
    [service getUserTypeWithActivationKey:key onSuccess:^(NSString *userType) {
        if(completion) {
            completion(userType);
        }
    }];
}

#pragma mark - Private

- (void)setupUI {
    self.view.backgroundColor = [UIColor primaryColor];
    self.nextButton.backgroundColor = [UIColor customYellowColor];
    self.nextButton.layer.cornerRadius = 5.f;
    
}

#pragma mark - Actions

- (IBAction)nextButton:(UIButton *)sender {
    if(![self.emailTextField.text isEqualToString:@""] && ![self.passwordTextField.text isEqualToString:@""] && ![self.activationKeyTextField.text isEqualToString:@""]) {
        [self getUserTypeWithKey:self.activationKeyTextField.text andCompletion:^(NSString *userType) {
            if(![userType isEqualToString:@""]) {
                self.userType = userType;
                [[FIRAuth auth]
                 createUserWithEmail:self.emailTextField.text
                 password:self.passwordTextField.text
                 completion:^(FIRUser *_Nullable user,
                              NSError *_Nullable error) {
                     if(!error) {
                         self.userId = user.uid;
                         if([userType isEqualToString:@"pupil"]) {
                             [self performSegueWithIdentifier:fromFirstRegistrationStepToSecondSegueIdentifier sender:nil];
                         } else if ([userType isEqualToString:@"teacher"]) {
                              [self performSegueWithIdentifier:fromRegistrationToTeacherDetailedRegistrationSegueIdentifier sender:nil];
                         }
                     }
                 }];
            } else {
                [self createAlert];
                [self presentViewController:self.alertController animated:YES completion:nil];
            }
        }];
    }
}

#pragma mark - Private

- (void)createAlert {
    self.alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Invalid activation key" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButtonAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.alertController addAction:okButtonAction];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:fromFirstRegistrationStepToSecondSegueIdentifier]) {
        RegistrationDetailsViewController *vc = (RegistrationDetailsViewController *)segue.destinationViewController;
        vc.userId = self.userId;
        vc.userType = self.userType;
    } else if([segue.identifier isEqualToString:fromRegistrationToTeacherDetailedRegistrationSegueIdentifier]) {
        TeacherRegistrationViewController *vc = (TeacherRegistrationViewController *)segue.destinationViewController;
        vc.userId = self.userId;
        vc.userType = self.userType;
    }
}

@end
