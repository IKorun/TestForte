//
//  TableViewController.h
//  TestToForte
//
//  Created by Orangesoft  on 4/21/16.
//  Copyright © 2016 iKoGor.by. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CustomTableViewCell;

@interface TableViewController : UITableViewController


- (void)removeCellByIndexPath:(NSIndexPath *)iPath;

@property(nonatomic)NSMutableArray *sourceArray;

@property (nonatomic) IBOutlet CustomTableViewCell *customCell;


@end
