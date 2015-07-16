//
//  TestAddTaskNameCell.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/5.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRoundProgressBar.h"
#import "MSquareProgressBar.h"

@class Task ;
@protocol TaskDetailNameCellDelegate <NSObject>

- (void)setTaskState:(BOOL)isFinish;

@end

@interface TaskDetailNameCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *TaskStateButton;
@property (weak, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (weak, nonatomic) IBOutlet MRoundProgressBar *taskProgressBar;
@property (weak, nonatomic) IBOutlet MSquareProgressBar *squareProgressBar;
@property (nonatomic , assign)id<TaskDetailNameCellDelegate>delegate ;

- (IBAction)taskStateAction:(UIButton *)sender;

- (void)configureCellWithTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath taskModel:(Task*)taskModel ;

@end
