//
//  AddScheduleNameCell.h
//  MyAssistant
//
//  Created by taomojingato on 15/8/3.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol reloadCellHeightDelegate <NSObject>

- (void)reloadCellHeight:(CGFloat)height describeStr:(NSString*)describeStr;

@end
@interface AddScheduleNameCell : UITableViewCell<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *scheduleNameTF;
@property (weak, nonatomic) IBOutlet UITextView *describeTextView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (nonatomic , assign)id<reloadCellHeightDelegate>delegate ;

@end
