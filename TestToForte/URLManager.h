//
//  URLManager.h
//  TestToForte
//
//  Created by Orangesoft  on 4/23/16.
//  Copyright © 2016 iKoGor.by. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLManager : NSObject


@property (nonatomic, copy) NSURL *workingUrl;

- (instancetype)initWithURL:(NSURL *)url;


@end
