//
//  Tool.m
//  SmartClock
//
//  Created by taomojingato on 15/5/4.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "Tool.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Tool

+(BOOL)isSuccess:(NSString *)success command:(NSString*)command result:(id)result
{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary*)result ;
        NSString *resultStr = dict[@"result"];
        NSString *commandStr = dict[@"command"];
        
        if ([resultStr isEqualToString:success] && [commandStr isEqualToString:command]) {
            return YES ;
        }
    }
    
    return NO ;
}
+ (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    
//    formatter.dateStyle = kCFDateFormatterShortStyle;
//    formatter.timeStyle = kCFDateFormatterShortStyle;
//    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];//zh_CN
    
    NSString *str = [formatter stringFromDate:date];
    return str;
}
+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
   
//    formatter.dateStyle = kCFDateFormatterShortStyle;
//    formatter.timeStyle = kCFDateFormatterShortStyle;
//    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    NSDate *date = [formatter dateFromString:datestring];
    return date;
}
+(BOOL)checkTelNumber:(NSString*)numberStr
{
    
    if ([numberStr length] == 0) {
        return NO;
    }
    //1[0-9]{10}
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    //    NSString *regex = @"[0-9]{11}";
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:numberStr];
    return isMatch ;
}
+(NSString*)MD5EncodedString:(NSString*)sourceString
{
    //转换成utf-8
    const char *cStr = [sourceString UTF8String];
    //开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    unsigned char result[16];
    //官方封装好的加密方法
    CC_MD5(cStr, (unsigned int)strlen(cStr), result); // This is the md5 call
    // 把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
    NSMutableString *Mstr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        //x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
        [Mstr appendFormat:@"%02x",result[i]];
        
    }
    return Mstr;
}
+(NSString*)BASE64EncodedString:(NSString*)sourceString
{

    NSString * _base64Str =  [[sourceString dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        
    
    return _base64Str ;
}
+ (NSString*)BASE64Decode:(NSString*)sourceString
{
    
    NSData* decodeData = [[NSData alloc] initWithBase64EncodedString:sourceString options:0];
    NSString *decodeStr = [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
    
    return decodeStr ;
}

+(NSString*)removeFirstSpace:(NSString*)string
{
    NSString *content = [string  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return content ;
}
/**
 *  删除最后一个空格
 *
 *  @param string 源字符串
 *
 *  @return 删除最后空格的字符串
 */
+(NSString*)removeLastSpace:(NSString*)string
{
    NSString *content = [string  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return content ;
}

/**
 *  求字符串size
 *
 *  @param message    字符串
 *  @param fontOfSize 字体大小
 *  @param maxWidth   最大width
 *  @param maxHeight  最大height
 *
 *  @return CGSize
 */
+ (CGSize)calculateMessage:(NSString*)message fontOfSize:(CGFloat)fontOfSize maxWidth:(CGFloat)maxWidth    maxHeight:(CGFloat)maxHeight
{
    CGFloat w ,h ;
    NSMutableDictionary *dic_w = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontOfSize] forKey:NSFontAttributeName];
    CGSize size_w = [message boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic_w context:nil].size;
    
    if (size_w.width > maxWidth) {
        w = maxWidth ;
    }
    else{
        w = size_w.width ;
    }
    
    NSMutableDictionary *dic_h = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:12] forKey:NSFontAttributeName];
    CGSize size_h = [message boundingRectWithSize:CGSizeMake(w, maxHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic_h context:nil].size;
    h = size_h.height ;
    
    CGSize  size = CGSizeMake(w, h);
    
    return size ;
}


/**
 *  发送邮件
 *
 *  @param connent      发送内容
 *  @param recipient    主送
 *  @param csRecipients 抄送
 *  @param mailDelegate 代理
 */
+(void)sendMailWithConnent:(NSString*)connent  recipient:(NSArray*)recipients  csRecipients:(NSArray*)csRecipients mailDelegate:(id<MFMailComposeViewControllerDelegate>)mailDelegate
{
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc]init];
        [mailVC setSubject:@"send It out"];
        [mailVC setToRecipients:recipients];
        [mailVC setCcRecipients:csRecipients];
        // [mailVC setBccRecipients:@[@"245891752@qq.com"]];
        mailVC.mailComposeDelegate = mailDelegate ;
        [mailVC setMessageBody:connent isHTML:NO];
        
        [[[[UIApplication sharedApplication].windows firstObject] rootViewController] presentViewController:mailVC animated:YES completion:nil];
    }
    else{
        
        [[[UIAlertView alloc]initWithTitle:nil message:@"您还未配置您的邮件" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil]show ];
    }
    
}

/**
 *  发送短信
 *
 *  @param connent         发送内容
 *  @param recipient       接受者
 *  @param messageDelegate 代理
 */
+(void)sendMessageWithConnent:(NSString*)connent  recipient:(NSString*)recipient messageDelegate:(id<MFMessageComposeViewControllerDelegate>)messageDelegate
{
    if ([MFMessageComposeViewController canSendText]) {
        
        MFMessageComposeViewController *messgaeVC = [[MFMessageComposeViewController alloc]init];
        messgaeVC.messageComposeDelegate = messageDelegate;
        messgaeVC.recipients = @[recipient];
        messgaeVC.body = connent ;
        
//        [[[[UIApplication sharedApplication].windows firstObject] rootViewController] presentViewController:messgaeVC animated:YES completion:nil];
        
        
        UIViewController *activeController = [UIApplication sharedApplication].keyWindow.rootViewController;
        if ([activeController isKindOfClass:[UINavigationController class]])
        {
            activeController = [(UINavigationController*) activeController visibleViewController];
        }
        else if (activeController.presentedViewController)
        {
            activeController = activeController.presentedViewController;
        }
        [activeController presentViewController:messgaeVC animated:YES completion:nil];
        
    }
    else{
        [[[UIAlertView alloc]initWithTitle:nil message:@"您的手机不支持发送短信功能" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil]show ];
    }
    
}
//
+ (NSString*)curDateOfWeek:(NSDate*)date
{
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [calendar components:NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit|NSWeekdayCalendarUnit fromDate:date];
    
    NSString *week = nil ;
    switch (dateComponents.weekday - 1) {
        case 0:
            week = @"星期日" ;
            break;
        case 1:
            week = @"星期一" ;
            break;
        case 2:
            week = @"星期二" ;
            break;
        case 3:
            week = @"星期三" ;
            break;
        case 4:
            week = @"星期四" ;
            break;
        case 5:
            week = @"星期五" ;
            break;
        case 6:
            week = @"星期六" ;
            break;
       
            
        default:
            break;
    }
    
    return week ;
}

+(NSString*)dateToString:(NSDate *)date isShowToday:(BOOL)isShowToday
{
    
    //判断是否是今年 、今天
    NSString * startString = nil ;
    //开始时间
    if ([date isThisYear]) {
        startString = [Tool stringFromFomate:date formate:@"MM月dd日"];
    }
    else{
        startString = [Tool stringFromFomate:date formate:@"yyyy年MM月dd日"] ;
    }
    
    if ([date isToday]) {
        if (isShowToday) {
             startString = @"今天";
        }
        else{
             startString = [Tool stringFromFomate:date formate:@"HH:mm"] ;
        }
    }
    
    return startString ;
    
}
@end
