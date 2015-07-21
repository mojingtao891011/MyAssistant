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
    if (_delegate && [_delegate respondsToSelector:@selector(scheduleState:indexPath:)]) {
        [_delegate scheduleState:sender.selected indexPath:self.indexPath];
    }
}

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath scheduleModel:(Schedule *)scheduleModel
{
    self.indexPath = indexPath ;
    //
    NSString *startTime = [Tool stringFromFomate:scheduleModel.schedulestartTime formate:@"HH:mm"];
    NSString *endtime = [Tool stringFromFomate:scheduleModel.scheduleEndTime formate:@"HH:mm"];
    self.scheduleTimeLabel.text = [NSString stringWithFormat:@"%@~%@" , startTime , endtime];
    
    //
    self.scheduleNameLabel.text = scheduleModel.scheduleName ;
    
    //
    self.scheduleStateButton.selected = [scheduleModel.scheduleIsFininsh boolValue];
}
@end
