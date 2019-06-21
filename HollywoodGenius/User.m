//
//  User.m
//  HollywoodGenius
//
//  Created by Cameron Mcleod on 2019-06-21.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)init
{
    self = [super init];
    if (self) {
        _totalScore = 0;
        _averageTime = 0.0;;
    }
    return self;
}

@end
