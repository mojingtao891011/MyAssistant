//
//  YearCell.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/24.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YearCellDelegate <NSObject>

- (void)selectedYearAction:(NSMutableArray*)years ;

@end
@interface YearCell : UITableViewCell

@property (nonatomic , retain)NSDate    *startTime ;
@property (nonatomic , assign)id<YearCellDelegate>delegate;

@end
