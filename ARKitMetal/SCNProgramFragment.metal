#include <metal_stdlib>
using namespace metal;
#include <SceneKit/scn_metal>


struct VertexInTransformsSCNProgramFragment {
  float4x4 modelViewProjectionTransform;
  float4x4 modelViewTransform;
  float4x4 projectionTransform;
};


struct VertexInSCNProgramFragment
{
  float4 position [[ attribute(SCNVertexSemanticPosition) ]];
  float2 texcoord [[ attribute(SCNVertexSemanticTexcoord0) ]];
};


struct ColorInOutSCNProgramFragment
{
  float4 position [[ position ]];
  float2 uv;
  uint vid;
};


vertex
ColorInOutSCNProgramFragment vertexShaderSCNProgramFragment(VertexInSCNProgramFragment in [[ stage_in ]],
                                                            constant SCNSceneBuffer& scn_frame [[ buffer(0) ]],
                                                            constant VertexInTransformsSCNProgramFragment& scn_node [[ buffer(1) ]],
                                                            constant float4x4& displayTransform [[ buffer(2) ]],
                                                            uint vid [[ vertex_id ]])
{
  ColorInOutSCNProgramFragment out;
  out.position = scn_node.modelViewProjectionTransform * float4(in.position.xyz, 1.0);
  out.position = float4(out.position.x + 0.2, out.position.y, out.position.z, out.position.w);

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

  out.vid = vid;
  return out;
}


fragment float4 fragmentShaderSCNProgramFragment(ColorInOutSCNProgramFragment in [[ stage_in ]],
                                                 texture2d<float, access::sample> colorSampler [[ texture(0) ]])
{
  constexpr sampler s = sampler(coord::normalized, filter::linear, address::repeat);
  float4 color = colorSampler.sample(s, in.uv);

  if (in.vid % 3 == 0) {
    return float4(1.0, color.g, color.b, 0.0);
  }
  return float4(color.r, color.g, color.b, 1.0);
}
