//
//  RootTableViewController.m
//  HollywoodGenius
//
//  Created by Ekam Singh Dhaliwal on 2019-06-19.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import "RootTableViewController.h"
#import "RootTableViewCell.h"
#import "PlayingGameViewController.h"
#import "User.h"
#import "RealmManager.h"
#import <AVFoundation/AVFoundation.h>


@interface RootTableViewController ()

@property User *user;
@property AVPlayer *player;

@end



@implementation RootTableViewController

const int QUESTIONS_IN_ROUND = 5;
const int ANSWERS_ON_SCREEN = 4;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.user = [[User alloc] init];
    
    
    NSString *mp3Path = [[NSBundle mainBundle] pathForResource:@"Harry Nilsson - Coconut (Audio)" ofType:@"mp3"];//Your Document mp3 path
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:mp3Path
                                                     ] options:nil];
    AVPlayerItem *_playerItem = [[AVPlayerItem alloc] initWithAsset:asset];
    _player = [[AVPlayer alloc]initWithPlayerItem:_playerItem];
    [_player addObserver:self forKeyPath:@"status" options:0 context:nil];
   
}

- (void)viewWillAppear:(BOOL)animated {
    [self doVolumeFade];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userInformation" forIndexPath:indexPath];
            
            cell.textLabel.text = [NSString stringWithFormat:@"Hollywood Genius"];
            UIFont *font = cell.textLabel.font;
            cell.textLabel.font = [font fontWithSize:40];
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            [cell sizeToFit];
            [cell.layer setMasksToBounds: YES];
            [cell.layer setBorderWidth:4.0];
            [cell.layer setCornerRadius: 10];
            return cell;
            break;
        }
        case 3: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userInformation" forIndexPath:indexPath];
            
            cell.textLabel.text = [NSString stringWithFormat:@"User Total Score: %d\nUser Average Time: %.fs\nUser Best Perfect Time: %.fs\nUser Games Played: %lu",
                                   self.user.totalScore,
                                   self.user.averageTime,
                                   self.user.perfectBestTime,
                                   (unsigned long)self.user.gamesPlayed ];
            
            [cell.layer setMasksToBounds: YES];
            [cell.layer setBorderWidth:4.0];
            [cell.layer setCornerRadius: 10];

            [cell sizeToFit];
            return cell;
            break;
        }
        case 1: {
            
            RootTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playGame" forIndexPath:indexPath];
            cell.gameType.text = @"Guess the Movie from a Clip!";
            return cell;
            break;
        }
        case 2: {
            RootTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playGame" forIndexPath:indexPath];
            cell.gameType.text = @"Guess the Movie from a Quote!";
            return cell;
            break;
        }
        default:
            return [[UITableViewCell alloc] init];
            break;
    }
    
}

//func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    return CGFloat(80)
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150; 
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self performSegueWithIdentifier:@"beginPlayingGame" sender:self];
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = sender;
    if ([cell.reuseIdentifier isEqualToString:@"playGame"])  {
    
        if ([segue.identifier isEqualToString:@"beginPlayingGame"]) {
            PlayingGameViewController *dVC = [segue destinationViewController];
            dVC.user = self.user;
            dVC.userDelegate = self;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            
            switch (indexPath.row) {
                case 1: dVC.gameType = clipGame;
                    _player.volume = 0.2;
                    break;
                case 2: dVC.gameType = quoteGame;
                    break;
                default:
                    break;
            }
            
        }
    }
    
}

- (void)addNewTime:(float)time andScore:(int)score {

    NSNumber *recordTime = [NSNumber numberWithFloat:time];
    NSNumber *recordScore = [NSNumber numberWithInt:score];
    [self.user.allTimes addObject:recordTime];
    [self.user.allScores addObject:recordScore];
    
    self.user.gamesPlayed = [self.user.allScores count];
    
    recordScore = [self.user.allScores valueForKeyPath:@"@sum.self"];
    self.user.totalScore = [recordScore intValue];
    
    recordTime = [self.user.allTimes valueForKeyPath:@"@avg.self"];
    self.user.averageTime = [recordTime floatValue];
    
    if (score == QUESTIONS_IN_ROUND){
        if (self.user.gamesPlayed > 1) {
            for (int i = 0 ; i <self.user.gamesPlayed; i++){
                if ([self.user.allScores[i] intValue] == QUESTIONS_IN_ROUND) {
                    if (time < [self.user.allTimes[i] floatValue]) {
                        self.user.perfectBestTime = time;
                    }
                }
            }
        } else {
            self.user.perfectBestTime = time;
        }
        RealmManager *realmanager = [[RealmManager alloc] init];
        [realmanager addScoreData:self.user.totalScore averageTime:[NSString stringWithFormat:@"%f", self.user.averageTime] andUUID:[NSDateFormatter localizedStringFromDate:[NSDate date]
                                                                                                                                dateStyle:NSDateFormatterShortStyle
                                                                                                                                timeStyle:NSDateFormatterFullStyle]];
    }
    
    [self.tableView reloadData];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if (object == _player && [keyPath isEqualToString:@"status"])
    {
        if (_player.status == AVPlayerStatusFailed)
            NSLog(@"AVPlayer Status Failed");
        else if (_player.status == AVPlayerStatusReadyToPlay)
        {
            //Start playing song
            [_player play];
        }
        else if (_player.status == AVPlayerItemStatusUnknown)
            NSLog(@"AVPlayer Status Unknown");
    }
}

-(void)doVolumeFade{
    if (self.player.volume < 1) {
        self.player.volume = 1;
        [self performSelector:@selector(doVolumeFade) withObject:nil afterDelay:0.1];
    }
}
@end
