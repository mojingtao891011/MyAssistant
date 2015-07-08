//
//  SubTaskCellTableViewCell.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/8.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "SubTaskCell.h"
#import "Task.h"
#import "SubTask.h"
#import "User.h"

@implementation SubTaskCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWithTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath taskModel:(Task*)taskModel
{
    SubTask *subTask = [taskModel.subTasks allObjects][indexPath.row - 1];
    self.subTaskName.text = subTask.subTaskName ;
    self.subTaskExecutor.text = subTask.executor.userName ;
    
    self.subTaskEndTime.text = [NSString stringWithFormat:@"%@截止",[Tool stringFromFomate:subTask.subTaskEndTime formate:@"MM月dd日"]];
}

- (IBAction)selectButtonAction:(UIButton *)sender {
    
    sender.selected = !sender.selected ;
}
@end
