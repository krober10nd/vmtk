##############################################################################
#
# Library:   VMTK
#
##############################################################################
include( ExternalProject )

SET(SUPERBUILD_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/Install CACHE PATH
    "Path where all targets will be installed.")

set( base "${CMAKE_BINARY_DIR}" )
set_property( DIRECTORY PROPERTY EP_BASE ${base} )

#set( shared ON )
#if ( BUILD_SHARED_LIBS )
#  set( shared "${BUILD_SHARED_LIBS}" )
#endif()
#set( testing OFF )
#set( examples OFF )
#set( build_type "Debug" )
#if( CMAKE_BUILD_TYPE )
#  set( build_type "${CMAKE_BUILD_TYPE}" )
#endif()

set( VMTK_DEPENDS "" )

set( gen "${CMAKE_GENERATOR}" )

FIND_PACKAGE( PythonInterp )
FIND_PACKAGE( PythonLibs )
 
IF (WIN32) 
  SET( PYTHON_MAJORMINOR ${PYTHON_VERSION_MAJOR}${PYTHON_VERSION_MINOR} )
  STRING( REGEX MATCH "[0-9][0-9]" PYTHON_MIN_MINOR ${PYTHON_EXECUTABLE}  )
  STRING( REGEX MATCH "(.*[/])*" PYTHON_ROOT_DIR ${PYTHON_EXECUTABLE}  )
  FILE( TO_NATIVE_PATH ${PYTHON_ROOT_DIR} PYTHON_ROOT_DIR_NATIVE )
ENDIF (WIN32)
 
##
## Check if sytem ITK or superbuild ITK
##
if( NOT USE_SYSTEM_ITK )

  ##
  ## ITK
  ##
  set( proj ITK )
  ExternalProject_Add( ${proj}
    GIT_REPOSITORY "${GIT_PROTOCOL}://github.com/Kitware/ITK.git"
    SOURCE_DIR "${CMAKE_BINARY_DIR}/ITK"
    BINARY_DIR ITK-Build
    CMAKE_GENERATOR ${gen}
    CMAKE_ARGS
      -Dgit_EXECUTABLE:FILEPATH=${GIT_EXECUTABLE}
      -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES}
      -DCMAKE_CXX_COMPILER:STRING=${CMAKE_CXX_COMPILER}
      #-DCMAKE_CXX_FLAGS:STRING="-fPIC" #${CMAKE_CXX_FLAGS}
      #-DCMAKE_C_FLAGS:STRING="-fPIC" #${CMAKE_C_FLAGS}
      -DCMAKE_EXE_LINKER_FLAGS:STRING=${CMAKE_EXE_LINKER_FLAGS}
      -DCMAKE_SHARED_LINKER_FLAGS:STRING=${CMAKE_SHARED_LINKER_FLAGS}
      -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
      -DCMAKE_INSTALL_PREFIX:PATH=${SUPERBUILD_INSTALL_PREFIX}
      -DITK_USE_FLAT_DIRECTORY_INSTALL:BOOL=${ITK_USE_FLAT_DIRECTORY_INSTALL}
      -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
      #-DBUILD_SHARED_LIBS:BOOL=OFF
      -DCMAKE_RC_COMPILER:BOOL=${CMAKE_RC_COMPILER}
      -DBUILD_EXAMPLES:BOOL=OFF
      -DBUILD_TESTING:BOOL=OFF
      -DITK_USE_REVIEW:BOOL=ON
      -DITK_USE_REVIEW_STATISTICS:BOOL=ON
      -DITK_USE_OPTIMIZED_REGISTRATION_METHODS:BOOL=ON
    INSTALL_DIR "${SUPERBUILD_INSTALL_PREFIX}/ITK"
    )
  set( ITK_DIR "${base}/ITK-Build" )

  set( VMTK_DEPENDS ${VMTK_DEPENDS} "ITK" )

endif( NOT USE_SYSTEM_ITK )

##
## Check if sytem VTK or superbuild VTK
##
if( NOT USE_SYSTEM_VTK )

  if( USE_VTK6_SUPERBUILD )
    set(VTK_GIT_TAG "v6.2.0-vmtk")
  else( USE_VTK6_SUPERBUILD )
    set(VTK_GIT_TAG "v5.10.0-vmtk")
  endif( USE_VTK6_SUPERBUILD )

  ##
  ## VTK
  ##
  set( proj VTK )
  ExternalProject_Add( VTK
    GIT_REPOSITORY "${GIT_PROTOCOL}://github.com/vmtk/VTK.git"
    GIT_TAG ${VTK_GIT_TAG}
    SOURCE_DIR "${CMAKE_BINARY_DIR}/VTK"
    BINARY_DIR VTK-Build
    CMAKE_GENERATOR ${gen}
    CMAKE_ARGS
      -Dgit_EXECUTABLE:FILEPATH=${GIT_EXECUTABLE}
      -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES}
      -DCMAKE_CXX_COMPILER:STRING=${CMAKE_CXX_COMPILER}
      -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
      -DCMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
      -DCMAKE_EXE_LINKER_FLAGS:STRING=${CMAKE_EXE_LINKER_FLAGS}
      -DCMAKE_SHARED_LINKER_FLAGS:STRING=${CMAKE_SHARED_LINKER_FLAGS}
      -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
      -DCMAKE_INSTALL_PREFIX:PATH=${SUPERBUILD_INSTALL_PREFIX}
      -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
      -DVTK_WRAP_PYTHON:BOOL=${VTK_VMTK_WRAP_PYTHON}
      -DVTK_USE_TK:BOOL=OFF
      -DVTK_USE_CARBON:BOOL=${VTK_USE_CARBON}
      -DVTK_USE_COCOA:BOOL=${VTK_VMTK_USE_COCOA}
      -DVTK_USE_INFOVIS:BOOL=${VTK_USE_INFOVIS}
      -DVTK_USE_N_WAY_ARRAYS:BOOL=${VTK_USE_N_WAY_ARRAYS}
      -DVTK_USE_PARALLEL:BOOL=${VTK_USE_PARALLEL}
      -DVTK_USE_QT:BOOL=${VTK_USE_QT}
      -DVTK_USE_RENDERING:BOOL=${VTK_USE_RENDERING}
      -DVTK_USE_HYBRID:BOOL=${VTK_USE_HYBRID}
      -DVTK_USE_TEXT_ANALYSIS:BOOL=${VTK_USE_TEXT_ANALYSIS}
      -DVTK_USE_X:BOOL=${VTK_USE_X}
      -DBUILD_EXAMPLES:BOOL=OFF
      -DBUILD_TESTING:BOOL=OFF
      -DVTK_USE_GUISUPPORT:BOOL=OFF
      -DVTK_INSTALL_PYTHON_USING_CMAKE:BOOL=ON
      -DCMAKE_RC_COMPILER:BOOL=${CMAKE_RC_COMPILER}
      -DPYTHON_DEBUG_LIBRARY=${PYTHON_DEBUG_LIBRARY}
      -DPYTHON_EXECUTABLE=${PYTHON_EXECUTABLE}
      -DPYTHON_INCLUDE_DIR=${PYTHON_INCLUDE_DIR}
      -DPYTHON_LIBRARY=${PYTHON_LIBRARY}
    INSTALL_DIR "${SUPERBUILD_INSTALL_PREFIX}/VTK"
    )
  set( VTK_DIR "${base}/VTK-Build" )

  set( VMTK_DEPENDS ${VMTK_DEPENDS} "VTK" )

endif( NOT USE_SYSTEM_VTK )

##
## VMTK - Normal Build
##
set( proj VMTK )
ExternalProject_Add( ${proj}
  DOWNLOAD_COMMAND ""
  SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}"
  BINARY_DIR VMTK-Build
  CMAKE_GENERATOR ${gen}
  CMAKE_ARGS
    -DBUILDNAME:STRING=${BUILDNAME}
    -DSITE:STRING=${SITE}
    -DMAKECOMMAND:STRING=${MAKECOMMAND}
    -DCMAKE_CXX_COMPILER:STRING=${CMAKE_CXX_COMPILER}
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DBUILD_EXAMPLES:BOOL=${BUILD_EXAMPLES}
    -DBUILD_TESTING:BOOL=${BUILD_TESTING}
    -DBUILD_DOCUMENTATION:BOOL=${BUILD_DOCUMENTATION}
    -DCMAKE_SHARED_LINKER_FLAGS:STRING=${CMAKE_SHARED_LINKER_FLAGS}
    -DCMAKE_EXE_LINKER_FLAGS:STRING=${CMAKE_EXE_LINKER_FLAGS}
    -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES}
    -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
    -DCMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
    -DCMAKE_INSTALL_PREFIX:PATH=${SUPERBUILD_INSTALL_PREFIX}
    -DVTK_VMTK_WRAP_PYTHON:BOOL=${VTK_VMTK_WRAP_PYTHON}
    -DVMTK_USE_SUPERBUILD:BOOL=OFF
    -DVMTK_CONTRIB_SCRIPTS:BOOL=${VMTK_CONTRIB_SCRIPTS}
    -DVTK_VMTK_CONTRIB:BOOL=${VTK_VMTK_CONTRIB}
    -DVMTK_SCRIPTS_ENABLED:BOOL=${VMTK_SCRIPTS_ENABLED}
    -DVMTK_MINIMAL_INSTALL:BOOL=OFF
    -DVMTK_ENABLE_DISTRIBUTION:BOOL=${VMTK_ENABLE_DISTRIBUTION}
    -DVMTK_WITH_LIBRARY_VERSION:BOOL=OFF
    -DVMTK_BUILD_TETGEN:BOOL=${VMTK_BUILD_TETGEN}
    -DVTK_VMTK_USE_COCOA:BOOL=${VTK_VMTK_USE_COCOA}
    -DVMTK_BUILD_STREAMTRACER:BOOL=${VMTK_BUILD_STREAMTRACER}
    -DVTK_REQUIRED_OBJCXX_FLAGS:STRING=${VTK_REQUIRED_OBJCXX_FLAGS}
    -DITK_DIR:PATH=${ITK_DIR}
    -DVTK_DIR:PATH=${VTK_DIR}
    -DCMAKE_RC_COMPILER:BOOL=${CMAKE_RC_COMPILER}
    -DPYTHON_DEBUG_LIBRARY=${PYTHON_DEBUG_LIBRARY}
    -DPYTHON_EXECUTABLE=${PYTHON_EXECUTABLE}
    -DPYTHON_INCLUDE_DIR=${PYTHON_INCLUDE_DIR}
    -DPYTHON_LIBRARY=${PYTHON_LIBRARY}
  INSTALL_DIR "${SUPERBUILD_INSTALL_PREFIX}/vmtk"
  DEPENDS
    ${VMTK_DEPENDS}
 )

SET( VTK_VERSION 5.10 )

SET( VMTK_INSTALL_DIR ${CMAKE_BINARY_DIR}/Install )
FILE( TO_NATIVE_PATH ${VMTK_INSTALL_DIR} VMTK_INSTALL_DIR_NATIVE )

IF (WIN32) 
  #FIND_PACKAGE( PYTHONINTERP )
  #FIND_PACKAGE( PYTHONLIBS )
  #
  #SET( PYTHON_MAJORMINOR ${PYTHON_VERSION_MAJOR}${PYTHON_VERSION_MINOR} )
  #STRING( REGEX MATCH "[0-9][0-9]" PYTHON_MIN_MINOR ${PYTHON_EXECUTABLE}  )
  #STRING( REGEX MATCH "(.*[/])*" PYTHON_ROOT_DIR ${PYTHON_EXECUTABLE}  )
  #FILE( TO_NATIVE_PATH ${PYTHON_ROOT_DIR} PYTHON_ROOT_DIR_NATIVE )
  
  CONFIGURE_FILE( vmtk_startup.bat.in ${VMTK_INSTALL_DIR}/vmtk_startup.bat )
ELSE (WIN32)
  IF (APPLE)
    SET( LIBRARY_PATH_ENV_VAR "DYLD_LIBRARY_PATH")
  ELSE (APPLE)
    SET( LIBRARY_PATH_ENV_VAR "LD_LIBRARY_PATH")
  ENDIF (APPLE)
  CONFIGURE_FILE( vmtk_env.sh.in ${VMTK_INSTALL_DIR}/vmtk_env.sh )
ENDIF (WIN32)

