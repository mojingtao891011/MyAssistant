//
//  TestAddTaskNameCell.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/5.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "TaskDetailNameCell.h"
#import "Task.h"

@implementation TaskDetailNameCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)taskStateAction:(UIButton *)sender {
    sender.selected = !sender.selected ;
    
    if (_delegate && [_delegate respondsToSelector:@selector(setTaskState:)]) {
        [_delegate setTaskState:sender.selected];
    }
}

- (void)configureCellWithTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath taskModel:(Task*)taskModel
{
    //任务标题
    self.TaskStateButton.selected = taskModel.taskIsFininsh.boolValue;
    self.taskNameLabel.text = taskModel.taskName ;
    self.taskProgressBar.strokeStartValues = 0;
    self.taskProgressBar.strokeEndValues =[taskModel.taskEndTime timeIntervalSinceDate:[NSDate date]]/[taskModel.taskEndTime timeIntervalSinceDate:taskModel.taskStartTime];
    self.taskProgressBar.labelTitle = [self shengYuTime:taskModel.taskEndTime];
    
    self.squareProgressBar.progressValue = [taskModel.taskProgress floatValue];
    
    
}
- (NSString*)shengYuTime:(NSDate *)endDate
{
    
    NSString *dateStr = nil  ;
    NSTimeInterval  seconds_f = [endDate timeIntervalSinceDate:[NSDate date]];
    CGFloat day_f = seconds_f / (24*60*60);
    if (day_f < 0) {
        dateStr = [NSString stringWithFormat:@"%0.0f天",day_f];
    }
    else if (day_f >0 && day_f < 1){
        dateStr= [NSString stringWithFormat:@"%0.0f小时" , seconds_f / (60*60)];
    }
    else {
        dateStr = [NSString stringWithFormat:@"%0.0f天" , day_f ];
    }
    
    
    return dateStr ;
}
@end
