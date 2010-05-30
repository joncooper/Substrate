/*
 *  FBPixel.h
 *  Substrate
 *
 *  Created by Jonathan Cooper on 5/27/10.
 *  Copyright 2010 Jon Cooper. All rights reserved.
 *
 */

// Should these be clamped floats instead?
typedef struct {
	uint8_t r;
	uint8_t g;
	uint8_t b;
	uint8_t a;
} FBPixel;

static inline FBPixel MakeFBPixel(uint8_t r, uint8_t g, uint8_t b, uint8_t a) 
{
	FBPixel pixel;
	pixel.r = r;
	pixel.g = g;
	pixel.b = b;
	pixel.a = a;
	return pixel;
}

static inline uint32_t FBPixelToUint32(FBPixel pixel)
{
	return ((uint32_t) pixel.r | ((uint32_t) pixel.g) << 8 | ((uint32_t) pixel.b) << 16 | ((uint32_t) pixel.a) << 24);
}
	

// Be careful to apply the shift before the cast, otherwise you are shifting something that's already 8 bits.

static inline uint8_t FBUnpackR(uint32_t packed) 
{
	return ((uint8_t) packed);
}

static inline uint8_t FBUnpackG(uint32_t packed) 
{
	return ((uint8_t) (packed >> 8));
}

static inline uint8_t FBUnpackB(uint32_t packed) {
	return ((uint8_t) (packed >> 16));
}

static inline uint8_t FBUnpackA(uint32_t packed) {
	return ((uint8_t) (packed >> 24));
}


static inline FBPixel Uint32ToFBPixel(uint32_t bytes) 
{
	FBPixel pixel;
	pixel.r = FBUnpackR(bytes);
	pixel.g = FBUnpackG(bytes);
	pixel.b = FBUnpackB(bytes);
	pixel.a = FBUnpackA(bytes);
	return pixel;
}
