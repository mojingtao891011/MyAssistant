//
//  TestAddSubTaskCell.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/5.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "AddSubTaskContentCell.h"

@implementation AddSubTaskContentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWithTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath subTaskl:(SubTask*)subTask
{
    self.cellTextLabel.text = [NSString stringWithFormat:@"子任务%d" , (int)indexPath.row];
    self.execurtorLabel.text = subTask.subTaskName ;
}
@end
