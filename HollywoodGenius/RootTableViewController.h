//
//  RootTableViewController.h
//  HollywoodGenius
//
//  Created by Ekam Singh Dhaliwal on 2019-06-19.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDelegateProtocol.h"

NS_ASSUME_NONNULL_BEGIN


typedef enum
{
    clipGame = 1,
    quoteGame
    
}gameState;

@interface RootTableViewController : UITableViewController <UserDelegateProtocol>

extern const int QUESTIONS_IN_ROUND;
extern const int ANSWERS_ON_SCREEN;

@end

NS_ASSUME_NONNULL_END
