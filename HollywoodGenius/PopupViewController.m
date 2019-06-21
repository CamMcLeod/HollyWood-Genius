//
//  popupViewController.m
//  HollywoodGenius
//
//  Created by Cameron Mcleod on 2019-06-21.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import "PopupViewController.h"
#import "RootTableViewController.h"

@interface PopupViewController ()

@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *congratsLabel;


@end

@implementation PopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.answerIsCorrect){
        self.answerLabel.text = @"Correct!";
        [self.answerLabel setTextColor: [UIColor greenColor]];
    } else {
        self.answerLabel.text = @"Sorry, Wrong Answer!";
        [self.answerLabel setTextColor: [UIColor redColor]];
    }
    if (self.endOfRound) {
        [self.continueButton setTitle:@"Play Another Round" forState:UIControlStateNormal];
        [self.continueButton setTitle:@"Play Another Round" forState:UIControlStateSelected];
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %@/%d", self.score, QUESTIONS_IN_ROUND ];
        self.timeLabel.text = [NSString stringWithFormat:@"Time: %@", self.time];
        [self.scoreLabel setHidden:NO];
        [self.timeLabel setHidden:NO];
        [self.congratsLabel setHidden:NO];
        
    } else {
        [self.continueButton setTitle:@"Play Next Clip" forState:UIControlStateNormal];
        [self.continueButton setTitle:@"Play Next Clip" forState:UIControlStateSelected];
        [self.scoreLabel setHidden:YES];
        [self.timeLabel setHidden:YES];
        [self.congratsLabel setHidden:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
