//
//  MovieObject.h
//  HollywoodGenius
//
//  Created by Ekam Singh Dhaliwal on 2019-06-20.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>



@interface MovieObject : RLMObject

@property NSString *title;
@property NSString *uuid;

- (instancetype)initWithTitle:(NSString *)title andUID:(NSString *)uuid; 

@end


