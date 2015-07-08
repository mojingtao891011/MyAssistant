//
//  TodayScheduleCell.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/23.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "TodayScheduleCell.h"

@implementation TodayScheduleCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@synthesize myschedule = _myschedule ;
- (void)setMyschedule:(Schedule *)myschedule
{
    if (_myschedule != myschedule) {
        _myschedule = myschedule ;
    }
    NSString *startStr =[Tool stringFromFomate:_myschedule.schedulestartTime formate:@"HH:mm"] ;
    NSString *endStr = [Tool stringFromFomate:_myschedule.scheduleEndTime formate:@"HH:mm"] ;
    self.scheduleTimeLabel.text = [NSString stringWithFormat:@"%@~%@" , startStr , endStr];
    self.scheduldTitleLabel.text = _myschedule.scheduleName ;
    
}
@end
