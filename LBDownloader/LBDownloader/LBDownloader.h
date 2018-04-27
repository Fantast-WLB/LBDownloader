//
//  LBDownloader.h
//  LBDownloader
//
//  Created by 吴龙波 on 2018/4/27.
//  Copyright © 2018 WhatTheGhost. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LBDownloadTask;

@interface LBDownloader : NSObject

///单例下载器
+ (instancetype)sharedInstance;


@end
