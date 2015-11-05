//
//  Player.h
//  Tic-Tac-Toe
//
//  Created by Ross Freeman on 11/5/15.
//  Copyright © 2015 Ross Freeman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Player : NSObject

@property (strong, nonatomic) NSString *playerID;
@property (strong, nonatomic) NSMutableArray *selectedBoxes;
@property (assign, nonatomic) NSInteger xCount;
@property (assign, nonatomic) NSInteger yCount;
@property (assign, nonatomic) NSInteger diagCount1;
@property (assign, nonatomic) NSInteger diagCount2;

- (BOOL)addBox:(UIImageView *)selectedBox isDiagonal:(BOOL)diagonal isAntiDiagonal:(BOOL)antiDiagonal;

@end
