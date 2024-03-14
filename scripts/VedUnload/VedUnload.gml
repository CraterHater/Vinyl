// Feather disable all

function VedUnload()
{
    static _system = __VedSystem();
    with(_system)
    {
        if (__project != undefined)
        {
            __project.__Unload();
            __project = undefined;
        }
        
        var _i = 0;
        repeat(array_length(__windowsArray))
        {
            __windowsArray[_i].__Close();
            ++_i;
        }
        
        var _i = 0;
        repeat(array_length(__modalsArray))
        {
            __modalsArray[_i].__Close();
            ++_i;
        }
        
        array_resize(__windowsArray, 0);
        array_resize(__modalsArray, 0);
        
        __VedWindowOpenSingle(__VedClassWindowDesktop);
    }
}