//
//  popupViewController.h
//  HollywoodGenius
//
//  Created by Cameron Mcleod on 2019-06-21.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PopupViewController : UIViewController

@property (nonatomic) bool answerIsCorrect;
@property (nonatomic) bool endOfRound;
@property (nonatomic) NSString *time;
@property (nonatomic) NSString *score;

@end

NS_ASSUME_NONNULL_END
