//
//  MovieObject.m
//  HollywoodGenius
//
//  Created by Ekam Singh Dhaliwal on 2019-06-20.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import "MovieObject.h"

@implementation MovieObject


- (instancetype)initWithTitle:(NSString *)title andUID:(NSString *)uuid
{
    self = [super init];
    if (self) {
        self.title = title;
        self.uuid = uuid; 
    }
    return self;
}


+ (NSString *)primaryKey {
    
    return @"uuid";
    
}

@end
