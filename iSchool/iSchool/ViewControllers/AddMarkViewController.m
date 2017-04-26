//
//  AddMarkViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/26/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "AddMarkViewController.h"
#import "ClassService.h"
#import "MarkModel.h"

static NSString *const fromAddMarkToPupilMarksSegueIdentifier = @"fromAddMarkToPupilMarksSegueIdentifier";

@interface AddMarkViewController ()

@property (weak, nonatomic) IBOutlet UITextField *markTextField;
@property (weak, nonatomic) IBOutlet UITextField *markTypeTextField;
@property (weak, nonatomic) IBOutlet UITextView *markDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

- (IBAction)submitButtonAction:(UIButton *)sender;
- (IBAction)presentPupilSegmentControlValueChanged:(UISegmentedControl *)sender;
- (IBAction)cancelButtonAction:(UIButton *)sender;
- (IBAction)actionEditingChangedMark:(UITextField *)sender;

@property (strong, nonatomic) NSArray *stateOfPupilPresent;
@property (strong, nonatomic) NSString *isOnLesson;

@end

@implementation AddMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stateOfPupilPresent = @[@"Present", @"Absent", @"Late"];
    self.isOnLesson = [self.stateOfPupilPresent objectAtIndex:0];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)setupUI {
    self.markTypeTextField.enabled = NO;
    self.view.backgroundColor = [UIColor primaryColor];
    self.submitButton.backgroundColor = [UIColor customYellowColor];
    self.submitButton.layer.cornerRadius = 5.f;
    self.cancelButton.backgroundColor = [UIColor customYellowColor];
    self.cancelButton.layer.cornerRadius = 5.f;
    self.markDescriptionTextView.layer.cornerRadius = 5.f;
}

- (MarkModel *)createMarkModelWithMark:(NSNumber *) mark {
    MarkModel *markModel = [MarkModel new];
    markModel.mark = mark;
    markModel.teacherId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
    markModel.wasOnLesson = self.isOnLesson;
    markModel.date = [self getCurrentDate];
    markModel.typeOfMark = self.markTypeTextField.text;
    markModel.markDescription = self.markDescriptionTextView.text;
    
    return markModel;
}

- (NSString *) getCurrentDate {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMMM yyyy HH:mm"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

#pragma mark - Networking

- (void)addMarkWithModel:(MarkModel *) markModel withCompletion:(void(^)()) completion {
    ClassService *service = [ClassService new];
    [service addMarkWithModel:markModel forPupil:self.pupilUserId forSubject:self.subjectId fromClass:self.classId onSuccess:^{
        [self performSegueWithIdentifier:fromAddMarkToPupilMarksSegueIdentifier sender:nil];
    }];
}

- (IBAction)submitButtonAction:(UIButton *)sender {
    MarkModel *model = [self createMarkModelWithMark:[NSNumber numberWithInteger:[self.markTextField.text integerValue]]];
    [self addMarkWithModel:model withCompletion:nil];
}

- (IBAction)presentPupilSegmentControlValueChanged:(UISegmentedControl *)sender {
    self.isOnLesson = [self.stateOfPupilPresent objectAtIndex:sender.selectedSegmentIndex];
    if(sender.selectedSegmentIndex == 1) {
        self.markTextField.enabled = NO;
    } else {
        self.markTextField.enabled = YES;
    }
}

- (IBAction)cancelButtonAction:(UIButton *)sender {
    [self performSegueWithIdentifier:fromAddMarkToPupilMarksSegueIdentifier sender:nil];
}

- (IBAction)actionEditingChangedMark:(UITextField *)sender {
    if(![sender.text isEqualToString:@""]) {
        self.markTypeTextField.enabled = YES;
    } else {
        self.markTypeTextField.enabled = NO;
        self.markTypeTextField.text = @"";
    }
}

@end
