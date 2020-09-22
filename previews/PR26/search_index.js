var documenterSearchIndex = {"docs":
[{"location":"#StomtaModels.jl","page":"Home","title":"StomtaModels.jl","text":"","category":"section"},{"location":"#Use-StomataModels","page":"Home","title":"Use StomataModels","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"julia> using Photosynthesis\njulia> using StomataModels\njulia> envir  = AirLayer{FT}();\njulia> ps_3   = C3CLM(FT);\njulia> leaves = Leaves{FT}(n_leaf=2);\njulia> sm     = OSMWang{FT}();\njulia> \njulia> leaf_photo_from_envir!(ps_3, leaves, envir, sm);","category":"page"},{"location":"API/#StomtaModels-API","page":"API","title":"StomtaModels API","text":"","category":"section"},{"location":"API/","page":"API","title":"API","text":"CurrentModule = StomataModels","category":"page"},{"location":"API/#Stomatal-model-schemes","page":"API","title":"Stomatal model schemes","text":"","category":"section"},{"location":"API/","page":"API","title":"API","text":"The StomataModels module relies mainly on Photosynthesis and PlantHydraulics     modules to predict stomatal behavior from plant physiology. This module has     both empirical and optimal stomatal models. These stomatal models are     abstractized to an abstract AbstractStomatalModel, which further     has subtypes EmpiricalStomatalModel and     OptimizationStomatalModel.","category":"page"},{"location":"API/","page":"API","title":"API","text":"AbstractStomatalModel\nEmpiricalStomatalModel\nOptimizationStomatalModel","category":"page"},{"location":"API/#StomataModels.AbstractStomatalModel","page":"API","title":"StomataModels.AbstractStomatalModel","text":"type AbstractStomatalModel\n\nHierarchy of the AbstractStomatalModel:\n\nEmpiricalStomatalModel\nOptimizationStomatalModel\n\n\n\n\n\n","category":"type"},{"location":"API/#StomataModels.EmpiricalStomatalModel","page":"API","title":"StomataModels.EmpiricalStomatalModel","text":"type EmpiricalStomatalModel\n\nHierarchy of the EmpiricalStomatalModel:\n\nESMBallBerry\nESMGentine\nESMLeuning\nESMMedlyn\n\n\n\n\n\n","category":"type"},{"location":"API/#StomataModels.OptimizationStomatalModel","page":"API","title":"StomataModels.OptimizationStomatalModel","text":"type OptimizationStomatalModel\n\nHierarchy of the OptimizationStomatalModel:\n\nOSMEller\nOSMSperry\nOSMWang\nOSMWAP\nOSMWAPMod\n\n\n\n\n\n","category":"type"},{"location":"API/","page":"API","title":"API","text":"Currently, the StomataModels module has four empirical model schemes, and they     are","category":"page"},{"location":"API/","page":"API","title":"API","text":"ESMBallBerry\nESMGentine\nESMLeuning\nESMMedlyn","category":"page"},{"location":"API/#StomataModels.ESMBallBerry","page":"API","title":"StomataModels.ESMBallBerry","text":"struct ESMBallBerry{FT}\n\nAn empirical model parameter set type for Ball-Berry type model. The equation used for Ball-Berry type model is\n\ngs = g0 + g1  RH  dfracACs\n\nFields\n\ng0\nminimal stomatal conductance g0 [mol m⁻² s⁻¹]\ng1\nslope of conductance-photosynthesis correlation [unitless]\n\n\n\n\n\n","category":"type"},{"location":"API/#StomataModels.ESMGentine","page":"API","title":"StomataModels.ESMGentine","text":"struct ESMGentine{FT}\n\nAn empirical model parameter set type for Gentine type model. The equation used for Gentine type model is\n\ngs = g0 + g1  dfrack_leafk_max  dfracACa\n\nNote it that the Gentine model does not require for a β function to tune the     soil drought response, but the use of k_leaf also does not permit     post-drought stomatal response unless k_leaf can be recovered.\n\nFields\n\ng0\nminimal stomatal conductance g0 [mol m⁻² s⁻¹]\ng1\nslope of conductance-photosynthesis correlation [unitless]\n\n\n\n\n\n","category":"type"},{"location":"API/#StomataModels.ESMLeuning","page":"API","title":"StomataModels.ESMLeuning","text":"struct ESMLeuning{FT}\n\nAn empirical model parameter set type for Leuning type model. The equation used for Leuning type model is\n\ngs = g0 + g1  dfracACs - Γ^*  dfrac11 + dfracVPDd0\n\nFields\n\ng0\nminimal stomatal conductance g0 [mol m⁻² s⁻¹]\ng1\nslope of conductance-photosynthesis correlation [unitless]\nd0\nfitting parameter of d/d0 below the fraction, same unit as vpd [Pa]\n\n\n\n\n\n","category":"type"},{"location":"API/#StomataModels.ESMMedlyn","page":"API","title":"StomataModels.ESMMedlyn","text":"struct ESMMedlyn{FT}\n\nAn empirical model parameter set type for Medlyn type model. The equation used in Medlyn type model is\n\ngs = g0 + 16  left( 1 + dfracg1sqrtVPD right)  dfracACa\n\nFields\n\ng0\nminimal stomatal conductance g0 [mol m⁻² s⁻¹]\ng1\nslope of conductance-photosynthesis correlation [Pa⁽⁵⁾]\n\n\n\n\n\n","category":"type"},{"location":"API/","page":"API","title":"API","text":"All the empirical models rely on beta functions to make corrections over     stomatal conductance to account for the stomatal closure with drier soil.     We have the following prescribed beta function types, and they are:","category":"page"},{"location":"API/","page":"API","title":"API","text":"AbstractBetaFunction","category":"page"},{"location":"API/#StomataModels.AbstractBetaFunction","page":"API","title":"StomataModels.AbstractBetaFunction","text":"abstract type AbstractBetaFunction{FT}\n\nHierachy of AbstractBetaFunction:\n\nAbstractBetaG\nBetaGLinearPleaf\nBetaGLinearPsoil\nBetaGLinearSWC\nAbstractBetaV\nBetaVLinearPleaf\nBetaVLinearPsoil\nBetaVLinearSWC\n\n\n\n\n\n","category":"type"},{"location":"API/","page":"API","title":"API","text":"Some beta functions make correction over the g1 parameter as in the empitical     models, and they are:","category":"page"},{"location":"API/","page":"API","title":"API","text":"AbstractBetaG\nBetaGLinearPleaf\nBetaGLinearPsoil\nBetaGLinearSWC","category":"page"},{"location":"API/#StomataModels.AbstractBetaG","page":"API","title":"StomataModels.AbstractBetaG","text":"abstract type AbstractBetaG{FT}\n\nHierachy of AbstractBetaG:\n\nBetaGLinearPleaf\nBetaGLinearPsoil\nBetaGLinearSWC\n\n\n\n\n\n","category":"type"},{"location":"API/#StomataModels.BetaGLinearPleaf","page":"API","title":"StomataModels.BetaGLinearPleaf","text":"mutable struct BetaGLinearPleaf{FT}\n\nLinear β function for g1 based on soil water potential.\n\nFields\n\np_max\nUpper bound of Pleaf [MPa]\np_min\nLower bound of Pleaf [MPa]\n\n\n\n\n\n","category":"type"},{"location":"API/#StomataModels.BetaGLinearPsoil","page":"API","title":"StomataModels.BetaGLinearPsoil","text":"mutable struct BetaGLinearPsoil{FT}\n\nLinear β function for g1 based on soil water potential.\n\nFields\n\np_max\nUpper bound of Psoil [MPa]\np_min\nLower bound of Psoil [MPa]\n\n\n\n\n\n","category":"type"},{"location":"API/#StomataModels.BetaGLinearSWC","page":"API","title":"StomataModels.BetaGLinearSWC","text":"mutable struct BetaGLinearSWC{FT}\n\nLinear β function for g1 based on soil water content.\n\nFields\n\nswc_max\nUpper bound of SWC\nswc_min\nLower bound of SWC\n\n\n\n\n\n","category":"type"},{"location":"API/","page":"API","title":"API","text":"Some beta functions make correction over the photosynthetic capacity as in the     Photosynthesis module, and they are:","category":"page"},{"location":"API/","page":"API","title":"API","text":"AbstractBetaV\nBetaVLinearPleaf\nBetaVLinearPsoil\nBetaVLinearSWC","category":"page"},{"location":"API/#StomataModels.AbstractBetaV","page":"API","title":"StomataModels.AbstractBetaV","text":"abstract type AbstractBetaV{FT}\n\nHierachy of AbstractBetaV:\n\nBetaVLinearPleaf\nBetaVLinearPsoil\nBetaVLinearSWC\n\n\n\n\n\n","category":"type"},{"location":"API/#StomataModels.BetaVLinearPleaf","page":"API","title":"StomataModels.BetaVLinearPleaf","text":"mutable struct BetaVLinearPleaf{FT}\n\nLinear β function for g1 based on soil water potential.\n\nFields\n\np_max\nUpper bound of Pleaf [MPa]\np_min\nLower bound of Pleaf [MPa]\n\n\n\n\n\n","category":"type"},{"location":"API/#StomataModels.BetaVLinearPsoil","page":"API","title":"StomataModels.BetaVLinearPsoil","text":"mutable struct BetaVLinearPsoil{FT}\n\nLinear β function for Vcmax based on soil water potential.\n\nFields\n\np_max\nUpper bound of Psoil [MPa]\np_min\nLower bound of Psoil [MPa]\n\n\n\n\n\n","category":"type"},{"location":"API/#StomataModels.BetaVLinearSWC","page":"API","title":"StomataModels.BetaVLinearSWC","text":"mutable struct BetaVLinearSWC{FT}\n\nLinear β function for Vcmax based on soil water content.\n\nFields\n\nswc_max\nUpper bound of SWC\nswc_min\nLower bound of SWC\n\n\n\n\n\n","category":"type"},{"location":"API/","page":"API","title":"API","text":"The beta functions are generalized with","category":"page"},{"location":"API/","page":"API","title":"API","text":"β_factor","category":"page"},{"location":"API/#StomataModels.β_factor","page":"API","title":"StomataModels.β_factor","text":"β_factor(bt::AbstractBetaFunction{FT},\n         pl::FT,\n         ps::FT,\n         swc::FT) where {FT<:AbstractFloat}\n\nCalculate the β correction factor, given\n\nbt AbstractBetaFunction type struct\npl Leaf water potential [MPa]\nps Soil water potential [MPa]\nswc Soil water content\n\n\n\n\n\n","category":"function"},{"location":"API/","page":"API","title":"API","text":"The StomataModels module also contains five optimization model schemes:","category":"page"},{"location":"API/","page":"API","title":"API","text":"OSMEller\nOSMSperry\nOSMWang\nOSMWAP\nOSMWAPMod","category":"page"},{"location":"API/#StomataModels.OSMEller","page":"API","title":"StomataModels.OSMEller","text":"struct OSMEller\n\nAn optimization model parameter set type for Eller model. The equation used for Eller model is\n\ndfracΘE = -dfracKE  dfracAK\n\nwhere K is dfracEP.\n\nFields\n\n\n\n\n\n","category":"type"},{"location":"API/#StomataModels.OSMSperry","page":"API","title":"StomataModels.OSMSperry","text":"struct OSMSperry\n\nAn optimization model parameter set type for Sperry model. The equation used for Sperry model is\n\ndfracΘE = -dfracKE  dfracA_maxK_max\n\nwhere K is dfracEP.\n\nFields\n\n\n\n\n\n","category":"type"},{"location":"API/#StomataModels.OSMWang","page":"API","title":"StomataModels.OSMWang","text":"struct OSMWang\n\nAn optimization model parameter set type for Eller type model. The equation used for Wang model is\n\ndfracΘE = dfracAE_crit - E\n\nFields\n\n\n\n\n\n","category":"type"},{"location":"API/#StomataModels.OSMWAP","page":"API","title":"StomataModels.OSMWAP","text":"struct OSMWAP{FT}\n\nAn optimization model parameter set type for Wolf-Anderegg-Pacala type model. The equation used for Wolf-Anderegg-Pacala model is\n\ndfracΘE = dfrac2aP + bK\n\nwhere K is ∂P/∂E.\n\nFields\n\na\nQuadratic equation parameter [μmol m⁻² s⁻¹ MPa⁻²]\nb\nQuadratic equation parameter [μmol m⁻² s⁻¹ MPa⁻¹]\n\n\n\n\n\n","category":"type"},{"location":"API/#StomataModels.OSMWAPMod","page":"API","title":"StomataModels.OSMWAPMod","text":"struct OSMWAPMod{FT}\n\nAn optimization model parameter set type for Wolf-Anderegg-Pacala type model,     modified by adding a photosynthesis component while set b and c = 0. The equation used for modified Wolf-Anderegg-Pacala model is\n\ndfracΘE = dfracaAPK\n\nwhere P is absolute value of leaf xylem pressure.\n\nFields\n\na\nQuadratic equation parameter [mol mol⁻¹ MPa⁻¹]\n\n\n\n\n\n","category":"type"},{"location":"API/#CanopyLayer","page":"API","title":"CanopyLayer","text":"","category":"section"},{"location":"API/","page":"API","title":"API","text":"The StomataModels module is designed for multi-layer canopies, and each canopy     has multiple leaves. The stomatal behaviors are modeled per layer basis,     and the layer may contain any number of leaves starting from 1.     Photosynthesis-related information is stored in CanopyLayer     struct, but be aware that the leaves have uniform photosynthetic parameters     and temperature (conductances are different in response to light     environment).","category":"page"},{"location":"API/","page":"API","title":"API","text":"CanopyLayer","category":"page"},{"location":"API/#StomataModels.CanopyLayer","page":"API","title":"StomataModels.CanopyLayer","text":"struct CanopyLayer{FT}\n\nStruct to store leaf information (multi-dimensional).\n\nFields\n\nps\nleaf photosynthesis system\nLA\nTotal leaf area [m²]\nLAI\nTotal leaf area index\nn_leaf\nH\nSensible Heat Flux [W m⁻²]\nLE\nLatent Heat Flux [W m⁻²]\nRn\nNet Radiation Balance [W m⁻²]\nLV\nLatent Heat of evaporation [J mol⁻¹]\nT\nTemperature [K]\nT_old\nOld temperature [K]\nwidth\nLeaf width [m]\ng_bc\nBoundary layer conductance to CO₂ [mol m⁻² s⁻¹]\ng_bh\nBoundary layer conductance to heat [mol m⁻² s⁻¹]\ng_bw\nBoundary layer conductance to H₂O [mol m⁻² s⁻¹]\ng_lc\nLeaf diffusive conductance to water CO₂ [mol m⁻² s⁻¹]\ng_lw\nLeaf diffusive conductance to water H₂O [mol m⁻² s⁻¹]\ng_m\nMesophyll conductance for CO₂ [mol m⁻² s⁻¹]\ng_sc\nStomatal conductance to water CO₂ [mol m⁻² s⁻¹]\ng_sw\nStomatal conductance to water H₂O [mol m⁻² s⁻¹]\ng_ias_c\nGias correction constant\ng_ias_e\nGias correction exponent\ng_max\nMaximal leaf diffusive conductance [mol m⁻² s⁻¹]\ng_max25\nMaximal leaf diffusive conductance at 298.15 K [mol m⁻² s⁻¹]\ng_min\nMinimal leaf diffusive conductance [mol m⁻² s⁻¹]\ng_min25\nMinimal leaf diffusive conductance at 298.15 K [mol m⁻² s⁻¹]\np_i\nLeaf internal CO₂ partial pressure [Pa]\np_s\nLeaf surface CO₂ partial pressure [Pa]\np_sat\nLeaf saturation vapor pressure [Pa]\nAc\nRubisCO limited photosynthetic rate [μmol m⁻² s⁻¹]\nAj\nLight limited photosynthetic rate [μmol m⁻² s⁻¹]\nAg\nGross photosynthetic rate [μmol m⁻² s⁻¹]\nAn\nNet photosynthetic rate [μmol m⁻² s⁻¹]\nAp\nProduct limited photosynthetic rate [μmol m⁻² s⁻¹]\nJ\nElectron transport [μmol m⁻² s⁻¹]\nJ_pot\nPotential Electron Transport Rate [μmol m⁻² s⁻¹]\nCO₂_per_electron\nTotal efficiency, incl. photorespiration [mol CO₂ mol⁻¹ e-]\nFm′\nlight adapted yield (Kp=0)\nFo′\nlight-adapted fluorescence yield in the dark (Kp=max)\nJa\nActual electron transport rate [μmol m⁻² s⁻¹]\nNPQ\nNon-Photochemical quenching\nqQ\nPhotochemical quenching\nqE\nenergy quenching\nφ\nPSII yield\nϕs\nSteady-state (light-adapted) yield (aka Fs)\nFm\ndark adapted yield (Kp=0)\nFo\ndark-adapted fluorescence yield (Kp=max)\nAPAR\nAbsorbed photosynthetic active radiation [μmol m⁻² s⁻¹]\nLAIx\nLeaf area fractions\na_max\nMaximal photosynthetic rate [μmol m⁻² s⁻¹]\ne\nFlow rate [mol m⁻² s⁻¹]\nec\nCritical flow rate [mol m⁻² s⁻¹]\nkr_max\nMaximal hydraulic conductance ratio\np_ups\nBase xylem pressre [MPa]\np_old\nBase xylem pressre memory [MPa]\n\n\n\n\n\n","category":"type"},{"location":"API/#Stomatal-conductance","page":"API","title":"Stomatal conductance","text":"","category":"section"},{"location":"API/","page":"API","title":"API","text":"For empirical stomatal models, the stomatal conductance is computed as the     intercept of two functions: an empirical function that describe stomatal     responses to the physiological and environmental cues and an function that     follows the diffusion nature of H₂O and CO₂. The abstractized function for     the empirical correlation is","category":"page"},{"location":"API/","page":"API","title":"API","text":"empirical_gsw_from_model","category":"page"},{"location":"API/#StomataModels.empirical_gsw_from_model","page":"API","title":"StomataModels.empirical_gsw_from_model","text":"empirical_gsw_from_model(model::EmpiricalStomatalModel{FT}, leaf::Leaf{FT}, envir::AirLayer{FT}, β::FT) where {FT<:AbstractFloat}\nempirical_gsw_from_model(model::EmpiricalStomatalModel{FT}, canopyi::CanopyLayer{FT}, envir::AirLayer{FT}, β::FT) where {FT<:AbstractFloat}\nempirical_gsw_from_model(model::EmpiricalStomatalModel{FT}, canopyi::CanopyLayer{FT}, envir::AirLayer{FT}, β::FT, ind::Int) where {FT<:AbstractFloat}\n\nSteady state gsw from empirical approach given\n\nmodel EmpiricalStomatalModel type empirical model parameter set\nleaf [Leaf] type struct\ncanopyi CanopyLayer type struct\nenvir [AirLayer] type struct\nβ Correction factor over the g1 part of an empirical model\nind Nth leaf in the canopy layer\n\n\n\n\n\n","category":"function"},{"location":"API/","page":"API","title":"API","text":"For optimization stomatal models, the stomatal conductance is computed as the     point where the marginal carbon gains equals the marginal carbon risk. The     marginal carbon gain and risk are generally numerically computed by     marginally increasing transpiration rate.","category":"page"},{"location":"API/","page":"API","title":"API","text":"This module uses ConstrainedRootSolver module to iterate through the two     functions to find the solution. The aim is to find the stomatal conductance     when the envir_diff! function equals 0. The envir_diff!     returns the diference between real and model-predicted conductances for     empirical stomatal models, and the difference between marginal carbon gain     and risk for optimization stomatal models.","category":"page"},{"location":"API/","page":"API","title":"API","text":"envir_diff!","category":"page"},{"location":"API/#StomataModels.envir_diff!","page":"API","title":"StomataModels.envir_diff!","text":"envir_diff!(x::FT,\n            photo_set::AbstractPhotoModelParaSet{FT},\n            canopyi::CanopyLayer{FT},\n            hs::LeafHydraulics{FT},\n            psoil::FT,\n            swc::FT,\n            envir::AirLayer{FT},\n            sm::OptimizationStomatalModel{FT},\n            bt::AbstractBetaFunction{FT},\n            ind::Int) where {FT<:AbstractFloat}\nenvir_diff!(x::FT,\n            photo_set::AbstractPhotoModelParaSet{FT},\n            canopyi::CanopyLayer{FT},\n            hs::LeafHydraulics{FT},\n            envir::AirLayer{FT},\n            sm::AbstractStomatalModel{FT},\n            ind::Int) where {FT<:AbstractFloat}\n\nCalculate the difference to be minimized for a given\n\nx Assumed leaf diffusive conductance\nphoto_set[C3ParaSet] or [C4ParaSet] type parameter set\ncanopyiCanopyLayer type struct\nhs Leaf hydraulic system\npsoil Soil water potential [MPa]\nswc Soil water content\nenvir[AirLayer] type struct\nsm EmpiricalStomatalModel or OptimizationStomatalModel\nbt AbstractBetaFunction type struct\nind Nth leaf in the canopy layer\n\nThe former function works for Ball-Berry, Leuning, and Medlyn models, the     latter works for Gentine and all the optimization based models.\n\n\n\n\n\n","category":"function"},{"location":"API/","page":"API","title":"API","text":"In the envir_diff! function, leaf photosynthetic rates is modeled     using update_leaf_from_glc!, which calculates the gas exchange     rates from a known total leaf diffusive conductance.","category":"page"},{"location":"API/","page":"API","title":"API","text":"update_leaf_from_glc!","category":"page"},{"location":"API/#StomataModels.update_leaf_from_glc!","page":"API","title":"StomataModels.update_leaf_from_glc!","text":"update_leaf_from_glc!(photo_set::AbstractPhotoModelParaSet{FT}, canopyi::CanopyLayer{FT}, envir::AirLayer{FT}, ind::Int, glc::FT) where {FT<:AbstractFloat}\nupdate_leaf_from_glc!(photo_set::AbstractPhotoModelParaSet{FT}, canopyi::CanopyLayer{FT}, envir::AirLayer{FT}) where {FT<:AbstractFloat}\n\nUpdate Nth leaf photosynthesis, given\n\nphoto_set [C3ParaSet] or [C4ParaSet] type parameter set\ncanopyi CanopyLayer type struct\nenvir [AirLayer] type struct\nind Nth leaf\nglc Given leaf diffusive conductance\n\nNote that this function does not make the gsw control, so it is not guaranteed     that gsw is within the physiological range. Thus, gsw control should be     made outside this function. This function is supposed to be used in the     optimal stomatl conductance models only, because optimal conductance can be     outside the physiological stomatal conductance range. Thus, using this     function for other purposes need to be cautious. In this case, it is     recommended to use update_leaf_from_gsw!.\n\n\n\n\n\n","category":"function"},{"location":"API/","page":"API","title":"API","text":"However, these functions do not force stomatal conductance to stay in its     ranges. For example, the stomatal conductance solution is set to be zero if     light is lower than the compensation point. In this case, the     envir_diff! function has to be used along with a control function     to guarantee realistic stomatal conductance.","category":"page"},{"location":"API/","page":"API","title":"API","text":"leaf_gsw_control!","category":"page"},{"location":"API/#StomataModels.leaf_gsw_control!","page":"API","title":"StomataModels.leaf_gsw_control!","text":"leaf_gsw_control!(photo_set::AbstractPhotoModelParaSet{FT}, canopyi::CanopyLayer{FT}, envir::AirLayer{FT}, ind::Int) where {FT<:AbstractFloat}\nleaf_gsw_control!(photo_set::AbstractPhotoModelParaSet{FT}, canopyi::CanopyLayer{FT}, envir::AirLayer{FT}) where {FT<:AbstractFloat}\n\nmake sure g_sw is in its physiological range limited by diffusion, given\n\nphoto_set [C3ParaSet] or [C4ParaSet] type parameter set\ncanopyi CanopyLayer type struct\nenvir [AirLayer] type struct\nind Nth leaf\n\nNote that this function is meant to use jointly with updateleaffrom_glc! when     computing optimal stomtal conductance.\n\n\n\n\n\n","category":"function"},{"location":"API/","page":"API","title":"API","text":"To facilitate the use of the StomataModels module, an abstractized function is     provided for conveniently obtaining stomatal conductance from given     environmental conditions.","category":"page"},{"location":"API/","page":"API","title":"API","text":"leaf_photo_from_envir!","category":"page"},{"location":"API/#StomataModels.leaf_photo_from_envir!","page":"API","title":"StomataModels.leaf_photo_from_envir!","text":"leaf_photo_from_envir!(\n            photo_set::AbstractPhotoModelParaSet{FT},\n            canopyi::CanopyLayer{FT},\n            hs::LeafHydraulics{FT},\n            psoil::FT,\n            swc::FT,\n            envir::AirLayer{FT},\n            sm::EmpiricalStomatalModel{FT},\n            bt::AbstractBetaFunction{FT}) where {FT<:AbstractFloat}\nleaf_photo_from_envir!(\n            photo_set::AbstractPhotoModelParaSet{FT},\n            canopyi::CanopyLayer{FT},\n            hs::LeafHydraulics{FT},\n            psoil::FT,\n            swc::FT,\n            envir::AirLayer{FT},\n            sm::EmpiricalStomatalModel{FT},\n            bt::AbstractBetaFunction{FT},\n            ind::Int) where {FT<:AbstractFloat}\nleaf_photo_from_envir!(\n            photo_set::AbstractPhotoModelParaSet{FT},\n            canopyi::CanopyLayer{FT},\n            hs::LeafHydraulics{FT},\n            envir::AirLayer{FT},\n            sm::AbstractStomatalModel{FT}) where {FT<:AbstractFloat}\nleaf_photo_from_envir!(\n            photo_set::AbstractPhotoModelParaSet{FT},\n            canopyi::CanopyLayer{FT},\n            hs::LeafHydraulics{FT},\n            envir::AirLayer{FT},\n            sm::AbstractStomatalModel{FT},\n            ind::Int) where {FT<:AbstractFloat}\n\nCalculate steady state gsw and photosynthesis from empirical approach, given\n\nphoto_set [C3ParaSet] or [C4ParaSet] type parameter set\ncanopyi CanopyLayer type struct\nhs Leaf hydraulic system\nenvir [AirLayer] type struct\nsm EmpiricalStomatalModel or OptimizationStomatalModel\nbt AbstractBetaFunction type struct\nind Nth leaf in canopyi\n\nThe former function works for Ball-Berry, Leuning, and Medlyn models, the     latter works for Gentine and all the optimization based models.\n\n\n\n\n\n","category":"function"},{"location":"API/","page":"API","title":"API","text":"To speed up the calculations, leaf physiological parameters are updated only     if the environmental conditions changes. For example, PAR (photosyntheis     active radiation) is constant when we iterate envir_diff!, and     the electron transport is only updated once. Similar for the cases of     leaf temperature and soil moisture. This kind of functions used in the     present module are","category":"page"},{"location":"API/","page":"API","title":"API","text":"update_leaf_TP!\nupdate_leaf_AK!","category":"page"},{"location":"API/#StomataModels.update_leaf_TP!","page":"API","title":"StomataModels.update_leaf_TP!","text":"update_leaf_TP!(photo_set::AbstractPhotoModelParaSet{FT}, canopyi::CanopyLayer{FT}, hs::LeafHydraulics{FT}, envir::AirLayer{FT}) where {FT<:AbstractFloat}\n\nUpdate leaf physiological parameters if temperature or pressure changes in the daytime, given\n\nphoto_set [C3ParaSet] or [C4ParaSet] type parameter set\ncanopyi CanopyLayer type struct\nhs Leaf hydraulic system\nenvir [AirLayer] type struct\n\n\n\n\n\n","category":"function"},{"location":"API/#StomataModels.update_leaf_AK!","page":"API","title":"StomataModels.update_leaf_AK!","text":"update_leaf_AK!(\n        photo_set::AbstractPhotoModelParaSet{FT},\n        canopyi::CanopyLayer{FT},\n        hs::LeafHydraulics{FT},\n        envir::AirLayer{FT}) where {FT<:AbstractFloat}\n\nUpdate leaf maximal A and K for Sperry model, given\n\nphoto_set [C3ParaSet] or [C4ParaSet] type parameter set\ncanopyi CanopyLayer type struct\nenvir [AirLayer] type struct\n\n\n\n\n\n","category":"function"},{"location":"API/","page":"API","title":"API","text":"I'd like to emphasize it here that the leaf_photo_from_envir!     function only applies to the case of constant leaf temperature because     leaf energy budget is not calculated, and thus     leaf_photo_from_envir! is only applicable to (1) known leaf     temperature, and (2) prognostically modeling the non-steady state stomatal     behaviors. As to the steady state case, leaf energy budget has to be     considered. For the prognotic stomatal conductance, it is recommended to     use update_leaf_from_gsw! function.","category":"page"},{"location":"API/","page":"API","title":"API","text":"update_leaf_from_gsw!","category":"page"},{"location":"API/#StomataModels.update_leaf_from_gsw!","page":"API","title":"StomataModels.update_leaf_from_gsw!","text":"update_leaf_from_gsw!(photo_set::AbstractPhotoModelParaSet{FT}, canopyi::CanopyLayer{FT}, envir::AirLayer{FT}, ind::Int, gsw::FT) where {FT<:AbstractFloat}\nupdate_leaf_from_gsw!(photo_set::AbstractPhotoModelParaSet{FT}, canopyi::CanopyLayer{FT}, envir::AirLayer{FT}, ind::Int) where {FT<:AbstractFloat}\nupdate_leaf_from_gsw!(photo_set::AbstractPhotoModelParaSet{FT}, canopyi::CanopyLayer{FT}, envir::AirLayer{FT}) where {FT<:AbstractFloat}\n\nUpdate Nth leaf photosynthesis, given\n\nphoto_set [C3ParaSet] or [C4ParaSet] type parameter set\ncanopyi CanopyLayer type struct\nenvir [AirLayer] type struct\nind Nth leaf\ngsw Given stomatal conductance to H₂O\n\nNote that this function makes the gsw control so that gsw is within the     physiological range.\n\n\n\n\n\n","category":"function"},{"location":"API/","page":"API","title":"API","text":"Note it here that stomtal conductance is controlled in this function, and thus     no additional control like leaf_gsw_control! is required if     update_leaf_from_gsw! is used.","category":"page"}]
}
