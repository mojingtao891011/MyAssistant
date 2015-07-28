//
//  AddressBookFriendCell2.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/28.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "AddressBookFriendCell2.h"

@implementation AddressBookFriendCell2

- (void)awakeFromNib {
    
    self.inviteButton.layer.cornerRadius = 5.0 ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setContact:(NSDictionary *)contact
{
    if (_contact != contact) {
        _contact = contact ;
    }
    
   
    NSString *firstName = _contact[@"firstName"];
    self.addressBookFriendName.text = [firstName stringByAppendingString:[NSString stringWithFormat:@" %@", _contact[@"lastName"]]];
    
    NSArray *phones = _contact[@"phones"];
    
    if ([phones count] > 0) {
        NSDictionary *phoneItem = phones[0];
        self.addressBookFriendPhone.text = phoneItem[@"value"];
    }

}
- (IBAction)inviteAction:(UIButton *)sender
{
    
    NSArray *phones = _contact[@"phones"];
    
    if ([phones count] > 0) {
        NSDictionary *phoneItem = phones[0];
       
        [Tool sendMessageWithConnent:@"我在懒人日程，懒人号:123456789。点击下载https://itunes.apple.com/us/app/chuang-tou-bao/id894285452" recipient:phoneItem[@"value"] messageDelegate:self];
    }
    
}
#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
    [[[[UIApplication sharedApplication].windows firstObject] rootViewController] dismissViewControllerAnimated:YES completion:nil];
    
}
@end
