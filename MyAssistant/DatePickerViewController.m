//
//  ScheduleDateController.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/24.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic , retain)NSTimer       *fetchTimer ;
@property (nonatomic , retain)NSDate        *selectedStartTime ;
@property (nonatomic , retain)NSDate        *selectedEndTime ;

@end

@implementation DatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedStartTime = self.startTime ;
    self.selectedEndTime = self.endTime ;
    
        
    if (self.typeInt == 0) {
          self.datePicker.datePickerMode = UIDatePickerModeDateAndTime ;
    }
    else if (self.typeInt == 1) {
        self.datePicker.datePickerMode = UIDatePickerModeTime ;
    }
    else{
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime ;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.fetchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(fetchTime:) userInfo:nil repeats:YES];
    
    if (self.startTime) {
        [self.datePicker setDate:self.startTime animated:YES];
    }
    
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (![self.startTime isEqualToDate:self.selectedStartTime] || ![self.endTime isEqualToDate:self.selectedEndTime]) {
        
        if (self.scheuleDateBlock) {
            self.scheuleDateBlock(self.selectedStartTime , self.selectedEndTime);
        }
    }
    
    if ([self.fetchTimer isValid]) {
        [self.fetchTimer invalidate];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)segmentedAction:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        
        self.datePicker.minimumDate = nil ;
        
        if (![self.startTime isEqualToDate:self.selectedStartTime]) {
            [self.datePicker setDate:self.selectedStartTime animated:YES];
        }
        else {
            [self.datePicker setDate:self.startTime animated:YES];
        }
    }
    else if (sender.selectedSegmentIndex == 1){
        
        self.datePicker.minimumDate = self.selectedStartTime ;
        
        if (![self.endTime isEqualToDate:self.selectedEndTime]) {
            [self.datePicker setDate:self.selectedEndTime animated:YES];
        }
        else{
            [self.datePicker setDate:self.endTime animated:YES];
        }
    }
    
}
- (void)fetchTime:(NSTimer*)sender
{
   
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
        {
            self.selectedStartTime = self.datePicker.date ;
            
        }
            break;
        case 1:
        {
            self.selectedEndTime = self.datePicker.date ;
        }
            break;
        default:
            break;
    }
}

@end
