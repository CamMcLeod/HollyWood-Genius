//
//  Clip.h
//  HollywoodGenius
//
//  Created by Ekam Singh Dhaliwal on 2019-06-20.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>


@interface Clip : RLMObject

@property NSString *quote;
@property NSString *clipName;
@property NSString *title;
@property NSString *uuid;


- (instancetype)initWithTitle:(NSString *)title andClipName:(NSString *)clipName andQuote:(NSString *)movieQuote andUID:(NSString *)uuid;

@end


