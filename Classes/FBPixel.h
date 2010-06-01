/*
 *  FBPixel.h
 *  Substrate
 *
 *  Created by Jonathan Cooper on 5/27/10.
 *  Copyright 2010 Jon Cooper. All rights reserved.
 *
 */

typedef struct {
	float r;
	float g;
	float b;
	float a;
} FBPixel;

static inline FBPixel MakeFBPixel(float r, float g, float b, float a) 
{
	FBPixel pixel;
	pixel.r = r;
	pixel.g = g;
	pixel.b = b;
	pixel.a = a;
	return pixel;
}

static inline BOOL BlessFBPixel(FBPixel pixel) {
	if ((pixel.r >= 0.0) && (pixel.r <= 1.0) &&
		(pixel.g >= 0.0) && (pixel.g <= 1.0) &&
		(pixel.b >= 0.0) && (pixel.b <= 1.0) &&
		(pixel.a >= 0.0) && (pixel.a <= 1.0)) {
		return YES;
	}
	else return NO;
}

static inline uint32_t FBPixelToUint32(FBPixel pixel)
{
	uint8_t r = (uint8_t) roundf(pixel.r * 255.0);
	uint8_t g = (uint8_t) roundf(pixel.g * 255.0);
	uint8_t b = (uint8_t) roundf(pixel.b * 255.0);
	uint8_t a = (uint8_t) roundf(pixel.a * 255.0);
	return ((uint32_t) r | ((uint32_t) g) << 8 | ((uint32_t) b) << 16 | ((uint32_t) a) << 24);
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
	pixel.r = ((float) FBUnpackR(bytes)) / 255.0;
	pixel.g = ((float) FBUnpackG(bytes)) / 255.0;
	pixel.b = ((float) FBUnpackB(bytes)) / 255.0;
	pixel.a = ((float) FBUnpackA(bytes)) / 255.0;
	return pixel;
}
