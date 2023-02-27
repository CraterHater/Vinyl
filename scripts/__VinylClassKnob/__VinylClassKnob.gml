/// @param name

function __VinylClassKnob(_name) constructor
{
    __name = _name;
    
    __valueDefault = 0;
    __valueReset   = true;
    __valueInput   = 0;
    __valueOutput  = 0;
    
    __rangeFree     = true;
    __rangeInputLo  = 0;
    __rangeInputHi  = 1;
    __rangeOutputLo = 0;
    __rangeOutputHi = 1;
    
    __targetArray = [];
    
    
    
    static toString = function()
    {
        return "<knob " + __name + ">";
    }
    
    static __Initialize = function(_knobData = {})
    {
        if (VINYL_CONFIG_VALIDATE_PROPERTIES && is_struct(_knobData)) __VinylValidateStruct(_knobData, ["default", "input range", "output range"]);
        
        var _rangeInputSet  = false;
        var _rangeOutputSet = false;
        
        if (is_numeric(_knobData))
        {
            __valueDefault = _knobData;
        }
        else if (is_struct(_knobData))
        {
            var _inputRangeArray = _knobData[$ "input range"];
            if (is_array(_inputRangeArray))
            {
                if (array_length(_inputRangeArray) != 2) __VinylError("Error in ", self, "\n\"input range\" property array must have exactly two elements");
                if (!is_numeric(_inputRangeArray[0])) __VinylError("Error in ", self, "\n\"input range\" property array elements must be numbers (index 0 datatype=", typeof(_inputRangeArray[0]), ")");
                if (!is_numeric(_inputRangeArray[1])) __VinylError("Error in ", self, "\n\"input range\" property array elements must be numbers (index 1 datatype=", typeof(_inputRangeArray[1]), ")");
                if (_inputRangeArray[0] == _inputRangeArray[1]) __VinylError("Error in ", self, "\n\"input range\" property array elements must be different numbers");
                
                _rangeInputSet = true;
                __rangeInputLo = _inputRangeArray[0];
                __rangeInputHi = _inputRangeArray[1];
            }
            else if (!is_undefined(_inputRangeArray))
            {
                __VinylError("Error in ", self, "\"\n\"input range\" property must be a two-element array");
            }
            
            var _outputRangeArray = _knobData[$ "output range"];
            if (is_array(_outputRangeArray))
            {
                if (array_length(_outputRangeArray) != 2) __VinylError("Error in ", self, "\n\"output range\" property array must have exactly two elements");
                if (!is_numeric(_outputRangeArray[0])) __VinylError("Error in ", self, "\n\"output range\" property array elements must be numbers (index 0 datatype=", typeof(_outputRangeArray[0]), ")");
                if (!is_numeric(_outputRangeArray[1])) __VinylError("Error in ", self, "\n\"output range\" property array elements must be numbers (index 1 datatype=", typeof(_outputRangeArray[1]), ")");
                if (_outputRangeArray[0] == _outputRangeArray[1]) __VinylError("Error in ", self, "\n\"output range\" property array elements must be different numbers");
                
                _rangeOutputSet = true;
                __rangeOutputLo = _outputRangeArray[0];
                __rangeOutputHi = _outputRangeArray[1];
            }
            else if (!is_undefined(_outputRangeArray))
            {
                __VinylError("Error in ", self, "\"\n\"output range\" property must be a two-element array");
            }
            
            if (!variable_struct_exists(_knobData, "default"))
            {
                __VinylError("Error in ", self, "\"\nKnobs must contain a \"default\" property");
            }
            
            __valueDefault = _knobData[$ "default"];
            
            if (!is_numeric(__valueDefault))
            {
                __VinylError("Error in ", self, "\"\n\"default\" property must be a number");
            }
        }
        else
        {
            __VinylError("Error in ", self, "\"\nKnob must be a number or a struct");
        }
        
        __rangeFree = (!_rangeInputSet && !_rangeOutputSet);
        if (!__rangeFree) __valueDefault = clamp(__valueDefault, __rangeOutputLo, __rangeOutputHi);
        
        __Refresh();
    }
    
    static __Store = function()
    {
        var _knobDict  = __VinylGlobalData().__knobDict;
        var _knobArray = __VinylGlobalData().__knobArray;
        
        _knobDict[$ __name] = self;
        array_push(_knobArray, self);
    }
    
    static __RestoreOldValue = function(_oldKnobDict)
    {
        var _oldKnob = _oldKnobDict[$ __name];
        if (_oldKnob != undefined) __Set(_oldKnob.__InputGet());
    }
    
    static __TargetCreate = function(_scope, _property)
    {
        array_push(__targetArray, new __VinylClassKnobTarget(_scope, _property));
    }
    
    static __Set = function(_value)
    {
        __valueReset = false;
        __valueInput = _value;
        __Refresh();
    }
    
    static __InputGet = function()
    {
        return __valueInput;
    }
    
    static __OutputGet = function()
    {
        return __valueOutput;
    }
    
    static __Reset = function()
    {
        __valueReset = true;
        __Refresh();
    }
    
    static __Refresh = function()
    {
        var _oldOutput = __valueOutput;
        
        if (__valueReset)
        {
            __valueOutput = __valueDefault;
            
            //Remap default value to input
            __valueInput = __rangeFree? __valueOutput : lerp(__rangeInputLo, __rangeInputHi, (__valueOutput - __rangeOutputLo) / (__rangeOutputHi - __rangeOutputLo));
        }
        else
        {
            if (__rangeFree)
            {
                __valueOutput = __valueInput;
            }
            else
            {
                //Remap input value to output
                __valueOutput = lerp(__rangeOutputLo, __rangeOutputHi, clamp((__valueInput - __rangeInputLo) / (__rangeInputHi - __rangeInputLo), 0, 1));
            }
        }
        
        if (_oldOutput != __valueOutput) __UpdateTargets();
    }
    
    static __UpdateTargets = function()
    {
        var _i = 0;
        repeat(array_length(__targetArray))
        {
            var _target = __targetArray[_i];
            _target.__Update(__valueOutput);
            ++_i;
        }
    }
}