// Feather disable all

/// @param yyPath
/// @param [showEditor=true]
/// @param [showPopUp=true]

function VedLoad(_yyPath, _show = true, _showPopUp = true)
{
    static _system = __VedSystem();
    
    VedUnload();
    _system.__project = new __VedClassProject();
    if (not _system.__project.__LoadFromGameMakerProject(_yyPath, _showPopUp)) return false;
    
    if (_show) VedShow();
    
    return true;
}