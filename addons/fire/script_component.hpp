#define COMPONENT fire
#define COMPONENT_BEAUTIFIED Fire
#include "\z\ace\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define CBA_DEBUG_SYNCHRONOUS
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_FIRE
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_FIRE
    #define DEBUG_SETTINGS DEBUG_SETTINGS_FIRE
#endif

#include "\z\ace\addons\main\script_macros.hpp"

//#include "\z\ace\addons\medical_engine\script_macros_medical.hpp"
#define VAR_PAIN              QEGVAR(medical,pain)
#define VAR_PAIN_SUPP         QEGVAR(medical,painSuppress)
#define VAR_UNCON             "ACE_isUnconscious"

#define GET_PAIN(unit)              (unit getVariable [VAR_PAIN, 0])
#define GET_PAIN_SUPPRESS(unit)     (unit getVariable [VAR_PAIN_SUPP, 0])
#define GET_PAIN_PERCEIVED(unit)    (0 max (GET_PAIN(unit) - GET_PAIN_SUPPRESS(unit)) min 1)
#define IS_UNCONSCIOUS(unit)       (unit getVariable [VAR_UNCON, false])

#define FIRE_MANAGER_PFH_DELAY 0.25
#define FLARE_SIZE_MODIFIER 5
#define PRONE_ROLLING_ANIMS [\
    "amovppnemstpsnonwnondnon_amovppnemevasnonwnondl",\
    "amovppnemstpsnonwnondnon_amovppnemevasnonwnondr",\
    "amovppnemstpsraswrfldnon_amovppnemevaslowwrfldl",\
    "amovppnemstpsraswrfldnon_amovppnemevaslowwrfldr",\
    "amovppnemstpsraswpstdnon_amovppnemevaslowwpstdl",\
    "amovppnemstpsraswpstdnon_amovppnemevaslowwpstdr",\
    "amovppnemstpsoptwbindnon_amovppnemevasoptwbindl",\
    "amovppnemstpsoptwbindnon_amovppnemevasoptwbindr"\
]


#define BURN_MAX_INTENSITY 10
#define BURN_MIN_INTENSITY 1

#define INTENSITY_DECREASE_MULT_PAT_DOWN 0.8
#define INTENSITY_DECREASE_MULT_ROLLING INTENSITY_DECREASE_MULT_PAT_DOWN
