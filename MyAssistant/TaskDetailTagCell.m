//
//  TestAddTaskThreeCell.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/5.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "TaskDetailTagCell.h"

@implementation TaskDetailTagCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWithTable:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath taskModel:(Task*)taskModel
{
    self.cellTextLabel.text = @"普通";
    self.cellImageView.image = [UIImage imageNamed:@"biaoqian"];
    
    int taskTag = [taskModel.taskTag intValue];
    switch (taskTag) {
        case 0:
            
            self.stateImageView.backgroundColor =SET_TASK_TAG0  ;
            break;
        case 1:
            
            self.stateImageView.backgroundColor = SET_TASK_TAG1 ;
            break;
        case 2:
          
            self.stateImageView.backgroundColor = SET_TASK_TAG2 ;
            break;
        case 3:
            
            self.stateImageView.backgroundColor = SET_TASK_TAG3 ;
            break;
            
        default:
            break;
    }

}
@end
