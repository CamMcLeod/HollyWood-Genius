//
//  ScoreHistory.m
//  HollywoodGenius
//
//  Created by Ekam Singh Dhaliwal on 2019-06-22.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import "ScoreHistory.h"


@implementation ScoreHistory

static float foo = 0;

- (instancetype)initWithTotalScore:(int)totalScore andAverageTime:(NSString *)averageTime  andUUID:(NSString *)uuid
{
    self = [super init];
    if (self) {
        self.averageTime = averageTime;
        self.totalScore = totalScore;
        self.uuid = uuid; 
    }
    return self;
}



+ (NSString *)primaryKey {
    
    return @"uuid";
    
}

@end
