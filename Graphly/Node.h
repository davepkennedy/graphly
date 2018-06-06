//
//  Node.h
//  Graphly
//
//  Created by Dave Kennedy on 09/05/2018.
//  Copyright © 2018 Dave Kennedy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Node : NSObject

@property NSUUID* identifier;
@property NSUUID* group;
@property NSString* name;
@property NSPoint position;
@property NSString* description;
@property(readonly) NSArray<NSUUID*>* connections;

- (instancetype) initWithValues:(NSDictionary*) values;

- (NSInteger)numberOfProperties;
- (id) property:(NSString*)name forItem:(NSInteger)item;
- (void) newValue:(id)object forProperty:(NSString*)name forItem:(NSInteger)item;

- (void) addConnection:(Node*) node;

- (NSDictionary*) toDictionary;

@end
