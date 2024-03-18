// Feather disable all

function __VedClassWindowPatterns() : __VedClassWindow() constructor
{
    __handle = "Patterns";
    
    __multiselector = new __VedClassMultiselector();
    
    __showDict = {
        "__VedClassPatternShuffle": true,
        "__VedClassPatternHLT":     true,
        "__VedClassPatternMulti":   true,
    };
    
    static __Update = function()
    {
        __BuildUI();
    }
    
    static __BuildUI = function()
    {
        var _project = _system.__project;
        
        var _patternArray = _project.__libPattern.__GetNameArray();
        var _patternDict  = _project.__libPattern.__GetDictionary();
        
        ImGui.SetNextWindowSize(0.6*room_width, 0.7*room_height, ImGuiCond.Once);
        ImGui.SetNextWindowPos(0.2*room_width, 0.15*room_height, ImGuiCond.Once);
	    
        //Allow the filter window to stay on top
        //var _flags = __VinylEditorWindowGetOpen("__filter")? ImGuiWindowFlags.NoBringToFrontOnFocus : ImGuiWindowFlags.None;
        var _flags = ImGuiWindowFlags.None;
        
        var _return = ImGui.Begin(__handle, not __closed, _flags, ImGuiReturnMask.Both);
        __closed = ((_return & ImGuiReturnMask.Pointer) <= 0);
        
        if (_return & ImGuiReturnMask.Return)
        {
            ImGui.BeginChild("Left Pane", 0.33*ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
                
                if (ImGui.Button("New")) __VedModalOpen(__VedClassModalNewPattern);
                ImGui.SameLine(undefined, 20);
                
                ImGui.BeginDisabled(__multiselector.__GetSelectedCount() <= 0);
                if (ImGui.Button("Delete"))
                {
                    __multiselector.__ForEachSelected(_patternDict,
                    method({
                        __library: _project.__libPattern,
                    },
                    function(_name, _struct)
                    {
                        __library.__RemoveByName(_name);
                    }));
                    
                    __multiselector.__SelectNone();
                }
                ImGui.EndDisabled();
                
                __showDict[$ "__VedClassPatternShuffle"] = ImGui.Checkbox("Shuffle", __showDict[$ "__VedClassPatternShuffle"]);
                ImGui.SameLine();
                __showDict[$ "__VedClassPatternHLT"] = ImGui.Checkbox("H-L-T", __showDict[$ "__VedClassPatternHLT"]);
                ImGui.SameLine();
                __showDict[$ "__VedClassPatternMulti"] = ImGui.Checkbox("Multi", __showDict[$ "__VedClassPatternMulti"]);
                
                //Keep an array of all visible sounds. We use this later for the "select all" button
                var _visibleArray = [];
                
                //Now do the actual table
                if (ImGui.BeginTable("Table", 2, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.ScrollY, ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY() - 50))
                {
                    //Set up our columns with fixed widths so we get a nice pretty layout
                    ImGui.TableSetupColumn("", ImGuiTableColumnFlags.WidthFixed, 21);
                    ImGui.TableSetupColumn("", ImGuiTableColumnFlags.WidthStretch, 1);
                    
                    //DRY - Used for both the fallback sound config and standard sound configs
                    var _funcBuildSelectable = function(_name, _pattern, _multiselector)
                    {
                        var _selected = _multiselector.__IsSelected(_name);
                        
                        //Left-hand side custom checkbox
                        ImGui.TableNextRow();
                        ImGui.TableSetColumnIndex(0);
                        ImGui.BeginDisabled(true);
                        ImGui.Text((_pattern == undefined)? "???" : _pattern.__GetAbbreviation());
                        ImGui.EndDisabled();
                        
                        //Right-hand side name
                        ImGui.TableSetColumnIndex(1);
                        if (ImGui.Selectable(_name + "##Select " + _name, _selected)) _multiselector.__SelectToggle(_name);
                    }
                    
                    //Iterate over every sound in the project and show them in the editor
                    var _i = 0;
                    repeat(array_length(_patternArray))
                    {
                        var _name = _patternArray[_i];
                        
                        var _selected = __multiselector.__IsSelected(_name);
                        
                        if ((not __multiselector.__multiselect) || (_selected && __multiselector.__seeSelected) || ((not _selected) && __multiselector.__seeUnselected)) //Selected check
                        {
                            var _pattern = _patternDict[$ _name];
                            if (__showDict[$ instanceof(_pattern)] ?? true)
                            {
                                _funcBuildSelectable(_name, _pattern, __multiselector);
                                
                                //Push the name of this visible sound to our array
                                array_push(_visibleArray, _name);
                            }
                        }
                        
                        ++_i;
                    }
                    
                    ImGui.EndTable();
                }
                
                //Build the selection handler UI at the bottom of the list of sounds
                __multiselector.__BuildUI(_patternDict, _visibleArray);
            ImGui.EndChild();
            
            ImGui.SameLine();
            
            ImGui.BeginChild("Right Pane", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
                //Collect some basic facts about the current selection(s)
                var _selectedCount    = __multiselector.__GetSelectedCount();
                var _lastSelectedName = __multiselector.__lastSelected;
                var _lastSelected     = _patternDict[$ _lastSelectedName];
                
                //Bit of aesthetic spacing
                ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 10);
                
                if (_selectedCount <= 0)
                {
                    //Add some helpful text to guide users if nothing's selected
                    ImGui.Text("Please select a pattern from the menu on the left.");
                }
                else
                {
                    if (_selectedCount == 1)
                    {
                        //Change the display text depending on what the user is actually seeing
                        ImGui.Text(__multiselector.__GetLastSelectedName());
                    }
                    else
                    {
                        //Change the display text depending on what the user is actually seeing
                        ImGui.Text(string_concat(__multiselector.__GetLastSelectedName(), " and ", string(_selectedCount-1), " others"));
                    }
                    
                    ImGui.NewLine();
                    _lastSelected.__BuildUI(__multiselector);
                }
            ImGui.EndChild();
            
            ImGui.EndChild();
        }
        
        ImGui.End();
    }
}