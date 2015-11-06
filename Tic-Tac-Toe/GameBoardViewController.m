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
    Player *player1 = [[Player alloc] init];
    Player *player2 = [[Player alloc] init];
    
    player1.playerID = @"Blue";
    player1.selectedBoxes = [[NSMutableArray alloc] initWithCapacity:0];
    
    player2.playerID = @"Purple";
    player2.selectedBoxes = [[NSMutableArray alloc] initWithCapacity:0];
    
    // Initialize GameBoard objects and set current player to X
    self.players = [NSMutableArray arrayWithObjects:player1, player2, nil];
    self.currentPlayer = player1;
    self.selectedBoxes = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.color2 = [UIColor colorWithRed:0.678f green:0.184f blue:0.957f alpha:1.00f];
    self.color1 = [UIColor colorWithRed:0.129f green:0.753f blue:0.992f alpha:1.00f];
    
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
        if (CGRectContainsPoint(box.frame, [eventInfo locationInView:self.gridView]) && ![self isSelected:box]) {
            
            // Add selected box to array of selected boxes
            [self.selectedBoxes addObject:box];
            
            BOOL isDiagonal = [self isDiagonal:box];
            BOOL isAntiDiagonal = [self isAntiDiagonal:box];

            if ([self.currentPlayer.playerID isEqual:@"Blue"]) {
                box.backgroundColor = self.color1;
                
                // Adds box to list of player 1's selected boxes and checks if player 1 won
                if ([self.currentPlayer addBox:box isDiagonal:isDiagonal isAntiDiagonal:isAntiDiagonal]) {
                    [self endGameWithPlayer:self.currentPlayer];
                }
                
                // All boxes are selected, so end game
                else if([self isGameOver]) {
                    [self endGameWithPlayer:nil];
                }
                
                  // Player 1 did not win so change to player 2
                else {
                    self.currentPlayer = self.players[1];
                    self.statusLabel.text = @"It is purple's turn";
                }
            }
            
            else {
                box.backgroundColor = self.color2;
                
                // Adds box to list of player 2's selected boxes and checks if player O won
                if ([self.currentPlayer addBox:box isDiagonal:isDiagonal isAntiDiagonal:isAntiDiagonal]) {
                    [self endGameWithPlayer:self.currentPlayer];
                }
                
                // All boxes are selected so end game
                else if([self isGameOver]) {
                    [self endGameWithPlayer:nil];
                }
                
                // Player 2 did not win so switch to player 1
                else {
                    self.currentPlayer = self.players[0];
                    self.statusLabel.text = @"It is blue's turn";
                }
            }
        }
    }
}

- (BOOL)isSelected:(UIImageView *)box {
    // Return YES if the box has already been selected/colored in
    if ([box.backgroundColor isEqual:self.color1] || [box.backgroundColor isEqual:self.color2]) {
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
                                                                       message:[NSString stringWithFormat:@"%@ won!", winner.playerID]
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

- (IBAction)userRestart:(id)sender {
    // User initiated game restart
    [self restartGame];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
