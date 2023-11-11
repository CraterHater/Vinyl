// Feather disable all

function __VinylEditorInit()
{
    static _editor = __VinylGlobalData().__editor;
    with(_editor)
    {
        __showing = false;
        
        __windowStates = {
            __desktop: {
                __function: __VinylEditorWindowDesktop,
                __open: true,
                __collapsed: false,
            },
            
            __settings: {
                __function: __VinylEditorWindowSettings,
                __open: false,
                __collapsed: false,
            },
            
            __project: {
                __function: __VinylEditorWindowProject,
                __open: false,
                __collapsed: false,
            },
            
            __configAssets: {
                __function: __VinylEditorWindowConfigAssets,
                __open: false,
                __collapsed: false,
                __popupData: {},
            },
            
            __configPatterns: {
                __function: __VinylEditorWindowConfigPatterns,
                __open: false,
                __collapsed: false,
                __popupData: {},
                __quickDelete: false,
            },
            
            __configLabels: {
                __function: __VinylEditorWindowConfigLabels,
                __open: false,
                __collapsed: false,
                __popupData: {},
                __quickDelete: false,
            },
            
            __configStacks: {
                __function: __VinylEditorWindowConfigStacks,
                __open: false,
                __collapsed: false,
                __popupData: {},
                __quickDelete: false,
            },
            
            __configKnobs: {
                __function: __VinylEditorWindowConfigKnobs,
                __open: false,
                __collapsed: false,
                __popupData: {},
                __quickDelete: false,
            },
            
            __configEffectChains: {
                __function: __VinylEditorWindowConfigEffectChains,
                __open: false,
                __collapsed: false,
                __popupData: {},
                __quickDelete: false,
            },
            
            __nowPlaying: {
                __function: __VinylEditorWindowNowPlaying,
                __open: false,
                __collapsed: false,
            },
            
            __snapshots: {
                __function: __VinylEditorWindowSnapshots,
                __open: false,
                __collapsed: false,
            },
        }
        
        __globalSettings = {};
        __globalSettingDirty = false;
    }
    
    if (not __VinylGetEditorEnabled()) return;
    
    __VinylGlobalSettingsLoad();
    
    ImGui.__Initialize();
}