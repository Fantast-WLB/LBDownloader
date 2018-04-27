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
    TASK_WAITING        = 1,    //等待下载
    TASK_DOWNLOADING    = 2,    //正在下载
    TASK_PAUSED         = 3,    //已经暂停
    TASK_CANCELED       = 4,    //已经取消
    TASK_DELETED        = 5,    //已经删除
};

@interface LBDownloadTask : NSObject
///下载资源地址
@property (nonatomic, copy) NSURL *taskURL;
///保存的文件名
@property (nonatomic, copy) NSString *fileName;
///任务状态
@property (nonatomic, assign) LBTaskStatus taskStatus;

///转成字典
- (NSDictionary *)toDictionary;
///转成模型
+ (instancetype)loadTaskFromDictionary:(NSDictionary *)dict;
@end
