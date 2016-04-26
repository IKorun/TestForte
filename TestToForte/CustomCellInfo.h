//
//  CustomCellInfo.h
//  TestToForte
//
//  Created by Orangesoft  on 4/25/16.
//  Copyright © 2016 iKoGor.by. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLDownloadManager.h"
//#import "CustomTableViewCell.h"

@class CustomTableViewCell;

typedef NS_ENUM(NSUInteger, DownloadState)
{
    DownloadStateStopped,
    DownloadStateActive,
    DownloadStatePaused,
    DownloadStateDownloaded
};


@interface CustomCellInfo : NSObject<NSURLSessionDownloadDelegate, NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>

@property (nonatomic) NSString *downloadURLString;

@property (nonatomic) NSString *buttonText;
@property (nonatomic) NSString *filename;
@property (nonatomic) NSString *stateText;

@property (nonatomic) float progress;

@property (nonatomic, weak) CustomTableViewCell *cell;

@property (nonatomic) DownloadState state;

@end
