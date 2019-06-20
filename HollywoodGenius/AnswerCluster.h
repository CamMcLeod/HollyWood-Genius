//
//  AdditionQuestion.h
//  HollywoodGenius
//
//  Created by Cameron Mcleod on 2019-06-19.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class Movie;

@interface AnswerCluster : NSObject
{
    Movie *_correctAnswer;
    
}

@property (nonatomic, strong) NSArray *answers;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;

- (Movie *) correctAnswer;
- (void) setCorrectAnswer: (Movie *) correctAnswer;
- (NSTimeInterval) answerTime;

@end
NS_ASSUME_NONNULL_END
