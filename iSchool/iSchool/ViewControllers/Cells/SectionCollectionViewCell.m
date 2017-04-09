//
//  SectionCollectionViewCell.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/9/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "SectionCollectionViewCell.h"

IB_DESIGNABLE

@interface SectionCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *sectionImage;
@property (weak, nonatomic) IBOutlet UILabel *sectionNameLabel;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) NSMutableArray *customConstraints;

@end

@implementation SectionCollectionViewCell

- (void)setupCellWithImage:(UIImage *)image andText:(NSString *)text {
    self.sectionImage.image = image;
    self.sectionNameLabel.text = text;
}

#pragma mark - Private

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ([super initWithCoder:aDecoder]) {
        [self setupXib];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self setupXib];
    }
    return self;
}

- (UIView *)loadViewFromNib {
    NSBundle *bundle = [NSBundle bundleForClass:[SectionCollectionViewCell class]];
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([SectionCollectionViewCell class]) bundle:bundle];
    UIView *view = [[nib instantiateWithOwner:self options:nil] firstObject];
    
    return view;
}


- (void)setupXib {
    UIView *view = [self loadViewFromNib];
    self.customConstraints = [NSMutableArray new];
    
    if (view != nil) {
        self.containerView = view;
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        NSDictionary *views = NSDictionaryOfVariableBindings(view);
        
        [self.customConstraints addObjectsFromArray:
         [NSLayoutConstraint constraintsWithVisualFormat:
          @"H:|[view]|" options:0 metrics:nil views:views]];
        [self.customConstraints addObjectsFromArray:
         [NSLayoutConstraint constraintsWithVisualFormat:
          @"V:|[view]|" options:0 metrics:nil views:views]];
        
        [NSLayoutConstraint activateConstraints:self.customConstraints];
       // [self settingUI];
    }
}

@end
