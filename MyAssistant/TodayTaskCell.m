//
//  TodayTaskCell.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/23.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "TodayTaskCell.h"


@implementation TodayTaskCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@synthesize myTask = _myTask ;
- (void)setMyTask:(Task *)myTask
{
    if (_myTask != myTask) {
        _myTask = myTask ;
    }
    
    self.taskNameLabel.text = _myTask.taskName ;
    NSString *endStr = [Tool stringFromFomate:_myTask.taskEndTime formate:@"MM月dd日"];
    self.taskEndtimeLabel.text =[NSString stringWithFormat:@"结束%@",endStr] ;
    
    self.taskStateView.labelFontSize = 7.0 ;
    

    NSTimeInterval  seconds_f = [_myTask.taskEndTime timeIntervalSinceDate:[NSDate date]];
    CGFloat day_f = seconds_f / (24*60*60);
    if (day_f < 0) {
        self.taskEndDayLabel.text = [NSString stringWithFormat:@"超出%0.0f天" , day_f * -1];
    }
    else if (day_f >0 && day_f < 1){
        self.taskEndDayLabel.text = [NSString stringWithFormat:@"还剩%0.0f小时" , seconds_f / (60*60)];
    }
    else {
        self.taskEndDayLabel.text = [NSString stringWithFormat:@"还剩%0.0f天" , day_f ];
    }
}
@end
