//
//  TodayScheduleCell.h
//  MyAssistant
//
//  Created by taomojingato on 15/6/23.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Schedule.h"

@interface TodayScheduleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *scheduleTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scheduldTitleLabel;

@property (nonatomic , retain)Schedule      *myschedule ;

@end
