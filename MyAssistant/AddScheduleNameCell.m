//
//  AddScheduleNameCell.m
//  MyAssistant
//
//  Created by taomojingato on 15/8/3.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "AddScheduleNameCell.h"

@implementation AddScheduleNameCell

- (void)awakeFromNib {
    self.describeTextView.delegate = self ;
    self.heightConstraint.constant = 0.0 ;
    self.tipLabel.hidden = YES ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (textView.text.length != 0 ) {
        self.tipLabel.hidden = YES ;
    }
    else{
        self.tipLabel.hidden  = NO ;
    }
    
    CGSize size = [Tool calculateMessage:[Tool removeLastSpace:textView.text] fontOfSize:14.0 maxWidth:textView.width-60 maxHeight:200.0];
    CGFloat cellHeight = size.height + 15 ;
    if (cellHeight >30.0) {
        self.height  = 65 + cellHeight  - 28;
        self.heightConstraint.constant = cellHeight ;
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.delegate && [_delegate respondsToSelector:@selector(reloadCellHeight:describeStr:)]) {
        [_delegate reloadCellHeight:self.height describeStr:textView.text];
    }
}
@end
