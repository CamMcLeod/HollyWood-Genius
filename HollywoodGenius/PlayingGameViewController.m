//
//  PlayingGameViewController.m
//  HollywoodGenius
//
//  Created by Ekam Singh Dhaliwal on 2019-06-19.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import "PlayingGameViewController.h"
#import "RootTableViewController.h"
#import "PopupViewController.h"
#import "GuessAnswersViewCell.h"
#import "Movie.h"
#import "AnswerManager.h"
#import "AnswerCluster.h"

@interface PlayingGameViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *videoContainerView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic) NSMutableArray *dummyMovieAnswerArray;
@property (nonatomic) AnswerManager *answerManager;
@property (nonatomic) AnswerCluster *answerCluster;

-(void)loadVideoWithURL:(NSURL *) pathURL;
-(void)importDataset;
-(void)askNewQuestion;
-(void)resetViewForNewQuestion;
-(void)runTimer;
-(void)updateTimer;
-(void)createAnswerCluster;

@end

@implementation PlayingGameViewController {
    bool answerIsCorrect;
    bool answerUpdated;
    NSTimeInterval questionTime;
    NSTimer *timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *backgroundImage = [UIImage imageNamed:@"background"];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backgroundImageView.image = backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self importDataset];

    answerUpdated = NO;
    
    [self askNewQuestion];
    
    self.answerManager = [[AnswerManager alloc] init];
    
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier{
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
    }

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GuessAnswersViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"guessAnswers" forIndexPath:indexPath];
    Movie *cellMovie = (self.answerCluster.movies)[indexPath.row];
    NSString *movieName = cellMovie.title;
    [cell.answer setTitle:movieName forState:UIControlStateNormal];
//    [cell.answer sizeToFit];
    cell.answer.titleLabel.numberOfLines = 2;//    cell.answer.titleLabel.lineBreakMode = NSLineBreakByClipping;
    cell.answer.titleLabel.adjustsFontSizeToFitWidth = YES;
    cell.answer.contentScaleFactor = 1;
    [cell setBackgroundColor: [UIColor lightGrayColor]];
    [cell.answer setBackgroundColor:[UIColor lightGrayColor]];
    
//    cell.answer.titleLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
//    cell.answer.backgroundColor = [UIColor blueColor];
    ; }

-(void)loadVideoWithURL:(NSURL *) pathURL {
    AVPlayer *videoPlayer = [AVPlayer playerWithURL:pathURL];
    
    AVPlayerViewController *playerController = [[AVPlayerViewController alloc] init];
    playerController.player = videoPlayer;
    AVPlayerLayer *playerLayer = [[AVPlayerLayer alloc] init];
    [playerLayer setPlayer:videoPlayer];
    playerLayer.frame = self.videoContainerView.frame;
    [self.videoContainerView.layer addSublayer:playerLayer];
    [videoPlayer play];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize cellSize = CGSizeMake(collectionView.frame.size.width/2 - 10, collectionView.frame.size.height/2 - 10);
    
    return cellSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GuessAnswersViewCell *selectedCell = [self.collectionView cellForItemAtIndexPath:indexPath];
    
    NSString *selectedAnswer = selectedCell.answer.titleLabel.text;
    if([selectedAnswer isEqualToString:self.answerCluster.correctAnswerName]){
        answerIsCorrect = YES;
        [selectedCell setBackgroundColor: [UIColor greenColor]];
        [selectedCell.answer setBackgroundColor:[UIColor greenColor]];
        
        int score = [self.score.text intValue];
        score++;
        self.score.text = [NSString stringWithFormat:@"%d", score];
        
        
    } else {
        answerIsCorrect = NO;
        [selectedCell setBackgroundColor: [UIColor redColor]];
        [selectedCell.answer setBackgroundColor:[UIColor redColor]];
        
    }
    
    [self.answerManager appendCluster:self.answerCluster];
    [timer invalidate];
    self.timeLabel.text = [NSString stringWithFormat:@"%.1f seconds", self.answerManager.timeOutput];
    
    [self performSegueWithIdentifier:@"answerResult" sender:self];
//    [self resetViewForNewQuestion];
    
}

-(void)askNewQuestion {
    
    [self createAnswerCluster];
    [self loadVideoWithURL:self.answerCluster.correctAnswerClip];
    [self runTimer];
    
}


-(void)createAnswerCluster {
    
    NSUInteger dummyMovieArrayCount = [self.dummyMovieAnswerArray count];
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    Movie *movie = [[Movie alloc] init];
    bool haveEnoughChoices = NO;
    do {
        int j = arc4random_uniform(dummyMovieArrayCount);
        movie = self.dummyMovieAnswerArray[j];
        int movieIndex = [movies indexOfObjectIdenticalTo:movie inRange:NSMakeRange(0,[movies count])];
        if ( movieIndex < 0){
            [movies addObject:movie];
            if([movies count] == 4) {
                break;
            }
        }
    } while (!haveEnoughChoices);
    
    bool clipIsUsed = YES;
    if ([self.answerManager.clipsInRound count] > 0){
        do {
            self.answerCluster = [[AnswerCluster alloc] initWithCluster:movies];
            int clipIndex = [self.answerManager.clipsInRound indexOfObjectIdenticalTo:self.answerCluster.correctAnswerClip inRange:NSMakeRange(0,[self.answerManager.clipsInRound count])];
            if ( clipIndex < 0){
                clipIsUsed = NO;
            }
        } while (clipIsUsed);
    } else {
        self.answerCluster = [[AnswerCluster alloc] initWithCluster:movies];
    }
}

-(void)resetViewForNewQuestion {
    
    self.answerCluster.movies = [[NSMutableArray alloc] init];
    [self.collectionView reloadData];
    [self.videoContainerView.layer.sublayers[0] removeFromSuperlayer];
    
    [self askNewQuestion];
    
    
}


-(void)runTimer{
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

-(void)updateTimer {
    
    questionTime = [[NSDate date] timeIntervalSinceDate: self.answerCluster.startTime];
    self.timeLabel.text = [NSString stringWithFormat:@"%.1f seconds", questionTime];
    
}

 #pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString: @"answerResult"]){
        
        [self setModalPresentationStyle:UIModalPresentationCurrentContext];
        PopupViewController *dVC = [segue destinationViewController];
        dVC.answerIsCorrect = answerIsCorrect;
        if ([self.answerManager.clipsInRound count] == QUESTIONS_IN_ROUND){
            dVC.endOfRound = TRUE;
            dVC.score = self.score.text;
            dVC.time = self.timeLabel.text;
            [self.score setHidden:YES];
            [self.timeLabel setHidden:YES];
        } else {
            dVC.endOfRound = FALSE;
        }
        
        
    }
    
}

- (IBAction)unwindToPlayingGameViewController:(UIStoryboardSegue *)unwindSegue {
    
    PopupViewController *sourceViewController = unwindSegue.sourceViewController;
    
    if ([unwindSegue.identifier isEqualToString:@"nextOrPlayAgain"]){
        if(sourceViewController.endOfRound) {
            self.answerManager = [[AnswerManager alloc] init];
            self.score.text = @"0";
            [self.score setHidden:NO];
            [self.timeLabel setHidden:NO];
        }
        [self resetViewForNewQuestion];
    } else if ([unwindSegue.identifier isEqualToString:@"exitGame"]){
        if ([self.answerManager.clipsInRound count] == QUESTIONS_IN_ROUND){
            [self.userDelegate addNewTime:self.answerManager.timeOutput andScore:[self.score.text intValue]];
        }
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark - Data Organization
-(void)importDataset {
    
    self.dummyMovieAnswerArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *path0 = [mainBundle URLForResource:@"Airplane" withExtension:@"mp4"];
    Movie *movie0 = [[Movie alloc] initWithTitle:@"Airplane" andClips:@[path0]];
    self.dummyMovieAnswerArray[0] = movie0;
    
    NSURL *path1 = [mainBundle URLForResource:@"Avatar" withExtension:@"mp4"];
    Movie *movie1 = [[Movie alloc] initWithTitle:@"Avatar" andClips:@[path1]];
    self.dummyMovieAnswerArray[1] = movie1;
    
    NSURL *path2 = [mainBundle URLForResource:@"Deadpool" withExtension:@"mp4"];
    Movie *movie2 = [[Movie alloc] initWithTitle:@"Deadpool" andClips:@[path2]];
    self.dummyMovieAnswerArray[2] = movie2;
    
    NSURL *path3 = [mainBundle URLForResource:@"Indiana Jones and the Last Crusade" withExtension:@"mp4"];
    Movie *movie3 = [[Movie alloc] initWithTitle:@"Indiana Jones and the Last Crusade" andClips:@[path3]];
    self.dummyMovieAnswerArray[3] = movie3;
    
    NSURL *path4 = [mainBundle URLForResource:@"Predator-1" withExtension:@"mp4"];
    NSURL *path5 = [mainBundle URLForResource:@"Predator-2" withExtension:@"mp4"];
    NSURL *path6 = [mainBundle URLForResource:@"Predator-3" withExtension:@"mp4"];
    Movie *movie4 = [[Movie alloc] initWithTitle:@"Predator" andClips:@[path4, path5, path6]];
    self.dummyMovieAnswerArray[4] = movie4;
    
    NSURL *path7 = [mainBundle URLForResource:@"Snakes on a Plane" withExtension:@"mp4"];
    Movie *movie5 = [[Movie alloc] initWithTitle:@"Snakes on a Plane" andClips:@[path7]];
    self.dummyMovieAnswerArray[5] = movie5;
    
    NSURL *path8 = [mainBundle URLForResource:@"The Big Lebowski" withExtension:@"mp4"];
    Movie *movie6 = [[Movie alloc] initWithTitle:@"The Big Lebowski" andClips:@[path8]];
    self.dummyMovieAnswerArray[6] = movie6;
    
    NSURL *path9 = [mainBundle URLForResource:@"The Princess Bride" withExtension:@"mp4"];
    Movie *movie7 = [[Movie alloc] initWithTitle:@"The Princess Bride" andClips:@[path9]];
    self.dummyMovieAnswerArray[7] = movie7;
    
    NSURL *path10 = [mainBundle URLForResource:@"Titanic" withExtension:@"mp4"];
    Movie *movie8 = [[Movie alloc] initWithTitle:@"Titanic" andClips:@[path10]];
    self.dummyMovieAnswerArray[8] = movie8;
    
    NSURL *path11 = [mainBundle URLForResource:@"Zoolander" withExtension:@"mp4"];
    Movie *movie9 = [[Movie alloc] initWithTitle:@"Zoolander" andClips:@[path11]];
    self.dummyMovieAnswerArray[9] = movie9;
    
}
@end
