//
//  DatePickerViewController.h
//  MyAssistant
//
//  Created by taomojingato on 15/6/21.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "BaseController.h"

@protocol DatePickerViewControllerDelegate <NSObject>

- (void)selectedDate:(NSDate*)date ;

@end

typedef enum
{
    DatePickerModeDate = 0 ,
    DatePickerModeDateAndTime = 1,
    DatePickerModeTime = 2 ,
    
}DatePickerShowMode;

@interface DatePickerController : BaseController

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic , copy)NSDate *curDate ;
@property (nonatomic , assign)DatePickerShowMode datePickerShowMode ;
@property (nonatomic , assign)id<DatePickerViewControllerDelegate>datePickerViewControllerDelegate ;
@property (nonatomic , copy)void(^selectedDateBlock)(NSDate*date);

@end
