//
//  TestAddTaskNameCell.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/5.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "TaskDetailNameCel.h"
#import "Task.h"

@implementation TaskDetailNameCel

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWithTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath taskModel:(Task*)taskModel
{
    //任务标题
    
    self.taskNameLabel.text = taskModel.taskName ;
    self.taskProgressBar.strokeStartValues = 0;
    self.taskProgressBar.strokeEndValues = 0;
    
}
@end
