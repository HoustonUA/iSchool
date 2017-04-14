//
//  RegistrationViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/13/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "RegistrationViewController.h"
#import "RegistrationDetailsViewController.h"
@import Firebase;

static NSString *const fromFirstRegistrationStepToSecondSegueIdentifier = @"fromFirstRegistrationStepToSecondSegueIdentifier";

@interface RegistrationViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *activationKeyTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (strong, nonatomic) NSString *userId;

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

#pragma mark - Private

- (void)setupUI {
    self.view.backgroundColor = [UIColor primaryColor];
    
}

#pragma mark - Actions

- (IBAction)nextButton:(UIButton *)sender {
    [[FIRAuth auth]
     createUserWithEmail:self.emailTextField.text
     password:self.passwordTextField.text
     completion:^(FIRUser *_Nullable user,
                  NSError *_Nullable error) {
         if(!error) {
             self.userId = user.uid;
             [self performSegueWithIdentifier:fromFirstRegistrationStepToSecondSegueIdentifier sender:nil];
         }
     }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    RegistrationDetailsViewController *vc = (RegistrationDetailsViewController *)segue.destinationViewController;
    vc.userId = self.userId;
}

@end
