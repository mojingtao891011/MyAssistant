//
//  SubRemindCell.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/9.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Schedule.h"

@interface SubRemindContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellTextLabel;

- (void)configureCellWithIndexPath:(NSIndexPath*)indexPath scheduleModel:(Schedule*)scheduleModel ;

@end
