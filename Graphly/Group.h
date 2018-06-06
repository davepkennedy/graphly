//
//  Group.h
//  Graphly
//
//  Created by Dave Kennedy on 30/05/2018.
//  Copyright © 2018 Dave Kennedy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Node;

@interface Group : NSObject

@property NSUUID* identifier;
@property(readonly) NSArray<NSUUID*>* nodes;

- (void) addNode:(Node*)node;
- (void) removeNode:(Node*)node;

@end
