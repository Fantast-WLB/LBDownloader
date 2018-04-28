//
//  LBFileHandler.m
//  LBDownloader
//
//  Created by 吴龙波 on 2018/4/27.
//  Copyright © 2018 WhatTheGhost. All rights reserved.
//

#import "LBFileHandler.h"

#define FILE_MANAGER [NSFileManager defaultManager]

@interface LBFileHandler ()
///文件信息
@property (nonatomic, strong) NSDictionary *fileInfo;
@end

@implementation LBFileHandler

#pragma mark - Singleton
+ (instancetype)defaultHandler {
    static LBFileHandler *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static LBFileHandler *instance = nil;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        instance = (LBFileHandler *) [super allocWithZone:zone];
    });
    return instance;
}

+ (id)copyWithZone:(struct _NSZone *)zone {
    return [[self class] defaultHandler];
}

#pragma mark - 文件
///保存文件到某个路径
- (void)saveFileData:(NSData *)data toPath:(NSString *)path
{
    if ([FILE_MANAGER isWritableFileAtPath:path]) {
        [data writeToFile:path atomically:YES];
    }
}

///新增文件信息记录
- (void)addFileToPlistWithURL:(NSURL *)url fileName:(NSString *)fileName
{
    [self.fileInfo setValue:fileName forKey:url.absoluteString];
    [self saveFileInfo];
}

///检查文件是否存在
- (BOOL)fileExistWithPath:(NSString *)filePath
{
    return [FILE_MANAGER fileExistsAtPath:filePath];
}

///创建文件夹
- (NSString *)createFolder:(NSString *)path
{
    NSError *error = nil;
    if (![self fileExistWithPath:path]) {
        [FILE_MANAGER createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"Create Folder Error:%@",[error description]);
            return nil;
        }
    }
    return path;
}

///读取已下载文件信息
- (NSDictionary *)loadFileInfo
{
    return [NSDictionary dictionaryWithContentsOfFile:FINISHED_PLIST];
}

///保存已下载文件信息
- (void)saveFileInfo
{
    if ([FILE_MANAGER isWritableFileAtPath:FINISHED_PLIST]) {
        [self.fileInfo writeToFile:FINISHED_PLIST atomically:YES];
    }
}

#pragma mark - 其他
///根据URL生成标识
- (NSString *)identifierWithURL:(NSURL *)url
{
    return [NSString stringWithFormat:@"%@_lb",url.absoluteString];
}

///根据URL和文件名生成标识
- (NSString *)identifierWithURL:(NSURL *)url fileName:(NSString *)fileName
{
    return [NSString stringWithFormat:@"%@_%@",url.absoluteString,fileName];
}

#pragma mark - LazyLoad
- (NSDictionary *)fileInfo
{
    if (!_fileInfo) {
        _fileInfo = [self loadFileInfo];
    }
    return _fileInfo;
}
@end
