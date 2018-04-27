//
//  LBDownloadSession.m
//  LBDownloader
//
//  Created by 吴龙波 on 2018/4/27.
//  Copyright © 2018 WhatTheGhost. All rights reserved.
//

#import "LBDownloadSession.h"
#import "LBDownloadTask.h"

#define DEFAULT_TIMEOUT 60

@interface LBDownloadSession ()<NSURLSessionDownloadDelegate>
///下载的任务
@property (nonatomic, strong) LBDownloadTask *task;
///下载会话
@property (nonatomic, strong) NSURLSession *urlSession;
///默认下载配置
@property (nonatomic, strong) NSURLSessionConfiguration *defaultConfiguration;
///自定义下载配置
@property (nonatomic, strong) NSURLSessionConfiguration *customConfiguration;
@end

@implementation LBDownloadSession

#pragma mark - 创建下载
+ (instancetype)lb_sessionWithURL:(NSURL *)url fileName:(NSString *)fileName
{
    LBDownloadSession *session = [[LBDownloadSession alloc]init];
    session.task = [[LBDownloadTask alloc]initWithURL:url fileName:fileName];
    return session;
}

- (instancetype)initWithURL:(NSURL *)url fileName:(NSString *)fileName
{
    if ([self init]) {
        self.task = [[LBDownloadTask alloc]initWithURL:url fileName:fileName];
    }
    return self;
}

#pragma mark - 下载操作
- (void)startDownload
{
    if (!_task) {
        NSLog(@"LBDownloadSession start with no task");
        return;
    }
    self.urlSession = [NSURLSession sessionWithConfiguration:self.customConfiguration ? self.customConfiguration : self.defaultConfiguration delegate:self delegateQueue:nil];
    switch (self.task.taskStatus) {
        case TASK_NULL:
        case TASK_WAITING:
        {
            //还未开始下载
            [self startNewDownload];
        }
            break;
        case TASK_DOWNLOADING:
            //正在下载
            
            break;
        case TASK_PAUSED:
            //暂停中
            
            break;
        case TASK_CANCELED:
        {
            //已经取消，判断是否有可以恢复下载的数据，有的话继续，没有的话重新开始下载
            if (self.task.resumeData) {
                [self resumeDownload];
            } else {
                [self startNewDownload];
            }
        }
            break;
        case TASK_DELETED:
            //已经删除，判断是否有本地已经下载完成文件，有的话完成下载，没有的话重新开始下载
            
            break;
    }
}

//开始新的下载
- (void)startNewDownload
{
    [self.urlSession downloadTaskWithURL:self.task.taskURL];
}

///根据数据恢复下载
- (void)resumeDownload
{
    [self.urlSession downloadTaskWithResumeData:self.task.resumeData];
}

///停止下载
- (void)stopDownload
{
    
}

///删除下载
- (void)deleteDownload
{
    
}

#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error
{
    //恢复下载用的数据
    NSData *resumeData = error.userInfo[NSURLSessionDownloadTaskResumeData];
    self.task.resumeData = resumeData.copy;
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    SecTrustRef trust = challenge.protectionSpace.serverTrust;
    NSString* host = self.task.taskURL.host;
    NSURLCredential *cred = [self customAuthenticationChallenge:trust domain:host];
    
    if(completionHandler)
    {
        if (cred) {
            completionHandler(NSURLSessionAuthChallengeUseCredential,cred);
        }else{
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge,cred);
        }
    }
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    
}

#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    //处理下载完成的文件
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    //处理下载进度
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    //恢复下载
}

#pragma mark - Private
-(NSURLCredential*)customAuthenticationChallenge:(SecTrustRef)trust domain:(NSString*)domain
{
    SecTrustResultType result;
    SecPolicyRef policyOverride = nil;
    //指定域名
    if (domain) {
        policyOverride = SecPolicyCreateSSL(true, (CFStringRef)domain);
        NSMutableArray * policies = [NSMutableArray array];
        [policies addObject:(__bridge id)policyOverride];
        SecTrustSetPolicies(trust, (__bridge CFArrayRef)policies);
    }
    if (policyOverride) {
        CFRelease(policyOverride);
    }
    OSStatus status = SecTrustEvaluate(trust, &result);
    if (status == errSecSuccess &&
        (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified)) {
        return [NSURLCredential credentialForTrust:trust];
    }else{
        return nil;
    }
}

#pragma mark - LazyLoad
- (NSURLSessionConfiguration *)defaultConfiguration
{
    if (!_defaultConfiguration) {
        _defaultConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:self.task.taskIdentifier];
    }
    return _defaultConfiguration;
}
@end
