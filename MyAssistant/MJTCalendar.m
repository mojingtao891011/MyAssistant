//
//  MJTCalendar.m
//  
//
//  Created by taomojingato on 15/6/26.
//
//

#import "MJTCalendar.h"
#import "UIViewExt.h"
#import "Task.h"
#import "Schedule.h"


#define     EVENT_KEY                       @"eventKey"

@interface MJTCalendar ()
{
    NSMutableDictionary *eventsByDate;
    CGFloat                         calenderHeight ;
    NSDate                          *lastSelectedDate;
}
@end

@implementation MJTCalendar

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
       
        calenderHeight = self.height ;
        
        [self _initCalender];
    }
    
    return self ;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _initCalender];
    }
    return self ;
}
- (void)_initCalender
{
    lastSelectedDate = [NSDate date];
    
    self.calendar = [JTCalendar new];
    
    // All modifications on calendarAppearance have to be done before setMenuMonthsView and setContentView
    // Or you will have to call reloadAppearance
    {
        
        self.calendar.calendarAppearance.calendar.firstWeekday = 2; // Sunday == 1, Saturday == 7
        self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
        self.calendar.calendarAppearance.ratioContentMenu = 3.;
        self.calendar.calendarAppearance.focusSelectedDayChangeMode = YES;
        self.calendar.calendarAppearance.isWeekMode = YES;
        self.calendar.calendarAppearance.dayDotColor= [UIColor redColor];
        self.calendar.calendarAppearance.dayCircleColorToday = ORANGE_COLOR ;
        self.calendar.calendarAppearance.dayCircleColorSelected = LIGHTGREY_FONT_COLOR ;
        self.calendar.calendarAppearance.dayCircleRatio = 0.8 ;
        self.calendar.calendarAppearance.dayTextFont = [UIFont systemFontOfSize:17.0];
        
    }
    
    self.calendarContentView = [[JTCalendarContentView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  calenderHeight  )];
    self.calendarContentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.calendarContentView];
    [self.calendar setContentView:self.calendarContentView];
    
    [self.calendar setDataSource:self];
    

    // 事件
    eventsByDate = [[NSUserDefaults standardUserDefaults]objectForKey:EVENT_KEY];
   
    [self.calendar reloadData];
    
    
    // 监听异步删除通知
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAction:) name:NOTE_DELETEMODEL object:nil];
    });
}

- (void)layoutSubviews
{
    [self.calendar repositionViews];
}
#pragma mark - Note
- (void)deleteAction:(NSNotification*)note
{
     NSString *key = [[self dateFormatter] stringFromDate:note.object];
    
    NSMutableArray *events = eventsByDate[key];
    if ([events containsObject:note.object]) {
        [events removeObject:note.object];
        
        [[NSUserDefaults standardUserDefaults]setObject:eventsByDate forKey:EVENT_KEY];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.calendar reloadData];
        });
    }
    
    
}
#pragma mark - Buttons callback

- (void)didGoTodayTouch
{
    [self.calendar setCurrentDate:[NSDate date]];
    
    lastSelectedDate = [NSDate date];
    
    if (self.selectedDateBlock) {
        self.selectedDateBlock(lastSelectedDate);
    }
}

- (void)didChangeModeTouch
{
    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
    
    if (self.calendar.calendarAppearance.isWeekMode) {
        self.calendar.calendarAppearance.dayTextFont = [UIFont systemFontOfSize:17.0];
    }
    else{
         self.calendar.calendarAppearance.dayTextFont = [UIFont systemFontOfSize:15.0];
    }
    
    [self transitionExample];
}

#pragma mark - JTCalendarDataSource

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(eventsByDate[key] && [eventsByDate[key] count] > 0){
        return YES;
    }
    
    
    return NO;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{

    if (self.selectedDateBlock) {
        self.selectedDateBlock(date);
    }
    
    
    lastSelectedDate = date ;
}

- (void)calendarDidLoadPreviousPage
{
    static NSInteger count;
    if ( self.calendar.calendarAppearance.isWeekMode) {
        count = -7 ;
    }
    else{
        count = -30 ;
    }
    
    [self.calendar setCurrentDateSelected:[NSDate dateWithTimeInterval:count *60*60*24 sinceDate:lastSelectedDate]];
    
    [self.calendar reloadData];
    
    lastSelectedDate = self.calendar.currentDateSelected ;
   
    if (self.selectedDateBlock) {
        self.selectedDateBlock(lastSelectedDate);
    }
}

- (void)calendarDidLoadNextPage
{
    static NSInteger count;
    if ( self.calendar.calendarAppearance.isWeekMode) {
        count = 7 ;
    }
    else{
        count = 30 ;
    }
    
    [self.calendar setCurrentDateSelected:[NSDate dateWithTimeInterval:count *60*60*24 sinceDate:lastSelectedDate]];
    
    [self.calendar reloadData];
    
    lastSelectedDate = self.calendar.currentDateSelected ;
    
    if (self.selectedDateBlock) {
        self.selectedDateBlock(lastSelectedDate);
    }

}

#pragma mark - Transition examples

- (void)transitionExample
{
    CGFloat newHeight = 220;
   
    if(self.calendar.calendarAppearance.isWeekMode){
        newHeight = 100.;
       
    }
    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.calendarContentView.height = newHeight ;
                       
                         [self layoutSubviews];
                         
                     }];
    
    [UIView animateWithDuration:.25
                     animations:^{
                         self.calendarContentView.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.calendar reloadAppearance];
                         
                         [UIView animateWithDuration:.25
                                          animations:^{
                                              self.calendarContentView.layer.opacity = 1;
                                              
                                          }];
                     }];
    
    self.height = newHeight ;
    

}

#pragma mark - Fake data

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateStyle = kCFDateFormatterShortStyle;
        dateFormatter.timeStyle = kCFDateFormatterShortStyle;
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    
    return dateFormatter;
}


- (void)createRandomEvents:(NSDate*)randomDate
{
    if (eventsByDate == nil) {
         eventsByDate = [NSMutableDictionary new];
    }

    NSString *key = [[self dateFormatter] stringFromDate:randomDate];
    
    if(!eventsByDate[key]){
        eventsByDate[key] = [NSMutableArray new];
    }
    
    [eventsByDate[key] addObject:randomDate];
    
    [[NSUserDefaults standardUserDefaults]setObject:eventsByDate forKey:EVENT_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self.calendar reloadData];
}


@end
