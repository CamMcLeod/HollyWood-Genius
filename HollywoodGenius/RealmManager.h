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

NS_ASSUME_NONNULL_BEGIN

@interface RealmManager : NSObject

@property (nonatomic) NSArray *movieObjectList;
@property (nonatomic) NSArray *clipList; 

- (void)createInitialData;

- (void)prepareData;
- (NSMutableArray *)parseCSVStringIntoArray:(NSString *)csvString;

@end

NS_ASSUME_NONNULL_END