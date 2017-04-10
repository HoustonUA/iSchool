//
//  MarkTableViewCell.h
//  iSchool
//
//  Created by Pavlo Ivanov on 4/10/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkModel.h"

@interface MarkTableViewCell : UITableViewCell

- (void)fillCellWithModel:(MarkModel *) model;

@end
