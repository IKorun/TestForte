//
//  CustomCellInfo.m
//  TestToForte
//
//  Created by Orangesoft  on 4/25/16.
//  Copyright © 2016 iKoGor.by. All rights reserved.
//

#import "CustomCellInfo.h"
#import "DownloadQueue.h"
#import "CustomTableViewCell.h"


@interface CustomCellInfo()

{
    URLDownloadManager *_downloadManager;
    
    NSString *_totalDownloaded;
    NSString *_totalSize;
    
    float _progress;
}

@end


@implementation CustomCellInfo


- (NSArray *)formatedStateNames
{
    static NSMutableArray * _names = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _names = [NSMutableArray arrayWithCapacity:4];
        [_names insertObject:@""
                     atIndex:DownloadStateStopped];
        [_names insertObject:@"Downloading"
                     atIndex:DownloadStateActive];
        [_names insertObject:@"Paused"
                     atIndex:DownloadStatePaused];
        [_names insertObject:@"Completed"
                     atIndex:DownloadStateDownloaded];
    });
    
    return _names;
}


- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray * tempArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [tempArray objectAtIndex:0];
    
    NSString *appDir = [docsDir stringByAppendingPathComponent:@"/Reader/"];
    
    if(![fileManager fileExistsAtPath:appDir])
    {
        [fileManager createDirectoryAtPath:appDir
               withIntermediateDirectories:NO
                                attributes:nil
                                     error:&error];
    }
    
    appDir =  [appDir stringByAppendingFormat:@"/%@",[[downloadTask response] suggestedFilename]];
    
    if([fileManager fileExistsAtPath:appDir])
    {
        NSLog([fileManager removeItemAtPath:appDir
                                      error:&error] ? @"deleted" : @"not deleted");
    }
    
    [fileManager moveItemAtPath:[location path]
                         toPath:appDir
                          error:&error];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[DownloadQueue sharedQueue] cellCompleteDownload:self];
        
        self.state = DownloadStateDownloaded;
    });
}


- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    _progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.cell.progressView setProgress:_progress];
        
        _totalDownloaded = [[self stringFromFileSize:totalBytesWritten] copy];
        _totalSize = [[self stringFromFileSize:totalBytesExpectedToWrite] copy];
        
        NSString *stateText = [self stringForStatusLabelWithProgress:_progress];
        self.stateText = [stateText copy];
        self.cell.stateField.text = stateText;
    });
}


- (NSString *)stringForStatusLabelWithProgress:(float)progress
{
    return [NSString stringWithFormat:@"%@ %@ of %@ (%.0f%@)", [[self formatedStateNames] objectAtIndex:self.state], _totalDownloaded, _totalSize, progress * 100, @"%"];
}


- (NSString *)stringFromFileSize:(long long)fSize
{
    return [NSByteCountFormatter stringFromByteCount:fSize
                                          countStyle:NSByteCountFormatterCountStyleFile];
}


- (void)setState:(DownloadState)state
{
    if (_state != state)
    {
        _state = state;
        
        switch (_state)
        {
            case DownloadStateActive:
            {
                [_downloadManager resume];
                
                [[DownloadQueue sharedQueue] cellStartDownload:self];
            }
                break;
                
            case DownloadStatePaused:
            {
                [_downloadManager pause];
                
                self.cell.stateField.text = [self stringForStatusLabelWithProgress:_progress];
            }
                break;
                
            case DownloadStateDownloaded:
            {
                self.cell.stateField.text = [self stringForStatusLabelWithProgress:_progress];
            }
                break;
                
            default:
                break;
        }
        
        self.cell.state = _state;
    }
}


- (void)setDownloadURLString:(NSString *)downloadURLString
{
    if (_downloadURLString != downloadURLString)
    {
        _downloadURLString = downloadURLString;
        
        NSURL *url = [NSURL URLWithString:_downloadURLString];
        
        if (_downloadManager == nil)
        {
            _downloadManager = [[URLDownloadManager alloc] initWithURL:url
                                                           andDelegate:self];
        }
        else
        {
            _downloadManager.workingUrl = url;
        }
    }
}

@end
