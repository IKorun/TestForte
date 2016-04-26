//
//  DownloadQueue.h
//  TestToForte
//
//  Created by Orangesoft  on 4/25/16.
//  Copyright © 2016 iKoGor.by. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CustomCellInfo;

@interface DownloadQueue : NSObject


+ (DownloadQueue *)sharedQueue;

- (instancetype)initWithMinNumberOfActiveDownloads:(NSUInteger)minNumber;

- (void)addCellInfo:(CustomCellInfo *)cellInfo;

- (void)cellStartDownload:(CustomCellInfo *)cellInfo;

- (void)cellCompleteDownload:(CustomCellInfo *)cellInfo;


@property(nonatomic) BOOL isStarted;


@end
