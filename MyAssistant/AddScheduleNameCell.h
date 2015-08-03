//
//  AddScheduleNameCell.h
//  MyAssistant
//
//  Created by taomojingato on 15/8/3.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddScheduleNameCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *scheduleNameTF;
@property (weak, nonatomic) IBOutlet UITextField *describeTextTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@end
