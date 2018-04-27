//
//  LBDownloadTask.m
//  LBDownloader
//
//  Created by 吴龙波 on 2018/4/27.
//  Copyright © 2018 WhatTheGhost. All rights reserved.
//

#import "LBDownloadTask.h"

@implementation LBDownloadTask

///转成字典
- (NSDictionary *)toDictionary
{
    return @{
             @"taskURL"  : _taskURL,
             @"fileName" : _fileName,
             @"taskStatus" : @(_taskStatus),
             };
}

///转成模型
+ (instancetype)loadTaskFromDictionary:(NSDictionary *)dict
{
    LBDownloadTask *task = [[LBDownloadTask alloc]init];
    
    task.taskURL = dict[@"taskURL"];
    task.fileName = dict[@"fileName"];
    task.taskStatus = [dict[@"taskStatus"] integerValue];
    
    return task;
}

@end
