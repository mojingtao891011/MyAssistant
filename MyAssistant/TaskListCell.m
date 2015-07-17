//
//  TestCell.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/17.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "TaskListCell.h"

@implementation TaskListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configurCellWithIndexPath:(NSIndexPath *)indexPath taskModel:(Task *)taskModel
{
    //
    switch (taskModel.taskTag.integerValue) {
        case 0:
            self.taskStateImageView.backgroundColor = SET_TASK_TAG0 ;
            break;
        case 1:
            self.taskStateImageView.backgroundColor = SET_TASK_TAG1 ;
            break;
        case 2:
            self.taskStateImageView.backgroundColor = SET_TASK_TAG2 ;
            break;
        case 3:
            self.taskStateImageView.backgroundColor = SET_TASK_TAG3 ;
            break;
        default:
            break;
    }
    
    //
    self.endTimeLabel.text = [NSString stringWithFormat:@"结束%@" , [Tool stringFromFomate:taskModel.taskEndTime formate:@"MM月dd日"]];
    
    //
    self.remainderTimeLabel.text = [self shengYuTime:taskModel.taskEndTime] ;
    
    //
    self.taskNameLabel.text = taskModel.taskName ;
    
    //
    self.taskProgressBar.strokeEndValues = [taskModel.taskProgress floatValue];
}
- (NSString*)shengYuTime:(NSDate *)endDate
{
    
    NSString *dateStr = nil  ;
    NSTimeInterval  seconds_f = [endDate timeIntervalSinceDate:[NSDate date]];
    CGFloat day_f = seconds_f / (24*60*60);
    if (day_f < 0) {
        dateStr = [NSString stringWithFormat:@"超出%0.0f天",day_f];
    }
    else if (day_f >0 && day_f < 1){
        dateStr= [NSString stringWithFormat:@"仅剩%0.0f小时" , seconds_f / (60*60)];
    }
    else {
        dateStr = [NSString stringWithFormat:@"还有%0.0f天" , day_f ];
    }
    
    
    return dateStr ;
}

@end
