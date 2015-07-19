//
//  ScheduleListCell.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/17.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "ScheduleListCell.h"

@implementation ScheduleListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)scheduleStateAction:(UIButton *)sender {
    sender.selected = !sender.selected ;
}

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath scheduleModel:(Schedule *)scheduleModel
{
    //
    NSString *startTime = [Tool stringFromFomate:scheduleModel.schedulestartTime formate:@"HH:mm"];
    NSString *endtime = [Tool stringFromFomate:scheduleModel.scheduleEndTime formate:@"HH:mm"];
    self.scheduleTimeLabel.text = [NSString stringWithFormat:@"%@~%@" , startTime , endtime];
    
    //
    self.scheduleNameLabel.text = scheduleModel.scheduleName ;
    
    //
}
@end
