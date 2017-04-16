//
//  PupilMarksViewController.m
//  iSchool
//
//  Created by Pavlo Ivanov on 4/16/17.
//  Copyright © 2017 Pavel Ivanov. All rights reserved.
//

#import "PupilMarksViewController.h"
#import "ClassService.h"
#import "MarkModel.h"
#import "UserService.h"
#import "MarkTableViewCell.h"

@interface PupilMarksViewController () <UITabBarDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)addMarkAction:(UIBarButtonItem *)sender;

@property (strong, nonatomic) NSArray *marksModels;

@end

@implementation PupilMarksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self getMarksModels];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)setupUI {
    self.navigationItem.title = self.pupilName;
}

- (MarkModel *)createMarkModelWithMark:(NSNumber *) mark {
    MarkModel *markModel = [MarkModel new];
    markModel.mark = mark;
    markModel.teacherId = [[NSUserDefaults standardUserDefaults] objectForKey:PUPIL_USER_ID];
    markModel.wasOnLesson = TRUE;
    markModel.date = [self getCurrentDate];
    
    return markModel;
}

- (NSString *) getCurrentDate {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

#pragma mark - Networking

- (void)getMarksModels {
    dispatch_group_t serviceGroup = dispatch_group_create();
    dispatch_group_enter(serviceGroup);
    [self getMarkOfUserWithCompletion:^{
        dispatch_group_leave(serviceGroup);
    }];
    
    dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
        [self getTeachersOfMarksWithCompletion:^{
            [self.tableView reloadData];
        }];
    });
}

- (void)getMarkOfUserWithCompletion:(void(^)()) completion {
    ClassService *service = [ClassService new];
    [service getMarkForUser:self.pupilUserId fromClass:self.classId forSubject:self.subjectId onSuccess:^(NSMutableArray *marks) {
        self.marksModels = [[NSArray alloc] initWithArray:marks];
        if(completion) {
            completion();
        }
    }];
}

- (void)getTeachersOfMarksWithCompletion:(void(^)()) completion {
    
    UserService *service = [UserService new];
    for (MarkModel *model in self.marksModels) {
        [service getTeacherProfileInfoWithUserId:model.teacherId onSuccess:^(TeacherModel *teacherModel) {
            model.teacherId = [NSString stringWithFormat:@"%@ %@ %@", teacherModel.surname, teacherModel.name, teacherModel.middlename];
            if(model == self.marksModels.lastObject) {
                if(completion) {
                    completion();
                }
            }
        }];
    }
}

- (void)addMarkWithModel:(MarkModel *) markModel withCompletion:(void(^)()) completion {
    ClassService *service = [ClassService new];
    [service addMarkWithModel:markModel forPupil:self.pupilUserId forSubject:self.subjectId fromClass:self.classId onSuccess:^{
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.marksModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MarkTableViewCell class]) forIndexPath:indexPath];
    
    [cell fillCellWithModel:[self.marksModels objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - Actions

- (IBAction)addMarkAction:(UIBarButtonItem *)sender {
    [self showAlertWithMarkInput];
}

- (void)showAlertWithMarkInput {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Set Mark"
                                                                              message: @"Input pupil mark"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    __block UITextField *tempTextField;
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        tempTextField = textField;
        textField.placeholder = @"Mark";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.textAlignment = NSTextAlignmentCenter;
    }];

    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if(![tempTextField.text isEqualToString:@""]) {
            NSNumber *mark = [NSNumber numberWithInteger:[tempTextField.text integerValue]];
            MarkModel *model = [self createMarkModelWithMark:mark];
            [self addMarkWithModel:model withCompletion:nil];
        }
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
