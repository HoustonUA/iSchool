//
//  SubjectMaterialTableViewCell.h
//  iSchool
//
//  Created by Pavlo Ivanov on 4/9/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaterialModel.h"

@interface SubjectMaterialTableViewCell : UITableViewCell

- (void)fillCellWithModel:(MaterialModel *) model;

@end
