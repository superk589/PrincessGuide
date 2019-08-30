#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BrotliKit.h"
#import "LMBrotliCompression.h"
#import "LMBrotliCompressor.h"
#import "NSData+BrotliCompression.h"

FOUNDATION_EXPORT double BrotliKitVersionNumber;
FOUNDATION_EXPORT const unsigned char BrotliKitVersionString[];

