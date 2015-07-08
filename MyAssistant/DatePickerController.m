//
//  DatePickerViewController.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/21.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "DatePickerController.h"
#import "Tool.h"

@interface DatePickerController ()



@end

@implementation DatePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.datePickerShowMode == DatePickerModeDateAndTime) {
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime ;
    }
    else if (self.datePickerShowMode == DatePickerModeTime) {
        self.datePicker.datePickerMode = UIDatePickerModeTime ;
    }
        
    
    [self setTime];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (![_curDate isEqualToDate:_datePicker.date]) {
        if (_datePickerViewControllerDelegate && [_datePickerViewControllerDelegate respondsToSelector:@selector(selectedDate:)]) {
            
            [_datePickerViewControllerDelegate selectedDate:_datePicker.date];
        }

        if (self.selectedDateBlock) {
            self.selectedDateBlock(_datePicker.date);
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)setTime
{
    if (!self.curDate) {
        [self.datePicker setDate:[NSDate date] animated:YES];
        return ;
    }
    
    [self.datePicker setDate:_curDate animated:YES];
}
@end
