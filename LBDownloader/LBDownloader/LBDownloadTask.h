//
//  LBDownloadTask.h
//  LBDownloader
//
//  Created by 吴龙波 on 2018/4/27.
//  Copyright © 2018 WhatTheGhost. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LBTaskStatus)
{
    TASK_NULL           = 0,    //初始状态
    TASK_WAITING        = 1,    //等待下载
    TASK_DOWNLOADING    = 2,    //正在下载
    TASK_PAUSED         = 3,    //已经暂停
    TASK_CANCELED       = 4,    //已经取消（下载中取消或者删除）
    TASK_DELETED        = 5,    //已经删除（下载完成删除）
};

typedef NS_ENUM(NSInteger, LBTaskPriority)
{
    TASK_PRIORITY_DEFAULT = 0,  //默认
    TASK_PRIORITY_LOW     = 1,  //低
    TASK_PRIORITY_NORMAL  = 2,  //普通
    TASK_PRIORITY_HIGH    = 3,  //高
};

@interface LBDownloadTask : NSObject

/****** 只读 ******/
///下载资源地址
@property (nonatomic, copy, readonly) NSURL *taskURL;
///保存的文件名
@property (nonatomic, copy, readonly) NSString *fileName;
///任务标识
@property (nonatomic, copy, readonly) NSString *taskIdentifier;
///任务状态
@property (nonatomic, assign, readonly) LBTaskStatus taskStatus;

/****** 可配置 ******/
///任务优先级
@property (nonatomic, assign) LBTaskPriority taskPriority;
///用来回复下载的数据
@property (nonatomic, copy) NSData *resumeData;

///创建任务
+ (instancetype)lb_taskWithURL:(NSURL *)url fileName:(NSString *)fileName;
- (instancetype)initWithURL:(NSURL *)url fileName:(NSString *)fileName;

///转成字典
- (NSDictionary *)toDictionary;
///转成模型
+ (instancetype)loadTaskFromDictionary:(NSDictionary *)dict;
@end
