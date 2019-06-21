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
@protocol NewCityFormDelegate <NSObject>

-(void)updateUser:(User *)user;

@end
NS_ASSUME_NONNULL_END
