using Pkg

if Sys.islinux()
    osrelease = "/etc/os-release"
    data = read(osrelease, String)
    if occursin("Solus", data)
        ENV["PYTHON"] = "/home/perin/Documents/projects/work/code/thermoptiplan_new/.venv/bin/python"
    elseif occursin("NixOS", data)
        ENV["PYTHON"] = "/home/lau/python_venv/bin/python"
    end
end

Pkg.build("PyCall")

using PyCall
using Statistics
pv = pyimport("pyvista")

function _average_extraction_temperature(outputfile::String, mask)
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

function extraction_temperatures_over_time(output_path::String, x::Float64, y::Float64, Δz::Vector{Tuple{Float64,Float64}}; tol_xy::Real=0.5)
    vtu_files = filter(f -> endswith(f, "000.vtu"), readdir(output_path))

    first_mesh = pv.read(joinpath(output_path, vtu_files[1]))
    points_coords = first_mesh.points

    # build masks for each layer
    masks = [
        map(row -> abs(row[1] - x) < tol_xy &&
                       abs(row[2] - y) < tol_xy &&
                       zmin ≤ row[3] ≤ zmax,
            eachrow(points_coords))
        for (zmin, zmax) in Δz
    ]
    results = map(vtu_file -> begin
            mesh = pv.read(joinpath(output_path, vtu_file))
            T_data = mesh.point_data.get_array("T")

            # compute mean T for each layer
            T_means = [mean(T_data[mask]) for mask in masks]

            # extract time
            time_regex = r"t_(\d+(?:\.\d+)?)\.vtu"
            m = match(time_regex, vtu_file)
            number = parse(Float64, m.captures[1])
            Δyear = number / 365 / 24 / 60 / 60

            return vcat(T_means, Δyear)
        end, vtu_files)

    return sort(results, by=x -> x[end])
end