//
//  LBDownloader.m
//  LBDownloader
//
//  Created by 吴龙波 on 2018/4/27.
//  Copyright © 2018 WhatTheGhost. All rights reserved.
//

#import "LBDownloader.h"
#import "LBDownloadTask.h"
#import "LBFileHandler.h"
#import "LBDownloadSession.h"

#warning todo:检查本地任务，区分是否要自动下载

///默认最大同时下载数量
#define DEFAULT_MAX_COUNT 3

@interface LBDownloader () <LBDownloadSessionDelegate>
///任务集合
@property (nonatomic, strong) NSCache *taskCache;

@end

@implementation LBDownloader

#pragma mark - Singleton
+ (instancetype)sharedInstance {
    static LBDownloader *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static LBDownloader *instance = nil;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        instance = (LBDownloader *) [super allocWithZone:zone];
    });
    return instance;
}

+ (id)copyWithZone:(struct _NSZone *)zone {
    return [[self class] sharedInstance];
}

#pragma mark - Public
///增加下载会话
- (void)lb_addDownloadSessionWithURL:(NSURL *)url fileName:(NSString *)fileName
{
    //检查是否有该文件，是否对应URL，不对应是覆盖还是沿用
#warning todo:
    
    //检查是否有该URL，存在回调文件名
#warning todo:
    
    //本地没有之后开始检查内存
    LBDownloadSession *downloadingSession = [self.taskCache objectForKey:[LBFileHandler identifierWithURL:url]];
    if (downloadingSession) {
        //已经有该会话，回调文件名
        if (self.delegate && [self.delegate respondsToSelector:@selector(urlDownloading:withFileName:)]) {
            [self.delegate urlDownloading:url withFileName:downloadingSession.task.fileName];
        }
    } else {
        //没有该会话，新建一个
        LBDownloadSession *session = [[LBDownloadSession alloc]initWithURL:url fileName:fileName];
        session.delegate = self;
        [self.taskCache setObject:session forKey:[LBFileHandler identifierWithURL:url]];
        [session startDownload];
    }
}

#pragma mark - LBDownloadSessionDelegate
- (void)sessionDownloading:(LBDownloadSession *)session withSpeed:(double)speed progress:(double)progress
{
    
}

- (void)sessionDownloading:(LBDownloadSession *)session
                 withSpeed:(double)speed
                  progress:(double)progress
         totalBytesWritten:(int64_t)totalBytesWritten
 totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
}

#pragma mark - LazyLoad
- (NSCache *)taskCache
{
    if (!_taskCache) {
        _taskCache = [[NSCache alloc]init];
    }
    return _taskCache;
}
@end
