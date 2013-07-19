//
//  Protocols.h
//  Snapalicious
//
//  Created by Carlotta Tatti on 20/02/13.
//
//

#import <Foundation/Foundation.h>

@interface Protocols : NSObject

@end

@protocol Recipe <FBGraphObject>

@property (retain, nonatomic) NSString *id;
@property (retain, nonatomic) NSString *url;

@end

@protocol PostRecipeAction <FBOpenGraphAction>

@property (retain, nonatomic) id <Recipe> recipe;

@end

@protocol Dish <FBGraphObject>

@property (retain, nonatomic) NSString *id;
@property (retain, nonatomic) NSString *url;

@end

@protocol PostDishAction <FBOpenGraphAction>

@property (retain, nonatomic) id <Dish> dish;

@end