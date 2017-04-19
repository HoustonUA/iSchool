//
//  TeacherPanelViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/9/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "TeacherPanelViewController.h"
#import "SectionCollectionViewCell.h"

typedef enum {
    Schedule = 0,
    Journals,
    MyClass,
    Materials,
    News,
    Settings
}SectionName;

static NSString *const fromTeacherPanelToJournalsSegueIdentifier = @"fromTeacherPanelToJournalsSegueIdentifier";

@interface TeacherPanelViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *sectionsNamesArray;

@end

@implementation TeacherPanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sectionsNamesArray = @[
                                @"Schedule", @"Journals", @"My Class", @"Materials",
                                @"News", @"Settings"
                                ];
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:PUPIL_USER_ID]);
    self.collectionView.backgroundColor = [UIColor primaryColor];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma  mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SectionCollectionViewCell class]) forIndexPath:indexPath];
    
    [cell setupCellWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Section%ld", indexPath.row]] andText:[self.sectionsNamesArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case Schedule:
            break;
        case Journals:
            [self performSegueWithIdentifier:fromTeacherPanelToJournalsSegueIdentifier sender:self];
            break;
        case MyClass:
            break;
        case Materials:
            break;
        case News:
            break;
        case Settings:
            break;
        default:
            break;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = self.view.bounds.size.width / 2 - 40;
    CGFloat height = (width * 3) / 4;
    
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(25, 20, 10, 20);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
