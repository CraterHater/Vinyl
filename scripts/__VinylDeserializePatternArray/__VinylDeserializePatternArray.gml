// Feather disable all

/// @param array
/// @param document
/// @param parent

function __VinylDeserializePatternArray(_inputArray, _document, _parent)
{
    var _outputArray = [];    
    
    var _i = 0;
    repeat(array_length(_inputArray))
    {
        var _input = _inputArray[_i];
        var _constructor = __VinylConvertPatternNameToConstructor(_input.type, _input.name);
        
        var _new = new _constructor();
        _new.__Deserialize(_input, _parent);
        
        if (_document != undefined)
        {
            _new.__Store(_document);
        }
        
        ++_i;
    }
    
    return _outputArray;
}