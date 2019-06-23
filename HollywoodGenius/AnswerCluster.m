//
//  AdditionQuestion.m
//  HollywoodGenius
//
//  Created by Cameron Mcleod on 2019-06-19.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import "RootTableViewController.h"
#import "AnswerCluster.h"
#import "AnswerManager.h"
#import "Movie.h"

@implementation AnswerCluster

- (instancetype)initWithCluster: (NSMutableArray *) movieCluster {
    if (self = [super init]) {
        // set start time to now
        _startTime = [NSDate date];
        _movies = [[NSMutableArray alloc] initWithArray:movieCluster];
        
        Movie *movie = movieCluster[arc4random_uniform(ANSWERS_ON_SCREEN)];
        NSArray *clips = movie.clips;
        _correctAnswerName = movie.title;
        _correctAnswerClip = clips[arc4random_uniform([clips count])];
        
    }
    return self;
}

- (void) setCorrectAnswerClip:(NSString *)correctMovieClip{
    _correctAnswerClip = correctMovieClip;
}

// overriding getter to return end date when answer is got
- (NSString *)correctAnswerClip {
    _endTime = [NSDate date];
    return _correctAnswerClip;
}

- (NSTimeInterval) answerTime {
    // return time interval between start and end time
    return [_endTime timeIntervalSinceDate: _startTime];
}

@end
