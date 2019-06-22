//
//  ScoreHistory.h
//  HollywoodGenius
//
//  Created by Ekam Singh Dhaliwal on 2019-06-22.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScoreHistory : RLMObject

@property NSString *averageTime;
//@property float totalTime; 
@property int totalScore;
//@property float perfectBestTime;
//@property NSUInteger gamesPlayed;
@property NSString *uuid;

- (instancetype)initWithTotalScore:(int)totalScore andAverageTime:(NSString *)averageTime  andUUID:(NSString *)uuid;

@end

NS_ASSUME_NONNULL_END
