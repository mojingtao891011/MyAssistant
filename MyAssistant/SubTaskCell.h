//
//  SubTaskCellTableViewCell.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/8.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSquareProgressBar.h"

@class  Task ;
@interface SubTaskCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *subTaskName;
@property (weak, nonatomic) IBOutlet UILabel *subTaskExecutor;
@property (weak, nonatomic) IBOutlet MSquareProgressBar *subtaskProgress;
@property (weak, nonatomic) IBOutlet UILabel *subTaskEndTime;

- (void)configureCellWithTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath taskModel:(Task*)taskModel ;
- (IBAction)selectButtonAction:(UIButton *)sender;

@end
