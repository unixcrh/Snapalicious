//
//  UserScore.m
//  Snapalicious
//
//  Created by Carlotta Tatti on 15/04/13.
//
//

#import "ScoreUtils.h"

@implementation ScoreUtils

+ (int)pointsForAction:(ActionType)action {
    switch (action) {
        case kScoreForDishUpload:
            return 5;
            break;
            
        case kScoreForRecipeWriteAfterLimit:
            return 5;
            
        case kScoreForRecipeWriteBeforeLimit:
            return 7;
            
        case kScoreForDishUploadAndRecipeWrite:
            return 10;
            
        default:
            break;
    }
}

@end
