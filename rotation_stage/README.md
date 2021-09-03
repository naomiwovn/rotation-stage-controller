Uses Encoder arduino library

Arduino nano every has issues with interrupt pins 2 and 3 with encoder library

Added to top of /Users/\<User\>/Documents/Arduino/libraries/Encoder/Encoder.cpp the following: 
```
#define FROM_ENCODER_CPP 
```

Changed the line in /Users/\<User\>/Documents/Arduino/libraries/Encoder/Encoder.h
```
#if defined(ENCODER_USE_INTERRUPTS) || !defined(ENCODER_DO_NOT_USE_INTERRUPTS)
```
to 
```
#if defined(ENCODER_USE_INTERRUPTS) || (!defined(ENCODER_DO_NOT_USE_INTERRUPTS) && !defined(FROM_ENCODER_CPP))
```

