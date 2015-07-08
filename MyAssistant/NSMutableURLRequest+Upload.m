//
//  NSMutableURLRequest+Upload.m
//  UploadExamples
//
//  Created by 刘凡 on 15/1/31.
//  Copyright (c) 2015年 joyios. All rights reserved.
//

#import "NSMutableURLRequest+Upload.h"


@implementation NSMutableURLRequest (Upload)

+ (instancetype)requestWithURL:(NSURL *)URL fileName:(NSString *)fileName name:(NSString *)name fileData:(NSData*)fileData{
    return [self requestWithURL:URL fileNameArr:@[fileName] name:name fileDatas:@[fileData]];
}

+ (instancetype)requestWithURL:(NSURL *)URL  fileName:(NSString *)fileName name:(NSString *)name fileDatas:(NSArray*)fileDatas
{
    
    return [self requestWithURL:URL fileNames:@[fileName] name:name fileDatas:fileDatas];
}

+ (instancetype)requestWithURL:(NSURL *)URL fileNameArr:(NSArray *)fileNameArr name:(NSString *)name fileDatas:(NSArray*)fileDatas{
    
    NSMutableArray *fileNames = [NSMutableArray arrayWithCapacity:fileNameArr.count];
    [fileNameArr enumerateObjectsUsingBlock:^(NSString *fileName, NSUInteger idx, BOOL *stop) {
        [fileNames addObject:fileName];
    }];
    
    return [self requestWithURL:URL  fileNames:fileNames name:name fileDatas:fileDatas];
}

+ (instancetype)requestWithURL:(NSURL *)URL  fileNames:(NSArray *)fileNames name:(NSString *)name  fileDatas:(NSArray*)fileDatas{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    request.HTTPMethod = @"POST";
    
    NSMutableData *data = [NSMutableData data];
    NSString *boundary = multipartFormBoundary();
    
    if (fileNames.count > 1) {
        name = [name stringByAppendingString:@"[]"];
    }
    
    
    [fileDatas enumerateObjectsUsingBlock:^(NSData *fileData, NSUInteger idx, BOOL *stop) {
        NSString *bodyStr = [NSString stringWithFormat:@"\n--%@\n", boundary];
        [data appendData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *fileName = fileNames[idx];
        bodyStr = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\" \n", name, fileName];
        [data appendData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[@"Content-Type: application/octet-stream\n\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [data appendData:fileData];
        
        [data appendData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        //
        bodyStr = [NSString stringWithFormat:@"\n--%@\n", boundary];
        [data appendData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
        
    }];
    
    
    NSString *bodyStr = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"privatekey\" \n\n%@\n" ,PRIVATEKEY ];
    [data appendData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *tailStr = [NSString stringWithFormat:@"--%@--\n", boundary];
    [data appendData:[tailStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    request.HTTPBody = data;
    
    NSString *headerString = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:headerString forHTTPHeaderField:@"Content-Type"];
    
    
    return request;
}

static NSString * multipartFormBoundary() {
    return [NSString stringWithFormat:@"Boundary+%08X%08X", arc4random(), arc4random()];
}

@end
