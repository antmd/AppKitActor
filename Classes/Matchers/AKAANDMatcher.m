//
//  AKAANDMatcher.m
//  AppKitActor
//
//  Created by Miguel Lara on 13/01/14.
//  Copyright (c) 2014 Miguel Lara. All rights reserved.
//

#import "AKAANDMatcher.h"


@interface AKAANDMatcher ()

@property (nonatomic, copy) NSArray *submatchers;

@end


@implementation AKAANDMatcher

+ (instancetype)matcherWithSubmatchers:(NSArray *)submatchers
{
	return [[self alloc] initWithSubmatchers:submatchers];
}

- (instancetype)initWithSubmatchers:(NSArray *)submatchers
{
    self = [super init];
    if (self)
	{
        _submatchers = submatchers;
    }
    return self;
}


#pragma mark AKAViewMatcher methods

- (BOOL)matchesView:(NSView *)view
{
	return [self testObject:view matchWithSelector:@selector(matchesView:)];
}


#pragma mark AKAWindowMatcher methods

- (BOOL)matchesWindow:(NSWindow *)window
{
	return [self testObject:window matchWithSelector:@selector(matchesWindow:)];
}


#pragma mark Shared implementation

- (BOOL)testObject:(id)object matchWithSelector:(SEL)selector
{
	BOOL matches = self.submatchers.count > 0;
	
	for (id<AKAViewMatcher> submatcher in self.submatchers)
	{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		matches = matches && [[submatcher performSelector:selector withObject:object] boolValue];
#pragma clang diagnostic pop
		if (!matches)
		{
			break;
		}
	}
	
	return matches;
}

- (NSString *)debugDescription
{
	NSMutableArray *descriptions = [NSMutableArray arrayWithCapacity:self.submatchers.count];
	for (id<AKAViewMatcher> submatcher in self.submatchers)
	{
		[descriptions addObject:[submatcher debugDescription]];
	}
	
	return [NSString stringWithFormat:@"AND:[%@]", [descriptions componentsJoinedByString:@", "]];
}

@end
