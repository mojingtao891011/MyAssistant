//
//  NetworkService.h
//  lid-demo
//
//  Created by taomojingato on 15/4/28.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//http://qztank.gicp.net:8800/protocol.html

#import "AFHTTPSessionManager.h"


#define INTERNAL
#ifdef INTERNAL
#define  hostNameUrlStr                        @"http://qztank.gicp.net:8800/bosman/main.php" //外网
#else
#define  hostNameUrlStr                        @"http://qztank.gicp.net:8800" //内网
#endif


//上传文件URL
static NSString *const uploadUrlStr                                          = @"http://qztank.gicp.net:8800/upload/upload_file.php" ;

//发送信息URL
static NSString *const sendInfoUrlStr                                       = @"/imessage.php";

//注册URL
static NSString *const registerUrlStr                                         = @"/register.php";

//登录
static NSString *const loginUrlStr                                              = @"/login.php";

//退出登录

static NSString *const logoutUrlStr                                           = @"/imessage.php";

@protocol NetworkServiceDelegate <NSObject>

- (void)requestCompeletion:(id)result ;
- (void)requestFail:(NSString*)fail ;

@end

typedef void(^RequestCompeletionBlock)(id);
typedef void(^RequestFailBlock)(NSString*);

@interface NetworkService : AFHTTPSessionManager

@property(nonatomic , assign)id<NetworkServiceDelegate>networkServiceDelegate ;

//单例
+ (instancetype)sharedClient ;

/**
 *上传
 *
 *  @param urlStr           上传URL
 *  @param filePath         上传文件地址
 *  @param networkDelegate  上传成功/失败的代理
 *  @param compeletionBlock 上传成功回调Block
 *  @param failBlock        上传失败回调Block
 */
- (void)uploadUrl:(NSString*)urlStr
      andFileName:(NSString*)fileName
      andFileData:(NSData*)fileData
andNetworkServiceDelegate:(id<NetworkServiceDelegate>)networkDelegate
andCompletionBlock:(RequestCompeletionBlock)compeletionBlock
     andFailBlock:(RequestFailBlock)failBlock;

/**
 *  网络请求HTTP
 *
 *  @param url              请求URL
 *  @param parmDict         请求参数
 *  @param networkDelegate  请求成功/失败的代理
 *  @param compeletionBlock 请求成功回调Block
 *  @param failBlock        请求失败回调Block
 */
- (void)startNetworkUrl:(NSString*)url
         andParmDict:(NSDictionary*)parmDict
        andNetworkServiceDelegate:(id<NetworkServiceDelegate>)networkDelegate
        andCompletionBlock:(RequestCompeletionBlock)compeletionBlock
        andFailBlock:(RequestFailBlock)failBlock;

@end
