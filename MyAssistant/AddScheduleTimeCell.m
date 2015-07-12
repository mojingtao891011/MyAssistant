//
//  AddScheduleCellStyle2.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/5.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "AddScheduleTimeCell.h"


@implementation AddScheduleTimeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWith:(UITableView*)tableView  indexPath:(NSIndexPath*)indexPath scheduleModel:(Schedule*)scheduleModel
{
    NSString *startStr = [Tool stringFromFomate:scheduleModel.schedulestartTime formate:@"MM月dd日"];
    NSString *endStr = [Tool stringFromFomate:scheduleModel.scheduleEndTime formate:@"MM月dd日"];
    
    //start
    
    self.startDayLabel.text = [NSString stringWithFormat:@"%@  %@" ,startStr , [Tool curDateOfWeek:scheduleModel.schedulestartTime]];
    self.startTimeLabel.text = [NSString stringWithFormat:@"开始  %@",[Tool stringFromFomate:scheduleModel.schedulestartTime formate:@"HH:mm"]];
    
    //end
    self.endDayLabel.text = [NSString stringWithFormat:@"%@  %@" ,endStr , [Tool curDateOfWeek:scheduleModel.scheduleEndTime]];
    self.endTimeLabel.text =  [NSString stringWithFormat:@"结束  %@",[Tool stringFromFomate:scheduleModel.scheduleEndTime formate:@"HH:mm"]];
}
@end
