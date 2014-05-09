// MatLabDM.h : main header file for the MatLabDM DLL
//
 

//#define EOF (-1)
 
#ifdef __cplusplus    // If used by C++ code, 
extern "C" {          // we need to export the C interface
#endif
 
__declspec(dllexport) int DMOpen(char* filename, int filetype);
__declspec(dllexport) int DMIsOpen(int DMid);

__declspec(dllexport) void DMClose(int DMid);
__declspec(dllexport) void DMCloseAll();

__declspec(dllexport) int DMSave(int DMid, char* filename);

__declspec(dllexport) mxArray* DMGetFileName(int DMid);
__declspec(dllexport) void     DMSetFileName(int DMid, char* filename);

__declspec(dllexport) mxArray* DMReadProjection(int DMid);

__declspec(dllexport) mxArray* DMReadItemDefs(int DMid);

__declspec(dllexport) int DMReadNumDims(int DMid);
__declspec(dllexport) int DMReadNumElmts(int DMid);
__declspec(dllexport) int DMReadNumNodes(int DMid);
__declspec(dllexport) int DMReadNumLayers(int DMid);
__declspec(dllexport) mxArray* DMReadRegSizes(int DMid);

__declspec(dllexport) mxArray* DMReadTemporalDef(int DMid);
__declspec(dllexport) mxArray* DMReadTemporalStartEnd(int DMid);
__declspec(dllexport) mxArray* DMReadTime(int DMid, int timestepno);

__declspec(dllexport) mxArray* DMReadElmts(int DMid);

__declspec(dllexport) mxArray* DMReadNodes(int DMid);

__declspec(dllexport) mxArray* DMReadElmtNodeConnectivity(int DMid);

__declspec(dllexport) mxArray* DMReadItemTimestep(int DMid, int itemno, int timestepno);

__declspec(dllexport) int DMWriteItemTimestep(int DMid, int itemno, int timestepno, mxArray* mxval);

#ifdef __cplusplus
}
#endif