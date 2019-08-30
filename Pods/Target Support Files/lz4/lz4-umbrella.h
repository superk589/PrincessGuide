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

#import "lz4.h"
#import "lz4frame.h"
#import "lz4frame_static.h"
#import "lz4hc.h"
#import "xxhash.h"

FOUNDATION_EXPORT double lz4VersionNumber;
FOUNDATION_EXPORT const unsigned char lz4VersionString[];

