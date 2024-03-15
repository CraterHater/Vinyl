// Feather disable all

#macro __VED_VERSION  "6.0.0"
#macro __VED_DATE     "2024-03-14"

#macro __VED_PROJECT_FILENAME  "vinyl.json"

#macro __VED_RUNNING_FROM_IDE  (GM_build_type == "run")
#macro __VED_ENABLED  (VED_ENABLED && (os_type == os_windows) && __VED_RUNNING_FROM_IDE)

#macro __VED_NEXT_UI_FILLS_WIDTH  ImGui.SetNextItemWidth(ImGui.GetContentRegionAvailX());
#macro __VED_UNDERLINE_PREV_TEXT  ImGui.DrawListAddLine(ImGui.GetWindowDrawList(), ImGui.GetItemRectMinX(), ImGui.GetItemRectMaxY(), ImGui.GetItemRectMaxX(), ImGui.GetItemRectMaxY(), c_white);

#macro __VED_NETWORKING_PORT  13587

function __VedSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    _system = {};
    
    with(_system)
    {
        if (not __VED_ENABLED) break;
        
        __frame = 0;
        __VedTrace("Welcome to Vinyl Editor! This is version ", __VED_VERSION, ", ", __VED_DATE);
        if (__VINYL_RUNNING_FROM_IDE) global.vinylEditorSystem = self;
        
        ImGui.__Initialize();
        
        __sendBuffer = buffer_create(1024, buffer_grow, 1);
        
        __showing = false;
        
        __windowsArray = [];
        __modalsArray = [];
        
        __VedWindowOpenSingle(__VedClassWindowDesktop);
        
        __project = undefined;
        time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, __VedUpdate, [], -1));
    }
    
    return _system;
}