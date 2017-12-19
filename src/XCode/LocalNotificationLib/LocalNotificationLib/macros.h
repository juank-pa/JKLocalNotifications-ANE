//
//  macros.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 12/16/17.
//

#ifndef macros_h
#define macros_h

#define DEFINE_ANE_FUNCTION(fn) FREObject (JKLN_##fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
#define MAP_FUNCTION(fn) { (const uint8_t*)(#fn), NULL, &(JKLN_##fn) }

#endif /* macros_h */
