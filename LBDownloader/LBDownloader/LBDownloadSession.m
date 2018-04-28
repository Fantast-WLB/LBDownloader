//
//  LBDownloadSession.m
//  LBDownloader
//
//  Created by 吴龙波 on 2018/4/27.
//  Copyright © 2018 WhatTheGhost. All rights reserved.
//

#warning todo:1.封装配置;2.后台下载

#import "LBDownloadSession.h"
#import "LBDownloadTask.h"
#import "LBFileHandler.h"

#define DEFAULT_TIMEOUT 60

@interface LBDownloadSession ()<NSURLSessionDownloadDelegate,NSURLSessionDataDelegate>
///下载的任务
@property (nonatomic, strong) LBDownloadTask *task;
///下载会话
@property (nonatomic, strong) NSURLSession *urlSession;
///代理队列
@property (nonatomic, strong) NSOperationQueue *sessionQueue;
///默认下载配置
@property (nonatomic, strong) NSURLSessionConfiguration *defaultConfiguration;
///自定义下载配置
@property (nonatomic, strong) NSURLSessionConfiguration *customConfiguration;
///上一个记录的时间
@property (nonatomic, assign) NSTimeInterval lastTimestamp;
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
#warning todo:检查是否存在本地任务(此前的判断是否够多了？)
    
    self.urlSession = [NSURLSession sessionWithConfiguration:self.customConfiguration ? self.customConfiguration : self.defaultConfiguration delegate:self delegateQueue:self.sessionQueue];
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
    self.lastTimestamp = [self getCurrentTimestamp];
    self.task.taskStatus = TASK_DOWNLOADING;
    [self.urlSession downloadTaskWithURL:self.task.taskURL];
}

///根据数据恢复下载
- (void)resumeDownload
{
    self.lastTimestamp = [self getCurrentTimestamp];
    self.task.taskStatus = TASK_DOWNLOADING;
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
    //保存下载完成的文件
    NSData *fileData = [NSData dataWithContentsOfURL:location];
    [FILE_HANDLER saveFileData:fileData.copy toPath:FILE_PATH(self.task.fileName)];
    [FILE_HANDLER addFileToPlistWithURL:self.task.taskURL fileName:self.task.fileName];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSTimeInterval interval = [self getCurrentTimestamp] - self.lastTimestamp;
    double downloadSpeed = bytesWritten / interval;//每秒下载量
    double downloadProgress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;//下载进度
    if (self.delegate && [self.delegate respondsToSelector:@selector(sessionDownloading:withSpeed:progress:)]) {
        [self.delegate sessionDownloading:self withSpeed:downloadSpeed progress:downloadProgress];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(sessionDownloading:withSpeed:progress:totalBytesWritten:totalBytesExpectedToWrite:)]) {
        [self.delegate sessionDownloading:self withSpeed:downloadSpeed progress:downloadProgress totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    //恢复下载
}

#pragma mark - NSURLSessionDataDelegate
/* The task has received a response and no further messages will be
 * received until the completion block is called. The disposition
 * allows you to cancel a request or to turn a data task into a
 * download task. This delegate message is optional - if you do not
 * implement it, you can get the response as a property of the task.
 *
 * This method will not be called for background upload tasks (which cannot be converted to download tasks).
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    
}

/* Notification that a data task has become a download task.  No
 * future messages will be sent to the data task.
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    
}

/* Sent when data is available for the delegate to consume.  It is
 * assumed that the delegate will retain and not copy the data.  As
 * the data may be discontiguous, you should use
 * [NSData enumerateByteRangesUsingBlock:] to access it.
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
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

- (NSTimeInterval)getCurrentTimestamp
{
    return [[NSDate date] timeIntervalSince1970];
}

#pragma mark - LazyLoad
- (NSURLSessionConfiguration *)defaultConfiguration
{
    if (!_defaultConfiguration) {
        _defaultConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:self.task.taskIdentifier];
    }
    return _defaultConfiguration;
}

- (NSOperationQueue *)sessionQueue
{
    if (!_sessionQueue) {
        _sessionQueue = [[NSOperationQueue alloc]init];
    }
    return _sessionQueue;
}
@end
