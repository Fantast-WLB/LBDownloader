//
//  LBFileHandler.m
//  LBDownloader
//
//  Created by 吴龙波 on 2018/4/27.
//  Copyright © 2018 WhatTheGhost. All rights reserved.
//

#import "LBFileHandler.h"

@implementation LBFileHandler

///根据URL生成标识
+ (NSString *)identifierWithURL:(NSURL *)url
{
    return [NSString stringWithFormat:@"%@_lb",url.absoluteString];
}

///根据URL和文件名生成标识
+ (NSString *)identifierWithURL:(NSURL *)url fileName:(NSString *)fileName
{
    return [NSString stringWithFormat:@"%@_%@",url.absoluteString,fileName];
}

@end
