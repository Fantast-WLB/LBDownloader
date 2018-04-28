//
//  LBDownloader.h
//  LBDownloader
//
//  Created by 吴龙波 on 2018/4/27.
//  Copyright © 2018 WhatTheGhost. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LBDownloadTask;
@class LBDownloadSession;

@protocol LBDownloaderDelegate <NSObject>

/**
 * URL正在以某文件名下载
 * @params url  目标URL
 * @params fileName  下载中文件名
 *
 */
- (void)urlDownloading:(NSURL *)url withFileName:(NSString *)fileName;

/**
 * URL已经以某文件名下载过
 * @params url  目标URL
 * @params fileName  本地文件名
 *
 */
- (void)urlAlreadyDownload:(NSURL *)url withFileName:(NSString *)fileName;

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

@interface LBDownloader : NSObject

@property (nonatomic, weak) id<LBDownloaderDelegate> delegate;

///单例下载器
+ (instancetype)sharedInstance;

/****** 会话 ******/
///增加下载会话
- (void)lb_addDownloadSessionWithURL:(NSURL *)url fileName:(NSString *)fileName;


/****** 任务 ******/
///加载本地历史任务
- (void)lb_loadCacheTasks;
///添加任务
- (void)lb_addTask:(LBDownloadTask *)task;
///删除任务
- (void)lb_deleteTask;
///清空任务
- (void)lb_deleteAllTasks;
@end
