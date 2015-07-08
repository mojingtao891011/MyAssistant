//
//  AddScheduleCellStyle3.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/5.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Schedule.h"

@interface AddScheduleCellStyle3 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellSubTextLabel;

- (void)configureCellWithTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath  scheduleModel:(Schedule*)scheduleModel ;

@end
