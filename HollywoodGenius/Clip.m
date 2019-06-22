//
//  Clip.m
//  HollywoodGenius
//
//  Created by Ekam Singh Dhaliwal on 2019-06-20.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import "Clip.h"

@implementation Clip

- (instancetype)initWithTitle:(NSString *)title andQuote:(NSString *)movieQuote andUID:(NSString *)uuid
{
    self = [super init];
    if (self) {
        self.title = title;
        self.uuid = uuid;
        self.quote = movieQuote; 
    }
    return self;
}

@end
