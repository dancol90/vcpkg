# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT_DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#

include(vcpkg_common_functions)

vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL "https://git.saipem.com/Hydrone/protoc-gen-hyro"
    REF v1.0
    SHA512 f90e50ea6c875dbeb85f1c4d30d7420b107d2c095953d91aac716f54b40cb51e32e35f10e8f9dc8dfebbed8715d31b56d4b6406276043273566f2052da902611
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    # OPTIONS -DUSE_THIS_IN_ALL_BUILDS=1 -DUSE_THIS_TOO=2
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_install_cmake()

file(GLOB EXECUTABLES ${CURRENT_PACKAGES_DIR}/bin/protoc-gen-hyro*)

foreach(E IN LISTS EXECUTABLES)
    file(INSTALL ${E} DESTINATION ${CURRENT_PACKAGES_DIR}/tools/protobuf
         PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_WRITE GROUP_EXECUTE WORLD_READ)
endforeach()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin)

set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)
#set(VCPKG_POLICY_EMPTY_PACKAGE enabled)

# Handle copyright
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/share/protoc-gen-hyro)
file(TOUCH ${CURRENT_PACKAGES_DIR}/share/protoc-gen-hyro/copyright)
# file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/protoc-gen-hyro RENAME copyright)

# Post-build test for cmake libraries
# vcpkg_test_cmake(PACKAGE_NAME protoc-gen-hyro)
