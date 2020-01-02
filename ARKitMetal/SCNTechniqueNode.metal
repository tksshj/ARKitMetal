#include <metal_stdlib>
using namespace metal;
#include <SceneKit/scn_metal>

struct VertexInTransformsSCNTechniqueNode {
  float4x4 modelViewProjectionTransform;
};


struct VertexInSCNTechniqueNode
{
  float4 position [[ attribute(SCNVertexSemanticPosition) ]];
};


struct ColorInOutSCNTechniqueNode
{
  float4 position [[ position ]];
};


vertex ColorInOutSCNTechniqueNode vertexShaderSCNTechniqueNode(VertexInSCNTechniqueNode in [[stage_in]],
                                                               constant VertexInTransformsSCNTechniqueNode& scn_node [[ buffer(0) ]])
{
  ColorInOutSCNTechniqueNode out;
  out.position = scn_node.modelViewProjectionTransform * float4(in.position.xyz, 1.0);
  return out;
}


fragment float4 fragmentShaderSCNTechniqueNode(ColorInOutSCNTechniqueNode in [[ stage_in ]],
                                               texture2d<float, access::sample> colorSampler [[ texture(0) ]])
{
  return float4(1.0, 0, 0, 1.0);
}
