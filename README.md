
# Substrate
## A port of Jared Tarbell's wonderful Processing sketch, Substrate, to the iPad.

I wrote this to learn something about writing iOS applications, and about OpenGL. 

The original is here: [Substrate](http://www.complexification.net/gallery/machines/substrate/).

Since there isn't any concept natively under iOS of blitting 2D graphics to the screen, I had to write a custom rendering layer on top of OpenGL. (This is what Cocos2D does too, btw.)

The actual implementation approach is mildly hair-raising and more than a little hacky: I render to a texture which then gets mapped onto a quad which is lit and displayed in the viewport. I've implemented a simple antialiased line drawing algorithm and color blending. 

The cracks are rendered using a thread that writes to the texture whilst another one renders the texture to the screen. This is not the best approach, since on a platform as constrained as this one, threading overhead is to be avoided. However, it resulted in the most straightforward port of the Processing code, and I thought I might want to port other Processing scripts one day. Dunno.

Perhaps this is useful to someone! If so, enjoy.

# Released under the MIT license

Copyright (C) 2011 by Jon Cooper

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
