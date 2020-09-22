###############################################################################
#
# Beta functions to make soil moisture correction
#
###############################################################################
"""
    abstract type AbstractBetaFunction{FT}

Hierachy of AbstractBetaFunction:
- [`AbstractBetaG`](@ref)
  - [`BetaGLinearPleaf`](@ref)
  - [`BetaGLinearPsoil`](@ref)
  - [`BetaGLinearSWC`](@ref)
- [`AbstractBetaV`](@ref)
  - [`BetaVLinearPleaf`](@ref)
  - [`BetaVLinearPsoil`](@ref)
  - [`BetaVLinearSWC`](@ref)
"""
abstract type AbstractBetaFunction{FT} end








###############################################################################
#
# Beta functions to correct g1 for empirical models
#
###############################################################################
"""
    abstract type AbstractBetaG{FT}

Hierachy of AbstractBetaG:
- [`BetaGLinearPleaf`](@ref)
- [`BetaGLinearPsoil`](@ref)
- [`BetaGLinearSWC`](@ref)
"""
abstract type AbstractBetaG{FT} <: AbstractBetaFunction{FT} end




"""
    mutable struct BetaGLinearPleaf{FT}

Linear β function for g1 based on soil water potential.

# Fields
$(DocStringExtensions.FIELDS)
"""
Base.@kwdef mutable struct BetaGLinearPleaf{FT} <: AbstractBetaG{FT}
    "Upper bound of Pleaf `[MPa]`"
    p_max::FT = 0
    "Lower bound of Pleaf `[MPa]`"
    p_min::FT = -5
end




"""
    mutable struct BetaGLinearPsoil{FT}

Linear β function for g1 based on soil water potential.

# Fields
$(DocStringExtensions.FIELDS)
"""
Base.@kwdef mutable struct BetaGLinearPsoil{FT} <: AbstractBetaG{FT}
    "Upper bound of Psoil `[MPa]`"
    p_max::FT = 0
    "Lower bound of Psoil `[MPa]`"
    p_min::FT = -5
end




"""
    mutable struct BetaGLinearSWC{FT}

Linear β function for g1 based on soil water content.

# Fields
$(DocStringExtensions.FIELDS)
"""
Base.@kwdef mutable struct BetaGLinearSWC{FT} <: AbstractBetaG{FT}
    "Upper bound of SWC"
    swc_max::FT = 1
    "Lower bound of SWC"
    swc_min::FT = 0
end








###############################################################################
#
# Beta functions to correct Vcmax for empirical models
#
###############################################################################
"""
    abstract type AbstractBetaV{FT}

Hierachy of AbstractBetaV:
- [`BetaVLinearPleaf`](@ref)
- [`BetaVLinearPsoil`](@ref)
- [`BetaVLinearSWC`](@ref)
"""
abstract type AbstractBetaV{FT} <: AbstractBetaFunction{FT} end




"""
    mutable struct BetaVLinearPleaf{FT}

Linear β function for g1 based on soil water potential.

# Fields
$(DocStringExtensions.FIELDS)
"""
Base.@kwdef mutable struct BetaVLinearPleaf{FT} <: AbstractBetaG{FT}
    "Upper bound of Pleaf `[MPa]`"
    p_max::FT = 0
    "Lower bound of Pleaf `[MPa]`"
    p_min::FT = -5
end




"""
    mutable struct BetaVLinearPsoil{FT}

Linear β function for Vcmax based on soil water potential.

# Fields
$(DocStringExtensions.FIELDS)
"""
Base.@kwdef mutable struct BetaVLinearPsoil{FT} <: AbstractBetaV{FT}
    "Upper bound of Psoil `[MPa]`"
    p_max::FT = 0
    "Lower bound of Psoil `[MPa]`"
    p_min::FT = -5
end




"""
    mutable struct BetaVLinearSWC{FT}

Linear β function for Vcmax based on soil water content.

# Fields
$(DocStringExtensions.FIELDS)
"""
Base.@kwdef mutable struct BetaVLinearSWC{FT} <: AbstractBetaV{FT}
    "Upper bound of SWC"
    swc_max::FT = 1
    "Lower bound of SWC"
    swc_min::FT = 0
end
