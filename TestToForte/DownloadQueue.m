//
//  DownloadQueue.m
//  TestToForte
//
//  Created by Orangesoft  on 4/25/16.
//  Copyright © 2016 iKoGor.by. All rights reserved.
//

#import "DownloadQueue.h"
#import "CustomCellInfo.h"


@interface DownloadQueue()

{
    NSUInteger _minNumberOfDowndloads;
    NSUInteger _indexofFirstInactiveCell;
    
    NSMutableArray *_cellsInfo;
    NSMutableArray *_cellsInfoWithActiveDownload;
    NSMutableArray *_cellsInfoWithCompletedDownload;
}

@end


@implementation DownloadQueue

+ (DownloadQueue *)sharedQueue
{
    static DownloadQueue *sharedQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQueue = [[DownloadQueue alloc] initWithMinNumberOfActiveDownloads:10];
    });
    return sharedQueue;
}


- (instancetype)initWithMinNumberOfActiveDownloads:(NSUInteger)minNumber
{
    self = [super init];
    
    if (self != nil)
    {
        _minNumberOfDowndloads = minNumber;
        
        _cellsInfo = [[NSMutableArray alloc] init];
        _cellsInfoWithActiveDownload = [[NSMutableArray alloc] init];
        _cellsInfoWithCompletedDownload = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)setIsStarted:(BOOL)isStarted
{
    if (_isStarted != isStarted)
    {
        _isStarted = isStarted;
        
        if (_isStarted)
        {
            [self start];
        }
    }
}


- (void)start
{
    NSUInteger countOfDownloads = _cellsInfoWithActiveDownload.count;
    
    for (CustomCellInfo *cellInfo in _cellsInfo)
    {
        _indexofFirstInactiveCell++;
        
        if (cellInfo.state == DownloadStateStopped)
        {
            [self startDownloadInCellInfo:cellInfo];
            countOfDownloads++;
            
            if (countOfDownloads >= _minNumberOfDowndloads)
            {
                break;
            }
        }
    }
}


- (void)startDownloadInCellInfo:(CustomCellInfo *)cellInfo
{
    if (![_cellsInfoWithActiveDownload containsObject:cellInfo])
    {
        [_cellsInfoWithActiveDownload addObject:cellInfo];
        cellInfo.state = DownloadStateActive;
    }
}



- (void)addCellInfo:(CustomCellInfo *)cellInfo
{
    [self addCellInfo:cellInfo
              toArray:_cellsInfo];
    
    if (self.isStarted && _cellsInfoWithActiveDownload.count < _minNumberOfDowndloads)
    {
        [self startDownloadInCellInfo:cellInfo];
    }
}


- (void)cellStartDownload:(CustomCellInfo *)cellInfo
{
    [self addCellInfo:cellInfo
              toArray:_cellsInfoWithActiveDownload];
}


- (void)cellCompleteDownload:(CustomCellInfo *)cellInfo
{
    if ([_cellsInfoWithActiveDownload containsObject:cellInfo])
    {
        [_cellsInfoWithCompletedDownload addObject:cellInfo];
        [_cellsInfoWithActiveDownload removeObject:cellInfo];
        
        [self handleCompletedTaskInInfo:cellInfo];
    }
}


- (void)handleCompletedTaskInInfo:(CustomCellInfo *)cellInfo
{
    while(_cellsInfoWithActiveDownload.count < _minNumberOfDowndloads)
    {
        if (_indexofFirstInactiveCell < _cellsInfo.count - 1)
        {
            CustomCellInfo *cellInfo = [_cellsInfo objectAtIndex:_indexofFirstInactiveCell++];
            
            if (![_cellsInfoWithActiveDownload containsObject:cellInfo])
            {
                cellInfo.state = DownloadStateActive;
            }
        }
        else
        {
            break;
        }
    }
}


- (void)addCellInfo:(CustomCellInfo *)cellInfo
            toArray:(NSMutableArray *)arr
{
    if (![arr containsObject:cellInfo])
    {
        [arr addObject:cellInfo];
    }
}


@end
