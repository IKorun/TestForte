//
//  URLDownloadManager.m
//  TestToForte
//
//  Created by Orangesoft  on 4/23/16.
//  Copyright © 2016 iKoGor.by. All rights reserved.
//

#import "URLDownloadManager.h"


@interface URLDownloadManager()

{
    NSURLSessionDownloadTask *_downloadTask;
}

@property (nonatomic, strong)NSURLSession *session;

@property (nonatomic) NSURL *workingUrl;

@end


@implementation URLDownloadManager

@synthesize workingUrl = _workingUrl;


- (instancetype)initWithURL:(NSURL *)url
                andDelegate:(id<NSURLSessionDownloadDelegate, NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>)delegate
{
    self = [super initWithURL:url];
    
    if (self != nil)
    {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                     delegate:delegate
                                                delegateQueue:nil];
        _downloadTask = [self.session downloadTaskWithURL:url];
        
        self.workingUrl = url;
    }
    
    return self;
}


- (void)pause
{
    [_downloadTask suspend];
}


- (void)resume
{
    [_downloadTask resume];
}


@end
