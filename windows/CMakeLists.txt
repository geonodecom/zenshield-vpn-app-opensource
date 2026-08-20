# Project-level configuration.
cmake_minimum_required(VERSION 3.14)
project(zenshield LANGUAGES CXX)

# The name of the executable created for the application. Change this to change
# the on-disk name of your application.
set(BINARY_NAME "zenshield")

# Build singbox-tunnel.exe and core/zenshield_core.dll from their public
# source repos if not already present (see packaging/build_native.sh) — runs
# once per fresh checkout (first cmake configure), skipped on every later one.
set(ZENSHIELD_TUNNEL_EXE "${CMAKE_CURRENT_SOURCE_DIR}/../singbox-tunnel.exe")
set(ZENSHIELD_CORE_DLL "${CMAKE_CURRENT_SOURCE_DIR}/core/zenshield_core.dll")
if(NOT EXISTS "${ZENSHIELD_TUNNEL_EXE}" OR NOT EXISTS "${ZENSHIELD_CORE_DLL}")
  message(STATUS "Building native tunnel binaries via build_native.sh (first build only)...")
  execute_process(
    COMMAND bash "${CMAKE_CURRENT_SOURCE_DIR}/packaging/build_native.sh"
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    RESULT_VARIABLE ZENSHIELD_NATIVE_BUILD_RESULT
  )
  if(NOT ZENSHIELD_NATIVE_BUILD_RESULT EQUAL 0)
    message(FATAL_ERROR "build_native.sh failed (exit code ${ZENSHIELD_NATIVE_BUILD_RESULT}) — see windows/packaging/build_native.sh")
  endif()
endif()

# Explicitly opt in to modern CMake behaviors to avoid warnings with recent
# versions of CMake.
cmake_policy(VERSION 3.14...3.25)

# Define build configuration option.
get_property(IS_MULTICONFIG GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(IS_MULTICONFIG)
  set(CMAKE_CONFIGURATION_TYPES "Debug;Profile;Release"
    CACHE STRING "" FORCE)
else()
  if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE "Debug" CACHE
      STRING "Flutter build mode" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
      "Debug" "Profile" "Release")
  endif()
endif()
# Define settings for the Profile build mode.
set(CMAKE_EXE_LINKER_FLAGS_PROFILE "${CMAKE_EXE_LINKER_FLAGS_RELEASE}")
set(CMAKE_SHARED_LINKER_FLAGS_PROFILE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE}")
set(CMAKE_C_FLAGS_PROFILE "${CMAKE_C_FLAGS_RELEASE}")
set(CMAKE_CXX_FLAGS_PROFILE "${CMAKE_CXX_FLAGS_RELEASE}")

# Use Unicode for all projects.
add_definitions(-DUNICODE -D_UNICODE)

# Find NuGet for plugins that require it (e.g., flutter_inappwebview_windows)
set(PROGRAM_FILES "$ENV{ProgramFiles}")
set(LOCAL_APPDATA "$ENV{LOCALAPPDATA}")

find_program(NUGET_EXE
  NAMES nuget.exe nuget
  PATHS
    "${PROGRAM_FILES}/NuGet"
    "${LOCAL_APPDATA}/Microsoft/VisualStudio"
    "${PROGRAM_FILES}/Microsoft Visual Studio"
  PATH_SUFFIXES
    "Common7/IDE/CommonExtensions/Microsoft/NuGet"
  NO_DEFAULT_PATH
)

if(NOT NUGET_EXE)
  find_program(NUGET_EXE NAMES nuget.exe nuget)
endif()

if(NOT NUGET_EXE)
  set(NUGET_DOWNLOAD_DIR "${CMAKE_BINARY_DIR}/nuget")
  set(NUGET_EXE "${NUGET_DOWNLOAD_DIR}/nuget.exe")
  
  if(NOT EXISTS "${NUGET_EXE}")
    message(STATUS "NuGet not found. Downloading NuGet...")
    file(MAKE_DIRECTORY "${NUGET_DOWNLOAD_DIR}")
    
    if(CMAKE_SYSTEM_PROCESSOR MATCHES "AMD64|x86_64")
      set(NUGET_URL "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe")
    else()
      set(NUGET_URL "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe")
    endif()
    
    file(DOWNLOAD
      "${NUGET_URL}"
      "${NUGET_EXE}"
      TLS_VERIFY ON
      STATUS DOWNLOAD_STATUS
    )
    
    list(GET DOWNLOAD_STATUS 0 STATUS_CODE)
    if(NOT STATUS_CODE EQUAL 0)
      message(FATAL_ERROR "Failed to download NuGet. Please install NuGet manually from https://www.nuget.org/downloads")
    endif()
  endif()
endif()

if(EXISTS "${NUGET_EXE}")
  message(STATUS "Found NuGet: ${NUGET_EXE}")
  set(NUGET "${NUGET_EXE}" CACHE FILEPATH "Path to NuGet executable" FORCE)
  set(NUGET_EXE "${NUGET_EXE}" CACHE FILEPATH "Path to NuGet executable" FORCE)
else()
  message(FATAL_ERROR "NuGet is required for building flutter_inappwebview_windows plugin. Please install NuGet from https://www.nuget.org/downloads")
endif()

# Compilation settings that should be applied to most targets.
#
# Be cautious about adding new options here, as plugins use this function by
# default. In most cases, you should add new options to specific targets instead
# of modifying this function.
function(APPLY_STANDARD_SETTINGS TARGET)
  target_compile_features(${TARGET} PUBLIC cxx_std_17)
  target_compile_options(${TARGET} PRIVATE /W4 /WX /wd"4100")
  target_compile_options(${TARGET} PRIVATE /EHsc)
  target_compile_definitions(${TARGET} PRIVATE "_HAS_EXCEPTIONS=0")
  target_compile_definitions(${TARGET} PRIVATE "$<$<CONFIG:Debug>:_DEBUG>")
endfunction()

# Flutter library and tool build rules.
set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")
add_subdirectory(${FLUTTER_MANAGED_DIR})

# Application build; see runner/CMakeLists.txt.
add_subdirectory("runner")


# Generated plugin build rules, which manage building the plugins and adding
# them to the application.
include(flutter/generated_plugins.cmake)


# === Installation ===
# Support files are copied into place next to the executable, so that it can
# run in place. This is done instead of making a separate bundle (as on Linux)
# so that building and running from within Visual Studio will work.
set(BUILD_BUNDLE_DIR "$<TARGET_FILE_DIR:${BINARY_NAME}>")
# Make the "install" step default, as it's required to run.
set(CMAKE_VS_INCLUDE_INSTALL_TO_DEFAULT_BUILD 1)
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "${BUILD_BUNDLE_DIR}" CACHE PATH "..." FORCE)
endif()

set(INSTALL_BUNDLE_DATA_DIR "${CMAKE_INSTALL_PREFIX}/data")
set(INSTALL_BUNDLE_LIB_DIR "${CMAKE_INSTALL_PREFIX}")

install(TARGETS ${BINARY_NAME} RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}"
  COMPONENT Runtime)

install(FILES "${FLUTTER_ICU_DATA_FILE}" DESTINATION "${INSTALL_BUNDLE_DATA_DIR}"
  COMPONENT Runtime)

install(FILES "${FLUTTER_LIBRARY}" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
  COMPONENT Runtime)

if(PLUGIN_BUNDLED_LIBRARIES)
  install(FILES "${PLUGIN_BUNDLED_LIBRARIES}"
    DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
    COMPONENT Runtime)
endif()

install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/core/zenshield_core.dll"
  DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
  COMPONENT Runtime
  OPTIONAL)

install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/../singbox-tunnel.exe"
  DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
  COMPONENT Runtime
  OPTIONAL)

install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/msvcp140.dll"
  DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
  COMPONENT Runtime
  OPTIONAL)

install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/vcruntime140_1.dll"
  DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
  COMPONENT Runtime
  OPTIONAL)

install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/vcruntime140.dll"
  DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
  COMPONENT Runtime
  OPTIONAL)

# Copy the native assets provided by the build.dart from all packages.
set(NATIVE_ASSETS_DIR "${PROJECT_BUILD_DIR}native_assets/windows/")
if(EXISTS "${NATIVE_ASSETS_DIR}")
  install(DIRECTORY "${NATIVE_ASSETS_DIR}"
     DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
     COMPONENT Runtime)
endif()

# Fully re-copy the assets directory on each build to avoid having stale files
# from a previous install.
set(FLUTTER_ASSET_DIR_NAME "flutter_assets")
install(CODE "
  file(REMOVE_RECURSE \"${INSTALL_BUNDLE_DATA_DIR}/${FLUTTER_ASSET_DIR_NAME}\")
  " COMPONENT Runtime)
install(DIRECTORY "${PROJECT_BUILD_DIR}/${FLUTTER_ASSET_DIR_NAME}"
  DESTINATION "${INSTALL_BUNDLE_DATA_DIR}" COMPONENT Runtime)

# Install the AOT library on non-Debug builds only.
install(FILES "${AOT_LIBRARY}" DESTINATION "${INSTALL_BUNDLE_DATA_DIR}"
  CONFIGURATIONS Profile;Release
  COMPONENT Runtime)
