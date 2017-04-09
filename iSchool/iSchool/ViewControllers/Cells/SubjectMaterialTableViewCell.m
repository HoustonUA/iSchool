//
//  SubjectMaterialTableViewCell.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/9/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "SubjectMaterialTableViewCell.h"

@interface SubjectMaterialTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *materialImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthorLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;

- (IBAction)downloadAction:(UIButton *)sender;

@end

@implementation SubjectMaterialTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark - Public

- (void)fillCellWithModel:(NSString *) tempVar {
    self.bookAuthorLabel.text = @"Ivanov Pavlo";
    self.bookNameLabel.text = @"Good Programming";
    self.materialImageView.image = [UIImage imageNamed:@"Section0"];
}

#pragma mark - Actions

- (IBAction)downloadAction:(UIButton *)sender {
}
@end
