//
//  LBFileHandler.h
//  LBDownloader
//
//  Created by 吴龙波 on 2018/4/27.
//  Copyright © 2018 WhatTheGhost. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FILE_HANDLER [LBFileHandler defaultHandler]

///项目主文件夹（一级）
#define BASE @"LBDownload"

///已下载文件夹（二级）
#define FINISHED @"Finished"

///未完成文件夹（二级）
#define TEMP @"Temp"

///缓存文件夹
#define CACHES_DIRECTORY [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

///已下载文件夹路径
#define FINISHED_FOLDER [NSString stringWithFormat:@"%@/%@/%@",CACHES_DIRECTORY,BASE,FINISHED]

///已下载文件的路径
#define FILE_PATH(fileName) [NSString stringWithFormat:@"%@/%@",[FILE_HANDLER createFolder:FINISHED_FOLDER],fileName]

///已下载文件信息路径
#define FINISHED_PLIST [NSString stringWithFormat:@"%@/FinishedFile.plist",FINISHED_FOLDER]

///未完成文件夹路径
#define TEMP_FOLDER [NSString stringWithFormat:@"%@/%@/%@",CACHES_DIRECTORY,BASE,TEMP]

///未完成文件的路径
#define TEMP_PATH(fileName) [NSString stringWithFormat:@"%@/%@",[FILE_HANDLER createFolder:TEMP_FOLDER],fileName]

///未完成文件任务信息路径
#define TASKS_PLIST [NSString stringWithFormat:@"%@/Tasks.plist",TEMP_FOLDER]

@interface LBFileHandler : NSObject
///文件信息
@property (nonatomic, strong, readonly) NSDictionary *fileInfo;

///单例
+ (instancetype)defaultHandler;

///保存文件到某个路径
- (void)saveFileData:(NSData *)data toPath:(NSString *)path;
///新增文件信息记录
- (void)addFileToPlistWithURL:(NSURL *)url fileName:(NSString *)fileName;

///检查文件是否存在
- (BOOL)fileExistWithPath:(NSString *)filePath;
///创建文件夹
- (NSString *)createFolder:(NSString *)path;

///根据URL生成标识
- (NSString *)identifierWithURL:(NSURL *)url;
///根据URL和文件名生成标识
- (NSString *)identifierWithURL:(NSURL *)url fileName:(NSString *)fileName;
@end
