#include <metal_stdlib>
using namespace metal;
#include <SceneKit/scn_metal>


struct VertexInSCNTechnique
{
  float4 position [[ attribute(SCNVertexSemanticPosition) ]];
};


struct ColorInOutSCNTechnique
{
  float4 position [[ position ]];
  float2 uv;
};


vertex ColorInOutSCNTechnique vertexShaderSCNTechnique(VertexInSCNTechnique in [[ stage_in ]])
{
  ColorInOutSCNTechnique out;
  out.position = in.position;
  out.uv = float2((in.position.x + 1.0) * 0.5 , (in.position.y + 1.0) * -0.5);
  return out;
}


fragment float4 fragmentShaderSCNTechnique(ColorInOutSCNTechnique in [[ stage_in ]],
                                           texture2d<float, access::sample> colorSampler [[texture(0)]])
{
  constexpr sampler s = sampler(coord::normalized, filter::linear, address::repeat);
  float4 color = colorSampler.sample(s, in.uv);
  return float4(color.r, 0, 0, 0.5);
}
