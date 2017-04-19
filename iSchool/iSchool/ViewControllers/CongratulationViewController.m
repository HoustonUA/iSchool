//
//  CongratulationViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/19/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "CongratulationViewController.h"

static NSString *const fromCongratulationsToLoginSegueIdentifier = @"fromCongratulationsToLoginSegueIdentifier";

@interface CongratulationViewController ()

@property (weak, nonatomic) IBOutlet UILabel *motivationLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmationButton;

- (IBAction)confirmAction:(UIButton *)sender;

@end

@implementation CongratulationViewController

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
    self.confirmationButton.backgroundColor = [UIColor customYellowColor];
    self.confirmationButton.layer.cornerRadius = 5.f;
    self.motivationLabel.text = [NSString stringWithFormat:@"%@, let's build our future together", self.userName];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)confirmAction:(UIButton *)sender {
    [self performSegueWithIdentifier:fromCongratulationsToLoginSegueIdentifier sender:nil];
}
@end
