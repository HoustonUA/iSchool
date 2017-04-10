//
//  PupilPanelViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/9/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "PupilPanelViewController.h"
#import "SectionCollectionViewCell.h"
#import "JournalViewController.h"

typedef enum {
    Journal = 0,
    Schedule,
    Materials,
    Notices,
    News,
    MyClass,
    Parents,
    Settings
}SectionName;

static NSString *const fromMainPupilToJournalSegueUdentifier = @"fromMainPupilToJournalSegueUdentifier";
static NSString *const fromMainPupilToScheduleSegueIdentifier = @"fromMainPupilToScheduleSegueIdentifier";
static NSString *const fromPupilMainPanelToNitocesSegueIdentifier = @"fromPupilMainPanelToNitocesSegueIdentifier";
static NSString *const fromPupilMainPanelToProfileSegueIdentifier = @"fromPupilMainPanelToProfileSegueIdentifier";

@interface PupilPanelViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSArray *sectionsNamesArray;
@property (assign, nonatomic) cellActionType lActionType;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)profileBarButtonItem:(UIBarButtonItem *)sender;

@end

@implementation PupilPanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sectionsNamesArray = @[
                                @"Journal", @"Schedule", @"Materials", @"Notices",
                                @"News", @"My Class", @"Settings", @"Parents"
                                ];
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"]);
    self.collectionView.backgroundColor = [UIColor primaryColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma  mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PupilPanelViewController class]) forIndexPath:indexPath];
    
    [cell setupCellWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Section%ld", indexPath.row]] andText:[self.sectionsNamesArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma  mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.row) {
        case Journal:
            self.lActionType = toSubjectViewController;
            [self performSegueWithIdentifier:fromMainPupilToJournalSegueUdentifier sender:self];
            break;
        case Schedule:
            [self performSegueWithIdentifier:fromMainPupilToScheduleSegueIdentifier sender:self];
            break;
        case Materials:
            self.lActionType = toSchoolMaterialsViewController;
            [self performSegueWithIdentifier:fromMainPupilToJournalSegueUdentifier sender:self];
            break;
        case Notices:
            [self performSegueWithIdentifier:fromPupilMainPanelToNitocesSegueIdentifier sender:self];
            break;
        case News:
            break;
        case MyClass:
            break;
        case Parents:
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:fromMainPupilToJournalSegueUdentifier]) {
        JournalViewController *vc = (JournalViewController *)segue.destinationViewController;
        vc.actionType = self.lActionType;
    } else if ([segue.identifier isEqualToString:fromPupilMainPanelToProfileSegueIdentifier]) {
        
    }
}

#pragma mark - Actions

- (IBAction)profileBarButtonItem:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:fromPupilMainPanelToProfileSegueIdentifier sender:self];
}
@end
