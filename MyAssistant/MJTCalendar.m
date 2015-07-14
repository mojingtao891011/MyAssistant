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


@interface MJTCalendar ()
{
    NSMutableDictionary *eventsByDate;
    CGFloat                         calenderHeight ;
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
    
    self.calendar = [JTCalendar new];
    
    // All modifications on calendarAppearance have to be done before setMenuMonthsView and setContentView
    // Or you will have to call reloadAppearance
    {
        
        self.calendar.calendarAppearance.calendar.firstWeekday = 2; // Sunday == 1, Saturday == 7
        self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
        self.calendar.calendarAppearance.ratioContentMenu = 3.;
        self.calendar.calendarAppearance.focusSelectedDayChangeMode = YES;
        self.calendar.calendarAppearance.isWeekMode = YES;
        self.calendar.calendarAppearance.dayDotColor= [UIColor colorWithRed:153/255.0 green:153/255.0  blue:153/255.0  alpha:1.0];
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
    
    //[self createRandomEvents];
    
}

- (void)layoutSubviews
{
    [self.calendar repositionViews];
}
#pragma mark - Note
- (void)createTaskRandomEvents:(NSNotification*)note
{
    if (!eventsByDate) {
        eventsByDate = [NSMutableDictionary new];
    }
    
    Task *task = note.object ;
    NSString *dateStr = [[self dateFormatter] stringFromDate:task.taskTheDate];
    
    
    if(!eventsByDate[dateStr]){
        eventsByDate[dateStr] = [NSMutableArray new];
    }
    
    [eventsByDate[dateStr] addObject:task.taskTheDate];
    
    
}

#pragma mark - Buttons callback

- (void)didGoTodayTouch
{
    [self.calendar setCurrentDate:[NSDate date]];
}

- (void)didChangeModeTouch
{
    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
    
    if (self.calendar.calendarAppearance.isWeekMode) {
        self.calendar.calendarAppearance.dayTextFont = [UIFont systemFontOfSize:17.0];
    }
    else{
         self.calendar.calendarAppearance.dayTextFont = [UIFont systemFontOfSize:14.0];
    }
    
    [self transitionExample];
}

#pragma mark - JTCalendarDataSource

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    //NSLog(@"== %@" , key);
    
    if(eventsByDate[key] && [eventsByDate[key] count] > 0){
        return YES;
    }
    
    
    return NO;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
//    NSString *key = [[self dateFormatter] stringFromDate:date];
//    NSArray *events = eventsByDate[key];
//    
//    NSLog(@"Date: %@ - %ld events", key, [events count]);
    if (self.selectedDateBlock) {
        self.selectedDateBlock(date);
    }
}

- (void)calendarDidLoadPreviousPage
{
    //NSLog(@"Previous page loaded");
    
   // self.calendar.currentDateSelected = []
}

- (void)calendarDidLoadNextPage
{
    //NSLog(@"Next page loaded");
}

#pragma mark - Transition examples

- (void)transitionExample
{
    CGFloat newHeight = 180;
   
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
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    
    return dateFormatter;
}


- (void)createRandomEvents
{
    eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!eventsByDate[key]){
            eventsByDate[key] = [NSMutableArray new];
        }
        
        [eventsByDate[key] addObject:randomDate];
    }
}


@end
