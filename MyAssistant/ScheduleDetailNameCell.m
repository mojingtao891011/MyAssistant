//
//  ScheduleDetailNameCell.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/10.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "ScheduleDetailNameCell.h"

@implementation ScheduleDetailNameCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath scheduleModel:(Schedule *)scheduleModel
{
    self.scheduleName.text = scheduleModel.scheduleName ;
    
    NSString *startime = [Tool stringFromFomate:scheduleModel.schedulestartTime formate:@"HH:mm"];
    NSString *endtime = [Tool stringFromFomate:scheduleModel.scheduleEndTime formate:@"HH:mm"];
    self.scheduleTime.text = [NSString stringWithFormat:@"开始%@-结束%@" , startime , endtime];
    
    self.scheduleYear.text = [Tool stringFromFomate:scheduleModel.scheduleCreatTime formate:@"yyyy年MM月dd日"];
    
    if (scheduleModel.scheduleAddress) {
        self.scheduleAddress.text = scheduleModel.scheduleAddress ;
    
    }else{
        self.scheduleAddress.text = @"无";
    }
}
@end
