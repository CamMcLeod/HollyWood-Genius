//
//  User.h
//  HollywoodGenius
//
//  Created by Cameron Mcleod on 2019-06-21.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property float averageTime;
@property int totalScore;
@property float perfectBestTime;
@property NSMutableArray *allTimes;
@property NSMutableArray *allScores;
@property NSUInteger gamesPlayed;

@end

NS_ASSUME_NONNULL_END
