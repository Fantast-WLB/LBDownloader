//
//  LBDownloader.h
//  LBDownloader
//
//  Created by 吴龙波 on 2018/4/27.
//  Copyright © 2018 WhatTheGhost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBDownloadTask.h"

@interface LBDownloader : NSObject

///单例下载器
+ (instancetype)sharedInstance;

///新增一个下载任务
- (void)lb_downloadWithTask:(LBDownloadTask *)task;
@end
