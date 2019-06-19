//
//  QuestionManager.h
//  HollywoodGenius
//
//  Created by Cameron Mcleod on 2019-06-19.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnswerManager : NSObject

@property NSMutableArray *answersInRound;

-(float) timeOutput;

@end

NS_ASSUME_NONNULL_END
