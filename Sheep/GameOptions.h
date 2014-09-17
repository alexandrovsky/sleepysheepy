//
//  GameOptions.h
//  Sheep2
//
//  Created by Dmitry Alexandrovsky on 16.09.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#ifndef Sheep2_GameOptions_h
#define Sheep2_GameOptions_h

typedef NS_OPTIONS(NSUInteger, CollisionCategory) {
    CollisionCategoryAnimal           = 1 << 0,
    CollisionCategoryFence           = 1 << 1,
    CollisionCategoryGround          = 1 << 2,
    CollisionCategoryEndingpoint     = 1 << 3,
};



#define kInitSpeed 160
#define kInitLifes 3

#endif
