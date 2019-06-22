//
//  RealmManager.h
//  HollywoodGenius
//
//  Created by Ekam Singh Dhaliwal on 2019-06-20.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovieObject.h"
#import "Clip.h"
#import "ScoreHistory.h"

NS_ASSUME_NONNULL_BEGIN

@interface RealmManager : NSObject

@property (nonatomic) NSArray *movieObjectList;
@property (nonatomic) NSArray *clipList;
@property RLMRealm *realm; 

- (void)createInitialData;

- (void)prepareData;
- (NSMutableArray *)parseCSVStringIntoArray:(NSString *)csvString;
- (NSArray *)retrieveMovieData;
- (NSArray *)retrieveRandomQuoteMovieAndUID;
- (NSString *)matchQuoteWithMovie:(NSString *)uid;
- (void)addScoreData:(int)totalScore averageTime:(NSString *)avgTime andUUID:(NSString *)uuid;
- (float)retrieveBestTime;

@end

NS_ASSUME_NONNULL_END
