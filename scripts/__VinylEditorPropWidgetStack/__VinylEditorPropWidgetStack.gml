// Feather disable all

/// @param UiID
/// @param dataStruct
/// @param parentStruct
/// @param columnName
/// @param columnValue
/// @param columnOption

function __VinylEditorPropWidgetStack(_id, _dataStruct, _parentStruct, _columnName, _columnValue, _columnOption)
{
    static _optionArray = [__VINYL_OPTION_UNSET, __VINYL_OPTION_SET];
    
    var _stackArray = ["Music"];
    
    var _originalOption = (_dataStruct == undefined)? __VINYL_OPTION_UNSET : _dataStruct.__stackOption;
    var _inheriting = (_originalOption == __VINYL_OPTION_UNSET);
    
    var _resolution = __VinylPatternResolveInheritedStack(_dataStruct, _parentStruct);
    var _option   = _resolution.__option;
    var _value    = _resolution.__value;
    var _priority = _resolution.__priority;
    
    ImGui.TableNextRow();
    ImGui.TableSetColumnIndex(_columnName);
    ImGui.Text("Stack");
    
    if (_option == __VINYL_OPTION_SET)
    {
        ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 5);
        ImGui.Text("Priority");
    }
    
    ImGui.TableSetColumnIndex(_columnValue);
    ImGui.BeginDisabled(_inheriting);
        switch(_option)
        {
            case __VINYL_OPTION_SET:
                ImGui.SetNextItemWidth(ImGui.GetColumnWidth(_columnValue));
                if (ImGui.BeginCombo("##Stack " + _id, _value, ImGuiComboFlags.None))
                {
                    var _i = 0;
                    repeat(array_length(_stackArray))
                    {
                        var _stackName = _stackArray[_i];
                        if (ImGui.Selectable(_stackName + "##Stack Option " + _id, (_value == _stackName)))
                        {
                            if (not _inheriting)
                            {
                                __VinylDocument().__Write(_dataStruct, "__stackName", _stackName);
                            }
                        }
                        
                        ++_i;
                    }
                    
                    ImGui.EndCombo();
                }
                
                ImGui.TableSetColumnIndex(_columnValue);
                var _newValue = ImGui.InputInt("##Stack Priority " + _id, _priority);
                if (not _inheriting)
                {
                    __VinylDocument().__Write(_dataStruct, "__stackPriority", _newValue);
                }
            break;
        }
    ImGui.EndDisabled();
    
    ImGui.TableSetColumnIndex(_columnOption);
    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(_columnOption));
    if (ImGui.BeginCombo("##Stack Option " + _id, _originalOption, ImGuiComboFlags.None))
    {
        var _i = 0;
        repeat(array_length(_optionArray))
        {
            var _optionName = _optionArray[_i];
            if (ImGui.Selectable(_optionName + "##Stack Option " + _id, (_originalOption == _optionName)))
            {
                __VinylDocument().__Write(_dataStruct, "__stackOption", _optionName);
            }
                        
            ++_i;
        }
        
        ImGui.EndCombo();
    }
}