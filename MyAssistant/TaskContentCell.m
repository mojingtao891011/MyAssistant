//
//  ContentCell.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/19.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "TaskContentCell.h"
#import "User.h"

@interface TaskContentCell ()

@property(nonatomic , retain)NSArray        *titleArr ;
@property (nonatomic , retain)NSArray       *titleArr1 ;
@end

@implementation TaskContentCell

- (void)awakeFromNib {
    
    _titleArr = @[@"分配" , @"截止日期" , @"标签"];
    _titleArr1 = @[@"关注" , @"附件" ];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTaskModel:(Task *)taskModel
{
    if (_taskModel != taskModel) {
        _taskModel = taskModel ;
    }
    
    self.titleLabel.text = _titleArr[self.tag];
    if (self.tag == 0) {
        User *executor = _taskModel.executor;
        NSString *executorName = executor.userName ;
        self.valueLabel.text = executorName ;
        
    }
    else if (self.tag== 1){
        NSString *endTime = [Tool stringFromFomate:_taskModel.taskEndTime formate:@"yyyy-MM-dd"];
        self.valueLabel.text  = endTime ;
        
    }
    else if (self.tag == 2){
        NSString *tag = [NSString stringWithFormat:@"%@" , _taskModel.taskTag];
        self.valueLabel.text = tag ;
        
    }
    
}
- (void)setTaskModel1:(Task *)taskModel1
{
    if (_taskModel1 != taskModel1) {
        _taskModel1 = taskModel1 ;
    }
    
    
    
    self.titleLabel.text = _titleArr1[self.tag];
    
    if (self.tag == 0)
    {
        
        NSMutableString *followersName = [NSMutableString new] ;
        for (User *user in _taskModel1.followers) {
            [followersName appendFormat:@" %@ " , user.userName];
        }
        
        self.valueLabel.text = followersName ;
        
    }
    else if (self.tag == 1)
    {

        self.valueLabel.text =[NSNumber numberWithInteger:_taskModel1.annexs.count].stringValue;
        
    }

}
@end
