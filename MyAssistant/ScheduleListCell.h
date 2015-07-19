//
//  ScheduleListCell.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/17.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Schedule.h"

@interface ScheduleListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *scheduleTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scheduleNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *scheduleStateButton;

- (IBAction)scheduleStateAction:(UIButton *)sender;
- (void)configureCellWithIndexPath:(NSIndexPath*)indexPath scheduleModel:(Schedule*)scheduleModel ;

@end
