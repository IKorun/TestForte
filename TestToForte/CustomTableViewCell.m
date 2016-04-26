//
//  CustomTableCellTableViewCell.m
//  TestToForte
//
//  Created by Orangesoft  on 4/21/16.
//  Copyright © 2016 iKoGor.by. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "DownloadQueue.h"
#import "AppDelegate.h"
#import "TableViewController.h"


@implementation CustomTableViewCell


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setButtonTitleAccordingToState:self.state];
    
    [self constraintsSetUp];
}


- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.cellInfo.cell = nil;
    self.cellInfo = nil;
}


- (void)constraintsSetUp
{
    NSLayoutConstraint *buttonPositionConstraint = [NSLayoutConstraint constraintWithItem:self.button
                                                                  attribute:NSLayoutAttributeRight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeRight
                                                                 multiplier:1.0
                                                                   constant:-10.0];
    [self addConstraint:buttonPositionConstraint];
    
    [self addConstraint:[self widthConstraintForView:self.progressView
                                      withMultiplier:1.0]];
    
    [self addConstraint:[self widthConstraintForView:self.filenameField
                                      withMultiplier:0.75]];
    
    [self addConstraint:[self widthConstraintForView:self.stateField
                                      withMultiplier:0.75]];
}


- (NSLayoutConstraint *)widthConstraintForView:(UIView *)view
                                withMultiplier:(CGFloat)mult
{
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:NSLayoutAttributeWidth
                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                           toItem:self
                                        attribute:NSLayoutAttributeWidth
                                       multiplier:mult
                                         constant:0];
}


- (IBAction)handleClick:(id)sender
{
    switch (self.state)
    {
        case DownloadStateStopped:
        {
            self.cellInfo.state = DownloadStateActive;
        }
            break;
            
        case DownloadStateActive:
        {
            self.cellInfo.state = DownloadStatePaused;
        }
            break;
            
        case DownloadStatePaused:
        {
            self.cellInfo.state = DownloadStateActive;
        }
            break;
            
        case DownloadStateDownloaded:
        {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]
                                                       delegate];
            
            [appDelegate.tController removeCellByIndexPath:self.indexPath];
        }
            break;
            
        default:
            break;
    }
}


- (void)setState:(DownloadState)state
{
    if (_state != state)
    {
        _state = state;
        
        [self setButtonTitleAccordingToState:_state];
    }
}


- (void)setButtonTitleAccordingToState:(DownloadState)state
{
    switch (_state)
    {
        case DownloadStateStopped:
        {
            [self setButtonTitle:@"Download"];
        }
            break;
            
        case DownloadStateActive:
        {
            [self setButtonTitle:@"Pause"];
        }
            break;
            
        case DownloadStatePaused:
        {
            [self setButtonTitle:@"Resume"];
        }
            break;
            
        case DownloadStateDownloaded:
        {
            [self setButtonTitle:@"Remove"];
        }
            break;
            
        default:
            break;
    }

}


- (void)setCellInfo:(CustomCellInfo *)cellInfo
{
    if (_cellInfo != cellInfo)
    {
        _cellInfo = cellInfo;
        
        self.state = _cellInfo.state;
        self.filenameField.text = _cellInfo.filename;
        self.stateField.text = _cellInfo.stateText;
        [self.progressView setProgress:_cellInfo.progress];
    }
}


- (void)setButtonTitle:(NSString *)title
{
    [self.button setTitle:title forState:UIControlStateNormal];
}

@end
