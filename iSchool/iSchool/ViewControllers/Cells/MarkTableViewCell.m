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


@end

@implementation MarkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Public

- (void)fillCellWithModel:(MarkModel *) model {
    
    self.dateLabel.text = [model.date stringValue];
    self.markLabel.text = [model.mark stringValue];
    self.teacherNameLabel.text = model.teacher;
}

#pragma mark - Private

- (void)setupUI {
    self.backgroundColor = [UIColor lightGrayColor];
    self.containerView.backgroundColor = [UIColor primaryColor];
    self.containerView.layer.borderWidth = 1.f;
    self.containerView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.topViewWithDate.backgroundColor = [UIColor mainColor];
    self.markContainerView.backgroundColor = [UIColor whiteColor];
    self.markContainerView.layer.cornerRadius = self.markContainerView.frame.size.width / 2;
    self.markContainerView.layer.borderWidth = 2.f;
    self.markContainerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

@end
