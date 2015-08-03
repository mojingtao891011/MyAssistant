//
//  MessageCell.m
//  MyAssistant
//
//  Created by taomojingato on 15/8/3.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    
    self.conflictButton.layer.cornerRadius = 3.0 ;
    self.replyButton.layer.cornerRadius = 3.0 ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
