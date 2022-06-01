using LightOSM
using JSON3

OUTFILE = "DT_MelbourneBuildings.json"
ORIGIN_LON = 144.9582818378044
ORIGIN_LAT = -37.81788823877398
SCALE_LON = 890000   # centimetres per degree
SCALE_LAT = 1110000  # centimetres per degree
SCALE_HEIGHT = 100    # centimetres per metre

function transform_coords(lon, lat)
    return Dict(
        "X" => Int64(round((lon - ORIGIN_LON) * SCALE_LON)),
        "Y" => Int64(round((lat - ORIGIN_LAT) * SCALE_LAT))
    )
end

# buildings_data = download_osm_buildings(
#     :place_name,
#     place_name="melbourne, australia",
#     save_to_file_location="melbourne_buildings.osm"
# )
# buildings = buildings_from_object(buildings_data)
buildings = buildings_from_file("melbourne_buildings.osm")

json_out = [
    Dict(
        "Name" => string(id),
        "Footprint" => [transform_coords(node.location.lon, node.location.lat) for node in b.polygons[1].nodes],
        "Height" => b.tags["height"] * SCALE_HEIGHT,
        "Label" => string(get(b.tags, "name", ""))
    ) for (id, b) in buildings
]

open(OUTFILE, "w") do io
    JSON3.write(io, json_out)
end