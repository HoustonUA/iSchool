//
//  MarkTableViewCell.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/10/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "MarkTableViewCell.h"

@interface MarkTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *topViewWithDate;
@property (weak, nonatomic) IBOutlet UIView *markContainerView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *markLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeOfMarkLabel;

@property (weak, nonatomic) IBOutlet UIButton *descriptionButton;
@property (strong, nonatomic) NSString *markDescription;

- (IBAction)descriptionShowAction:(UIButton *)sender;

@end

@implementation MarkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.colorOfCell = [UIColor primaryColor];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(4.0f, 0);
    self.layer.shadowOpacity = 0.7f;
    self.layer.shadowRadius = 4.0f;
    self.layer.masksToBounds = false;
    [self layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Public

- (void)fillCellWithModel:(MarkModel *) model {

    self.dateLabel.text = model.date;
    self.markLabel.text = [model.mark stringValue];
    self.teacherNameLabel.text = model.teacherId;
    if([model.wasOnLesson isEqualToString:@"Present"]) {
        self.markContainerView.layer.borderColor = [UIColor greenColor].CGColor;
    } else if([model.wasOnLesson isEqualToString:@"Absent"]){
        self.markContainerView.layer.borderColor = [UIColor redColor].CGColor;
    } else if([model.wasOnLesson isEqualToString:@"Late"]){
        self.markContainerView.layer.borderColor = [UIColor customYellowColor].CGColor;
    }
    self.typeOfMarkLabel.text = model.typeOfMark;
    self.markDescription = model.markDescription;
}

#pragma mark - Private

- (void)setupUI {
    self.backgroundColor = [UIColor lightGrayColor];
    self.containerView.backgroundColor = self.colorOfCell;
    self.containerView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.topViewWithDate.backgroundColor = [UIColor mainColor];
    self.markContainerView.backgroundColor = [UIColor whiteColor];
    self.markContainerView.layer.cornerRadius = self.markContainerView.frame.size.width / 2;
    self.markContainerView.layer.borderWidth = 5.f;
}

- (UIAlertController *)createAlertController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Description" message:self.markDescription preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:okAction];
    
    return alertController;
}

#pragma mark - Actions

- (IBAction)descriptionShowAction:(UIButton *)sender {
    if([self.delegate conformsToProtocol:@protocol(MarkTableViewCellDelegate)]) {
        [self.delegate alertDidTappedOkButton:[self createAlertController]];
    }
}
@end
