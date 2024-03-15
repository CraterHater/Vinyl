// Feather disable all

function __VedClassModalNoIdent() : __VedClassModal() constructor
{
    static __FirstTime = function()
    {
        ImGui.OpenPopup("Incompatible Game");
        ImGui.SetNextWindowPos(window_get_width()/2, window_get_height ()/2, ImGuiCond.Appearing, 0.5, 0.5);
    }
    
    static __BuildUI = function()
    {
        if (ImGui.BeginPopupModal("Incompatible Game", undefined, ImGuiWindowFlags.NoResize))
        {
            ImGui.Text("The target game is missing a Vinyl identifier.");
            
            ImGui.Separator();
            
            if (ImGui.Button("OK")) ImGui.CloseCurrentPopup();
            
            ImGui.EndPopup();
        }
    }
}