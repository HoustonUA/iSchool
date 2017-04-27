//
//  MarkTableViewCell.h
//  iSchool
//
//  Created by Pavlo Ivanov on 4/10/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkModel.h"

@protocol MarkTableViewCellDelegate <NSObject>

- (void)alertDidTappedOkButton:(UIAlertController *) alertController;

@end

@interface MarkTableViewCell : UITableViewCell

@property (weak, nonatomic) id <MarkTableViewCellDelegate> delegate;
@property (strong, nonatomic) UIColor *colorOfCell;

- (void)fillCellWithModel:(MarkModel *) model;
- (void)setupUI;

@end
