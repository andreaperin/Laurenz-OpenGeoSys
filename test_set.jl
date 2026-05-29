using JLD2
using DataFrames

include("extractor.jl")

df = DataFrame(
    thermal_conductivity_sandstone1=[2.286459605275977],
    specific_heat_capacity_sandstone1=[792.7236713275739],
    density_sandstone1=[2667.6594030051397], thermal_conductivity_sandstone2=[2.1552203952847067],
    specific_heat_capacity_sandstone2=[936.2550026827848],
    density_sandstone2=[2719.5697877726166], thermal_conductivity_sandstone3=[2.4649599802529543],
    specific_heat_capacity_sandstone3=[896.7924155437291],
    density_sandstone3=[2591.413381902884], sandstone_porosity_parameter_2=[0.18489244081546352],
    sandstone_porosity_parameter_3=[0.1913774806539648],
    sandstone_porosity_parameter_4=[0.2257264481985051], kappa_Sandstone_2=[2.552076752070744e-13],
    kappa_Sandstone_3=[2.587366186617377e-13],
    kappa_Sandstone_4=[2.78403985198814e-13]
)

push!(df, (
    thermal_conductivity_sandstone1=2.4614974769462745,
    specific_heat_capacity_sandstone1=971.8127401496853,
    density_sandstone1=2786.120039723157, thermal_conductivity_sandstone2=2.398027660221882,
    specific_heat_capacity_sandstone2=741.9191444450385,
    density_sandstone2=2530.719588562591, thermal_conductivity_sandstone3=2.133517473721366,
    specific_heat_capacity_sandstone3=689.0355694099836,
    density_sandstone3=2693.6514477574674, sandstone_porosity_parameter_2=0.20633686293489073,
    sandstone_porosity_parameter_3=0.2148838357472227,
    sandstone_porosity_parameter_4=0.197391167177972, kappa_Sandstone_2=2.0205766204791188e-13,
    kappa_Sandstone_3=2.2528852171907585e-13,
    kappa_Sandstone_4=2.2131671975211137e-13
))

push!(df, (
    thermal_conductivity_sandstone1=2.3420156620250756,
    specific_heat_capacity_sandstone1=689.5073972644033,
    density_sandstone1=2601.098924400676, thermal_conductivity_sandstone2=2.2873948897516567,
    specific_heat_capacity_sandstone2=800.4550927710399,
    density_sandstone2=2649.657912249373, thermal_conductivity_sandstone3=2.4412768195782117,
    specific_heat_capacity_sandstone3=809.7928686040984,
    density_sandstone3=2749.949864286079, sandstone_porosity_parameter_2=0.21911595255693406,
    sandstone_porosity_parameter_3=0.2211665645788002,
    sandstone_porosity_parameter_4=0.18553287461922363, kappa_Sandstone_2=2.7462012402821784e-13,
    kappa_Sandstone_3=2.7474199840225964e-13,
    kappa_Sandstone_4=1.9239504048997774e-13
))

push!(df, (
    thermal_conductivity_sandstone1=2.090603907798708,
    specific_heat_capacity_sandstone1=858.1587436675655,
    density_sandstone1=2721.9365877400314, thermal_conductivity_sandstone2=2.574764927093988,
    specific_heat_capacity_sandstone2=845.5299575142011,
    density_sandstone2=2755.9358628604336, thermal_conductivity_sandstone3=2.217314264629966,
    specific_heat_capacity_sandstone3=855.685341406243,
    density_sandstone3=2646.0099222167796, sandstone_porosity_parameter_2=0.19637972618791041,
    sandstone_porosity_parameter_3=0.19732033756906914,
    sandstone_porosity_parameter_4=0.21567223431918853, kappa_Sandstone_2=2.2037858506628137e-13,
    kappa_Sandstone_3=2.0990368051173666e-13,
    kappa_Sandstone_4=2.5868270401894335e-13
))

push!(df, (
    thermal_conductivity_sandstone1=2.003133805849668,
    specific_heat_capacity_sandstone1=823.7139247785533,
    density_sandstone1=2553.7025365897152, thermal_conductivity_sandstone2=2.187558511690412,
    specific_heat_capacity_sandstone2=829.9133098885949,
    density_sandstone2=2629.1880147651254, thermal_conductivity_sandstone3=2.031937819390536,
    specific_heat_capacity_sandstone3=978.3449275168372,
    density_sandstone3=2773.5337424447716, sandstone_porosity_parameter_2=0.21547375476618705,
    sandstone_porosity_parameter_3=0.22712473694417717,
    sandstone_porosity_parameter_4=0.2093305193450573, kappa_Sandstone_2=2.6832246407120026e-13,
    kappa_Sandstone_3=2.297605279885305e-13,
    kappa_Sandstone_4=2.466043021437259e-13
))

push!(df, (
    thermal_conductivity_sandstone1=2.4445183110828053,
    specific_heat_capacity_sandstone1=730.0579678099405,
    density_sandstone1=2692.5163665705904, thermal_conductivity_sandstone2=2.5110062750136297,
    specific_heat_capacity_sandstone2=777.6450992625525,
    density_sandstone2=2770.2631934160518, thermal_conductivity_sandstone3=2.566266925994194,
    specific_heat_capacity_sandstone3=737.0341162471856,
    density_sandstone3=2640.7976575402986, sandstone_porosity_parameter_2=0.1894761512277045,
    sandstone_porosity_parameter_3=0.20406856112458918,
    sandstone_porosity_parameter_4=0.18970975365897347, kappa_Sandstone_2=2.2627605218975778e-13,
    kappa_Sandstone_3=2.423476638255279e-13,
    kappa_Sandstone_4=2.070790855515955e-13
))

push!(df, (
    thermal_conductivity_sandstone1=2.262728730107809,
    specific_heat_capacity_sandstone1=893.5741028245724,
    density_sandstone1=2669.0141647113894, thermal_conductivity_sandstone2=2.185921833405494,
    specific_heat_capacity_sandstone2=752.1401160683457,
    density_sandstone2=2758.8416936351325, thermal_conductivity_sandstone3=2.504833004377818,
    specific_heat_capacity_sandstone3=819.6113918377216,
    density_sandstone3=2573.908620420543, sandstone_porosity_parameter_2=0.20813579325891826,
    sandstone_porosity_parameter_3=0.1927310874306057,
    sandstone_porosity_parameter_4=0.21742271378420542, kappa_Sandstone_2=2.4910318884411007e-13,
    kappa_Sandstone_3=1.964051186549452e-13,
    kappa_Sandstone_4=2.3651609573407833e-13
))

push!(df, (
    thermal_conductivity_sandstone1=2.147685563187786,
    specific_heat_capacity_sandstone1=768.5088877470416,
    density_sandstone1=2527.936341884993, thermal_conductivity_sandstone2=2.537194652132395,
    specific_heat_capacity_sandstone2=921.9921494548327,
    density_sandstone2=2688.6014527929955, thermal_conductivity_sandstone3=2.406159961311073,
    specific_heat_capacity_sandstone3=734.0588049320832,
    density_sandstone3=2764.991165381422, sandstone_porosity_parameter_2=0.19681723365851486,
    sandstone_porosity_parameter_3=0.2235790135710638,
    sandstone_porosity_parameter_4=0.20124477674173152, kappa_Sandstone_2=2.0793774869268167e-13,
    kappa_Sandstone_3=2.7627278247536734e-13,
    kappa_Sandstone_4=2.6591054591666147e-13
))

push!(df, (
    thermal_conductivity_sandstone1=2.1840012701524,
    specific_heat_capacity_sandstone1=759.3751462631035,
    density_sandstone1=2480.7699440747615, thermal_conductivity_sandstone2=2.300271615250866,
    specific_heat_capacity_sandstone2=766.6832841048882,
    density_sandstone2=2628.6981646136387, thermal_conductivity_sandstone3=2.297743036907626,
    specific_heat_capacity_sandstone3=866.3604001975112,
    density_sandstone3=2778.141715097675, sandstone_porosity_parameter_2=0.19441594803117146,
    sandstone_porosity_parameter_3=0.20595371501182516,
    sandstone_porosity_parameter_4=0.2272651127088028, kappa_Sandstone_2=2.3214123942170143e-13,
    kappa_Sandstone_3=1.9834931089821734e-13,
    kappa_Sandstone_4=2.040600614098712e-13
))

push!(df, (
    thermal_conductivity_sandstone1=2.560378653286427,
    specific_heat_capacity_sandstone1=842.2831011651448,
    density_sandstone1=2682.5937915937025, thermal_conductivity_sandstone2=2.5494152230966924,
    specific_heat_capacity_sandstone2=967.1365063980571,
    density_sandstone2=2786.1136065550168, thermal_conductivity_sandstone3=2.3366415141677175,
    specific_heat_capacity_sandstone3=800.0821218251912,
    density_sandstone3=2620.564509555452, sandstone_porosity_parameter_2=0.21679754637322257,
    sandstone_porosity_parameter_3=0.18095480991385984,
    sandstone_porosity_parameter_4=0.19890122460914517, kappa_Sandstone_2=2.6230277329337245e-13,
    kappa_Sandstone_3=2.856754842083746e-13,
    kappa_Sandstone_4=2.611274793080368e-13
))

push!(df, (
    thermal_conductivity_sandstone1=2.4019885845244144,
    specific_heat_capacity_sandstone1=806.2710708323209,
    density_sandstone1=2624.6831179667424, thermal_conductivity_sandstone2=2.078356386988414,
    specific_heat_capacity_sandstone2=864.6138346889915,
    density_sandstone2=2697.334283478795, thermal_conductivity_sandstone3=1.9620057867522473,
    specific_heat_capacity_sandstone3=729.1359074862056,
    density_sandstone3=2506.427263317171, sandstone_porosity_parameter_2=0.20420778030731596,
    sandstone_porosity_parameter_3=0.1993663724137789,
    sandstone_porosity_parameter_4=0.1834963022621791, kappa_Sandstone_2=2.1376969730477724e-13,
    kappa_Sandstone_3=2.3668929901329346e-13,
    kappa_Sandstone_4=2.845815094266072e-13
))

push!(df, (
    thermal_conductivity_sandstone1=1.9073242323840955,
    specific_heat_capacity_sandstone1=884.1751516198611,
    density_sandstone1=2732.178207718153, thermal_conductivity_sandstone2=2.4509424338916195,
    specific_heat_capacity_sandstone2=808.7416944659944,
    density_sandstone2=2575.8166700320944, thermal_conductivity_sandstone3=2.589742841078733,
    specific_heat_capacity_sandstone3=875.1976490290313,
    density_sandstone3=2727.214532077869, sandstone_porosity_parameter_2=0.18290986680604446,
    sandstone_porosity_parameter_3=0.22489757487625878,
    sandstone_porosity_parameter_4=0.21435018159228747, kappa_Sandstone_2=2.4322663940920206e-13,
    kappa_Sandstone_3=2.477880344724946e-13,
    kappa_Sandstone_4=2.2716800915031e-13
))


const x_extractor = 2_250.0
const y_extractor = 0.0

const Δz_bottom = (-1374.8, -1364.6)
const Δz_middle = (-1338.0, -1309.1)
const Δz_top = (-1265.4, -1240.2)

const Δz_extractor = [
    Δz_bottom,
    Δz_middle,
    Δz_top
]

samples = [
    "output/Model_ML_IRZ/2026-05-23-13-29-28/sample-001",
    "output/Model_ML_IRZ/2026-05-23-13-29-28/sample-002",
    "output/Model_ML_IRZ/2026-05-23-13-29-28/sample-003",
    "output/Model_ML_IRZ/2026-05-23-13-29-28/sample-004",
    "output/Model_ML_IRZ/2026-05-23-13-29-28/sample-005",
    "output/Model_ML_IRZ/2026-05-23-13-29-28/sample-006",
    "output/Model_ML_IRZ/2026-05-23-13-29-28/sample-007",
    "output/Model_ML_IRZ/2026-05-23-13-29-28/sample-008",
    "output/Model_ML_IRZ/2026-05-23-13-29-28/sample-009",
    "output/Model_ML_IRZ/2026-05-23-13-29-28/sample-010",
    "output/Model_ML_IRZ/2026-05-23-13-29-28/sample-011",
    "output/Model_ML_IRZ/2026-05-23-13-29-28/sample-012"
]

ext_ts_s = []
for s in samples
    push!(ext_ts_s, extraction_temperatures_over_time(s, x_extractor, y_extractor, Δz_extractor))
end

df.extraction_temperatures = ext_ts_s

function flow_percentage(kappa_bottom::Real, kappa_middle::Real, kappa_top::Real, Δz_bottom::Tuple, Δz_middle::Tuple, Δz_top::Tuple)
    kappas = [kappa_bottom, kappa_middle, kappa_top]
    thicknesses = [abs(a - b) for (a, b) in [Δz_bottom, Δz_middle, Δz_top]]
    flows = kappas .* thicknesses
    return flows ./ sum(flows)
end
df.flows = flow_percentage.(df.kappa_Sandstone_4, df.kappa_Sandstone_3, df.kappa_Sandstone_2, Ref(Δz_bottom), Ref(Δz_middle), Ref(Δz_top))

function final_temperature(extraction_temperatures::Vector{Vector{Float64}}, flows::Vector{Float64})
    return [[sum(v[1:3] .* flows), v[4]] for v in extraction_temperatures]
end
df.final_T = final_temperature.(df.extraction_temperatures, df.flows)

function crossing_year(final_temperature_data::Vector{Vector{Float64}})
    T = first.(final_temperature_data)
    t = last.(final_temperature_data)

    T0 = T[1]
    target = T0 - 1

    idx = findfirst(T .<= target)
    if idx === nothing || idx == 1
        return t[end]
    end
    # points around the crossing
    t1, t2 = t[idx-1], t[idx]
    T1, T2 = T[idx-1], T[idx]

    # linear interpolation
    return t1 + (target - T1) * (t2 - t1) / (T2 - T1)
end
df.crossing_year = crossing_year.(df.final_T)

n = size(df)[1]

@save joinpath("Tests", "test_" * string(n) * ".jld2") df