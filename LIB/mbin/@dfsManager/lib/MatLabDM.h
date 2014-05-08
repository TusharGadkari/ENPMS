// MatLabDM.h : main header file for the MatLabDM DLL
//
 
__declspec(dllexport) int      DMOpen(char* filename, int filetype);
__declspec(dllexport) int      DMIsOpen(int DMid);
__declspec(dllexport) int      DMIsInitialized(int DMid);

__declspec(dllexport) int      DMCreateSkeleton(char* filename, int filetype, int datatype);
__declspec(dllexport) void     DMCreate(int DMid);

__declspec(dllexport) mxArray* DMGetItemDefs(int DMid);
__declspec(dllexport) void     DMAddItem(int DMid, char* mname, char* mdescr, char* eumtypeid, char* eumunitid, int elmtbased);

__declspec(dllexport) void     DMClose(int DMid);
__declspec(dllexport) void     DMCloseAll();
__declspec(dllexport) int      DMSave(int DMid, char* filename);

__declspec(dllexport) mxArray* DMGetFileName(int DMid);
__declspec(dllexport) void     DMSetFileName(int DMid, char* filename);
__declspec(dllexport) mxArray* DMGetFileTitle(int DMid);
__declspec(dllexport) void     DMSetFileTitle(int DMid, char* filedescr);
__declspec(dllexport) mxArray* DMGetFileDescr(int DMid);
__declspec(dllexport) void     DMSetFileDescr(int DMid, char* filetitle);

__declspec(dllexport) mxArray* DMGetProjection(int DMid);

__declspec(dllexport) int      DMSetSpatialDefReg(int DMid, char* proj, mxArray* mxorigo, double orientation, int dim, mxArray* mxspatial);
__declspec(dllexport) int      DMSetSpatialDefFEM(int DMid, char* proj, mxArray* mxElmts, mxArray* mxNodes, int ndim, int nlayers);
__declspec(dllexport) mxArray* DMGetBathymetry(int DMid);
__declspec(dllexport) void     DMSetBathymetry(int DMid, mxArray* mxval);

__declspec(dllexport) int      DMGetNumDims(int DMid);
__declspec(dllexport) int      DMGetNumElmts(int DMid);
__declspec(dllexport) int      DMGetNumNodes(int DMid);
__declspec(dllexport) int      DMGetNumLayers(int DMid);
__declspec(dllexport) mxArray* DMGetGeoOrigin(int DMid);
__declspec(dllexport) double   DMGetOrientation(int DMid);
//__declspec(dllexport) void     DMSetOrientation(int DMid, double orientation);
__declspec(dllexport) mxArray* DMGetRegOrigin(int DMid);
__declspec(dllexport) mxArray* DMGetRegSizes(int DMid);
__declspec(dllexport) mxArray* DMGetRegSpacing(int DMid);

__declspec(dllexport) int      DMCreateTemporalDef(int DMid, int timeaxistype, mxArray* mxstartdate, int numtimesteps, double timestepsec);
__declspec(dllexport) mxArray* DMGetTemporalDef(int DMid);
__declspec(dllexport) mxArray* DMGetTemporalStartEnd(int DMid);
__declspec(dllexport) mxArray* DMGetTime(int DMid, int timestepno);
__declspec(dllexport) void     DMSetTime(int DMid, int timestepno, mxArray* mxdate);

__declspec(dllexport) mxArray* DMGetElmts(int DMid);
__declspec(dllexport) mxArray* DMGetNodes(int DMid);
__declspec(dllexport) mxArray* DMGetElmtNodeConnectivity(int DMid);

__declspec(dllexport) mxArray* DMGetItemTimestep(int DMid, int itemno, int timestepno);
__declspec(dllexport) int      DMSetItemTimestep(int DMid, int itemno, int timestepno, mxArray* mxval);
__declspec(dllexport) mxArray* DMGetSpatialItemTimestep(int DMid, int itemno, int timestepno);
__declspec(dllexport) int      DMSetSpatialItemTimestep(int DMid, int itemno, int timestepno, mxArray* mxval);

__declspec(dllexport) mxArray* DMItemTypeGetAll();
__declspec(dllexport) mxArray* DMItemTypeGetUnits(const char* itemid);
__declspec(dllexport) mxArray* DMUnitGetAll();
__declspec(dllexport) mxArray* DMUnitGetAbbr(char * unitid);

__declspec(dllexport) mxArray* DMTest1(int in);
__declspec(dllexport) mxArray* DMTest2(int in);
