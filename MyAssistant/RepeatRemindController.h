//
//  RepeatRemindController.h
//  MyAssistant
//
//  Created by taomojingato on 15/6/24.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "BaseTableController.h"

typedef enum {
    
    noRepeat = 0,
    everyDayRepeat = 1,
    everyWeekRepeat = 2,
    everyMonthRepeat = 3,
    everyYearRepeat = 4,
    
}RepeatType;


@interface RepeatRemindController : BaseTableController

@property (nonatomic , assign)RepeatType        curRepeatType ;
@property (nonatomic , copy)void(^selectedRepeatTypeBlock)(NSInteger selectedRepeatType);

@end
