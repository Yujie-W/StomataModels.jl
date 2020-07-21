###############################################################################
#
# Diff function to minimize by ConstrainedRootSolvers
#
###############################################################################
"""
    envir_diff!(
            x::FT,
            photo_set::AbstractPhotoModelParaSet,
            leaves::Leaves{FT},
            hs::LeafHydraulics{FT},
            envir::AirLayer{FT},
            sm::AbstractStomatalModel,
            ind::Int)

Calculate the difference to be minimized for a given
- `x` Assumed leaf diffusive conductance
- `photo_set`[`C3ParaSet`] or [`C4ParaSet`] type parameter set
- `leaves`[`Leaves`](@ref) type struct
- `hs` Leaf hydraulic system
- `envir`[`AirLayer`] type struct
- `sm` Stomatal model option (photo_set.Sto)
- `int` Nth leaf in Leaves
"""
function envir_diff!(
            x::FT,
            photo_set::AbstractPhotoModelParaSet,
            leaves::Leaves{FT},
            envir::AirLayer{FT},
            hs::LeafHydraulics{FT},
            sm::ESMGentine{FT},
            ind::Int
            ) where {FT<:AbstractFloat}
    # unpack variables
    @unpack p_sat, ps = leaves;
    @unpack p_atm, p_H₂O = envir;
    g_bc  = leaves.g_bc[ind];
    g_bw  = leaves.g_bw[ind];
    g_m   = leaves.g_m[ind];

    # update photosynthesis for ps
    ps.g_lc = x;
    leaf_photo_from_glc!(photo_set, ps, envir);

    # calculate flow rate and β
    g_sc = 1 / max( 1/x - 1/g_m - 1/g_bc, FT(1.6e-3) );
    g_sw = g_sc * FT(1.6);
    g_lw = 1 / (1/g_sw + 1/g_bw);
    e_lf = g_lw * (p_sat - p_H₂O) / p_atm;
    k_lf = leaf_xylem_risk(hs, e_lf);

    # calculate g_sw from stomatal model
    g_md = empirical_gsw_from_model(sm, ps, envir, k_lf);
    g_md = min(leaves.g_max, g_md);

    # calculate model predicted g_lc
    g_lm = 1 / (FT(1.6)/g_md + 1/g_bc + 1/g_m);

    return g_lm - x
end

function envir_diff!(
            x::FT,
            photo_set::AbstractPhotoModelParaSet,
            leaves::Leaves{FT},
            hs::LeafHydraulics{FT},
            envir::AirLayer{FT},
            sm::EmpiricalStomatalModel,
            ind::Int
            ) where {FT<:AbstractFloat}
    # unpack variables
    @unpack ps = leaves;
    g_bc  = leaves.g_bc[ind];
    g_m   = leaves.g_m[ind];

    # update photosynthesis for ps
    ps.g_lc = x;
    leaf_photo_from_glc!(photo_set, ps, envir);

    # calculate g_sw from stomatal model
    g_md = empirical_gsw_from_model(sm, ps, envir, FT(1));
    g_md = min(leaves.g_max, g_md);

    # calculate model predicted g_lc
    g_lm = 1 / (FT(1.6)/g_md + 1/g_bc + 1/g_m);

    return g_lm - x
end

function envir_diff!(
            x::FT,
            photo_set::AbstractPhotoModelParaSet,
            leaves::Leaves{FT},
            hs::LeafHydraulics{FT},
            envir::AirLayer{FT},
            sm::OSMEller,
            ind::Int
            ) where {FT<:AbstractFloat}
    # unpack variables
    @unpack g_max, g_min, p_sat, ps = leaves;
    @unpack p_atm, p_H₂O = envir;
    g_bc = leaves.g_bc[ind];
    g_bw = leaves.g_bw[ind];
    g_m  = leaves.g_m[ind];

    # calculate the limit of g_lc to ensure x in the physiological range
    _glh = 1 / (1/g_bc + FT(1.6)/g_max + 1/g_m);
    _gll = 1 / (1/g_bc + FT(1.6)/g_min + 1/g_m);

    if x > _glh
        x = _glh + FT(1e-4);
        leaves.g_sw[ind] = 2 * g_max;

        return FT(0)
    elseif x< _gll
        x = _gll - FT(1e-4);
        leaves.g_sw[ind] = FT(0);

        return FT(0)
    else
        # update photosynthesis from x-FT(1e-3)
        g_lc = x - FT(1e-3);
        ps.g_lc = g_lc;
        leaf_photo_from_glc!(photo_set, ps, envir);

        g_sc = 1 / ( 1/g_lc - 1/g_m - 1/g_bc );
        g_sw = g_sc * FT(1.6);
        g_lw = 1 / (1/g_sw + 1/g_bw);
        a_1  = ps.An;
        e_1  = g_lw * (p_sat - p_H₂O) / p_atm;
        k_1  = leaf_xylem_risk(hs, e_1);

        # update photosynthesis from x
        g_lc = x;
        ps.g_lc = g_lc;
        leaf_photo_from_glc!(photo_set, ps, envir);

        g_sc = 1 / ( 1/g_lc - 1/g_m - 1/g_bc );
        g_sw = g_sc * FT(1.6);
        g_lw = 1 / (1/g_sw + 1/g_bw);
        a_2  = ps.An;
        e_2  = g_lw * (p_sat - p_H₂O) / p_atm;
        k_2  = leaf_xylem_risk(hs, e_2);

        ∂A∂E = (a_2 - a_1) / (e_2 - e_1);
        ∂Θ∂E = (k_1 - k_2) / (e_2 - e_1) * a_2 / k_2;
        diff = ∂A∂E - ∂Θ∂E;

        #= used for debugging
        @show x;
        @show ∂A∂E;
        @show ∂Θ∂E;
        println("");
        #sleep(0.1);
        # =#

        return diff
    end
end

function envir_diff!(
            x::FT,
            photo_set::AbstractPhotoModelParaSet,
            leaves::Leaves{FT},
            hs::LeafHydraulics{FT},
            envir::AirLayer{FT},
            sm::OSMSperry,
            ind::Int
            ) where {FT<:AbstractFloat}
    # unpack variables
    @unpack g_max, g_min, kr_max, p_sat, ps = leaves;
    @unpack p_atm, p_H₂O = envir;
    a_max = leaves.a_max[ind];
    g_bc  = leaves.g_bc[ind];
    g_bw  = leaves.g_bw[ind];
    g_m   = leaves.g_m[ind];

    # calculate the limit of g_lc to ensure x in the physiological range
    _glh = 1 / (1/g_bc + FT(1.6)/g_max + 1/g_m);
    _gll = 1 / (1/g_bc + FT(1.6)/g_min + 1/g_m);

    if x > _glh
        x = _glh + FT(1e-4);
        leaves.g_sw[ind] = 2 * g_max;

        return FT(0)
    elseif x< _gll
        x = _gll - FT(1e-4);
        leaves.g_sw[ind] = FT(0);

        return FT(0)
    else
        # update photosynthesis from x-FT(1e-3)
        g_lc = x - FT(1e-3);
        ps.g_lc = g_lc;
        leaf_photo_from_glc!(photo_set, ps, envir);

        g_sc = 1 / ( 1/g_lc - 1/g_m - 1/g_bc );
        g_sw = g_sc * FT(1.6);
        g_lw = 1 / (1/g_sw + 1/g_bw);
        a_1  = ps.An;
        e_1  = g_lw * (p_sat - p_H₂O) / p_atm;
        k_1  = leaf_xylem_risk(hs, e_1);

        # update photosynthesis from x
        g_lc = x;
        ps.g_lc = g_lc;
        leaf_photo_from_glc!(photo_set, ps, envir);

        g_sc = 1 / ( 1/g_lc - 1/g_m - 1/g_bc );
        g_sw = g_sc * FT(1.6);
        g_lw = 1 / (1/g_sw + 1/g_bw);
        a_2  = ps.An;
        e_2  = g_lw * (p_sat - p_H₂O) / p_atm;
        k_2  = leaf_xylem_risk(hs, e_2);

        ∂A∂E = (a_2 - a_1) / (e_2 - e_1);
        ∂Θ∂E = (k_1 - k_2) / (e_2 - e_1) * a_max / kr_max;
        diff = ∂A∂E - ∂Θ∂E;

        #= used for debugging
        @show x;
        @show ∂A∂E;
        @show ∂Θ∂E;
        println("");
        #sleep(0.1);
        # =#

        return diff
    end
end

function envir_diff!(
            x::FT,
            photo_set::AbstractPhotoModelParaSet,
            leaves::Leaves{FT},
            hs::LeafHydraulics{FT},
            envir::AirLayer{FT},
            sm::OSMWang,
            ind::Int
            ) where {FT<:AbstractFloat}
    # unpack variables
    @unpack ec, g_max, g_min, p_sat, ps = leaves;
    @unpack p_atm, p_H₂O = envir;
    g_bc  = leaves.g_bc[ind];
    g_bw  = leaves.g_bw[ind];
    g_m   = leaves.g_m[ind];

    # calculate the limit of g_lc to ensure x in the physiological range
    _glh = 1 / (1/g_bc + FT(1.6)/g_max + 1/g_m);
    _gll = 1 / (1/g_bc + FT(1.6)/g_min + 1/g_m);

    if x > _glh
        x = _glh + FT(1e-4);
        leaves.g_sw[ind] = 2 * g_max;

        return FT(0)
    elseif x< _gll
        x = _gll - FT(1e-4);
        leaves.g_sw[ind] = FT(0);

        return FT(0)
    else
        # update photosynthesis from x-FT(1e-3)
        g_lc = x - FT(1e-3);
        ps.g_lc = g_lc;
        leaf_photo_from_glc!(photo_set, ps, envir);

        g_sc = 1 / ( 1/g_lc - 1/g_m - 1/g_bc );
        g_sw = g_sc * FT(1.6);
        g_lw = 1 / (1/g_sw + 1/g_bw);
        a_1  = ps.An;
        e_1  = g_lw * (p_sat - p_H₂O) / p_atm;

        # update photosynthesis from x
        g_lc = x;
        ps.g_lc = g_lc;
        leaf_photo_from_glc!(photo_set, ps, envir);

        g_sc = 1 / ( 1/g_lc - 1/g_m - 1/g_bc );
        g_sw = g_sc * FT(1.6);
        g_lw = 1 / (1/g_sw + 1/g_bw);
        a_2  = ps.An;
        e_2  = g_lw * (p_sat - p_H₂O) / p_atm;

        ∂A∂E = (a_2 - a_1) / (e_2 - e_1);
        ∂Θ∂E = a_2 / max(ec - e_2, FT(1e-7));
        diff = ∂A∂E - ∂Θ∂E;

        #= used for debugging
        @show x;
        @show ∂A∂E;
        @show ∂Θ∂E;
        println("");
        #sleep(0.1);
        # =#

        return diff
    end
end

function envir_diff!(
            x::FT,
            photo_set::AbstractPhotoModelParaSet,
            leaves::Leaves{FT},
            hs::LeafHydraulics{FT},
            envir::AirLayer{FT},
            sm::OSMWAP,
            ind::Int
            ) where {FT<:AbstractFloat}
    # unpack variables
    @unpack g_max, g_min, p_sat, ps = leaves;
    @unpack p_atm, p_H₂O = envir;
    g_bc = leaves.g_bc[ind];
    g_bw = leaves.g_bw[ind];
    g_m  = leaves.g_m[ind];

    # calculate the limit of g_lc to ensure x in the physiological range
    _glh = 1 / (1/g_bc + FT(1.6)/g_max + 1/g_m);
    _gll = 1 / (1/g_bc + FT(1.6)/g_min + 1/g_m);

    if x > _glh
        x = _glh + FT(1e-4);
        leaves.g_sw[ind] = 2 * g_max;

        return FT(0)
    elseif x< _gll
        x = _gll - FT(1e-4);
        leaves.g_sw[ind] = FT(0);

        return FT(0)
    else
        # update photosynthesis from x-FT(1e-3)
        g_lc = x - FT(1e-3);
        ps.g_lc = g_lc;
        leaf_photo_from_glc!(photo_set, ps, envir);

        g_sc = 1 / ( 1/g_lc - 1/g_m - 1/g_bc );
        g_sw = g_sc * FT(1.6);
        g_lw = 1 / (1/g_sw + 1/g_bw);
        a_1  = ps.An;
        e_1  = g_lw * (p_sat - p_H₂O) / p_atm;
        p_1  = xylem_p_from_flow(hs, e_1);

        # update photosynthesis from x
        g_lc = x;
        ps.g_lc = g_lc;
        leaf_photo_from_glc!(photo_set, ps, envir);

        g_sc = 1 / ( 1/g_lc - 1/g_m - 1/g_bc );
        g_sw = g_sc * FT(1.6);
        g_lw = 1 / (1/g_sw + 1/g_bw);
        a_2  = ps.An;
        e_2  = g_lw * (p_sat - p_H₂O) / p_atm;
        p_2  = xylem_p_from_flow(hs, e_2);

        ∂A∂E = (a_2 - a_1) / (e_2 - e_1);
        ∂Θ∂E = (-2 * sm.a * p_2 + sm.b) / (e_2 - e_1) * (p_1 - p_2);
        diff = ∂A∂E - ∂Θ∂E;

        #= used for debugging
        @show x;
        @show ∂A∂E;
        @show ∂Θ∂E;
        println("");
        #sleep(0.1);
        # =#

        return diff
    end
end

function envir_diff!(
            x::FT,
            photo_set::AbstractPhotoModelParaSet,
            leaves::Leaves{FT},
            hs::LeafHydraulics{FT},
            envir::AirLayer{FT},
            sm::OSMWAPMod,
            ind::Int
            ) where {FT<:AbstractFloat}
    # unpack variables
    @unpack g_max, g_min, p_sat, ps = leaves;
    @unpack p_atm, p_H₂O = envir;
    g_bc = leaves.g_bc[ind];
    g_bw = leaves.g_bw[ind];
    g_m  = leaves.g_m[ind];

    # calculate the limit of g_lc to ensure x in the physiological range
    _glh = 1 / (1/g_bc + FT(1.6)/g_max + 1/g_m);
    _gll = 1 / (1/g_bc + FT(1.6)/g_min + 1/g_m);

    if x > _glh
        x = _glh + FT(1e-4);
        leaves.g_sw[ind] = 2 * g_max;

        return FT(0)
    elseif x< _gll
        x = _gll - FT(1e-4);
        leaves.g_sw[ind] = FT(0);

        return FT(0)
    else
        # update photosynthesis from x-FT(1e-3)
        g_lc = x - FT(1e-3);
        ps.g_lc = g_lc;
        leaf_photo_from_glc!(photo_set, ps, envir);

        g_sc = 1 / ( 1/g_lc - 1/g_m - 1/g_bc );
        g_sw = g_sc * FT(1.6);
        g_lw = 1 / (1/g_sw + 1/g_bw);
        a_1  = ps.An;
        e_1  = g_lw * (p_sat - p_H₂O) / p_atm;
        p_1  = xylem_p_from_flow(hs, e_1);

        # update photosynthesis from x
        g_lc = x;
        ps.g_lc = g_lc;
        leaf_photo_from_glc!(photo_set, ps, envir);

        g_sc = 1 / ( 1/g_lc - 1/g_m - 1/g_bc );
        g_sw = g_sc * FT(1.6);
        g_lw = 1 / (1/g_sw + 1/g_bw);
        a_2  = ps.An;
        e_2  = g_lw * (p_sat - p_H₂O) / p_atm;
        p_2  = xylem_p_from_flow(hs, e_2);

        ∂A∂E = (a_2 - a_1) / (e_2 - e_1);
        ∂Θ∂E = (-2 * sm.a * p_2 * a_2) / (e_2 - e_1) * (p_1 - p_2);
        diff = ∂A∂E - ∂Θ∂E;

        #= used for debugging
        @show x;
        @show ∂A∂E;
        @show ∂Θ∂E;
        println("");
        #sleep(0.1);
        # =#

        return diff
    end
end
