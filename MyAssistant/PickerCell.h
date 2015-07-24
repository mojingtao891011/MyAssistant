//
//  PickerCell.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/23.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    firstPicker = 0 ,
    secondPicker = 1
}PickerType;

@protocol PickerCellDelegate <NSObject>

- (void)selectedComponent:(NSString*)repeat1 repeat2:(NSString*)repeat2 pickerType:(PickerType)pickerType;

@end

@interface PickerCell : UITableViewCell<UIPickerViewDataSource , UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic , assign)PickerType  pickerType ;
@property (nonatomic , assign)id<PickerCellDelegate>delegate;
@property (nonatomic , copy)NSString *componentStr;

@end
