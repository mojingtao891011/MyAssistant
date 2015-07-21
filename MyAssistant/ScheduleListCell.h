//
//  ScheduleListCell.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/17.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Schedule.h"

@protocol ScheduleListCellDelegate <NSObject>

- (void)scheduleState:(BOOL)isFininsh indexPath:(NSIndexPath*)indexPath ;

@end
@interface ScheduleListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *scheduleTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scheduleNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *scheduleStateButton;
@property (nonatomic , assign)id<ScheduleListCellDelegate>delegate ;
@property (nonatomic, copy)NSIndexPath      *indexPath ;

- (IBAction)scheduleStateAction:(UIButton *)sender;
- (void)configureCellWithIndexPath:(NSIndexPath*)indexPath scheduleModel:(Schedule*)scheduleModel ;

@end
