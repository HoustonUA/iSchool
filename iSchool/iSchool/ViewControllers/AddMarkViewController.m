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

@interface AddMarkViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

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
@property (strong, nonatomic) NSArray *typeOfMark;
@property (strong, nonatomic) NSString *isOnLesson;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIToolbar *toolbar;

@end

@implementation AddMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stateOfPupilPresent = @[@"Present", @"Absent", @"Late"];
    self.typeOfMark = @[@"In Class (verbally)", @"In Class (writing)", @"Homework",
                        @"Dictation", @"Independent Work", @"Individual Work",
                        @"Lab", @"Composition", @"Control Work", @"Mark By The Topic", @"Semester Mark"];
    self.isOnLesson = [self.stateOfPupilPresent objectAtIndex:0];
    [self setupPickerView];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setupUI {
    self.markTypeTextField.inputView = self.pickerView;
    self.markTypeTextField.inputAccessoryView = self.toolbar;
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
    [self.markTypeTextField resignFirstResponder];
}

- (void)cancelAction:(id) sender {
    self.markTypeTextField.text = @"";
    [self.markTypeTextField resignFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.typeOfMark count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.typeOfMark objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.markTypeTextField.text = [self.typeOfMark objectAtIndex:row];
}

#pragma mark - Actions

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
