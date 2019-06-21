//
//  UserDelegateProtocol.h
//  HollywoodGenius
//
//  Created by Cameron Mcleod on 2019-06-21.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN
@protocol UserDelegateProtocol <NSObject>

-(void)addNewTime:(float) time andScore: (int) score;

@end
NS_ASSUME_NONNULL_END
