//
//  GameBoardViewController.h
//  Tic-Tac-Toe
//
//  Created by Ross Freeman on 11/5/15.
//  Copyright © 2015 Ross Freeman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"

@interface GameBoardViewController : UIViewController

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *gameBoxes;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *diagonalBoxes;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *antiDiagonalBoxes;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) NSMutableArray *players;
@property (strong, nonatomic) Player *currentPlayer;
@property (strong, nonatomic) NSMutableArray *selectedBoxes;

- (BOOL)isSelected:(UIImageView *)box;
- (BOOL)isDiagonal:(UIImageView *)box;
- (BOOL)isAntiDiagonal:(UIImageView *)box;
- (BOOL)isGameOver;

- (void)endGameWithPlayer:(Player *)winner;
- (void)restartGame;

@end
