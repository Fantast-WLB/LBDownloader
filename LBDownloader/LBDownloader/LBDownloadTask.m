//
//  LBDownloadTask.m
//  LBDownloader
//
//  Created by 吴龙波 on 2018/4/27.
//  Copyright © 2018 WhatTheGhost. All rights reserved.
//

#import "LBDownloadTask.h"
#import "LBFileHandler.h"

@interface LBDownloadTask ()
///下载资源地址
@property (nonatomic, copy) NSURL *taskURL;
///保存的文件名
@property (nonatomic, copy) NSString *fileName;
///任务标识
@property (nonatomic, copy) NSString *taskIdentifier;
///任务状态
@property (nonatomic, assign) LBTaskStatus taskStatus;
@end

@implementation LBDownloadTask

#pragma mark - 创建任务
+ (instancetype)lb_taskWithURL:(NSURL *)url fileName:(NSString *)fileName
{
    LBDownloadTask *task = [[LBDownloadTask alloc]init];
    task.taskURL = url;
    task.fileName = fileName;
    task.taskStatus = TASK_NULL;
    task.taskPriority = TASK_PRIORITY_DEFAULT;
    return task;
}

- (instancetype)initWithURL:(NSURL *)url fileName:(NSString *)fileName
{
    if ([self init]) {
        self.taskURL = url;
        self.fileName = fileName;
        self.taskStatus = TASK_NULL;
        self.taskPriority = TASK_PRIORITY_DEFAULT;
    }
    return self;
}

///转成字典
- (NSDictionary *)toDictionary
{
    return @{
             @"taskURL"  : _taskURL,
             @"fileName" : _fileName,
             @"taskStatus" : @(_taskStatus),
             @"taskPriority" : @(_taskPriority),
             @"resumeData" : _resumeData,
             };
}

///转成模型
+ (instancetype)loadTaskFromDictionary:(NSDictionary *)dict
{
    LBDownloadTask *task = [[LBDownloadTask alloc]init];
    
    task.taskURL = dict[@"taskURL"];
    task.fileName = dict[@"fileName"];
    task.taskStatus = [dict[@"taskStatus"] integerValue];
    task.taskPriority = [dict[@"taskPriority"] integerValue];
    task.resumeData = dict[@"resumeData"];
    
    return task;
}

#pragma mark - LazyLoad
- (NSString *)taskIdentifier
{
    if (!_taskIdentifier) {
        _taskIdentifier = [LBFileHandler identifierWithURL:self.taskURL fileName:self.fileName];
    }
    return _taskIdentifier;
}
@end
