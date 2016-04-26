//
//  URLManager.m
//  TestToForte
//
//  Created by Orangesoft  on 4/23/16.
//  Copyright © 2016 iKoGor.by. All rights reserved.
//

#import "URLManager.h"

@implementation URLManager


- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    
    if (self != nil)
    {
        self.workingUrl = url;
    }
    
    return self;
}


@end
