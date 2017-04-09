//
//  SubjectTableViewCell.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/9/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "SubjectTableViewCell.h"

@interface SubjectTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *subjectNameLabel;

@end

@implementation SubjectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public

- (void)fillCellWithSubjectName:(NSString *) subjectName {
    
    self.subjectNameLabel.text = subjectName;
}

@end
