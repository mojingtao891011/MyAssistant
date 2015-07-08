//
//  TestAddTaskTwoCell.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/5.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "TaskDetailContentCell.h"
#import "User.h"

@implementation TaskDetailContentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}
- (void)configureCellWithTable:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath taskModel:(Task*)taskModel
{
    //
    if (indexPath.section == 0) {
        //执行时间
        if (indexPath.row == taskModel.subTasks.count +1) {
            
            self.cellImageView.image = [UIImage imageNamed:@"rili"];
            
            //判断是否是今年 、今天
            NSString *startString = nil ;
            NSString *endString = nil ;
            NSDate *startTime = taskModel.taskStartTime ;
            NSDate *endTime = taskModel.taskEndTime ;
            //开始时间
            if ([startTime isThisYear]) {
                startString = [Tool stringFromFomate:startTime formate:@"MM月dd日"];
            }
            else{
                startString = [Tool stringFromFomate:startTime formate:@"yyyy年MM月dd日"] ;
            }
            
            if ([startTime isToday]) {
                startString = @"今天";
            }
            //结束时间
            if ([endTime isThisYear]) {
                endString = [Tool stringFromFomate:endTime formate:@"MM月dd日"] ;
            }
            else{
                endString = [Tool stringFromFomate:endTime formate:@"yyyy年MM月dd日"] ;
            }
            
            //开始时间、结束时间都是今天(今天00:15-0630)
            if ([startTime isToday] &&[endTime isToday] ) {
                startString  = [NSString stringWithFormat:@"今天%@",[Tool stringFromFomate:startTime formate:@"HH:mm"]];
                endString = [Tool stringFromFomate:endTime formate:@"HH:mm"] ;
            }
            
            self.cellTextLabel.text = [NSString stringWithFormat:@"%@-%@" , startString , endString];
            self.cellEndTextLabel.text = @"";

            
        }
        //执行者
        else if (indexPath.row == taskModel.subTasks.count +2){
            self.cellImageView.image = [UIImage imageNamed:@"zhixingzhe"];
            self.cellTextLabel.text = @"执行者";
            self.cellEndTextLabel.text = taskModel.executor.userName ;
        }

    }
    //
    else if (indexPath.section == 1){
        
        self.cellImageView.image = [UIImage imageNamed:@"canyuzhe"];
        
        self.cellTextLabel.text = @"参与者";
    
        //参与者
        
        NSArray * followers = [taskModel.followers allObjects];
        NSMutableString *appNameStr = [NSMutableString new];
        for (User *user in followers) {
            [appNameStr appendFormat:@" %@" , user.userName];
        }
        
        self.cellEndTextLabel.text = appNameStr ;
    }
    
    else if (indexPath.section == 3){
        self.cellImageView.image = [UIImage imageNamed:@"fujian"];
        self.cellTextLabel.text = @"附件";
        self.cellEndTextLabel.text = [NSString stringWithFormat:@"%d" , (int)taskModel.annexs.count ];
    }
  
}
@end
