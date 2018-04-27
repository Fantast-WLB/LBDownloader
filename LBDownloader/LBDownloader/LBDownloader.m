//
//  LBDownloader.m
//  LBDownloader
//
//  Created by 吴龙波 on 2018/4/27.
//  Copyright © 2018 WhatTheGhost. All rights reserved.
//

#import "LBDownloader.h"
#import "LBDownloadTask.h"

///默认最大同时下载数量
#define DEFAULT_MAX_COUNT 3

@interface LBDownloader ()
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


#pragma mark - LazyLoad
- (NSCache *)taskCache
{
    if (!_taskCache) {
        _taskCache = [[NSCache alloc]init];
    }
    return _taskCache;
}
@end
