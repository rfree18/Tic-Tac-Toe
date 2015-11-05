//
//  Player.m
//  Tic-Tac-Toe
//
//  Created by Ross Freeman on 11/5/15.
//  Copyright © 2015 Ross Freeman. All rights reserved.
//

#import "Player.h"

@implementation Player

- (BOOL)addBox:(UIImageView *)selectedBox isDiagonal:(BOOL)diagonal isAntiDiagonal:(BOOL)antiDiagonal{
    CGFloat selectedX = selectedBox.frame.origin.x;
    CGFloat selectedY = selectedBox.frame.origin.y;
    
    for (UIImageView *box in self.selectedBoxes) {
        CGFloat x = box.frame.origin.x;
        CGFloat y = box.frame.origin.y;
        
        // Check if selected box is in the same row or column and add 1 to appropriate variable
        if (selectedX == x) {
            self.xCount++;
        }
        else if (selectedY == y) {
            self.yCount++;
        }
    }
    
    // Check if selected box is diagonal and/or anti-diagonal and add 1 to appropriate variables
    if (diagonal) {
        self.diagCount1++;
    }
    
    // Note: center box is both diagonal and anti-diagonal so it counts twice
    
    if (antiDiagonal) {
        self.diagCount2++;
    }
    
    // If player has 3 boxes selected in any row, column, or diagonal, then they win
    if (self.xCount == 3 || self.yCount == 3 || self.diagCount1 == 3 || self.diagCount2 == 3) {
        return true;
    }
    
    [self.selectedBoxes addObject:selectedBox];
    
    return false;
}

@end
