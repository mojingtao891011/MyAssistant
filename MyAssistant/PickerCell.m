//
//  PickerCell.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/23.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "PickerCell.h"

@interface PickerCell ()

@property (nonatomic , retain)NSArray  *firstDataSources ;
@property (nonatomic , retain)NSMutableArray  *secondDataSources;

@end

@implementation PickerCell

- (void)awakeFromNib {
    
    
    [self _initPickerView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)_initPickerView
{
    self.firstDataSources = @[@"每天" , @"每周" , @"每月" , @"每年"];
    
    for (int i = 1; i < 1000; i++) {
        if (self.secondDataSources == nil) {
            self.secondDataSources = [NSMutableArray arrayWithCapacity:1000];
        }
        [self.secondDataSources  addObject:[NSNumber numberWithInt:i]];
    }
    
    self.pickerView.delegate = self ;
    self.pickerView.dataSource = self ;
    
    
    
}
- (void)setPickerType:(PickerType)pickerType
{
    if (_pickerType != pickerType) {
        _pickerType = pickerType ;
    }
    
    [self.pickerView reloadAllComponents];
}
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSInteger componentNumber ;
    if (_pickerType == firstPicker) {
        componentNumber = 1;
    }
    else if (_pickerType == secondPicker){
        componentNumber = 2 ;
    }
    return componentNumber ;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_pickerType == firstPicker) {
         return self.firstDataSources.count ;
    }
    else if (_pickerType == secondPicker){
        if (component == 0) {
             return self.secondDataSources.count ;
        }
        else{
            return 1;
        }
       
    }

    return 0 ;
}
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_pickerType == firstPicker) {
        return self.firstDataSources[row];
    }
    else if (_pickerType == secondPicker){
        if (component == 0) {
             return [NSString stringWithFormat:@"%@" , self.secondDataSources[row]];
        }
        else{
            return self.componentStr;
        }
    }
    
    return nil ;
}
#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    static NSString *repeat1 = @"每天" ;
    static NSString *repeat2 = @"" ;
    static PickerType pickerType ;
    if (_pickerType == firstPicker) {
        repeat1= self.firstDataSources[row];
        pickerType = firstPicker ;
    }
    else if (_pickerType == secondPicker){
        repeat2 = self.secondDataSources[row];
        pickerType = secondPicker ;
    }
    
    if (component == 0) {
    
        if (_delegate && [_delegate respondsToSelector:@selector(selectedComponent:repeat2:pickerType:)]) {
            [_delegate selectedComponent:repeat1 repeat2:repeat2 pickerType:pickerType];
        }
    }
    
}
@end
