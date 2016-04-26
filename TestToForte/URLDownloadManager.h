//
//  URLDownloadManager.h
//  TestToForte
//
//  Created by Orangesoft  on 4/23/16.
//  Copyright © 2016 iKoGor.by. All rights reserved.
//

#import "URLDataManager.h"


@interface URLDownloadManager : URLDataManager


- (instancetype)initWithURL:(NSURL *)url andDelegate:(id <NSURLSessionDownloadDelegate, NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>)delegate;

- (void)pause;

- (void)resume;


@end
