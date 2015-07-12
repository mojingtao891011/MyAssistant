//
//  TestAddTaskCell.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/5.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "AddTaskSetTimeCell.h"
#import "User.h"

@implementation AddTaskSetTimeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)configureCellWithTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath taskModel:(Task*)taskModel
{
    if (indexPath.section == 0) {
        if (indexPath.row != 0) {
            
            NSString *setTime = nil ;
            if (taskModel.taskStartTime) {
                NSString *startString = [Tool dateToString:taskModel.taskStartTime isShowToday:YES];
                NSString *endString = [Tool dateToString:taskModel.taskEndTime isShowToday:NO];
                setTime = [NSString stringWithFormat:@"%@ - %@" , startString , endString];
            }
            else{
                setTime = @"设置时间" ;
            }
            
            NSArray *textStrArr = @[ setTime,@"执行者" ];
            NSArray *arr = @[@"rili" , @"zhixingzhe"];
            self.cellTextLabel.text = textStrArr[indexPath.row - 1];
            self.cellImageView.image = [UIImage imageNamed:arr[indexPath.row - 1]];
            
            if (indexPath.row == 2 && taskModel.executor) {
                self.cellEndTextLabel.text = taskModel.executor.userName ;
            }
        }
    }
    else if(indexPath.section == 1){
        self.cellTextLabel.text = @"参与者";
        self.cellImageView.image = [UIImage imageNamed:@"canyuzhe"];
        
        if (taskModel.followers.count != 0) {
            NSMutableString *mutableStr = [NSMutableString new];
            for (User *user in taskModel.followers) {
                [mutableStr appendFormat:@"%@ " , user.userName];
            }
            self.cellEndTextLabel.text = mutableStr ;
        }
        
    }
    else if (indexPath.section == 2){
        self.cellTextLabel.text = @"普通";
        self.cellImageView.image = [UIImage imageNamed:@"biaoqian"];
        self.widthConstraint.constant = 21 ;
        
        switch (taskModel.taskTag.integerValue) {
            case 0:
                self.cellEndTextLabel.backgroundColor = SET_TASK_TAG0 ;
                break;
            case 1:
                  self.cellEndTextLabel.backgroundColor = SET_TASK_TAG1 ;
                break;
            case 2:
                  self.cellEndTextLabel.backgroundColor = SET_TASK_TAG2 ;
                break;
            case 3:
                  self.cellEndTextLabel.backgroundColor = SET_TASK_TAG3 ;
                break;
                
            default:
                break;
        }
        
    }
    else if (indexPath.section == 3){
        self.cellTextLabel.text = @"附件" ;
        self.cellImageView.image = [UIImage imageNamed:@"fujian"];
        
        self.cellEndTextLabel.text = [NSString stringWithFormat:@"%d" , (int)taskModel.annexs.count];
    }
    else if (indexPath.section == 4 ){
        self.cellTextLabel.text = @"子任务" ;
        self.cellImageView.image = [UIImage imageNamed:@"zirenwu"];
    }
    
    if (indexPath.section == 2) {
        self.taskTagLabel.backgroundColor = SET_TASK_TAG0 ;
        self.taskTagLabel.hidden = NO ;
         self.widthConstraint.constant = 21 ;
    }
    else{
        self.taskTagLabel.hidden = YES ;
         self.widthConstraint.constant = 163 ;
    }
}

@end
