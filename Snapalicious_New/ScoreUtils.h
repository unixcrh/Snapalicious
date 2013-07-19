//
//  UserScore.h
//  Snapalicious
//
//  Created by Carlotta Tatti on 15/04/13.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    kScoreForDishUpload,
    kScoreForRecipeWriteAfterLimit,
    kScoreForRecipeWriteBeforeLimit,
    kScoreForDishUploadAndRecipeWrite
} ActionType;

@interface ScoreUtils : NSObject

+ (int)pointsForAction:(ActionType)action;

@end
