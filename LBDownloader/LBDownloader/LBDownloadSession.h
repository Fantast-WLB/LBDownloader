//
//  LBDownloadSession.h
//  LBDownloader
//
//  Created by 吴龙波 on 2018/4/27.
//  Copyright © 2018 WhatTheGhost. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LBDownloadTask;
@class LBDownloadSession;

@protocol LBDownloadSessionDelegate <NSObject>

/**
 * 任务下载速度和进度
 * @params session  下载会话
 * @params speed    bytes / second
 * @params progress 0~1
 *
 */
- (void)sessionDownloading:(LBDownloadSession *)session withSpeed:(double)speed progress:(double)progress;

/**
 * 任务下载速度、进度、数据量
 * @params session  下载会话
 * @params speed    bytes / second
 * @params progress 0~1
 * @params totalBytesWritten 已经下载大小
 * @params totalBytesExpectedToWrite 总大小
 *
 */
- (void)sessionDownloading:(LBDownloadSession *)session
                 withSpeed:(double)speed
                  progress:(double)progress
         totalBytesWritten:(int64_t)totalBytesWritten
 totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;
@end

@interface LBDownloadSession : NSObject

@property (nonatomic, weak) id<LBDownloadSessionDelegate> delegate;

///下载的任务
@property (nonatomic, strong, readonly) LBDownloadTask *task;

///创建下载会话
+ (instancetype)lb_sessionWithURL:(NSURL *)url fileName:(NSString *)fileName;
- (instancetype)initWithURL:(NSURL *)url fileName:(NSString *)fileName;

/****** 下载动作 ******/
///开始下载
- (void)startDownload;
///停止下载
- (void)stopDownload;
///删除下载
- (void)deleteDownload;
@end
