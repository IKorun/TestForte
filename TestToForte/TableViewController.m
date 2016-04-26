//
//  TableViewController.m
//  TestToForte
//
//  Created by Orangesoft  on 4/21/16.
//  Copyright © 2016 iKoGor.by. All rights reserved.
//

#import "TableViewController.h"
#import "CustomTableViewCell.h"
#import "DownloadQueue.h"


NSString * const DQURLKey = @"download_sd";


@interface TableViewController ()

{
    DownloadQueue *_downloadQueue;
    BOOL _isFirstLoad;
}

@property (nonatomic) NSMutableDictionary *cellsInfo;

@end


@implementation TableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isFirstLoad = YES;
    
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                  target:self
                                                  action:@selector(startDownloadQueue)]];
    
    _downloadQueue = [DownloadQueue sharedQueue];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"CustomCell"];
    
    self.cellsInfo = [[NSMutableDictionary alloc] init];
}


- (void)startDownloadQueue
{
    _downloadQueue.isStarted = YES;
}


- (void)setSourceArray:(NSMutableArray *)sourceArray
{
    if (_sourceArray != sourceArray)
    {
        NSMutableArray *tempArray = [self filteredArrayFromArray:sourceArray];
        
        _isFirstLoad = NO;
        
        _sourceArray = tempArray;
        
        [self.tableView reloadData];
    }
}


- (NSMutableArray *)filteredArrayFromArray:(NSArray *)array
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSDictionary *cellDescription in array)
    {
        CustomCellInfo *cellInfo = [self cellInfoFromDescription:cellDescription];
        NSString *urlString = [cellDescription objectForKey:DQURLKey];
        
        if (urlString != nil && [urlString class] != [NSNull class])
        {
            [tempArray addObject:cellDescription];
            
            if (_isFirstLoad)
            {
                [self.cellsInfo setObject:cellInfo
                                   forKey:[self keyForDictionaryWithCellDescription:cellDescription]];
            }
        }
    }
    
    return tempArray;
}


- (NSString *)keyForDictionaryWithCellDescription:(NSDictionary *)description
{
    return [description objectForKey:DQURLKey];
}


- (void)removeCellByIndexPath:(NSIndexPath *)iPath
{
    NSUInteger index = iPath.row;
    
    [self.sourceArray removeObjectAtIndex:index];
    NSNumber *key = [[self.cellsInfo allKeys] objectAtIndex:index];
    [self.cellsInfo removeObjectForKey:key];
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:iPath, nil]
                          withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    NSString *title = (self.sourceArray.count == 0) ? @"Connecting" : @"";
    
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class]]] setTextAlignment:NSTextAlignmentCenter];
    
    return title;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceArray.count;
}


- (CustomTableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"CustomCell";
    
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                                       forIndexPath:indexPath];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell"
                                                     owner:self
                                                   options:nil];
        cell = (CustomTableViewCell *)[nib objectAtIndex:0];
    }
    
    [self configureCell:cell
      forRowAtIndexPath:indexPath];
    
    return cell;
}


- (void)configureCell:(CustomTableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = indexPath.row;
    
    NSDictionary *cellDescription = [self.sourceArray objectAtIndex:index];
    
    CustomCellInfo *cellInfo = [self cellInfoWithDublicateCheckFromDescription:cellDescription];
    
    cellInfo.cell = cell;
    
    [[DownloadQueue sharedQueue] addCellInfo:cellInfo];
    
    cell.cellInfo = cellInfo;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
}


- (CustomCellInfo *)cellInfoWithDublicateCheckFromDescription:(NSDictionary *)cellDescription
{
    NSString *identificator = [self keyForDictionaryWithCellDescription:cellDescription];
    
    CustomCellInfo *cellInfo = [self.cellsInfo objectForKey:identificator];
    
    if (cellInfo == nil)
    {
        cellInfo = [self cellInfoFromDescription:cellDescription];
        
        [self.cellsInfo setObject:cellInfo
                           forKey:identificator];
    }
    
    return cellInfo;
}


- (CustomCellInfo *)cellInfoFromDescription:(NSDictionary *)cellDescription
{
    CustomCellInfo *cellInfo = [[CustomCellInfo alloc] init];
    
    NSString *urlString = [cellDescription objectForKey:DQURLKey];
    
    if (urlString != nil && [urlString class] != [NSNull class])
    {
        cellInfo.downloadURLString = [urlString copy];
    }
    
    NSArray *partsOfUrl = [cellInfo.downloadURLString componentsSeparatedByString:@"/"];
    
    cellInfo.filename = [[partsOfUrl lastObject] copy];
    
    return cellInfo;
}


@end
