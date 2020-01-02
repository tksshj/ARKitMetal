#include <metal_stdlib>
using namespace metal;
#include <SceneKit/scn_metal>


struct VertexInTransformsSCNProgram {
  float4x4 modelViewProjectionTransform;
  float4x4 modelViewTransform;
  float4x4 projectionTransform;
};


struct VertexInSCNProgram
{
  float4 position [[ attribute(SCNVertexSemanticPosition) ]];
};


struct ColorInOutSCNProgram
{
  float4 position [[ position ]];
  float2 uv;
};


vertex ColorInOutSCNProgram vertexShaderSCNProgram(VertexInSCNProgram in [[ stage_in ]],
                                                   constant SCNSceneBuffer& scn_frame [[ buffer(0) ]],
                                                   constant VertexInTransformsSCNProgram& scn_node [[ buffer(1) ]],
                                                   constant float4x4& displayTransform [[ buffer(2) ]])
{
  ColorInOutSCNProgram out;
  out.position = scn_node.modelViewProjectionTransform * float4(in.position.xyz, 1.0);

  // Transform the vertex to the camera coordinate system.
  float4 vertexCamera = scn_node.modelViewTransform * in.position;

  // Camera projection and perspective divide to get normalized viewport coordinates (clip space).
  float4 vertexClipSpace = scn_frame.projectionTransform * vertexCamera;
  vertexClipSpace /= vertexClipSpace.w;

  // XY in clip space is [-1,1]x[-1,1], so adjust to UV texture coordinates: [0,1]x[0,1].
  // Image coordinates are Y-flipped (upper-left origin).
  float4 vertexImageSpace = float4(vertexClipSpace.xy * 0.5 + 0.5, 0.0, 1.0);
  vertexImageSpace.y = 1.0 - vertexImageSpace.y;

  // Apply ARKit's display transform (device orientation * front-facing camera flip).
  float4 transformedVertex = displayTransform * vertexImageSpace;

  // Output as texture coordinates for use in later rendering stages.
  out.uv = transformedVertex.xy;

  return out;
}


fragment float4 fragmentShaderSCNProgram(ColorInOutSCNProgram in [[ stage_in ]],
                                         texture2d<float, access::sample> colorSampler [[ texture(0) ]])
{
  constexpr sampler s = sampler(coord::normalized, filter::linear, address::repeat);
  float4 color = colorSampler.sample(s, in.uv);
  return float4(1.0, color.g, color.b, 1.0);
}
