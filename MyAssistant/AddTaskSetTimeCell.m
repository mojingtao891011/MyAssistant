//
//  TestAddTaskCell.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/5.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "AddTaskSetTimeCell.h"

@implementation AddTaskSetTimeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)configureCellWithTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row != 0) {
            NSArray *textStrArr = @[@"设置时间" ,@"执行者" ];
            NSArray *arr = @[@"rili" , @"zhixingzhe"];
            self.cellTextLabel.text = textStrArr[indexPath.row - 1];
            self.cellImageView.image = [UIImage imageNamed:arr[indexPath.row - 1]];
        }
    }
    else if(indexPath.section == 1){
        self.cellTextLabel.text = @"参与者";
        self.cellImageView.image = [UIImage imageNamed:@"canyuzhe"];
    }
    else if (indexPath.section == 2){
        self.cellTextLabel.text = @"普通";
        self.cellImageView.image = [UIImage imageNamed:@"biaoqian"];
        
    }
    else if (indexPath.section == 3){
        self.cellTextLabel.text = @"附件" ;
        self.cellImageView.image = [UIImage imageNamed:@"fujian"];
    }
    else if (indexPath.section == 4 ){
        self.cellTextLabel.text = @"子任务" ;
        self.cellImageView.image = [UIImage imageNamed:@"zirenwu"];
    }
    
    if (indexPath.section == 2) {
        self.taskTagLabel.backgroundColor = SET_TASK_TAG0 ;
        self.taskTagLabel.hidden = NO ;
    }
    else{
        self.taskTagLabel.hidden = YES ;
    }
}

@end
