//
//  QuestionManager.m
//  HollywoodGenius
//
//  Created by Cameron Mcleod on 2019-06-19.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import "AnswerManager.h"
#import "AnswerCluster.h"
#import "Movie.h"

@implementation AnswerManager

- (instancetype)init {
    if (self = [super init]) {
        
        // initialize clusters array
        _clustersInRound = [[NSMutableArray alloc] init];
        // initialize used clips array
        _clipsInRound = [[NSMutableArray alloc] init];
        
    }
    return self;
}

-(float) timeOutput {
    
    //add time intervals for each question
    NSTimeInterval totalTime = 0;
    for (AnswerCluster *answer in self.clustersInRound) {
        totalTime += answer.answerTime;
    }
    
//    NSDate *gameStart = [[self.answers firstObject] startDate];
//    NSDate *gameEnd = [[self.answers lastObject] endDate];
    
    NSLog(@"%@", [NSString stringWithFormat:@"total time: %.fs", totalTime]);
    
    return totalTime;
}

-(void)appendCluster:(AnswerCluster *)cluster{
    
    [self.clustersInRound addObject:cluster];
    [self.clipsInRound addObject:cluster.correctAnswerClip];
    
}


@end
