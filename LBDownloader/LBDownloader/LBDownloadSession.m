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

#pragma mark - 操作
- (void)startDownload
{
    if (!_task) {
        NSLog(@"LBDownloadSession start with no task");
        return;
    }
    switch (self.task.taskStatus) {
        case TASK_NULL:
        case TASK_WAITING:
            //还未开始下载
            
            break;
        case TASK_DOWNLOADING:
            //正在下载
            
            break;
        case TASK_PAUSED:
            //暂停中
            
            break;
        case TASK_CANCELED:
            //已经取消
            
            break;
        case TASK_DELETED:
            //已经删除
            
            break;
    }
    self.urlSession = [NSURLSession sessionWithConfiguration:self.customConfiguration ? self.customConfiguration : self.defaultConfiguration delegate:self delegateQueue:[[NSOperationQueue alloc]init]];

    [self.urlSession downloadTaskWithURL:self.task.taskURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }];
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
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
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
