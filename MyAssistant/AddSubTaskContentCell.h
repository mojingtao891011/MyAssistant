//
//  TestAddSubTaskCell.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/5.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubTask.h"

@interface AddSubTaskContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *execurtorLabel;

- (void)configureCellWithTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath subTaskl:(SubTask*)subTask ;

@end
