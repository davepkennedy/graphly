//
//  Graph.h
//  Graphly
//
//  Created by Dave Kennedy on 09/05/2018.
//  Copyright © 2018 Dave Kennedy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Node.h"

@class Group;

@interface Graph : NSObject

@property (readonly) NSArray<Node*>* nodes;
@property (readonly) NSArray<Group*>* groups;

- (instancetype) initWithNodes:(NSArray*)nodes;

- (Node*) newNode;
- (Group*) newGroup;
- (void) connect:(Node*) origin to:(Node*) destination;

-(NSArray<NSDictionary*>*) toArray;
-(Node*) nodeForID:(NSUUID*) identifier;

@end
