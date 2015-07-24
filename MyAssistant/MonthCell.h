//
//  MonthCell.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/24.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MonthCellDelegate <NSObject>

- (void)selectedMonthDay:(NSMutableArray*)months ;

@end

@interface MonthCell : UITableViewCell

@property (nonatomic , retain)NSDate *startTime ;
@property (nonatomic , assign)id<MonthCellDelegate>delegate ;

- (void)clickButton:(UIButton*)sender;

@end
