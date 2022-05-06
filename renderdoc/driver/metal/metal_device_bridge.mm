/******************************************************************************
 * The MIT License (MIT)
 *
 * Copyright (c) 2022 Baldur Karlsson
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

#include "metal_device.h"
#include <Availability.h>
#include "metal_command_queue.h"
#include "metal_library.h"
#include "metal_types_bridge.h"

// Bridge for MTLDevice
@implementation ObjCBridgeMTLDevice

// ObjCBridgeMTLDevice specific
- (id<MTLDevice>)real
{
  return id<MTLDevice>(Unwrap(GetWrapped(self)));
}

// Silence compiler warning
// error: method possibly missing a [super dealloc] call [-Werror,-Wobjc-missing-super-calls]
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc
{
  GetWrapped(self)->Dealloc();
}
#pragma clang diagnostic pop

// Use the real MTLDevice to find methods from messages
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
  id fwd = self.real;
  return [fwd methodSignatureForSelector:aSelector];
}

// Forward any unknown messages to the real MTLDevice
- (void)forwardInvocation:(NSInvocation *)invocation
{
  SEL aSelector = [invocation selector];

  if([self.real respondsToSelector:aSelector])
    [invocation invokeWithTarget:self.real];
  else
    [super forwardInvocation:invocation];
}

// MTLDevice : based on the protocol defined in
// Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX12.1.sdk/System/Library/Frameworks/Metal.framework/Headers/MTLDevice.h

- (NSString *)name
{
  return self.real.name;
}

- (uint64_t)registryID API_AVAILABLE(macos(10.13), ios(11.0))
{
  return self.real.registryID;
}

- (MTLSize)maxThreadsPerThreadgroup API_AVAILABLE(macos(10.11), ios(9.0))
{
  return self.real.maxThreadsPerThreadgroup;
}

- (BOOL)isLowPower API_AVAILABLE(macos(10.11), macCatalyst(13.0))API_UNAVAILABLE(ios)
{
  return self.real.lowPower;
}

- (BOOL)isHeadless API_AVAILABLE(macos(10.11), macCatalyst(13.0))API_UNAVAILABLE(ios)
{
  return self.real.headless;
}

- (BOOL)isRemovable API_AVAILABLE(macos(10.13), macCatalyst(13.0))API_UNAVAILABLE(ios)
{
  return self.real.removable;
}

- (BOOL)hasUnifiedMemory API_AVAILABLE(macos(10.15), ios(13.0))
{
  return self.real.hasUnifiedMemory;
}

- (uint64_t)recommendedMaxWorkingSetSize API_AVAILABLE(macos(10.12), macCatalyst(13.0))
    API_UNAVAILABLE(ios)
{
  return self.real.recommendedMaxWorkingSetSize;
}

- (MTLDeviceLocation)location API_AVAILABLE(macos(10.15))API_UNAVAILABLE(ios)
{
  return self.real.location;
}

- (NSUInteger)locationNumber API_AVAILABLE(macos(10.15))API_UNAVAILABLE(ios)
{
  return self.real.locationNumber;
}

- (uint64_t)maxTransferRate API_AVAILABLE(macos(10.15))API_UNAVAILABLE(ios)
{
  return self.real.maxTransferRate;
}

- (BOOL)isDepth24Stencil8PixelFormatSupported API_AVAILABLE(macos(10.11), macCatalyst(13.0))
    API_UNAVAILABLE(ios)
{
  return GetWrapped(self)->isDepth24Stencil8PixelFormatSupported();
}

- (MTLReadWriteTextureTier)readWriteTextureSupport API_AVAILABLE(macos(10.13), ios(11.0))
{
  return (MTLReadWriteTextureTier)GetWrapped(self)->readWriteTextureSupport();
}

- (MTLArgumentBuffersTier)argumentBuffersSupport API_AVAILABLE(macos(10.13), ios(11.0))
{
  return (MTLArgumentBuffersTier)GetWrapped(self)->argumentBuffersSupport();
}

- (BOOL)areRasterOrderGroupsSupported API_AVAILABLE(macos(10.13), ios(11.0))
{
  return GetWrapped(self)->areRasterOrderGroupsSupported();
}

- (BOOL)supports32BitFloatFiltering API_AVAILABLE(macos(11.0), ios(14.0))
{
  return GetWrapped(self)->supports32BitFloatFiltering();
}

- (BOOL)supports32BitMSAA API_AVAILABLE(macos(11.0), ios(14.0))
{
  return GetWrapped(self)->supports32BitMSAA();
}

- (BOOL)supportsQueryTextureLOD API_AVAILABLE(macos(11.0), ios(14.0))
{
  return GetWrapped(self)->supportsQueryTextureLOD();
}

- (BOOL)supportsBCTextureCompression API_AVAILABLE(macos(11.0))
// It is available for ios in SDK 11.1 and it is marked as unavailable in SDK 12
#if __MAC_OS_X_VERSION_MAX_ALLOWED >= __MAC_12_0
    API_UNAVAILABLE(ios)
#endif    // #if __MAC_OS_X_VERSION_MAX_ALLOWED >= __MAC_12_0
{
  return GetWrapped(self)->supportsBCTextureCompression();
}

- (BOOL)supportsPullModelInterpolation API_AVAILABLE(macos(11.0), ios(14.0))
{
  return GetWrapped(self)->supportsPullModelInterpolation();
}
- (BOOL)areBarycentricCoordsSupported API_AVAILABLE(macos(10.15))API_UNAVAILABLE(ios)
{
  return GetWrapped(self)->areBarycentricCoordsSupported();
}

- (BOOL)supportsShaderBarycentricCoordinates API_AVAILABLE(macos(10.15))API_UNAVAILABLE(ios)
{
  return GetWrapped(self)->supportsShaderBarycentricCoordinates();
}

- (NSUInteger)currentAllocatedSize API_AVAILABLE(macos(10.13), ios(11.0))
{
  return self.real.currentAllocatedSize;
}

- (nullable id<MTLCommandQueue>)newCommandQueue
{
  return id<MTLCommandQueue>(GetWrapped(self)->newCommandQueue());
}

- (nullable id<MTLCommandQueue>)newCommandQueueWithMaxCommandBufferCount:(NSUInteger)maxCommandBufferCount
{
  METAL_NOT_HOOKED();
  return [self.real newCommandQueueWithMaxCommandBufferCount:maxCommandBufferCount];
}

- (MTLSizeAndAlign)heapTextureSizeAndAlignWithDescriptor:(MTLTextureDescriptor *)desc
    API_AVAILABLE(macos(10.13), ios(10.0))
{
  METAL_NOT_HOOKED();
  return [self.real heapTextureSizeAndAlignWithDescriptor:desc];
}

- (MTLSizeAndAlign)heapBufferSizeAndAlignWithLength:(NSUInteger)length
                                            options:(MTLResourceOptions)options
    API_AVAILABLE(macos(10.13), ios(10.0))
{
  METAL_NOT_HOOKED();
  return [self.real heapBufferSizeAndAlignWithLength:length options:options];
}

- (nullable id<MTLHeap>)newHeapWithDescriptor:(MTLHeapDescriptor *)descriptor
    API_AVAILABLE(macos(10.13), ios(10.0))
{
  METAL_NOT_HOOKED();
  return [self.real newHeapWithDescriptor:descriptor];
}

- (nullable id<MTLBuffer>)newBufferWithLength:(NSUInteger)length options:(MTLResourceOptions)options
{
  METAL_NOT_HOOKED();
  return [self.real newBufferWithLength:length options:options];
}

- (nullable id<MTLBuffer>)newBufferWithBytes:(const void *)pointer
                                      length:(NSUInteger)length
                                     options:(MTLResourceOptions)options
{
  METAL_NOT_HOOKED();
  return [self.real newBufferWithBytes:pointer length:length options:options];
}

- (nullable id<MTLBuffer>)newBufferWithBytesNoCopy:(void *)pointer
                                            length:(NSUInteger)length
                                           options:(MTLResourceOptions)options
                                       deallocator:(void (^__nullable)(void *pointer,
                                                                       NSUInteger length))deallocator
{
  METAL_NOT_HOOKED();
  return [self.real newBufferWithBytesNoCopy:pointer
                                      length:length
                                     options:options
                                 deallocator:deallocator];
}

- (nullable id<MTLDepthStencilState>)newDepthStencilStateWithDescriptor:
    (MTLDepthStencilDescriptor *)descriptor
{
  METAL_NOT_HOOKED();
  return [self.real newDepthStencilStateWithDescriptor:descriptor];
}

- (nullable id<MTLTexture>)newTextureWithDescriptor:(MTLTextureDescriptor *)descriptor
{
  return id<MTLTexture>(
      GetWrapped(self)->newTextureWithDescriptor((MTL::TextureDescriptor *)descriptor));
}

- (nullable id<MTLTexture>)newTextureWithDescriptor:(MTLTextureDescriptor *)descriptor
                                          iosurface:(IOSurfaceRef)iosurface
                                              plane:(NSUInteger)plane
    API_AVAILABLE(macos(10.11), ios(11.0))
{
  NS::String *nsString = (NS::String *)[[NSThread callStackSymbols] objectAtIndex:1];
  // Example parentCallsite string
  //"1 QuartzCore 0x00000001b956ece8 _ZL19get_unused_drawableP20_CAMetalLayerPrivatebb + 676"
  bool nextDrawable = false;
  if(nsString)
  {
    rdcstr parentCallsite(nsString->utf8String());
    nextDrawable = (parentCallsite.contains("CAMetalLayer") && parentCallsite.contains("drawable"));
  }

  if(nextDrawable)
  {
    return id<MTLTexture>(GetWrapped(self)->nextDrawableTexture(
        (MTL::TextureDescriptor *)descriptor, iosurface, plane));
  }
  return id<MTLTexture>(GetWrapped(self)->newTextureWithDescriptor(
      (MTL::TextureDescriptor *)descriptor, iosurface, plane));
}

- (nullable id<MTLTexture>)newSharedTextureWithDescriptor:(MTLTextureDescriptor *)descriptor
    API_AVAILABLE(macos(10.14), ios(13.0))
{
  METAL_NOT_HOOKED();
  return [self.real newSharedTextureWithDescriptor:descriptor];
}

- (nullable id<MTLTexture>)newSharedTextureWithHandle:(MTLSharedTextureHandle *)sharedHandle
    API_AVAILABLE(macos(10.14), ios(13.0))
{
  METAL_NOT_HOOKED();
  return [self.real newSharedTextureWithHandle:sharedHandle];
}

- (nullable id<MTLSamplerState>)newSamplerStateWithDescriptor:(MTLSamplerDescriptor *)descriptor
{
  METAL_NOT_HOOKED();
  return [self.real newSamplerStateWithDescriptor:descriptor];
}

- (nullable id<MTLLibrary>)newDefaultLibrary
{
  return id<MTLLibrary>(GetWrapped(self)->newDefaultLibrary());
}

- (nullable id<MTLLibrary>)newDefaultLibraryWithBundle:(NSBundle *)bundle
                                                 error:(__autoreleasing NSError **)error
    API_AVAILABLE(macos(10.12), ios(10.0))
{
  METAL_NOT_HOOKED();
  return [self.real newDefaultLibraryWithBundle:bundle error:error];
}

- (nullable id<MTLLibrary>)newLibraryWithFile:(NSString *)filepath
                                        error:(__autoreleasing NSError **)error
{
  METAL_NOT_HOOKED();
  return [self.real newLibraryWithFile:filepath error:error];
}

- (nullable id<MTLLibrary>)newLibraryWithURL:(NSURL *)url
                                       error:(__autoreleasing NSError **)error
    API_AVAILABLE(macos(10.13), ios(11.0))
{
  METAL_NOT_HOOKED();
  return [self.real newLibraryWithURL:url error:error];
}

- (nullable id<MTLLibrary>)newLibraryWithData:(dispatch_data_t)data
                                        error:(__autoreleasing NSError **)error
{
  METAL_NOT_HOOKED();
  return [self.real newLibraryWithData:data error:error];
}

- (nullable id<MTLLibrary>)newLibraryWithSource:(NSString *)source
                                        options:(nullable MTLCompileOptions *)options
                                          error:(__autoreleasing NSError **)error
{
  return (id<MTLLibrary>)(GetWrapped(self)->newLibraryWithSource(
      (NS::String *)source, (MTL::CompileOptions *)options, (NS::Error **)error));
}

- (void)newLibraryWithSource:(NSString *)source
                     options:(nullable MTLCompileOptions *)options
           completionHandler:(MTLNewLibraryCompletionHandler)completionHandler
{
  METAL_NOT_HOOKED();
  return
      [self.real newLibraryWithSource:source options:options completionHandler:completionHandler];
}

#if __MAC_OS_X_VERSION_MAX_ALLOWED >= __MAC_12_0
- (nullable id<MTLLibrary>)newLibraryWithStitchedDescriptor:(MTLStitchedLibraryDescriptor *)descriptor
                                                      error:(__autoreleasing NSError **)error
    API_AVAILABLE(macos(12.0), ios(15.0))
{
  METAL_NOT_HOOKED();
  return [self.real newLibraryWithStitchedDescriptor:descriptor error:error];
}
#endif

#if __MAC_OS_X_VERSION_MAX_ALLOWED >= __MAC_12_0
- (void)newLibraryWithStitchedDescriptor:(MTLStitchedLibraryDescriptor *)descriptor
                       completionHandler:(MTLNewLibraryCompletionHandler)completionHandler
    API_AVAILABLE(macos(12.0), ios(15.0))
{
  METAL_NOT_HOOKED();
  [self.real newLibraryWithStitchedDescriptor:descriptor completionHandler:completionHandler];
}
#endif

- (nullable id<MTLRenderPipelineState>)
newRenderPipelineStateWithDescriptor:(MTLRenderPipelineDescriptor *)descriptor
                               error:(__autoreleasing NSError **)error
{
  return id<MTLRenderPipelineState>(GetWrapped(self)->newRenderPipelineStateWithDescriptor(
      (MTL::RenderPipelineDescriptor *)descriptor, (NS::Error **)error));
}

- (nullable id<MTLRenderPipelineState>)
newRenderPipelineStateWithDescriptor:(MTLRenderPipelineDescriptor *)descriptor
                             options:(MTLPipelineOption)options
                          reflection:(MTLAutoreleasedRenderPipelineReflection *__nullable)reflection
                               error:(__autoreleasing NSError **)error
{
  METAL_NOT_HOOKED();
  return [self.real newRenderPipelineStateWithDescriptor:descriptor
                                                 options:options
                                              reflection:reflection
                                                   error:error];
}

- (void)newRenderPipelineStateWithDescriptor:(MTLRenderPipelineDescriptor *)descriptor
                           completionHandler:(MTLNewRenderPipelineStateCompletionHandler)completionHandler
{
  METAL_NOT_HOOKED();
  return [self.real newRenderPipelineStateWithDescriptor:descriptor
                                       completionHandler:completionHandler];
}

- (void)newRenderPipelineStateWithDescriptor:(MTLRenderPipelineDescriptor *)descriptor
                                     options:(MTLPipelineOption)options
                           completionHandler:
                               (MTLNewRenderPipelineStateWithReflectionCompletionHandler)completionHandler
{
  METAL_NOT_HOOKED();
  return [self.real newRenderPipelineStateWithDescriptor:descriptor
                                                 options:options
                                       completionHandler:completionHandler];
}

- (nullable id<MTLComputePipelineState>)
newComputePipelineStateWithFunction:(id<MTLFunction>)computeFunction
                              error:(__autoreleasing NSError **)error
{
  METAL_NOT_HOOKED();
  return [self.real newComputePipelineStateWithFunction:computeFunction error:error];
}

- (nullable id<MTLComputePipelineState>)
newComputePipelineStateWithFunction:(id<MTLFunction>)computeFunction
                            options:(MTLPipelineOption)options
                         reflection:(MTLAutoreleasedComputePipelineReflection *__nullable)reflection
                              error:(__autoreleasing NSError **)error
{
  METAL_NOT_HOOKED();
  return [self.real newComputePipelineStateWithFunction:computeFunction
                                                options:options
                                             reflection:reflection
                                                  error:error];
}

- (void)newComputePipelineStateWithFunction:(id<MTLFunction>)computeFunction
                          completionHandler:(MTLNewComputePipelineStateCompletionHandler)completionHandler
{
  METAL_NOT_HOOKED();
  return [self.real newComputePipelineStateWithFunction:computeFunction
                                      completionHandler:completionHandler];
}

- (void)newComputePipelineStateWithFunction:(id<MTLFunction>)computeFunction
                                    options:(MTLPipelineOption)options
                          completionHandler:
                              (MTLNewComputePipelineStateWithReflectionCompletionHandler)completionHandler
{
  METAL_NOT_HOOKED();
  return [self.real newComputePipelineStateWithFunction:computeFunction
                                                options:options
                                      completionHandler:completionHandler];
}

- (nullable id<MTLComputePipelineState>)
newComputePipelineStateWithDescriptor:(MTLComputePipelineDescriptor *)descriptor
                              options:(MTLPipelineOption)options
                           reflection:(MTLAutoreleasedComputePipelineReflection *__nullable)reflection
                                error:(__autoreleasing NSError **)error
    API_AVAILABLE(macos(10.11), ios(9.0))
{
  METAL_NOT_HOOKED();
  return [self.real newComputePipelineStateWithDescriptor:descriptor
                                                  options:options
                                               reflection:reflection
                                                    error:error];
}

- (void)newComputePipelineStateWithDescriptor:(MTLComputePipelineDescriptor *)descriptor
                                      options:(MTLPipelineOption)options
                            completionHandler:
                                (MTLNewComputePipelineStateWithReflectionCompletionHandler)completionHandler
    API_AVAILABLE(macos(10.11), ios(9.0))
{
  METAL_NOT_HOOKED();
  return [self.real newComputePipelineStateWithDescriptor:descriptor
                                                  options:options
                                        completionHandler:completionHandler];
}

- (nullable id<MTLFence>)newFence API_AVAILABLE(macos(10.13), ios(10.0))
{
  METAL_NOT_HOOKED();
  return [self.real newFence];
}

- (BOOL)supportsFeatureSet:(MTLFeatureSet)featureSet
{
  return GetWrapped(self)->supportsFeatureSet((MTL::FeatureSet)featureSet);
}

- (BOOL)supportsFamily:(MTLGPUFamily)gpuFamily API_AVAILABLE(macos(10.15), ios(13.0))
{
  return GetWrapped(self)->supportsFamily((MTL::GPUFamily)gpuFamily);
}

- (BOOL)supportsTextureSampleCount:(NSUInteger)sampleCount API_AVAILABLE(macos(10.11), ios(9.0))
{
  return GetWrapped(self)->supportsTextureSampleCount(sampleCount);
}

- (NSUInteger)minimumLinearTextureAlignmentForPixelFormat:(MTLPixelFormat)format
    API_AVAILABLE(macos(10.13), ios(11.0))
{
  METAL_NOT_HOOKED();
  return [self.real minimumLinearTextureAlignmentForPixelFormat:format];
}

- (NSUInteger)minimumTextureBufferAlignmentForPixelFormat:(MTLPixelFormat)format
    API_AVAILABLE(macos(10.14), ios(12.0))
{
  METAL_NOT_HOOKED();
  return [self.real minimumTextureBufferAlignmentForPixelFormat:format];
}

- (nullable id<MTLRenderPipelineState>)
newRenderPipelineStateWithTileDescriptor:(MTLTileRenderPipelineDescriptor *)descriptor
                                 options:(MTLPipelineOption)options
                              reflection:(MTLAutoreleasedRenderPipelineReflection *__nullable)reflection
                                   error:(__autoreleasing NSError **)error
    API_AVAILABLE(macos(11.0), macCatalyst(14.0), ios(11.0), tvos(14.5))
{
  METAL_NOT_HOOKED();
  return [self.real newRenderPipelineStateWithTileDescriptor:descriptor
                                                     options:options
                                                  reflection:reflection
                                                       error:error];
}

- (void)newRenderPipelineStateWithTileDescriptor:(MTLTileRenderPipelineDescriptor *)descriptor
                                         options:(MTLPipelineOption)options
                               completionHandler:
                                   (MTLNewRenderPipelineStateWithReflectionCompletionHandler)completionHandler
    API_AVAILABLE(macos(11.0), macCatalyst(14.0), ios(11.0), tvos(14.5))
{
  METAL_NOT_HOOKED();
  return [self.real newRenderPipelineStateWithTileDescriptor:descriptor
                                                     options:options
                                           completionHandler:completionHandler];
}

- (NSUInteger)maxThreadgroupMemoryLength API_AVAILABLE(macos(10.13), ios(11.0))
{
  return self.real.maxThreadgroupMemoryLength;
}

- (NSUInteger)maxArgumentBufferSamplerCount API_AVAILABLE(macos(10.14), ios(12.0))
{
  return self.real.maxArgumentBufferSamplerCount;
}

- (BOOL)areProgrammableSamplePositionsSupported API_AVAILABLE(macos(10.13), ios(11.0))
{
  return GetWrapped(self)->areProgrammableSamplePositionsSupported();
}

- (void)getDefaultSamplePositions:(MTLSamplePosition *)positions
                            count:(NSUInteger)count API_AVAILABLE(macos(10.13), ios(11.0))
{
  METAL_NOT_HOOKED();
  return [self.real getDefaultSamplePositions:positions count:count];
}

- (nullable id<MTLArgumentEncoder>)newArgumentEncoderWithArguments:
    (NSArray<MTLArgumentDescriptor *> *)arguments API_AVAILABLE(macos(10.13), ios(11.0))
{
  METAL_NOT_HOOKED();
  return [self.real newArgumentEncoderWithArguments:arguments];
}

- (BOOL)supportsRasterizationRateMapWithLayerCount:(NSUInteger)layerCount
    API_AVAILABLE(macos(10.15.4), ios(13.0), macCatalyst(13.4))
{
  return GetWrapped(self)->supportsRasterizationRateMapWithLayerCount(layerCount);
}

- (nullable id<MTLRasterizationRateMap>)newRasterizationRateMapWithDescriptor:
    (MTLRasterizationRateMapDescriptor *)descriptor
    API_AVAILABLE(macos(10.15.4), ios(13.0), macCatalyst(13.4))
{
  METAL_NOT_HOOKED();
  return [self.real newRasterizationRateMapWithDescriptor:descriptor];
}

- (nullable id<MTLIndirectCommandBuffer>)
newIndirectCommandBufferWithDescriptor:(MTLIndirectCommandBufferDescriptor *)descriptor
                       maxCommandCount:(NSUInteger)maxCount
                               options:(MTLResourceOptions)options
    API_AVAILABLE(macos(10.14), ios(12.0))
{
  METAL_NOT_HOOKED();
  return [self.real newIndirectCommandBufferWithDescriptor:descriptor
                                           maxCommandCount:maxCount
                                                   options:options];
}

- (nullable id<MTLEvent>)newEvent API_AVAILABLE(macos(10.14), ios(12.0))
{
  METAL_NOT_HOOKED();
  return [self.real newEvent];
}

- (nullable id<MTLSharedEvent>)newSharedEvent API_AVAILABLE(macos(10.14), ios(12.0))
{
  METAL_NOT_HOOKED();
  return [self.real newSharedEvent];
}

- (nullable id<MTLSharedEvent>)newSharedEventWithHandle:(MTLSharedEventHandle *)sharedEventHandle
    API_AVAILABLE(macos(10.14), ios(12.0))
{
  METAL_NOT_HOOKED();
  return [self.real newSharedEventWithHandle:sharedEventHandle];
}

- (uint64_t)peerGroupID API_AVAILABLE(macos(10.15))API_UNAVAILABLE(ios)
{
  return self.real.peerGroupID;
}

- (uint32_t)peerIndex API_AVAILABLE(macos(10.15))API_UNAVAILABLE(ios)
{
  return self.real.peerIndex;
}

- (uint32_t)peerCount API_AVAILABLE(macos(10.15))API_UNAVAILABLE(ios)
{
  return self.real.peerCount;
}

- (MTLSize)sparseTileSizeWithTextureType:(MTLTextureType)textureType
                             pixelFormat:(MTLPixelFormat)pixelFormat
                             sampleCount:(NSUInteger)sampleCount
    API_AVAILABLE(macos(11.0), macCatalyst(14.0), ios(13.0))
{
  METAL_NOT_HOOKED();
  return [self.real sparseTileSizeWithTextureType:textureType
                                      pixelFormat:pixelFormat
                                      sampleCount:sampleCount];
}

- (NSUInteger)sparseTileSizeInBytes API_AVAILABLE(macos(11.0), macCatalyst(14.0), ios(13.0))
{
  return self.real.sparseTileSizeInBytes;
}

- (void)convertSparsePixelRegions:(const MTLRegion[_Nonnull])pixelRegions
                    toTileRegions:(MTLRegion[_Nonnull])tileRegions
                     withTileSize:(MTLSize)tileSize
                    alignmentMode:(MTLSparseTextureRegionAlignmentMode)mode
                       numRegions:(NSUInteger)numRegions
    API_AVAILABLE(macos(11.0), macCatalyst(14.0), ios(13.0))
{
  METAL_NOT_HOOKED();
  return [self.real convertSparsePixelRegions:pixelRegions
                                toTileRegions:tileRegions
                                 withTileSize:tileSize
                                alignmentMode:mode
                                   numRegions:numRegions];
}

- (void)convertSparseTileRegions:(const MTLRegion[_Nonnull])tileRegions
                  toPixelRegions:(MTLRegion[_Nonnull])pixelRegions
                    withTileSize:(MTLSize)tileSize
                      numRegions:(NSUInteger)numRegions
    API_AVAILABLE(macos(11.0), macCatalyst(14.0), ios(13.0))
{
  METAL_NOT_HOOKED();
  return [self.real convertSparseTileRegions:tileRegions
                              toPixelRegions:pixelRegions
                                withTileSize:tileSize
                                  numRegions:numRegions];
}

- (NSUInteger)maxBufferLength API_AVAILABLE(macos(10.14), ios(12.0))
{
  return self.real.maxBufferLength;
}

- (NSArray<id<MTLCounterSet>> *)counterSets API_AVAILABLE(macos(10.15), ios(14.0))
{
  return self.real.counterSets;
}

- (nullable id<MTLCounterSampleBuffer>)newCounterSampleBufferWithDescriptor:
                                           (MTLCounterSampleBufferDescriptor *)descriptor
                                                                      error:(NSError **)error
    API_AVAILABLE(macos(10.15), ios(14.0))
{
  METAL_NOT_HOOKED();
  return [self.real newCounterSampleBufferWithDescriptor:descriptor error:error];
}

- (void)sampleTimestamps:(MTLTimestamp *)cpuTimestamp
            gpuTimestamp:(MTLTimestamp *)gpuTimestamp API_AVAILABLE(macos(10.15), ios(14.0))
{
  METAL_NOT_HOOKED();
  return [self.real sampleTimestamps:cpuTimestamp gpuTimestamp:gpuTimestamp];
}

- (BOOL)supportsCounterSampling:(MTLCounterSamplingPoint)samplingPoint
    API_AVAILABLE(macos(11.0), ios(14.0))
{
  return GetWrapped(self)->supportsCounterSampling((MTL::CounterSamplingPoint)samplingPoint);
}

- (BOOL)supportsVertexAmplificationCount:(NSUInteger)count
    API_AVAILABLE(macos(10.15.4), ios(13.0), macCatalyst(13.4))
{
  return GetWrapped(self)->supportsVertexAmplificationCount(count);
}

- (BOOL)supportsDynamicLibraries API_AVAILABLE(macos(11.0), ios(14.0))
{
  return GetWrapped(self)->supportsDynamicLibraries();
}

#if __MAC_OS_X_VERSION_MAX_ALLOWED >= __MAC_12_0
- (BOOL)supportsRenderDynamicLibraries API_AVAILABLE(macos(12.0), ios(15.0))
{
  return GetWrapped(self)->supportsRenderDynamicLibraries();
}
#endif

- (nullable id<MTLDynamicLibrary>)newDynamicLibrary:(id<MTLLibrary>)library
                                              error:(NSError **)error
    API_AVAILABLE(macos(11.0), ios(14.0))
{
  METAL_NOT_HOOKED();
  return [self.real newDynamicLibrary:library error:error];
}

- (nullable id<MTLDynamicLibrary>)newDynamicLibraryWithURL:(NSURL *)url
                                                     error:(NSError **)error
    API_AVAILABLE(macos(11.0), ios(14.0))
{
  METAL_NOT_HOOKED();
  return [self.real newDynamicLibraryWithURL:url error:error];
}

- (nullable id<MTLBinaryArchive>)newBinaryArchiveWithDescriptor:(MTLBinaryArchiveDescriptor *)descriptor
                                                          error:(NSError **)error
    API_AVAILABLE(macos(11.0), ios(14.0))
{
  METAL_NOT_HOOKED();
  return [self.real newBinaryArchiveWithDescriptor:descriptor error:error];
}

- (BOOL)supportsRaytracing API_AVAILABLE(macos(11.0), ios(14.0))
{
  return GetWrapped(self)->supportsRaytracing();
}

- (MTLAccelerationStructureSizes)accelerationStructureSizesWithDescriptor:
    (MTLAccelerationStructureDescriptor *)descriptor API_AVAILABLE(macos(11.0), ios(14.0))
{
  METAL_NOT_HOOKED();
  return [self.real accelerationStructureSizesWithDescriptor:descriptor];
}

- (nullable id<MTLAccelerationStructure>)newAccelerationStructureWithSize:(NSUInteger)size
    API_AVAILABLE(macos(11.0), ios(14.0))
{
  METAL_NOT_HOOKED();
  return [self.real newAccelerationStructureWithSize:size];
}

- (nullable id<MTLAccelerationStructure>)newAccelerationStructureWithDescriptor:
    (MTLAccelerationStructureDescriptor *)descriptor API_AVAILABLE(macos(11.0), ios(14.0))
{
  METAL_NOT_HOOKED();
  return [self.real newAccelerationStructureWithDescriptor:descriptor];
}

- (BOOL)supportsFunctionPointers API_AVAILABLE(macos(11.0), ios(14.0))
{
  return GetWrapped(self)->supportsFunctionPointers();
}

#if __MAC_OS_X_VERSION_MAX_ALLOWED >= __MAC_12_0
- (BOOL)supportsFunctionPointersFromRender API_AVAILABLE(macos(12.0), ios(15.0))
{
  return GetWrapped(self)->supportsFunctionPointersFromRender();
}
#endif

#if __MAC_OS_X_VERSION_MAX_ALLOWED >= __MAC_12_0
- (BOOL)supportsRaytracingFromRender API_AVAILABLE(macos(12.0), ios(15.0))
{
  return GetWrapped(self)->supportsRaytracingFromRender();
}
#endif

// Treat as if the API is available from SDK 12.0
// It is marked as available from SDK 11.0, however it was not present in SDK 11.1 MTLDevice.h
#if __MAC_OS_X_VERSION_MAX_ALLOWED >= __MAC_12_0
- (BOOL)supportsPrimitiveMotionBlur API_AVAILABLE(macos(11.0), ios(14.0))
{
  return GetWrapped(self)->supportsPrimitiveMotionBlur();
}
#endif

@end
