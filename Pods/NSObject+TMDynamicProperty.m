//
//  NSObject+TMDynamicProperty.m
//  Pods
//
//  Created by Zitao Xiong on 1/31/15.
//
//

#import "NSObject+TMDynamicProperty.h"
#import <objc/runtime.h>

enum TypeEncodings {
    Char                = 'c',
    Bool                = 'B',
    Short               = 's',
    Int                 = 'i',
    Long                = 'l',
    LongLong            = 'q',
    UnsignedChar        = 'C',
    UnsignedShort       = 'S',
    UnsignedInt         = 'I',
    UnsignedLong        = 'L',
    UnsignedLongLong    = 'Q',
    Float               = 'f',
    Double              = 'd',
    Object              = '@'
};



@interface NSObject (TMDynamicPropertyPrivate)
@property (readonly, nonatomic) NSMutableDictionary *TM_storeDictionary;
@property (strong, nonatomic) NSMutableDictionary *TM_mapping;
@end

@implementation NSObject(TMDynamicProperty)

static long long longLongGetter(NSObject *self, SEL _cmd) {
    NSString *key = [self defaultsKeyForSelector:_cmd];
    return [[self.TM_storeDictionary objectForKey:key] longLongValue];
}

static void longLongSetter(NSObject *self, SEL _cmd, long long value) {
    NSString *key = [self defaultsKeyForSelector:_cmd];
    NSNumber *object = [NSNumber numberWithLongLong:value];
    [self.TM_storeDictionary setObject:object forKey:key];
}

static bool boolGetter(NSObject *self, SEL _cmd) {
    NSString *key = [self defaultsKeyForSelector:_cmd];
    return [[self.TM_storeDictionary valueForKey:key] boolValue];
}

static void boolSetter(NSObject *self, SEL _cmd, bool value) {
    NSString *key = [self defaultsKeyForSelector:_cmd];
    [self.TM_storeDictionary setValue:@(value) forKey:key];
}

static int integerGetter(NSObject *self, SEL _cmd) {
    NSString *key = [self defaultsKeyForSelector:_cmd];
    return [[self.TM_storeDictionary valueForKey:key] intValue];
}

static void integerSetter(NSObject *self, SEL _cmd, int value) {
    NSString *key = [self defaultsKeyForSelector:_cmd];
    [self.TM_storeDictionary setValue:@(value) forKey:key];
}

static float floatGetter(NSObject *self, SEL _cmd) {
    NSString *key = [self defaultsKeyForSelector:_cmd];
    return [[self.TM_storeDictionary valueForKey:key] floatValue];
}

static void floatSetter(NSObject *self, SEL _cmd, float value) {
    NSString *key = [self defaultsKeyForSelector:_cmd];
    [self.TM_storeDictionary setValue:@(value) forKey:key];
}

static double doubleGetter(NSObject *self, SEL _cmd) {
    NSString *key = [self defaultsKeyForSelector:_cmd];
    return [[self.TM_storeDictionary valueForKey:key] doubleValue];
}

static void doubleSetter(NSObject *self, SEL _cmd, double value) {
    NSString *key = [self defaultsKeyForSelector:_cmd];
    [self.TM_storeDictionary setValue:@(value) forKey:key];
}

static id objectGetter(NSObject *self, SEL _cmd) {
    NSString *key = [self defaultsKeyForSelector:_cmd];
//    return [self.TM_storeDictionary objectForKey:key];
    return objc_getAssociatedObject(self, (__bridge const void *)(key));
}

static void objectSetter(NSObject *self, SEL _cmd, id object) {
    NSString *key = [self defaultsKeyForSelector:_cmd];
//    objc_setAssociatedObject(self, (__bridge const void *)(key) , object, OBJC_ASSOCIATION_RETAIN);
//    return;
    if (object) {
        [self.TM_storeDictionary setObject:object forKey:key];
    } else {
        [self.TM_storeDictionary removeObjectForKey:key];
    }
}

- (NSString *)defaultsKeyForSelector:(SEL)selector {
    return [[[self class] TM_mapping] objectForKey:NSStringFromSelector(selector)];
}

- (NSMutableDictionary *)TM_storeDictionary {
    NSMutableDictionary *dictionary = objc_getAssociatedObject(self, _cmd);
    if (!dictionary) {
        dictionary = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, dictionary, OBJC_ASSOCIATION_RETAIN);
    }
    return dictionary;
}

+ (NSMutableDictionary *)TM_mapping {
    static dispatch_once_t onceToken;
    __strong static NSMutableDictionary *dictionary;
    dispatch_once(&onceToken, ^{
        dictionary = [[NSMutableDictionary alloc] init];
    });
    return dictionary;
}

+ (void)generateAccessorMethods {
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; ++i) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        const char *attributes = property_getAttributes(property);
        
        char *getter = strstr(attributes, ",G");
        if (getter) {
            getter = strdup(getter + 2);
            getter = strsep(&getter, ",");
        } else {
            getter = strdup(name);
        }
        SEL getterSel = sel_registerName(getter);
        free(getter);
        
        char *setter = strstr(attributes, ",S");
        if (setter) {
            setter = strdup(setter + 2);
            setter = strsep(&setter, ",");
        } else {
            asprintf(&setter, "set%c%s:", toupper(name[0]), name + 1);
        }
        SEL setterSel = sel_registerName(setter);
        free(setter);
        
        NSString *key = [NSString stringWithFormat:@"%s", name];
        [[self TM_mapping] setValue:key forKey:NSStringFromSelector(getterSel)];
        [[self TM_mapping] setValue:key forKey:NSStringFromSelector(setterSel)];
        
        IMP getterImp = NULL;
        IMP setterImp = NULL;
        char type = attributes[1];
        switch (type) {
            case Short:
            case Long:
            case LongLong:
            case UnsignedChar:
            case UnsignedShort:
            case UnsignedInt:
            case UnsignedLong:
            case UnsignedLongLong:
                getterImp = (IMP)longLongGetter;
                setterImp = (IMP)longLongSetter;
                break;
                
            case Bool:
            case Char:
                getterImp = (IMP)boolGetter;
                setterImp = (IMP)boolSetter;
                break;
                
            case Int:
                getterImp = (IMP)integerGetter;
                setterImp = (IMP)integerSetter;
                break;
                
            case Float:
                getterImp = (IMP)floatGetter;
                setterImp = (IMP)floatSetter;
                break;
                
            case Double:
                getterImp = (IMP)doubleGetter;
                setterImp = (IMP)doubleSetter;
                break;
                
            case Object:
                getterImp = (IMP)objectGetter;
                setterImp = (IMP)objectSetter;
                break;
                
            default:
                free(properties);
                [NSException raise:NSInternalInconsistencyException format:@"Unsupported type of property \"%s\" in class %@", name, self];
                break;
        }
        
        char types[5];
        
        snprintf(types, 4, "%c@:", type);
        class_addMethod([self class], getterSel, getterImp, types);
        
        snprintf(types, 5, "v@:%c", type);
        class_addMethod([self class], setterSel, setterImp, types);
    }
    
    free(properties);
}
@end
