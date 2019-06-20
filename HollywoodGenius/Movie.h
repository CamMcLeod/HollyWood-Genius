//
//  Movie.h
//  HollywoodGenius
//
//  Created by Cameron Mcleod on 2019-06-19.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSObject

@property NSString *title;
@property NSMutableArray *actors;
@property NSMutableDictionary *clips;

- (instancetype)initWith:(NSString *)title andActors: (NSArray *)actors andClips: (NSDictionary *)clips;

@end

NS_ASSUME_NONNULL_END

/*
 Movie object will contain properties: movie title, actors, clip dictionary.
 “Clip” dictionary with Key: clip ID number and 2 element array of subtitles/lines in clip and AV video file.
 Screen loads random movie object from Allmovies array - adds clip used to “used in this quiz dictionary”

*/

