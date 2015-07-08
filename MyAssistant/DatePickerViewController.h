//
//  ScheduleDateController.h
//  MyAssistant
//
//  Created by taomojingato on 15/6/24.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "BaseController.h"

typedef enum
{
    ModeTime = 0,
   ModeDate = 1,
   ModeDateAndTime = 2,
   ModeCountDownTimer = 3 ,
    
}DATEPICKMODE_ENUM;

@interface DatePickerViewController : BaseController

@property (nonatomic , retain)NSDate *startTime ;
@property (nonatomic , retain)NSDate *endTime ;
@property (nonatomic , copy)void(^scheuleDateBlock)(NSDate *startTime , NSDate *endTime) ;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
//@property (nonatomic , assign)DATEPICKMODE_ENUM  dateModeEnum ;
@property (nonatomic , assign)NSInteger  typeInt ;

@end
