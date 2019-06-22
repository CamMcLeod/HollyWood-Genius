//
//  AdditionQuestion.h
//  HollywoodGenius
//
//  Created by Cameron Mcleod on 2019-06-19.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnswerCluster : NSObject
{
    NSString *_correctAnswerClip;
    
}

@property (nonatomic, strong) NSMutableArray *movies;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSString *correctAnswerName;

- (NSString *) correctAnswerClip;
- (void) setCorrectAnswerClip: (NSString *) correctAnswerClip;
- (NSTimeInterval) answerTime;

- (instancetype)initWithCluster: (NSArray *) movieCluster;

@end

NS_ASSUME_NONNULL_END
