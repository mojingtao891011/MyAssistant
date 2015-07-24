//
//  MonthCell.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/24.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "MonthCell.h"

@interface MonthCell ()

@property (nonatomic , retain)NSMutableArray    *selectedButton;
@property (nonatomic , retain)NSMutableArray    *selectedDay;

@end

@implementation MonthCell

- (void)awakeFromNib {
    
   
    [self _initMonthButton];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)_initMonthButton
{
    if (self.selectedButton == nil) {
        self.selectedButton = [NSMutableArray arrayWithCapacity:30];
    }
    if (self.selectedDay == nil) {
        self.selectedDay = [NSMutableArray arrayWithCapacity:30];
    }
    
    self.startTime = [NSDate date];
    
    //  先定义一个遵循某个历法的日历对象
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //  通过已定义的日历对象，获取某个时间点的NSDateComponents表示，并设置需要表示哪些信息（NSYearCalendarUnit, NSMonthCalendarUnit, NSDayCalendarUnit等）
    NSDateComponents *dateComponents = [greCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:self.startTime];
    
    //button
    CGFloat monthButtonWidth = SCREEN_WIDTH/7;
    CGFloat monthButtonHeight = 40.0;
    for (int i = 0; i < 31 ; i++) {
        int row = i / 7;//第几行
        int column = i % 7;//第几列
        UIButton *monthButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [monthButton setFrame:CGRectMake(column*monthButtonWidth, row*40 , monthButtonWidth, monthButtonHeight)];
        [monthButton setTitle:[NSString stringWithFormat:@"%d" , i+1] forState:UIControlStateNormal];
        monthButton.backgroundColor= [UIColor whiteColor];
        [monthButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        monthButton.tag = i ;
        if (monthButton.tag+1 == dateComponents.day) {
            monthButton.selected = YES ;
            monthButton.backgroundColor= [UIColor redColor];
            [monthButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [self.selectedButton addObject:monthButton];
            [self.selectedDay addObject:[NSNumber numberWithInteger:monthButton.tag]];
        }
        monthButton.layer.borderWidth = 0.5 ;
        monthButton.layer.borderColor = [UIColor lightGrayColor].CGColor ;
        [monthButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:monthButton];
    }
}
- (void)clickButton:(UIButton*)sender
{
    if (self.selectedButton.count == 1 && [self.selectedButton containsObject:sender]) {
        return ;
    }
    sender.selected = !sender.selected ;
    if (sender.selected) {
        sender.backgroundColor= [UIColor redColor];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self.selectedButton addObject:sender];
        [self.selectedDay addObject:[NSNumber numberWithInteger:sender.tag]];
    }
    else{
        sender.backgroundColor= [UIColor whiteColor];
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.selectedButton removeObject:sender];
        [self.selectedDay removeObject:[NSNumber numberWithInteger:sender.tag]];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectedMonthDay:)]) {
        [_delegate selectedMonthDay:self.selectedDay];
    }
    
}
@end
