###############################################################################
#
# Stomatal model scheme types
#
###############################################################################
#= EmpiricalStomatalModel type tree
AbstractStomatalModel
---> EmpiricalStomatalModel
    ---> ESMBallBerry    # use RH
    ---> ESMGentine      # use k_leaf
    ---> ESMLeuning      # Use VPD
    ---> ESMMedlyn       # use VPD
---> OptimizationStomatalModel
    ---> OSMEller        # Eller 2018 Model
    ---> OSMSperry       # Sperry 2017 model
    ---> OSMWang         # Wang 2020 model
    ---> OSMWAP          # Wolf-Anderegg-Pacala model
    ---> OSMWAP          # Modified Wolf-Anderegg-Pacala model
=#
"""
    type AbstractStomatalModel

Hierarchy of the `AbstractStomatalModel`:
- [`EmpiricalStomatalModel`](@ref)
- [`OptimizationStomatalModel`](@ref)
"""
abstract type AbstractStomatalModel{FT} end




"""
    type EmpiricalStomatalModel

Hierarchy of the `EmpiricalStomatalModel`:
- [`ESMBallBerry`](@ref)
- [`ESMGentine`](@ref)
- [`ESMLeuning`](@ref)
- [`ESMMedlyn`](@ref)
"""
abstract type EmpiricalStomatalModel{FT} <: AbstractStomatalModel{FT} end




"""
    struct ESMBallBerry{FT}

An empirical model parameter set type for Ball-Berry type model.
The equation used for Ball-Berry type model is
```math
gs = g0 + g1 ⋅ RH ⋅ \\dfrac{A}{Cs}
```

# Fields
$(DocStringExtensions.FIELDS)
"""
Base.@kwdef mutable struct ESMBallBerry{FT<:AbstractFloat} <: EmpiricalStomatalModel{FT}
    "minimal stomatal conductance g0 `[mol m⁻² s⁻¹]`"
    g0::FT = FT(0.025)
    "slope of conductance-photosynthesis correlation `[unitless]`"
    g1::FT = FT(9.0  )
end




"""
    struct ESMGentine{FT}

An empirical model parameter set type for Gentine type model.
The equation used for Gentine type model is
```math
gs = g0 + g1 ⋅ \\dfrac{k_{leaf}}{k_{max}} ⋅ \\dfrac{A}{Ca}.
```
Note it that the Gentine model does not require for a `β` function to tune the
    soil drought response, but the use of `k_leaf` also does not permit
    post-drought stomatal response unless `k_leaf` can be recovered.

# Fields
$(DocStringExtensions.FIELDS)
"""
Base.@kwdef mutable struct ESMGentine{FT<:AbstractFloat} <: EmpiricalStomatalModel{FT}
    "minimal stomatal conductance g0 `[mol m⁻² s⁻¹]`"
    g0::FT = FT(0.025)
    "slope of conductance-photosynthesis correlation `[unitless]`"
    g1::FT = FT(9.0  )
end




"""
    struct ESMLeuning{FT}

An empirical model parameter set type for Leuning type model.
The equation used for Leuning type model is
```math
gs = g0 + g1 ⋅ \\dfrac{A}{Cs - Γ^{*}} ⋅ \\dfrac{1}{1 + \\dfrac{VPD}{d0}}
```

# Fields
$(DocStringExtensions.FIELDS)
"""
Base.@kwdef mutable struct ESMLeuning{FT<:AbstractFloat} <: EmpiricalStomatalModel{FT}
    "minimal stomatal conductance g0 `[mol m⁻² s⁻¹]`"
    g0::FT = FT(0.025 )
    "slope of conductance-photosynthesis correlation `[unitless]`"
    g1::FT = FT(8.0   )
    "fitting parameter of d/d0 below the fraction, same unit as vpd `[Pa]`"
    d0::FT = FT(3000.0)
end




"""
    struct ESMMedlyn{FT}

An empirical model parameter set type for Medlyn type model.
The equation used in Medlyn type model is
```
gs = g0 + (1 + \\dfrac{g1}{\\sqrt{VPD}} ⋅ \\dfrac{A}{Ca}
```

# Fields
$(DocStringExtensions.FIELDS)
"""
Base.@kwdef mutable struct ESMMedlyn{FT<:AbstractFloat} <: EmpiricalStomatalModel{FT}
    "minimal stomatal conductance g0 `[mol m⁻² s⁻¹]`"
    g0::FT = FT(0.025)
    "slope of conductance-photosynthesis correlation `[Pa⁽⁵⁾]`"
    g1::FT = FT(125.0)
end




"""
    type OptimizationStomatalModel

Hierarchy of the `OptimizationStomatalModel`:
- [`OSMEller`](@ref)
- [`OSMSperry`](@ref)
- [`OSMWang`](@ref)
- [`OSMWAP`](@ref)
- [`OSMWAPMod`](@ref)
"""
abstract type OptimizationStomatalModel{FT} <: AbstractStomatalModel{FT} end




"""
    struct OSMEller

An optimization model parameter set type for Eller model.
The equation used for Eller model is
```math
\\dfrac{∂Θ}{∂E} = -\\dfrac{∂K}{∂E} ⋅ \\dfrac{A}{K}
```
where K is ``\\dfrac{∂E}{∂P}``.

# Fields
$(DocStringExtensions.FIELDS)
"""
struct OSMEller{FT} <: OptimizationStomatalModel{FT} end




"""
    struct OSMSperry

An optimization model parameter set type for Sperry model.
The equation used for Sperry model is
```math
\\dfrac{∂Θ}{∂E} = -\\dfrac{∂K}{∂E} ⋅ \\dfrac{A_{max}}{K_{max}}
```
where K is ``\\dfrac{∂E}{∂P}``.

# Fields
$(DocStringExtensions.FIELDS)
"""
struct OSMSperry{FT} <: OptimizationStomatalModel{FT} end




"""
    struct OSMWang

An optimization model parameter set type for Eller type model.
The equation used for Wang model is
```math
\\dfrac{∂Θ}{∂E} = \\dfrac{A}{E_{crit} - E}
```

# Fields
$(DocStringExtensions.FIELDS)
"""
struct OSMWang{FT} <: OptimizationStomatalModel{FT} end




"""
    struct OSMWAP{FT}

An optimization model parameter set type for Wolf-Anderegg-Pacala type model.
The equation used for Wolf-Anderegg-Pacala model is
```math
\\dfrac{∂Θ}{∂E} = \\dfrac{2aP + b}{K}
```
where K is ∂P/∂E.

# Fields
$(DocStringExtensions.FIELDS)
"""
Base.@kwdef mutable struct OSMWAP{FT<:AbstractFloat} <: OptimizationStomatalModel{FT}
    "Quadratic equation parameter `[μmol m⁻² s⁻¹ MPa⁻²]`"
    a::FT = FT(0.5)
    "Quadratic equation parameter `[μmol m⁻² s⁻¹ MPa⁻¹]`"
    b::FT = FT(2.0)
end




"""
    struct OSMWAPMod{FT}

An optimization model parameter set type for Wolf-Anderegg-Pacala type model,
    modified by adding a photosynthesis component while set b and c = 0.
The equation used for modified Wolf-Anderegg-Pacala model is
```math
\\dfrac{∂Θ}{∂E} = \\dfrac{aAP}{K}
```
where P is absolute value of leaf xylem pressure.

# Fields
$(DocStringExtensions.FIELDS)
"""
Base.@kwdef mutable struct OSMWAPMod{FT<:AbstractFloat} <: OptimizationStomatalModel{FT}
    "Quadratic equation parameter `[mol mol⁻¹ MPa⁻¹]`"
    a::FT = FT(0.1)
end








###############################################################################
#
# Leaves parameters container
#
###############################################################################
"""
    struct Leaves{FT}

Struct to store leaf information (multi-dimensional).

# Fields
$(DocStringExtensions.FIELDS)
"""
Base.@kwdef mutable struct Leaves{FT<:AbstractFloat}
    # Leaves photosynthesis system
    "leaf photosynthesis system"
    ps ::Leaf{FT} = Leaf{FT}()
    "Total leaf area `[m²]`"
    LA ::FT = FT(150)
    "Total leaf area index"
    LAI::FT = FT(3)

    # Number of Leaves per canopy layer
    n_leaf::Int = 325

    # Temperature related, different for each leaf
    "Sensible Heat Flux `[W m⁻²]`"
    H ::Array{FT,1} = zeros(FT, n_leaf)
    "Latent Heat Flux `[W m⁻²]`"
    LE::Array{FT,1} = zeros(FT, n_leaf)
    "Net Radiation Balance `[W m⁻²]`"
    Rn::Array{FT,1} = zeros(FT, n_leaf)

    # Tempearture related, same for all leaves
    "Latent Heat of evaporation `[J mol⁻¹]`"
    LV   ::FT = latent_heat_vapor(K_25) * 1000 / MOLMASS_WATER
    "Temperature `[K]`"
    T    ::FT = FT(K_25)
    "Old temperature `[K]`"
    T_old::FT = FT(0)
    "Leaf width `[m]`"
    width::FT = FT(0.05)

    # Photosynthesis system, different for each leaf
    "NPQ rate constant (initially zero)"
    Kn     ::Array{FT,1} = zeros(FT, n_leaf)
    "Rate constant for photochemistry (all reaction centers open)"
    Kp     ::Array{FT,1} = zeros(FT, n_leaf) .+ 4

    # Photosynthesis system, same for all leaves
    "Rate constant for thermal dissipation"
    Kd       ::FT = FT(0.85)
    "Rate constant for fluorescence (const)"
    Kf       ::FT = FT(0.05)
    "Maximal rate constant for photochemistry (all reaction centers open)"
    Kpmax    ::FT = FT(4)
    "max PSII yield (Kn=0, all RC open)"
    maxPSII  ::FT = Kpmax / (Kpmax + Kf +Kd)
    "Fraction of absorbed light used by PSII ETR"
    PSII_frac::FT = FT(0.5)

    # Diffusive conductances, same for all leaves
    "Boundary layer conductance to CO₂ `[mol m⁻² s⁻¹]`"
    g_bc::Array{FT,1} = zeros(FT, n_leaf) .+ FT(3/1.35)
    "Boundary layer conductance to heat `[mol m⁻² s⁻¹]`"
    g_bh::Array{FT,1} = zeros(FT, n_leaf) .+ FT(3)
    "Boundary layer conductance to H₂O `[mol m⁻² s⁻¹]`"
    g_bw::Array{FT,1} = zeros(FT, n_leaf) .+ FT(3)
    "Leaf diffusive conductance to water CO₂ `[mol m⁻² s⁻¹]`"
    g_lc::Array{FT,1} = zeros(FT, n_leaf) .+ FT(0.08032)
    "Leaf diffusive conductance to water H₂O `[mol m⁻² s⁻¹]`"
    g_lw::Array{FT,1} = zeros(FT, n_leaf) .+ FT(0.1519)
    "Mesophyll conductance for CO₂ `[mol m⁻² s⁻¹]`"
    g_m ::Array{FT,1} = zeros(FT, n_leaf) .+ FT(0.5)
    "Stomatal conductance to water CO₂ `[mol m⁻² s⁻¹]`"
    g_sc::Array{FT,1} = zeros(FT, n_leaf) .+ FT(0.1)
    "Stomatal conductance to water H₂O `[mol m⁻² s⁻¹]`"
    g_sw::Array{FT,1} = zeros(FT, n_leaf) .+ FT(0.16)

    # Diffusive conductances, same for all leaves
    "Gias correction constant"
    g_ias_c::FT = FT(0)
    "Gias correction exponent"
    g_ias_e::FT = FT(0.3)
    "Maximal leaf diffusive conductance `[mol m⁻² s⁻¹]`"
    g_max  ::FT = FT(0.8)
    "Maximal leaf diffusive conductance at 298.15 K `[mol m⁻² s⁻¹]`"
    g_max25::FT = FT(0.8)
    "Minimal leaf diffusive conductance `[mol m⁻² s⁻¹]`"
    g_min  ::FT = FT(0.025)
    "Minimal leaf diffusive conductance at 298.15 K `[mol m⁻² s⁻¹]`"
    g_min25::FT = FT(0.025)

    # CO₂ and H₂O pressures, different for each leaf
    "Leaf internal CO₂ partial pressure `[Pa]`"
    p_i::Array{FT,1} = zeros(FT, n_leaf) .+ FT(10)
    "Leaf surface CO₂ partial pressure `[Pa]`"
    p_s::Array{FT,1} = zeros(FT, n_leaf) .+ FT(40)

    # CO₂ and H₂O pressures, same for all leaves
    "Leaf saturation vapor pressure `[Pa]`"
    p_sat::FT = saturation_vapor_pressure(T)

    # Photosynthesis related, different for each leaf
    "RubisCO limited photosynthetic rate `[μmol m⁻² s⁻¹]`"
    Ac   ::Array{FT,1} = zeros(FT, n_leaf)
    "Light limited photosynthetic rate `[μmol m⁻² s⁻¹]`"
    Aj   ::Array{FT,1} = zeros(FT, n_leaf)
    "Gross photosynthetic rate `[μmol m⁻² s⁻¹]`"
    Ag   ::Array{FT,1} = zeros(FT, n_leaf)
    "Net photosynthetic rate `[μmol m⁻² s⁻¹]`"
    An   ::Array{FT,1} = zeros(FT, n_leaf)
    "Product limited photosynthetic rate `[μmol m⁻² s⁻¹]`"
    Ap   ::Array{FT,1} = zeros(FT, n_leaf)
    "Electron transport `[μmol m⁻² s⁻¹]`"
    J    ::Array{FT,1} = zeros(FT, n_leaf)
    "Potential Electron Transport Rate `[μmol m⁻² s⁻¹]`"
    J_pot::Array{FT,1} = zeros(FT, n_leaf)

    # Photosynthesis related, same for all leaves
    "Maximal electron transport rate `[μmol m⁻² s⁻¹]`"
    Jmax   ::FT = FT(120)
    "Maximal electron transport rate at 298.15 K `[μmol m⁻² s⁻¹]`"
    Jmax25 ::FT = FT(120)
    "RubisCO coefficient Kc `[Pa]`"
    Kc     ::FT = FT(0)
    "RubisCO coefficient Ko `[Pa]`"
    Ko     ::FT = FT(0)
    "PEP coefficient Ko `[Pa]`"
    Kpep   ::FT = FT(0)
    "Michaelis-Menten's coefficient `[Pa]`"
    Km     ::FT = FT(0)
    "Respiration rate `[μmol m⁻² s⁻¹]`"
    Rd     ::FT = FT(1)
    "Respiration rate at 298.15 K `[μmol m⁻² s⁻¹]`"
    Rd25   ::FT = FT(1)
    "Maximal carboxylation rate `[μmol m⁻² s⁻¹]`"
    Vcmax  ::FT = FT(60)
    "Maximal carboxylation rate at 298.15 K `[μmol m⁻² s⁻¹]`"
    Vcmax25::FT = FT(60)
    "Maximal PEP carboxylation rate `[μmol m⁻² s⁻¹]`"
    Vpmax  ::FT = FT(120)
    "Maximal PEP carboxylation rate at 298.15 K `[μmol m⁻² s⁻¹]`"
    Vpmax25::FT = FT(120)
    "CO₂ compensation point with the absence of Rd `[Pa]`"
    Γ_star ::FT = FT(0)

    # Fluorescence related, different for each leaf
    "Total efficiency, incl. photorespiration `[mol CO₂ mol⁻¹ e-]`"
    CO₂_per_electron::Array{FT,1} = zeros(FT, n_leaf) .+ FT(1/6)
    "light adapted yield (`Kp=0`)"
    Fm′             ::Array{FT,1} = zeros(FT, n_leaf)
    "light-adapted fluorescence yield in the dark (`Kp=max`)"
    Fo′             ::Array{FT,1} = zeros(FT, n_leaf)
    "Actual electron transport rate `[μmol m⁻² s⁻¹]`"
    Ja              ::Array{FT,1} = zeros(FT, n_leaf)
    "Non-Photochemical quenching "
    NPQ             ::Array{FT,1} = zeros(FT, n_leaf)
    "Photochemical quenching"
    qQ              ::Array{FT,1} = zeros(FT, n_leaf)
    "energy quenching"
    qE              ::Array{FT,1} = zeros(FT, n_leaf)
    "PSII yield"
    φ               ::Array{FT,1} = zeros(FT, n_leaf)
    "Steady-state (light-adapted) yield (aka Fs)"
    ϕs              ::Array{FT,1} = zeros(FT, n_leaf)

    # Fluorescence related, same for all leaves
    "dark adapted yield (`Kp=0`)"
    Fm::FT = FT(0)
    "dark-adapted fluorescence yield (`Kp=max`)"
    Fo::FT = FT(0)

    # Environment related, different for each leaf
    "Absorbed photosynthetic active radiation `[μmol m⁻² s⁻¹]`"
    APAR::Array{FT,1} = zeros(FT, n_leaf) .+ 100
    "Leaf area fractions"
    LAIx::Array{FT,1} = ones(FT, n_leaf) ./ n_leaf;

    # Stomtal optimization related, different for each leaf
    "Maximal photosynthetic rate `[μmol m⁻² s⁻¹]`"
    a_max::Array{FT,1} = zeros(FT, n_leaf)
    "Flow rate `[mol m⁻² s⁻¹]`"
    e    ::Array{FT,1} = zeros(FT, n_leaf)

    # Stomtal optimization related, same for all leaves
    "Critical flow rate `[mol m⁻² s⁻¹]`"
    ec    ::FT = FT(2e-9)
    "Maximal hydraulic conductance ratio"
    kr_max::FT = FT(1)
    "Base xylem pressre `[MPa]`"
    p_ups ::FT = FT(0)
    "Base xylem pressre memory `[MPa]`"
    p_old ::FT = FT(1)
end
