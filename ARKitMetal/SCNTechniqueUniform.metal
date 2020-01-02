#include <metal_stdlib>
using namespace metal;
#include <SceneKit/scn_metal>


struct UniformSCNTechniqueUniform
{
  float red;
};


struct VertexInSCNTechniqueUniform
{
  float4 position [[attribute(SCNVertexSemanticPosition)]];
};


struct ColorInOutSCNTechniqueUniform
{
  float4 position [[ position ]];
  float2 uv;
};


vertex ColorInOutSCNTechniqueUniform vertexShaderSCNTechniqueUniform(VertexInSCNTechniqueUniform in [[ stage_in ]])
{
  ColorInOutSCNTechniqueUniform out;
  out.position = in.position;
  out.uv = float2((in.position.x + 1.0) * 0.5 , (in.position.y + 1.0) * -0.5);
  return out;
}


fragment float4 fragmentShaderSCNTechniqueUniform(ColorInOutSCNTechniqueUniform in [[ stage_in ]],
                                                  texture2d<float, access::sample> colorSampler   [[ texture(0) ]],
                                                  constant UniformSCNTechniqueUniform& uniformIn [[ buffer(0) ]])
{
  constexpr sampler s = sampler(coord::normalized, filter::linear, address::repeat);
  float4 color = colorSampler.sample(s, in.uv);
  return float4(uniformIn.red, color.g, color.b, 1.0);
}
