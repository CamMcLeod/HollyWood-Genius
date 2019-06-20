//
//  Movie.m
//  HollywoodGenius
//
//  Created by Cameron Mcleod on 2019-06-19.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (instancetype)initWith:(NSString *)title andActors: (NSArray *)actors andClips: (NSDictionary *)clips
{
    self = [super init];
    if (self) {
        
        self.title = title;
        self.actors = [[NSMutableArray alloc] initWithArray:actors];
        self.clips = [[NSMutableDictionary alloc] initWithDictionary:clips];
        
    }
    return self;
}

@end
