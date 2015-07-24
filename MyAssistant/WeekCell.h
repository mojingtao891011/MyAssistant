//
//  WeekCell.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/24.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WeekCellDelegate <NSObject>

- (void)selectedWeekDay:(NSMutableArray*)weeks ;

@end

@interface WeekCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UIImageView *redioImageView;
@property (nonatomic , assign)id<WeekCellDelegate>delegate ;


@end
