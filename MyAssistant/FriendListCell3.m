//
//  FriendListCell3.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/29.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "FriendListCell3.h"

@interface FriendListCell3 ()


@end
@implementation FriendListCell3

- (void)awakeFromNib {
    
    self.friendImage.layer.cornerRadius = 5.0 ;
    self.friendImage.clipsToBounds = YES ;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
