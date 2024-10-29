/*******************************************************************************
 * The MIT License (MIT)
 *
 * Copyright (c) 2023, Jean-David Gadina - www.xs-labs.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the Software), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

#import "CrashHelper.h"
#include <stdexcept>

static void recursiveCall();
static void recursiveCall()
{
             char buf[ 1024 * 1024 ];
    volatile bool call = true;
    
    memset( buf, 0, sizeof( buf ) );
    printf( "%s", buf );
    
    if( call )
    {
        recursiveCall();
    }
}

@implementation CrashHelper

+ ( void )crash_ObjCException
{
    volatile int x = 0;
    
    if( x == 0 )
    {
        @throw [ NSException exceptionWithName: @"TestException" reason: @"hello, world" userInfo: @{} ];
    }
}

+ ( void )crash_CPPException
{
    volatile int x = 0;
    
    if( x == 0 )
    {
        throw std::runtime_error( "hello, world" );
    }
}

static volatile char * crash_SegmentationFault_Buffer = nullptr;

+ ( void )crash_SegmentationFault
{
    crash_SegmentationFault_Buffer[ 0 ] = 0;
}

+ ( void )crash_Abort
{
    volatile int x = 0;
    
    if( x == 0 )
    {
        abort();
    }
}

+ ( void )crash_StackOverflow
{
    recursiveCall();
}

@end
