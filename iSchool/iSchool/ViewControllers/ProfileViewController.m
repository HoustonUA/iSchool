//
//  ProfileViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/10/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserModel.h"
#import "UserService.h"
#import "ClassService.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewOnTopOfScreen;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *detailsContainerView;
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *parentLabel;
@property (weak, nonatomic) IBOutlet UILabel *parentPhoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (strong, nonatomic) UserModel *userModel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showLoader];
    [self getProfileDetailInfoWithCompletion:^(UserModel *userModel) {
        [self fillViewWithModel:userModel];
        [self hideLoader];
    }];
    [self getClassName];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)setupUI {
    self.viewOnTopOfScreen.backgroundColor = [UIColor mainColor];
    self.view.backgroundColor = [UIColor primaryColor];
    self.profilePhotoImageView.layer.cornerRadius = self.profilePhotoImageView.frame.size.height / 2;
    
    self.editButton.layer.cornerRadius = 4.f;
    self.editButton.backgroundColor = [UIColor customYellowColor];
    self.profilePhotoImageView.layer.borderWidth = 4.f;
    self.profilePhotoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.detailsContainerView.backgroundColor = [UIColor whiteColor];
    self.detailsContainerView.layer.cornerRadius = 10.f;
    self.detailsContainerView.layer.borderWidth = 1.f;
    self.detailsContainerView.layer.borderColor = [UIColor darkGrayColor].CGColor;
}

- (void)fillViewWithModel:(UserModel *) model {
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", model.surname, model.name];
    self.phoneNumberLabel.text = model.phone;
    self.birthdayLabel.text = [model.birthday stringValue];
    self.parentLabel.text = model.parentOne;
    self.parentPhoneNumberLabel.text = model.parentsPhone;
}

#pragma mark - Networking

- (void)getClassName {
    ClassService *service = [ClassService new];
    NSString *classId = [[NSUserDefaults standardUserDefaults] objectForKey:PUPIL_CLASS_ID];
    [service getNameOfClass:classId onSuccess:^(NSString *className) {
        self.classNameLabel.text = className;
    }];
}

- (void)getProfileDetailInfoWithCompletion:(void(^)(UserModel *userModel)) completion {
    UserService *service = [UserService new];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    [service getPupilProfileInfoWithUserId:userId onSuccess:^(UserModel *userModel) {
        self.userModel = userModel;
        if(completion) {
            completion(userModel);
        }
    }];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
