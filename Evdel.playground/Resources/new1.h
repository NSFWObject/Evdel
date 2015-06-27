//
//  WMLRouteBuilder.h
//  Wondermall
//
//  Created by Sash Zats on 2/3/15.
//  Copyright (c) 2015 Wondermall Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMLOpenStoreEventSource.h"
#import "WMLDealTypes.h"


@interface WMLRouteBuilder : NSObject

+ (nonnull instancetype)sharedRouteBuilder;

@end


@interface WMLRouteBuilder (Home)

- (nonnull NSURL *)storesURL;

- (nonnull NSURL *)savedListURL;

- (nonnull NSURL *)universalSearchURLWithQuery:(nullable NSString *)searchTerm;

@end


@interface WMLRouteBuilder (Store)

- (nonnull NSURL *)storeURLForStoreId:(nonnull NSString *)storeId eventSource:(WMLOpenStoreEventSource)eventSource;

- (nonnull NSURL *)shippingPolicyURLForStoreId:(nonnull NSString *)storeId;

@end


@interface WMLRouteBuilder (CouponBook)

- (nonnull NSURL *)couponBookURL;

- (nonnull NSURL *)dealPopupForDealId:(nonnull NSString *)dealId source:(WMLOpenDealEventSource)source;

@end


@interface WMLRouteBuilder (Cart)

- (nonnull NSURL *)cartURL;

- (nonnull NSURL *)buyAtCartURLForStoreWithId:(nonnull NSString *)storeId;

@end


@interface WMLRouteBuilder (Product)

- (nonnull NSURL *)productURLForProductId:(nonnull NSString *)productId sliceId:(nullable NSString *)sliceId variantId:(nullable NSString *)variantId;

@end
