//
//  LBDownloadSession.h
//  LBDownloader
//
//  Created by 吴龙波 on 2018/4/27.
//  Copyright © 2018 WhatTheGhost. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LBDownloadTask;

@interface LBDownloadSession : NSObject

///下载的任务
@property (nonatomic, strong, readonly) LBDownloadTask *task;

///创建下载
+ (instancetype)lb_sessionWithURL:(NSURL *)url fileName:(NSString *)fileName;
- (instancetype)initWithURL:(NSURL *)url fileName:(NSString *)fileName;

//下载动作
- (void)startDownload;
@end
