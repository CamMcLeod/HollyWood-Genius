//
//  PlayingGameViewController.h
//  HollywoodGenius
//
//  Created by Ekam Singh Dhaliwal on 2019-06-19.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UserDelegateProtocol.h"

NS_ASSUME_NONNULL_BEGIN


@class User;

@interface PlayingGameViewController : UIViewController

@property User *user;
@property (nonatomic, weak) id  <UserDelegateProtocol>  userDelegate;

@end

NS_ASSUME_NONNULL_END
