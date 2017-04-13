//
//  SubjectMaterialTableViewCell.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/9/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "SubjectMaterialTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@import Firebase;

@interface SubjectMaterialTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *materialImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthorLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;

@property (strong, nonatomic) NSString *bookUrlString;

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

- (void)fillCellWithModel:(MaterialModel *) model {
    self.bookUrlString = model.downloadUrl;
    self.bookAuthorLabel.text = model.author;
    self.bookNameLabel.text = model.bookName;
    NSURL *imageUrl = [NSURL URLWithString:model.imageUrl];
    [self.materialImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"Section0"]];
    self.downloadButton.layer.cornerRadius = 5.f;
    self.downloadButton.layer.borderWidth = 3.f;
    self.downloadButton.layer.borderColor = [UIColor mainColor].CGColor;
    self.downloadButton.backgroundColor = [UIColor primaryColor];
}

#pragma mark - Actions

- (IBAction)downloadAction:(UIButton *)sender {
    NSURL *downloadUrl = [NSURL URLWithString:self.bookUrlString];
    [[UIApplication sharedApplication] openURL:downloadUrl];
}
@end
