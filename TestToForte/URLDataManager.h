//
//  URLManager.h
//  TestToForte
//
//  Created by Orangesoft  on 4/21/16.
//  Copyright © 2016 iKoGor.by. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLManager.h"

@class AppDelegate;

@protocol URLDataManagerDelegate <NSObject>

- (void)handleDictionary:(NSDictionary *)dictionary;

@end


@interface URLDataManager : URLManager


- (NSDictionary *)parsedDictionary;

@property (nonatomic, readonly) NSDictionary *parsedDictionary;
@property (strong, nonatomic) AppDelegate <URLDataManagerDelegate> *delegate;


@end
