cmake_minimum_required(VERSION 3.18)

# -----------------------------------------------------------------------------
# Core "bag of usage requirements" your main target links to
# -----------------------------------------------------------------------------
add_library(ext_third_party INTERFACE)

# List of runtime files to bubble up to parent
set(_EXT_TP_RUNTIME_DLLS "")

# Helper macro to append runtime(s)
function(_ext_tp_append_runtime)
  foreach(_f IN LISTS ARGN)
    if(_f)
      list(APPEND _EXT_TP_RUNTIME_DLLS "${_f}")
    endif()
  endforeach()
  set(_EXT_TP_RUNTIME_DLLS
      "${_EXT_TP_RUNTIME_DLLS}"
      PARENT_SCOPE)
endfunction()

# =============================================================================
# WINDOWS (MSVC/ClangCL)
# =============================================================================
if(WIN32)
# =============================================================================
# APPLE: split macOS vs iOS/tvOS
# =============================================================================
elseif(APPLE)

  # ----------------------
  # iOS (mobile)
  # ----------------------
  if(CMAKE_OSX_SYSROOT MATCHES "iphone")
    # The GameMaker Xcode project (set via EXT_GM_XCODEPROJ_OVERRIDE in
    # src/CMakeLists.txt) is where `pod install` drops the Facebook SDK.
    # Its parent folder holds the CocoaPods `Pods/` tree.
    get_filename_component(_GM_PARENT_DIR "${EXT_GM_XCODEPROJ_OVERRIDE}" DIRECTORY)
    set(_PODS_DIR "${_GM_PARENT_DIR}/Pods")

    if(NOT EXISTS "${_PODS_DIR}")
      message(FATAL_ERROR
        "[third_party] CocoaPods folder not found: ${_PODS_DIR}\n"
        "Run `pod install` in the GameMaker Xcode project first "
        "(EXT_GM_XCODEPROJ_OVERRIDE = ${EXT_GM_XCODEPROJ_OVERRIDE}).")
    endif()

    # Pick device vs simulator slice for the current SDK. CMAKE_OSX_SYSROOT can
    # be a short SDK name or an absolute SDK path and its case is not guaranteed.
    string(TOLOWER "${CMAKE_OSX_SYSROOT}" _OSX_SYSROOT_LOWER)
    if(_OSX_SYSROOT_LOWER MATCHES "simulator")
      set(_WANT_SIMULATOR TRUE)
    else()
      set(_WANT_SIMULATOR FALSE)
    endif()

    # -------------------------------------------------------------------------
    # Locate a CocoaPods-vendored .xcframework by name. Do not hardcode slice
    # folder names: older Facebook SDKs used names such as ios-arm64_armv7 and
    # ios-arm64_i386_x86_64-simulator, while newer releases use ios-arm64 and
    # ios-arm64_x86_64-simulator.
    # -------------------------------------------------------------------------
    function(_ext_tp_link_pod_xcframework _pod_dir _xcf_name _fw_name _required)
      # Bound the search to the pod's own folder when present; fall back to the
      # whole Pods tree if the vendor uses an unexpected layout.
      set(_search_root "${_PODS_DIR}/${_pod_dir}")
      if(NOT EXISTS "${_search_root}")
        set(_search_root "${_PODS_DIR}")
      endif()

      file(GLOB_RECURSE _entries LIST_DIRECTORIES TRUE "${_search_root}/*")
      set(_xcf "")
      foreach(_c IN LISTS _entries)
        if(IS_DIRECTORY "${_c}" AND _c MATCHES "/${_xcf_name}$")
          set(_xcf "${_c}")
          break()
        endif()
      endforeach()

      if(NOT _xcf)
        if(_required)
          message(FATAL_ERROR
            "[third_party] Missing ${_xcf_name} under: ${_search_root}\n"
            "Run `pod install` so the Facebook SDK is available.")
        else()
          message(STATUS
            "[third_party] Optional ${_xcf_name} not found under ${_search_root} (skipping)")
          return()
        endif()
      endif()

      # Discover the real framework slices supplied by this XCFramework.
      file(GLOB_RECURSE _xcf_entries LIST_DIRECTORIES TRUE "${_xcf}/*")
      set(_slice "")
      set(_available_slices "")
      foreach(_c IN LISTS _xcf_entries)
        if(IS_DIRECTORY "${_c}" AND _c MATCHES "/${_fw_name}\.framework$")
          get_filename_component(_candidate_slice "${_c}" DIRECTORY)
          get_filename_component(_slice_name "${_candidate_slice}" NAME)
          string(TOLOWER "${_slice_name}" _slice_name_lower)
          list(APPEND _available_slices "${_slice_name}")

          # Never select the Mac Catalyst variant for an iPhone/iPad build.
          if(_slice_name_lower MATCHES "maccatalyst")
            continue()
          endif()

          if(_WANT_SIMULATOR)
            if(_slice_name_lower MATCHES "simulator")
              set(_slice "${_candidate_slice}")
            endif()
          else()
            if(_slice_name_lower MATCHES "^ios-" AND
               NOT _slice_name_lower MATCHES "simulator")
              set(_slice "${_candidate_slice}")
            endif()
          endif()
        endif()
      endforeach()
      list(REMOVE_DUPLICATES _available_slices)

      if(_WANT_SIMULATOR)
        set(_wanted_platform "iOS Simulator")
      else()
        set(_wanted_platform "iOS device")
      endif()

      if(NOT _slice OR NOT EXISTS "${_slice}/${_fw_name}.framework")
        if(_required)
          message(FATAL_ERROR
            "[third_party] Could not find a compatible ${_fw_name}.framework slice.\n"
            "XCFramework: ${_xcf}\n"
            "Available slices: ${_available_slices}\n"
            "Wanted: ${_wanted_platform}\n"
            "Sysroot: ${CMAKE_OSX_SYSROOT}")
        else()
          message(STATUS
            "[third_party] Optional ${_fw_name} has no compatible slice "
            "for ${CMAKE_OSX_SYSROOT}; available: ${_available_slices} (skipping)")
          return()
        endif()
      endif()

      message(STATUS "[third_party] Using ${_fw_name}: ${_slice}")

      # -F is needed for both compilation/module lookup and linking.
      target_compile_options(ext_third_party INTERFACE "-F${_slice}")
      target_link_options(ext_third_party INTERFACE "-F${_slice}")
      target_link_libraries(ext_third_party INTERFACE "-framework" "${_fw_name}")
    endfunction()

    # Facebook SDK frameworks and dependencies (link in order)
    # FBSDKCoreKit_Basics (optional - may be bundled with FBSDKCoreKit)
    _ext_tp_link_pod_xcframework(
      "FBSDKCoreKit_Basics" "FBSDKCoreKit_Basics.xcframework" "FBSDKCoreKit_Basics" FALSE)
    # FBAEMKit depends on FBSDKCoreKit_Basics
    _ext_tp_link_pod_xcframework(
      "FBAEMKit" "FBAEMKit.xcframework" "FBAEMKit" TRUE)
    # FBSDKCoreKit is the main framework
    _ext_tp_link_pod_xcframework(
      "FBSDKCoreKit" "FBSDKCoreKit.xcframework" "FBSDKCoreKit" TRUE)
    # FBSDKLoginKit for authentication
    _ext_tp_link_pod_xcframework(
      "FBSDKLoginKit" "FBSDKLoginKit.xcframework" "FBSDKLoginKit" TRUE)
    # FBSDKShareKit for sharing (optional)
    _ext_tp_link_pod_xcframework(
      "FBSDKShareKit" "FBSDKShareKit.xcframework" "FBSDKShareKit" FALSE)

  # ----------------------
  # macOS (desktop)
  # ----------------------
  else()
  endif() # macOS

# =============================================================================
# ANDROID (the Facebook SDK arrives via <YYAndroidGradleDependencies>, not here)
# =============================================================================
elseif(ANDROID)
# =============================================================================
# LINUX
# =============================================================================
elseif(UNIX)
endif()

# =============================================================================
# Bubble up runtime list to parent
# =============================================================================
set(EXT_TP_RUNTIME_DLLS "${_EXT_TP_RUNTIME_DLLS}" PARENT_SCOPE)
