//
//  Node.m
//  Graphly
//
//  Created by Dave Kennedy on 09/05/2018.
//  Copyright © 2018 Dave Kennedy. All rights reserved.
//

#import "Node.h"

static const NSString* IDENTIFIER_KEY = @"identifier";
static const NSString* NAME_KEY = @"name";
static const NSString* DESCRIPTION_KEY = @"description";
static const NSString* POSITION_KEY = @"position";
static const NSString* CONNECTIONS_KEY = @"connections";

@implementation Node {
    NSMutableArray<NSUUID*>* _connections;
}

@synthesize identifier, name, position, description;
@synthesize connections = _connections;

- (instancetype) init {
    self = [super init];
    if (self) {
        self.identifier = [NSUUID UUID];
        self.name = @"Test Node";
        self.description = @"";
        _connections = [NSMutableArray array];

    }
    return self;
}

- (instancetype) initWithValues:(NSDictionary*) values {
    self = [super init];
    if (self) {
        self.identifier = [[NSUUID alloc] initWithUUIDString:[values objectForKey:IDENTIFIER_KEY]];
        self.name = [values objectForKey:NAME_KEY];
        self.description = [values objectForKey:DESCRIPTION_KEY];
        NSDictionary* pos = [values objectForKey:POSITION_KEY];
        NSNumber* x = [pos objectForKey:@"x"];
        NSNumber* y = [pos objectForKey:@"y"];
        self.position = NSMakePoint(x.floatValue, y.floatValue);
        
        NSArray* connections = [values objectForKey:CONNECTIONS_KEY];
        _connections = [NSMutableArray array];
        for (NSString* str in connections) {
            NSUUID* uuid = [[NSUUID alloc] initWithUUIDString:str];
            [_connections addObject:uuid];
        }
    }
    return self;
}

- (NSInteger)numberOfProperties {
    return 0;
}

- (id) property:(NSString*)name forItem:(NSInteger)item
{
    return nil;
}

- (void) newValue:(id)object forProperty:(NSString*)name forItem:(NSInteger)item
{
    
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[self.identifier UUIDString] forKey:IDENTIFIER_KEY];
    [dict setObject:self.name forKey:NAME_KEY];
    [dict setObject:self.description forKey:DESCRIPTION_KEY];
    [dict setObject:[NSDictionary dictionaryWithObjects:@[[NSNumber numberWithFloat:self.position.x], [NSNumber numberWithFloat:self.position.y]]
                                                forKeys:@[@"x", @"y"]]
             forKey:POSITION_KEY];
    
    NSMutableArray* uuids = [NSMutableArray array];
    for (NSUUID* connection in _connections) {
        [uuids addObject:[connection UUIDString]];
    }
    [dict setObject:uuids forKey:CONNECTIONS_KEY];
    
    return dict;
}

- (void) addConnection:(Node*) node {
    [_connections addObject:node.identifier];
}

@end
