//
//  Movie.m
//  HollywoodGenius
//
//  Created by Cameron Mcleod on 2019-06-19.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.clips = [[NSMutableArray alloc] init];
        self.quotes = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title andClips: (NSMutableArray *)clips
{
    self = [super init];
    if (self) {
        
        self.title = title;
        self.clips = [[NSMutableArray alloc] initWithArray:clips];
        
    }
    return self;
}

@end
