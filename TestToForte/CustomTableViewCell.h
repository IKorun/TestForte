//
//  CustomTableCellTableViewCell.h
//  TestToForte
//
//  Created by Orangesoft  on 4/21/16.
//  Copyright © 2016 iKoGor.by. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCellInfo.h"


@interface CustomTableViewCell : UITableViewCell


- (IBAction)handleClick:(id)sender;

@property (nonatomic, weak) IBOutlet UILabel *filenameField;
@property (nonatomic, weak) IBOutlet UILabel *stateField;
@property (nonatomic, weak) IBOutlet UIButton *button;
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;

@property (nonatomic) DownloadState state;

@property (nonatomic) NSIndexPath *indexPath;

@property (nonatomic, weak) CustomCellInfo *cellInfo;


@end
