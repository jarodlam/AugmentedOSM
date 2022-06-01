// Copyright Epic Games, Inc. All Rights Reserved.

#include "OSMPluginBPLibrary.h"
#include "OSMPlugin.h"

#include "CompGeom/PolygonTriangulation.h"

UOSMPluginBPLibrary::UOSMPluginBPLibrary(const FObjectInitializer& ObjectInitializer)
: Super(ObjectInitializer)
{

}

void UOSMPluginBPLibrary::TriangulateSimplePolygon
(
    const TArray<FVector>& VertexPositions,
    TArray<int>& OutTriangles
)
{
    if (VertexPositions.Num() < 3) {
        return;
    }
    
    // Convert to internal non-Blueprint types
    TArray<FVector3<float>> VertexPositionsInternal;
    for (auto v : VertexPositions) {
        VertexPositionsInternal.Add(v);
    }
    TArray<FIndex3i> OutTrianglesInternal = TArray<FIndex3i>();
    
	PolygonTriangulation::TriangulateSimplePolygon(VertexPositionsInternal, OutTrianglesInternal);
    
    // Convert triangles to flat array compatible with Procedural Mesh
    for (auto t : OutTrianglesInternal) {
        OutTriangles.Add(t.A);
        OutTriangles.Add(t.B);
        OutTriangles.Add(t.C);
    }
}
