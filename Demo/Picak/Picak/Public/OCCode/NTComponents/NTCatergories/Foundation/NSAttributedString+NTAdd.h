//
//  NSAttributedString+NTAdd.h
//  NewCenterWeather
//
//  Created by 肖文 on 2017/7/19.
//  Copyright © 2017年 肖文. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef NT_ATTRIBUTE_STRING_CREAT
#define NT_ATTRIBUTE_STRING_CREAT(_string_ ,_attributes_) \
({ \
NSAttributedString *str = nil; \
NSString *theString = (_string_); \
if (theString) { \
    str = [[NSAttributedString alloc] initWithString:theString attributes:(_attributes_)]; \
} \
str; \
})
#endif

#ifndef NT_MUTABLE_ATTRIBUTE_STRING_CREAT
#define NT_MUTABLE_ATTRIBUTE_STRING_CREAT(_string_ ,_attributes_) \
({ \
NSMutableAttributedString *str = nil; \
NSString *theString = (_string_); \
if (theString) { \
str = [[NSMutableAttributedString alloc] initWithString:theString attributes:(_attributes_)]; \
} \
str; \
})
#endif

@interface NSAttributedString (NTAdd)

@end
