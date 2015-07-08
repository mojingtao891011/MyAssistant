//
//  TestAddTaskNameCell.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/5.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRoundProgressBar.h"

@class Task ;

@interface TaskDetailNameCel : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *TaskStateButton;
@property (weak, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (weak, nonatomic) IBOutlet MRoundProgressBar *taskProgressBar;

- (void)configureCellWithTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath taskModel:(Task*)taskModel ;

@end
