using Pkg

if Sys.islinux()
    ENV["PYTHON"] = "/home/lau/python_venv/bin/python"
elseif Sys.iswindows()
    ENV["PYTHON"] = "C:/Users/username/anaconda3/python.exe"
elseif Sys.isapple()
    ENV["PYTHON"] = "/Users/andreaperin_macos/Documents/Code/5_OpenGeoSys/.venv/bin/python"
else
    # ENV["PYTHON"] = "" # Default: try system Python or let PyCall auto-detect
end

# Pkg.build("PyCall")

using PyCall
using Statistics

function extract_all_extraction_temperatures(output_path::String, x::Float64, y::Float64, Δz::Vector{Float64})
    vtu_files = filter(f -> endswith(f, "000.vtu"), readdir(output_path))
    pv = pyimport("pyvista")

    first_mesh = pv.read(joinpath(output_path, vtu_files[1]))
    points_coords = first_mesh.points
    mask = map(row -> row[1] == x && row[2] == y && Δz[1] ≤ row[3] ≤ Δz[2], eachrow(points_coords))

    results = map(vtu_file -> _average_extraction_temperature(joinpath(output_path, vtu_file), pv, mask), vtu_files)

    results_sorted = sort(results, by=x -> x[2])
    return results_sorted
end


function _average_extraction_temperature(outputfile::String, pv, mask)
    mesh = pv.read(outputfile)
    T_data = mesh.point_data.get_array("T")

    Ts_extraction = T_data[mask]
    time_regex = r"t_(\d+(?:\.\d+)?)\.vtu"

    m = match(time_regex, outputfile)
    number_str = m.captures[1]
    number = parse(Float64, number_str)
    Δyear = number / 365 / 24 / 60 / 60
    return [mean(Ts_extraction), Δyear]
end