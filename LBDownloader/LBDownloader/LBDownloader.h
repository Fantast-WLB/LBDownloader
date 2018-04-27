//
//  LBDownloader.h
//  LBDownloader
//
//  Created by 吴龙波 on 2018/4/27.
//  Copyright © 2018 WhatTheGhost. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LBDownloadTask;

@protocol LBDownloaderDelegate <NSObject>

///URL正在以某文件名下载
- (void)urlDownloading:(NSURL *)url withFileName:(NSString *)fileName;
///URL已经以某文件名下载过
- (void)urlAlreadyDownload:(NSURL *)url withFileName:(NSString *)fileName;
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
