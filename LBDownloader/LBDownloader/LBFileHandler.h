//
//  LBFileHandler.h
//  LBDownloader
//
//  Created by 吴龙波 on 2018/4/27.
//  Copyright © 2018 WhatTheGhost. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBFileHandler : NSObject

///根据URL生成标识
+ (NSString *)identifierWithURL:(NSURL *)url;
///根据URL和文件名生成标识
+ (NSString *)identifierWithURL:(NSURL *)url fileName:(NSString *)fileName;

@end
