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
#import "RealmManager.h"


@interface PlayingGameViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *videoContainerView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (nonatomic) NSMutableArray *dummyMovieAnswerArray;
@property (nonatomic) AnswerManager *answerManager;
@property (nonatomic) AnswerCluster *answerCluster;
@property RealmManager *realManager;

-(void)loadVideoWithURL:(NSURL *) pathURL;
-(void)loadQuoteWithString:(NSString *) quoteString;
-(bool)checkforRepeats:(NSArray *)movieArray name:(NSString *)checkMovie;
-(void)importDataset;
-(void)askNewQuestion;
-(void)resetViewForNewQuestion;
-(void)runTimer;
-(void)updateTimer;
-(void)createAnswerCluster;
-(void)createDatabaseAnswerCluster;

@end

@implementation PlayingGameViewController {
    bool answerIsCorrect;
    NSTimeInterval questionTime;
    NSTimer *timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIImage *backgroundImage = [UIImage imageNamed:@"background"];
//    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
//    backgroundImageView.image = backgroundImage;
//    [self.view insertSubview:backgroundImageView atIndex:0];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    NSLog(@"%u", self.gameType);
    
    [self importDataset];
    self.realManager = [[RealmManager alloc] init];
    [self.realManager createInitialData];
    [self askNewQuestion];
    
    self.answerManager = [[AnswerManager alloc] init];
    
   
    
  
    
//   NSLog(@"%@",[RLMRealmConfiguration defaultConfiguration].fileURL);
    
    
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier{
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
    }

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return ANSWERS_ON_SCREEN;
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

-(void)loadQuoteWithString:(NSString *) quoteString {
    
    CGRect quoteFrame = CGRectMake(10, 10, self.videoContainerView.frame.size.width-20, self.videoContainerView.frame.size.height-20);
    
    UILabel *quoteLabel = [[UILabel alloc] initWithFrame:quoteFrame];
    [self.videoContainerView addSubview:quoteLabel];
    quoteLabel.text = self.answerCluster.correctAnswerClip;
    quoteLabel.textColor = [UIColor colorWithRed:255/255.0 green:215/255.0 blue:0/255.0 alpha:1.0];
    quoteLabel.backgroundColor = [UIColor darkGrayColor];
    [quoteLabel setNumberOfLines:4];
    [quoteLabel setTextAlignment:NSTextAlignmentCenter];
    UIFont *font = quoteLabel.font;
    quoteLabel.font = [font fontWithSize:30];
    [quoteLabel setCenter:self.videoContainerView.center];
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize cellSize = CGSizeMake(collectionView.frame.size.width/2 - 10, collectionView.frame.size.height/2 - 10);
    
    return cellSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GuessAnswersViewCell *selectedCell = (GuessAnswersViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
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
    
    if (self.gameType == clipGame) {
        
        [self createAnswerCluster];
        [self loadVideoWithURL:[NSURL URLWithString:self.answerCluster.correctAnswerClip] ];
        
    } else if (self.gameType == quoteGame) {
        NSLog(@"asking new quote");
        [self createDatabaseAnswerCluster];
        [self loadQuoteWithString:self.answerCluster.correctAnswerClip];
        
    }

    
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
            if([movies count] == ANSWERS_ON_SCREEN) {
                break;
            }
        }
    } while (!haveEnoughChoices);
    
    bool clipIsUsed = YES;
    if ([self.answerManager.clipsInRound count] > 0){
        do {
            self.answerCluster = [[AnswerCluster alloc] initWithCluster:movies];
            int clipIndex = (int)[self.answerManager.clipsInRound indexOfObjectIdenticalTo:self.answerCluster.correctAnswerClip inRange:NSMakeRange(0,[self.answerManager.clipsInRound count])];
            if ( clipIndex < 0){
                clipIsUsed = NO;
            }
        } while (clipIsUsed);
    } else {
        self.answerCluster = [[AnswerCluster alloc] initWithCluster:movies];
    }
}

-(void)createDatabaseAnswerCluster {
    // fill with algorithm to pull movies randomly from database
    Movie *movie;
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    bool isMatch = NO;
    
    while ([movies count] < ANSWERS_ON_SCREEN) {
        NSArray *tmp =  [self.realManager retrieveRandomQuoteMovieAndUID];
        NSString *theMovie =  tmp[1];
        NSString *quote = tmp[0];
        
         if (![self checkforRepeats: movies name:theMovie]) {
             movie = [[Movie alloc] initWithTitle:theMovie andClips:@[quote]];
             [movies addObject:movie];
         }
       
    }
    
    bool clipIsUsed = YES;
    if ([self.answerManager.clipsInRound count] > 0){
        do {
            self.answerCluster = [[AnswerCluster alloc] initWithCluster:movies];
            int clipIndex = (int)[self.answerManager.clipsInRound indexOfObjectIdenticalTo:self.answerCluster.correctAnswerClip inRange:NSMakeRange(0,[self.answerManager.clipsInRound count])];
            if ( clipIndex < 0){
                clipIsUsed = NO;
            }
        } while (clipIsUsed);
    } else {
        self.answerCluster = [[AnswerCluster alloc] initWithCluster:movies];
    }
    
    
//
}

-(bool)checkforRepeats:(NSArray *)movieArray name:(NSString *)checkMovie {
    
    if ([movieArray count] == 0) {
        return NO;
    }
    for (Movie *movieTitle in movieArray) {
        if ([checkMovie isEqualToString: movieTitle.title]) {
            return YES;
        }
    }
    return NO;
}

-(void)resetViewForNewQuestion {
    
    self.answerCluster = [[AnswerCluster alloc] init];
    [self.collectionView reloadData];
    if (self.gameType == clipGame) {
        [self.videoContainerView.layer.sublayers[0] removeFromSuperlayer];
    }
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
        for (UIView *view in [self.videoContainerView subviews])
        {
            [view removeFromSuperview];
        }
        for (CALayer *layer in self.videoContainerView.layer.sublayers)
        {
            [layer removeFromSuperlayer];
        }
        
        
        if ([self.answerManager.clipsInRound count] == QUESTIONS_IN_ROUND){
            dVC.endOfRound = TRUE;
            dVC.score = self.score.text;
            dVC.time = self.timeLabel.text;
            [self.score setHidden:YES];
            [self.scoreLabel setHidden:YES];
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
            [self.userDelegate addNewTime:self.answerManager.timeOutput andScore:[self.score.text intValue]];
            self.answerManager = [[AnswerManager alloc] init];
            self.score.text = @"0";
            [self.score setHidden:NO];
            [self.scoreLabel setHidden:NO];
            [self.timeLabel setHidden:NO];
        }
        [self resetViewForNewQuestion];
    } else if ([unwindSegue.identifier isEqualToString:@"exitGame"]){
        if (sourceViewController.endOfRound){
            [self.userDelegate addNewTime:self.answerManager.timeOutput andScore:[self.score.text intValue]];
            self.answerManager = [[AnswerManager alloc] init];
            self.score.text = @"0";
            [self.score setHidden:NO];
            [self.scoreLabel setHidden:NO];
            [self.timeLabel setHidden:NO];
        }
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark - Data Organization
-(void)importDataset {
    
    if (self.gameType == clipGame) {
        
        self.dummyMovieAnswerArray = [[NSMutableArray alloc] initWithCapacity:10];
        
        NSBundle *mainBundle = [NSBundle mainBundle];
        
        NSURL *loadURL = [mainBundle URLForResource:@"Airplane" withExtension:@"mp4"];
        NSString *path0 = [loadURL absoluteString];
        Movie *movie0 = [[Movie alloc] initWithTitle:@"Airplane" andClips:@[path0]];
        self.dummyMovieAnswerArray[0] = movie0;
        
        loadURL = [mainBundle URLForResource:@"Avatar" withExtension:@"mp4"];
        NSString *path1 = [loadURL absoluteString];
        Movie *movie1 = [[Movie alloc] initWithTitle:@"Avatar" andClips:@[path1]];
        self.dummyMovieAnswerArray[1] = movie1;
        
        loadURL = [mainBundle URLForResource:@"Deadpool" withExtension:@"mp4"];
        NSString *path2 = [loadURL absoluteString];
        Movie *movie2 = [[Movie alloc] initWithTitle:@"Deadpool" andClips:@[path2]];
        self.dummyMovieAnswerArray[2] = movie2;
        
        loadURL = [mainBundle URLForResource:@"Indiana Jones and the Last Crusade" withExtension:@"mp4"];
        NSString *path3 = [loadURL absoluteString];
        Movie *movie3 = [[Movie alloc] initWithTitle:@"Indiana Jones and the Last Crusade" andClips:@[path3]];
        self.dummyMovieAnswerArray[3] = movie3;
        
        NSURL *loadURL1 = [mainBundle URLForResource:@"Predator-1" withExtension:@"mp4"];
        NSURL *loadURL2 = [mainBundle URLForResource:@"Predator-2" withExtension:@"mp4"];
        NSURL *loadURL3 = [mainBundle URLForResource:@"Predator-3" withExtension:@"mp4"];
        NSString *path4 = [loadURL1 absoluteString];
        NSString *path5 = [loadURL2 absoluteString];
        NSString *path6 = [loadURL3 absoluteString];
        Movie *movie4 = [[Movie alloc] initWithTitle:@"Predator" andClips:@[path4, path5, path6]];
        self.dummyMovieAnswerArray[4] = movie4;
        
        loadURL = [mainBundle URLForResource:@"Snakes on a Plane" withExtension:@"mp4"];
        NSString *path7 = [loadURL absoluteString];
        Movie *movie5 = [[Movie alloc] initWithTitle:@"Snakes on a Plane" andClips:@[path7]];
        self.dummyMovieAnswerArray[5] = movie5;
        
        loadURL = [mainBundle URLForResource:@"The Big Lebowski" withExtension:@"mp4"];
        NSString *path8 = [loadURL absoluteString];
        Movie *movie6 = [[Movie alloc] initWithTitle:@"The Big Lebowski" andClips:@[path8]];
        self.dummyMovieAnswerArray[6] = movie6;
        
        loadURL = [mainBundle URLForResource:@"The Princess Bride" withExtension:@"mp4"];
        NSString *path9 = [loadURL absoluteString];
        Movie *movie7 = [[Movie alloc] initWithTitle:@"The Princess Bride" andClips:@[path9]];
        self.dummyMovieAnswerArray[7] = movie7;
        
        loadURL = [mainBundle URLForResource:@"Titanic" withExtension:@"mp4"];
        NSString *path10 = [loadURL absoluteString];
        Movie *movie8 = [[Movie alloc] initWithTitle:@"Titanic" andClips:@[path10]];
        self.dummyMovieAnswerArray[8] = movie8;
        
        loadURL = [mainBundle URLForResource:@"Zoolander" withExtension:@"mp4"];
        NSString *path11 = [loadURL absoluteString];
        Movie *movie9 = [[Movie alloc] initWithTitle:@"Zoolander" andClips:@[path11]];
        self.dummyMovieAnswerArray[9] = movie9;
        
    }
    
}
@end
