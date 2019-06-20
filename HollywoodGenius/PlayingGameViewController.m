//
//  PlayingGameViewController.m
//  HollywoodGenius
//
//  Created by Ekam Singh Dhaliwal on 2019-06-19.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import "PlayingGameViewController.h"
#import "GuessAnswersViewCell.h"
#import "Movie.h"

@interface PlayingGameViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *videoContainerView;

@property (nonatomic) NSMutableArray *dummyMovieAnswerArray;

-(void)loadVideoWithURL:(NSURL *) pathURL;

@end

@implementation PlayingGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *backgroundImage = [UIImage imageNamed:@"background"];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backgroundImageView.image = backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    self.dummyMovieAnswerArray = [[NSMutableArray alloc] initWithCapacity:10];

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
    
    
    [self loadVideoWithURL:path0];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
    }

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GuessAnswersViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"guessAnswers" forIndexPath:indexPath];
    Movie *cellMovie = (self.dummyMovieAnswerArray)[indexPath.row];
    NSString *movieName = cellMovie.title;
    [cell.answer setTitle:movieName forState:UIControlStateNormal];
    [cell.answer sizeToFit];
//    cell.answer.titleLabel.numberOfLines = 2;
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
    playerLayer.frame = CGRectOffset(self.videoContainerView.frame, 0, -40);
    
    [self.videoContainerView.layer addSublayer:playerLayer];
    [videoPlayer play];
    
}



//- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
//    <#code#>
//}
//
//- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
//    <#code#>
//}
//
//- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
//    return CGSizeMake(self.view.frame.size.width, 200); 
//}
//
//- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
//    <#code#>
//}
//
//- (void)setNeedsFocusUpdate {
//    <#code#>
//}
//
//- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
//    <#code#>
//}
//
//- (void)updateFocusIfNeeded {
//    <#code#>
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
