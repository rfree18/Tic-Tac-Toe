//
//  GameBoardViewController.m
//  Tic-Tac-Toe
//
//  Created by Ross Freeman on 11/5/15.
//  Copyright © 2015 Ross Freeman. All rights reserved.
//

#import "GameBoardViewController.h"

@interface GameBoardViewController ()

@end

@implementation GameBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize Player objects with default values
    Player *xPlayer = [[Player alloc] init];
    Player *oPlayer = [[Player alloc] init];
    
    xPlayer.playerID = @"X";
    xPlayer.selectedBoxes = [[NSMutableArray alloc] initWithCapacity:0];
    
    oPlayer.playerID = @"O";
    oPlayer.selectedBoxes = [[NSMutableArray alloc] initWithCapacity:0];
    
    // Initialize GameBoard objects and set current player to X
    self.players = [NSMutableArray arrayWithObjects:xPlayer, oPlayer, nil];
    self.currentPlayer = xPlayer;
    self.selectedBoxes = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSLog(@"%@", self.gameBoxes);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // Occurs when a box is touched
    
    UITouch *eventInfo = [[event allTouches] anyObject];
    
    for (UIImageView *box in self.gameBoxes) {
        if (CGRectContainsPoint(box.frame, [eventInfo locationInView:self.view]) && ![self isSelected:box]) {
            
            // Add selected box to array of selected boxes
            [self.selectedBoxes addObject:box];
            
            BOOL isDiagonal = [self isDiagonal:box];
            BOOL isAntiDiagonal = [self isAntiDiagonal:box];

            if ([self.currentPlayer.playerID isEqual:@"X"]) {
                box.backgroundColor = [UIColor blueColor];
                
                // Adds box to list of player X's selected boxes and checks if player X won
                if ([self.currentPlayer addBox:box isDiagonal:isDiagonal isAntiDiagonal:isAntiDiagonal]) {
                    [self endGameWithPlayer:self.currentPlayer];
                }
                
                // All boxes are selected, so end game
                else if([self isGameOver]) {
                    [self endGameWithPlayer:nil];
                }
                
                  // Player X did not win so change to player O
                else {
                    self.currentPlayer = self.players[1];
                    self.statusLabel.text = @"It is player O's turn";
                }
            }
            
            else {
                box.backgroundColor = [UIColor redColor];
                
                // Adds box to list of player O's selected boxes and checks if player O won
                if ([self.currentPlayer addBox:box isDiagonal:isDiagonal isAntiDiagonal:isAntiDiagonal]) {
                    [self endGameWithPlayer:self.currentPlayer];
                }
                
                // All boxes are selected so end game
                else if([self isGameOver]) {
                    [self endGameWithPlayer:nil];
                }
                
                // Player O did not win so switch to player X
                else {
                    self.currentPlayer = self.players[0];
                    self.statusLabel.text = @"It is player X's turn";
                }
            }
        }
    }
}

- (BOOL)isSelected:(UIImageView *)box {
    // Return YES if the box has already been selected/colored in
    if (box.backgroundColor == [UIColor blueColor] || box.backgroundColor == [UIColor redColor]) {
        return YES;
    }
    return NO;
}

- (BOOL)isDiagonal:(UIImageView *)box {
    // Compare selected box to array of diagonal boxes to see if the selected box is diagonal
    for (UIImageView *view in self.diagonalBoxes) {
        if (box == view) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isAntiDiagonal:(UIImageView *)box {
    // Compare selected box to array of anti-diagonal boxes to see if the selected box is anti-diagonal
    for (UIImageView *view in self.antiDiagonalBoxes) {
        if (box == view) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isGameOver {
    // Checks if the number of selected boxes is equal to the total number of boxes
    if (self.selectedBoxes.count == self.gameBoxes.count) {
        return YES;
    }
    
    return NO;
}

- (void)endGameWithPlayer:(Player *)winner {
    // Display appropriate alert depending on end game status and allow user to start a new game
    
    if (winner == nil) {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Game Over"
                                                                       message:@"The game was a tie."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *restartAction = [UIAlertAction actionWithTitle:@"New Game" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self restartGame];
                                                              }];
        
        [alert addAction:restartAction];
        [self presentViewController:alert animated:YES completion:^{}];
        
    }
    
    else {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Congratulations!"
                                                                       message:[NSString stringWithFormat:@"Player %@ won!", winner.playerID]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *restartAction = [UIAlertAction actionWithTitle:@"New Game" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self restartGame];
                                                              }];
        
        [alert addAction:restartAction];
        [self presentViewController:alert animated:YES completion:^{}];
       
    }
}


- (void)restartGame {
    Player *xPlayer = self.players[0];
    Player *oPlayer = self.players[1];
    
    // Reset player variables to original state
    xPlayer.selectedBoxes = [[NSMutableArray alloc] initWithCapacity:0];
    xPlayer.xCount = 0;
    xPlayer.yCount = 0;
    xPlayer.diagCount1 = 0;
    xPlayer.diagCount2 = 0;
    
    oPlayer.selectedBoxes = [[NSMutableArray alloc] initWithCapacity:0];
    oPlayer.xCount = 0;
    oPlayer.yCount = 0;
    oPlayer.diagCount1 = 0;
    oPlayer.diagCount2 = 0;
    
    for (UIImageView *box in self.gameBoxes) {
        box.backgroundColor = [UIColor lightGrayColor];
    }
    
    self.currentPlayer = xPlayer;
    self.selectedBoxes = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.statusLabel.text = @"Select any square to start!";
}

@end
