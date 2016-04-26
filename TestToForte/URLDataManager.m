//
//  URLManager.m
//  TestToForte
//
//  Created by Orangesoft  on 4/21/16.
//  Copyright © 2016 iKoGor.by. All rights reserved.
//

#import "URLDataManager.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>

@interface URLDataManager()

@property (nonatomic) NSURL *workingUrl;
@property (nonatomic) NSDictionary *parsedDictionary;

@end


@implementation URLDataManager


@synthesize workingUrl = _workingUrl;

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super initWithURL:url];
    
    if (self != nil)
    {
        self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    
    return self;
}


- (void)setWorkingUrl:(NSURL *)workingUrl
{
    if (_workingUrl != workingUrl)
    {
        _workingUrl = workingUrl;
        
        NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                              dataTaskWithURL:_workingUrl
                                              completionHandler:^(NSData *data,
                                                                  NSURLResponse *response,
                                                                  NSError *error) {
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      self.parsedDictionary = [self parseDataToDictionary:data];
                                                      
                                                      if ([self.delegate conformsToProtocol:@protocol(URLDataManagerDelegate)])
                                                      {
                                                          [self.delegate handleDictionary:self.parsedDictionary];
                                                      }
                                                  });
                                              }];
        
        [downloadTask resume];
    }
}


- (NSDictionary *)parseDataToDictionary:(NSData *)data
{
    NSDictionary *parsedDictionary = nil;
    
    NSError *error = nil;
    id parsedObject = [NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingMutableContainers
                                                        error:&error];
    
    if ([parsedObject isKindOfClass:[NSDictionary class]])
    {
        parsedDictionary = [NSDictionary dictionaryWithDictionary:parsedObject];
    }
    
    return parsedDictionary;
}


@end
