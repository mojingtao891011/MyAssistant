//
//  Tool.h
//  SmartClock
//
//  Created by taomojingato on 15/5/4.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface Tool : NSObject

/**
 *  判断网络请求是否成功
 *
 *  @param success <#success description#>
 *  @param command <#command description#>
 *  @param result  <#result description#>
 *
 *  @return <#return value description#>
 */
+(BOOL)isSuccess:(NSString *)success command:(NSString*)command result:(id)result ;
/**
 *  日期转字符串
 *
 *  @param date    日期
 *  @param formate 日期格式
 *
 *  @return 转化后的字符串
 */
+ (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate ;
/**
 *  字符串转日期
 *
 *  @param datestring 日期字符串
 *  @param formate    日期格式
 *
 *  @return 转化后的日期
 */
+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate ;

/**
 *  判断是否是手机号码
 *
 *  @param numberStr 手机号码
 *
 *  @return 是YES 、不是NO
 */
+(BOOL)checkTelNumber:(NSString*)numberStr ;

/**
 *  MD5加密
 *
 *  @param sourceString 源字符串
 *
 *  @return 加密后的字符串
 */
+(NSString*)MD5EncodedString:(NSString*)sourceString ;

/**
 *  base64解码
 *
 *  @param sourceString 愿字符串
 *
 *  @return 解码后的字符串
 */
+(NSString*)BASE64EncodedString:(NSString*)sourceString ;
/**
 *  base64编码
 *
 *  @param sourceString 源字符串
 *
 *  @return 编码后的字符串
 */
+ (NSString*)BASE64Decode:(NSString*)sourceString ;


/**
 *  删除开始的空格
 *
 *  @param string 源字符串
 *
 *  @return 删除后的字符串
 */
+(NSString*)removeFirstSpace:(NSString*)string ;
/**
 *  删除最后一个空格
 *
 *  @param string 源字符串
 *
 *  @return 删除最后空格的字符串
 */
+(NSString*)removeLastSpace:(NSString*)string ;


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
+ (CGSize)calculateMessage:(NSString*)message fontOfSize:(CGFloat)fontOfSize maxWidth:(CGFloat)maxWidth    maxHeight:(CGFloat)maxHeight ;


/**
 *  发送邮件
 *
 *  @param connent      发送内容
 *  @param recipient    主送
 *  @param csRecipients 抄送
 *  @param mailDelegate 代理
 */
+(void)sendMailWithConnent:(NSString*)connent  recipient:(NSArray*)recipients  csRecipients:(NSArray*)csRecipients mailDelegate:(id<MFMailComposeViewControllerDelegate>)mailDelegate ;

/**
 *  发送短信
 *
 *  @param connent         发送内容
 *  @param recipient       接受者
 *  @param messageDelegate 代理
 */
+(void)sendMessageWithConnent:(NSString*)connent  recipient:(NSString*)recipient messageDelegate:(id<MFMessageComposeViewControllerDelegate>)messageDelegate ;

@end
