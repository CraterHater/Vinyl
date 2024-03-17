// Feather disable all

function __VedClassPatternShuffle() constructor
{
    __name = undefined;
    
    __soundArray  = [];
    __gainForce   = false;
    __gain        = [1, 1];
    __gainOption  = __VED_OPTION_MULTIPLY;
    __pitchForce  = false;
    __pitch       = [1, 1];
    __pitchOption = __VED_OPTION_MULTIPLY;
    
    static __CompilePlay = function(_buffer)
    {
        
    }
    
    static __Serialize = function(_array)
    {
        array_push(_array, {
            name: __name,
        });
    }
    
    static __Deserialize = function(_data)
    {
        __name = _data.name;
    }
    
    static __SetGain = function(_value)
    {
        if (not array_equals(_value, __gain))
        {
            __gain = variable_clone(_value);
            
            //If the two values have inverted then swap 'em over
            if (__gain[0] > __gain[1])
            {
                var _temp = __gain[0];
                __gain[0] = __gain[1];
                __gain[1] = _temp;
            }
        }
    }
    
    static __SetPitch = function(_value)
    {
        if (not array_equals(_value, __pitch))
        {
            __pitch = variable_clone(_value);
            
            //If the two values have inverted then swap 'em over
            if (__pitch[0] > __pitch[1])
            {
                var _temp = __pitch[0];
                __pitch[0] = __pitch[1];
                __pitch[1] = _temp;
            }
        }
    }
    
    static __SetGainOption = function(_value)
    {
        if (_value != __gainOption)
        {
            __gainOption = _value;
            if (__gainOption == __VED_OPTION_MULTIPLY) __SetGain([__gain[0], __gain[0]]);
        }
    }
    
    static __SetPitchOption = function(_value)
    {
        if (_value != __pitchOption)
        {
            __pitchOption = _value;
            if (__pitchOption == __VED_OPTION_MULTIPLY) __SetPitch([__pitch[0], __pitch[0]]);
        }
    }
    
    static __SetGainForce = function(_value)
    {
        if (_value != __gainForce)
        {
            __gainForce = _value;
        }
    }
    
    static __SetPitchForce = function(_value)
    {
        if (_value != __pitchForce)
        {
            __pitchForce = _value;
        }
    }
    
    static __BuildUI = function(_multiselector)
    {
        static _optionArray = [__VED_OPTION_UNSET, __VED_OPTION_MULTIPLY, __VED_OPTION_RANDOMIZE];
        
        ImGui.Text("Shuffle-type pattern");
        ImGui.NewLine();
        
        if (ImGui.BeginTable("Sound", 3, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 110))
        {
            ////Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("", ImGuiTableColumnFlags.WidthFixed, 100);
            ImGui.TableSetupColumn("", ImGuiTableColumnFlags.WidthFixed, 125);
            ImGui.TableSetupColumn("", ImGuiTableColumnFlags.WidthStretch, 1);
            
            //Gain
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Force Gain");
            ImGui.TableSetColumnIndex(1);
            __SetGainForce(ImGui.Checkbox("Force Gain", __gainForce));
            
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Gain");
            
            var _originalOption = __gainOption;
            ImGui.TableSetColumnIndex(1);
            ImGui.SetNextItemWidth(ImGui.GetColumnWidth(1));
            if (ImGui.BeginCombo("##Gain Option " + __name, _originalOption, ImGuiComboFlags.None))
            {
                var _i = 0;
                repeat(array_length(_optionArray))
                {
                    var _optionName = _optionArray[_i];
                    if (ImGui.Selectable(_optionName + "##Gain Option " + __name, (_originalOption == _optionName)))
                    {
                        __SetGainOption(_optionName);
                    }
                    
                    ++_i;
                }
                
                ImGui.EndCombo();
            }
            
            ImGui.TableSetColumnIndex(2);
            switch(__gainOption)
            {
                case __VED_OPTION_UNSET:
                    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(2));
                    ImGui.BeginDisabled(true);
                    var _newValue = ImGui.SliderFloat("##Gain " + __name, 1, 0.01, 2);
                    ImGui.EndDisabled();
                break;
                
                case __VED_OPTION_MULTIPLY:
                    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(2));
                    var _newValue = ImGui.SliderFloat("##Gain " + __name, __gain[0], 0.01, 2);
                    __SetGain([_newValue, _newValue]);
                break;
                
                case __VED_OPTION_RANDOMIZE:
                    var _newValue = variable_clone(__gain);
                    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(2));
                    ImGui.SliderFloat2("##Gain " + __name, _newValue, 0.01, 2);
                    __SetGain(_newValue);
                break;
            }
            
            //Pitch
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Force Pitch");
            ImGui.TableSetColumnIndex(1);
            __SetPitchForce(ImGui.Checkbox("Force Pitch", __pitchForce));
            
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Pitch");
            
            var _originalOption = __pitchOption;
            ImGui.TableSetColumnIndex(1);
            ImGui.SetNextItemWidth(ImGui.GetColumnWidth(1));
            if (ImGui.BeginCombo("##Pitch Option " + __name, _originalOption, ImGuiComboFlags.None))
            {
                var _i = 0;
                repeat(array_length(_optionArray))
                {
                    var _optionName = _optionArray[_i];
                    if (ImGui.Selectable(_optionName + "##Pitch Option " + __name, (_originalOption == _optionName)))
                    {
                        __SetPitchOption(_optionName);
                    }
                    
                    ++_i;
                }
                
                ImGui.EndCombo();
            }
            
            ImGui.TableSetColumnIndex(2);
            switch(__pitchOption)
            {
                case __VED_OPTION_UNSET:
                    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(2));
                    ImGui.BeginDisabled(true);
                    var _newValue = ImGui.SliderFloat("##Pitch " + __name, 1, 0.01, 2);
                    ImGui.EndDisabled();
                break;
                
                case __VED_OPTION_MULTIPLY:
                    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(2));
                    var _newValue = ImGui.SliderFloat("##Pitch " + __name, __pitch[0], 0.01, 2);
                    __SetPitch([_newValue, _newValue]);
                break;
                
                case __VED_OPTION_RANDOMIZE:
                    var _newValue = variable_clone(__pitch);
                    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(2));
                    ImGui.SliderFloat2("##Pitch " + __name, _newValue, 0.01, 2);
                    __SetPitch(_newValue);
                break;
            }
            
            ImGui.EndTable();
        }
    }
}