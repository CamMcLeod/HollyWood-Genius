//
//  QuestionManager.h
//  HollywoodGenius
//
//  Created by Cameron Mcleod on 2019-06-19.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AnswerCluster;

@interface AnswerManager : NSObject

@property NSMutableArray *clustersInRound;
@property NSMutableArray *clipsInRound;

-(float) timeOutput;
-(void)appendCluster:(AnswerCluster *)cluster;

@end

NS_ASSUME_NONNULL_END
