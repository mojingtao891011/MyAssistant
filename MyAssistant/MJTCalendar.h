//
//  MJTCalendar.h
//  
//
//  Created by taomojingato on 15/6/26.
//
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"

@interface MJTCalendar : UIView<JTCalendarDataSource>


@property (retain, nonatomic) JTCalendarMenuView *calendarMenuView;
@property (retain, nonatomic) JTCalendarContentView *calendarContentView;

//如果用nib
@property (retain, nonatomic) NSLayoutConstraint *calendarContentViewHeight;

@property (strong, nonatomic) JTCalendar *calendar;

@property (nonatomic , copy)void(^selectedDateBlock)(NSDate*selectedDate);
@property (nonatomic , copy)void(^calendarDidLoadPreviousPageBlock)(NSDate *selectedDate);
@property (nonatomic , copy)void(^calendarDidLoadPreviousNextBlock)(NSDate *selectedDate);

@property (nonatomic , retain)NSArray *eventArr ;

- (void)didGoTodayTouch ;

- (void)didChangeModeTouch ;

- (void)createRandomEvents:(NSDate*)randomDate ;

@end
