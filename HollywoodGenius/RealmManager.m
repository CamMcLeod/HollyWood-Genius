//
//  RealmManager.m
//  HollywoodGenius
//
//  Created by Ekam Singh Dhaliwal on 2019-06-20.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import "RealmManager.h"

@implementation RealmManager


- (instancetype)init
{
    self = [super init];
    if (self) {
        _realm = [RLMRealm defaultRealm];
    }
    return self;
}


- (void)createInitialData {
    if (self.realm.isEmpty) {
        [self prepareData]; 
        [self.realm beginWriteTransaction];
        
        for (int i = 0; i < [self.movieObjectList count]; i++) {
            MovieObject *movie = [[MovieObject alloc] initWithTitle:self.movieObjectList[i] andUID:[[NSUUID UUID] UUIDString]];
            [self.realm addObject:movie];
            for (NSString *movieQuote in self.clipList[i]) {
                Clip *clip = [[Clip alloc] initWithTitle: movie.title andQuote: movieQuote andUID:movie.uuid];
                [self.realm addObject:clip];
            }
        }
        [self.realm commitWriteTransaction];
    
    }
    
}

- (void)addScoreData:(int)totalScore averageTime:(NSString *)avgTime andUUID:(NSString *)uuid {
    [self.realm beginWriteTransaction];
    ScoreHistory *scoreHistory = [[ScoreHistory alloc] initWithTotalScore:totalScore andAverageTime:avgTime andUUID:uuid];
    [self.realm addObject:scoreHistory];
    [self.realm commitWriteTransaction]; 
}


- (float)retrieveBestTime {
    RLMResults<ScoreHistory *> *timeList = [ScoreHistory allObjects];
    float bestTime = 0;
    for (ScoreHistory *scoreHistory in timeList) {
        float tmpValue = [scoreHistory.averageTime floatValue];
        if (tmpValue <= bestTime) {
            bestTime = tmpValue;
        }
    }
    return bestTime;
}

- (NSArray *)retrieveMovieData {
    RLMResults<MovieObject *> *movieList = [MovieObject allObjects];
    NSMutableArray *movieListArray = [[NSMutableArray alloc] init];
    for (MovieObject *movie in movieList) {
        [movieListArray addObject: movie.title];
    }
    return [movieListArray copy];
    
}

- (NSArray *)retrieveRandomQuoteMovieAndUID {
    RLMResults<Clip *> *clipList = [Clip allObjects];
    NSMutableDictionary *chosenClipDictionary = [[NSMutableDictionary alloc] init];
    for (Clip *quote in clipList) {
        [chosenClipDictionary setObject:quote.uuid forKey:quote.quote];
    }
//    NSLog(@"%@", chosenClipDictionary); 
    NSArray *quoteKeys = [chosenClipDictionary allKeys];
    NSString *randomQuote = quoteKeys[arc4random_uniform((int)[quoteKeys count])];
    NSString *randomuid = chosenClipDictionary[randomQuote];
    NSString *movieName = [self matchQuoteWithMovie:randomuid];
    NSArray *finalArray = @[randomQuote, movieName, randomuid];
    return finalArray;
}

- (NSString *)matchQuoteWithMovie:(NSString *)uid {
    RLMResults<MovieObject *> *movieList = [MovieObject allObjects];
    for (MovieObject *movie in movieList) {
        if ([movie.uuid isEqualToString:uid]) {
            return movie.title;
        }
    }
    return @"No match found";
}





- (void)prepareData {
//    NSString *strFile = [[NSBundle mainBundle]
//                              pathForResource:@"movieQuotes" ofType:@"csv"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"movieQuotes" ofType:@"csv"];
//    NSString *strFile = [NSString stringWithContentsOfFile:@"/Users/camsteezin/Desktop/Lighthouse/Midterm Project/HollyWood-Genius/movieQuotes.csv"  encoding:NSUTF8StringEncoding error:NULL];
    
    NSString *strFile = [NSString stringWithContentsOfFile:path  encoding:NSUTF8StringEncoding error:NULL];
    if (!strFile) {
        NSLog(@"Error reading file.");
    }
    NSArray *theArray = [[NSArray alloc] init];
    theArray = [strFile componentsSeparatedByString:@"\n"];
    NSMutableArray *movieList = [[NSMutableArray alloc] init];
    NSMutableArray *quoteList = [[NSMutableArray alloc] init];
    
    for(NSString *rows in theArray) {
        NSMutableArray *movieQuotes  = [self parseCSVStringIntoArray:rows];
        [movieList addObject:movieQuotes[0]];
        NSArray *tmpArray = [movieQuotes subarrayWithRange:NSMakeRange(1, [movieQuotes count] - 1)];
        NSMutableArray *tmpQuotes = [[NSMutableArray alloc] init];
        for (NSString *quote in tmpArray) {
            NSString *someRegexp = @"(.*[a-zA-z].*)";
            NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", someRegexp];
            if ([myTest evaluateWithObject: quote]) {
                [tmpQuotes addObject:quote];
            }
        }
        [quoteList addObject:tmpQuotes];
    }
    self.movieObjectList = movieList;
    self.clipList = [quoteList mutableCopy];
    
}


- (NSMutableArray *)parseCSVStringIntoArray:(NSString *)csvString {
    
    NSMutableArray *csvDataArray = [[NSMutableArray alloc] init];
    
    // break string into an array of individual characters
    NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[csvString length]];
    int csvStringLength = (int)[csvString length];
    for (int c=0; c < csvStringLength; c++) {
        NSString *ichar  = [NSString stringWithFormat:@"%c", [csvString characterAtIndex:c]];
        [characters addObject:ichar];
    }
    
    BOOL quotationMarksPresent = FALSE;
    
    for (NSString *ichar in characters) {
        if ([ichar isEqualToString:@"\""]) {
            quotationMarksPresent = TRUE;
            break;
        }
    }
    
    if (!quotationMarksPresent) {
        // quotation marks are NOT present
        // simply break by comma and return
        
        NSArray *componentArray = [csvString componentsSeparatedByString:@","];
        csvDataArray = [NSMutableArray arrayWithArray:componentArray];
        
        return csvDataArray;
        
    } else {
        // quotation marks ARE present
        
        NSString *field = [NSString string];
        BOOL ignoreCommas = FALSE;
        int counter = 0;
        
        for (NSString *ichar in characters) {
            
            if ([ichar isEqualToString:@"\n"]) {
                // end of line reached
                [csvDataArray addObject:field];
                
                return csvDataArray;
            }
            
            if (counter == ([characters count]-1)) {
                // end of character stream reached
                // add last character to field, add to array and return
                field = [field stringByAppendingString:ichar];
                [csvDataArray addObject:field];
                
                return csvDataArray;
            }
            
            
            if (ignoreCommas == FALSE) {
                if ( [ichar isEqualToString:@","] == FALSE) {
                    // ichar is NOT a comma
                    
                    if ([ichar isEqualToString:@"\""] == FALSE) {
                        // ichar is NOT a double-quote
                        field = [field stringByAppendingString:ichar];
                    } else {
                        // ichar IS a double-quote
                        ignoreCommas = TRUE;
                        field = [field stringByAppendingString:ichar];
                    }
                    
                } else {
                    // comma reached - add field to array
                    if ([field isEqualToString:@""] == FALSE) {
                        [csvDataArray addObject:field];
                        field = @"";
                    }
                    
                }
                
            } else {
                
                if ([ichar isEqualToString:@"\""] == FALSE) {
                    // ichar is NOT a double-quote
                    field = [field stringByAppendingString:ichar];
                } else {
                    // ichar IS a double-quote
                    // closing double-quote reached
                    ignoreCommas = FALSE;
                    field = [field stringByAppendingString:ichar];
                    // end of field reached - add field to array
                    if ([field isEqualToString:@""] == FALSE) {
                        [csvDataArray addObject:field];
                        field = @"";
                    }
                    
                }
                
            } // END if (ignoreCommas == FALSE)
            
            counter++;
        } // END for (NSString *ichar in characters)
        
    }
    
    return nil;
}


@end




