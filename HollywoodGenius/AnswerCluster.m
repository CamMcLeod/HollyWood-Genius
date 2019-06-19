//
//  AdditionQuestion.m
//  HollywoodGenius
//
//  Created by Cameron Mcleod on 2019-06-19.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import "AnswerCluster.h"
#import "Movie.h"

@implementation AnswerCluster

- (instancetype)initWithCluster: (NSArray *) movieCluster {
    if (self = [super init]) {
        // set start time to now
        _startTime = [NSDate date];
        _answers = [[NSArray alloc] initWithArray:movieCluster];
    }
    return self;
}

- (void) setCorrectAnswer:(Movie *)correctMovie{
    _correctAnswer = correctMovie;
}

// overriding getter to return end date when answer is got
- (Movie *)correctAnswer {
    _endTime = [NSDate date];
    return _correctAnswer;
}

- (NSTimeInterval) answerTime {
    // return time interval between start and end time
    return [_endTime timeIntervalSinceDate: _startTime];
}

@end
