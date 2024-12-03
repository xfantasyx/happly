#!/bin/bash
TARGET=fmt_11_0_2
TARGET_CMAKE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TARGET_SOURCE_DIR=${TARGET_CMAKE_DIR}

# you need export : "ARCH", "ROOT_DIR",
# option dir: "INSTALL_DIR", "BUILD_GEN_DIR" "UPLOAD_URL"
__arch=
__root_dir=
__install_dir=
__build_gen_dir=
__upload_url=


if [ -n "${ARCH}" ]; then
   __arch=${ARCH}
else
   __arch="x64"
fi

if [ -n "${ROOT_DIR}" ]; then
   __root_dir=${ROOT_DIR}
else
   __root_dir=${TARGET_CMAKE_DIR}
fi

if [ -n "${INSTALL_DIR}" ]; then
   __install_dir=${INSTALL_DIR}
else
   __install_dir=${__root_dir}/install/vs2019/sdk
fi

if [ -n "${BUILD_GEN_DIR}" ]; then
   __build_gen_dir=${BUILD_GEN_DIR}
else
   __build_gen_dir=${__root_dir}/build_generated/vs2019
fi

if [ -n "${UPLOAD_URL}" ]; then
   __upload_url=${UPLOAD_URL}
fi


echo TARGET_CMAKE_DIR:$TARGET_CMAKE_DIR
echo TARGET_SOURCE_DIR:${TARGET_SOURCE_DIR}
echo INSTALL_DIR:${__install_dir}
echo BUILD_GENERATE_DIR:${__build_gen_dir}

echo "*** start build ${TARGET} ***"
   
install_path="${__install_dir}/${TARGET}"
build_path="${__build_gen_dir}/${TARGET}"

echo "install_path=${install_path}"
echo "build_path=${build_path}"

# rm exsit install
if [ -e "${install_path}" ]; then
   rm -rf ${install_path}
fi
# rm exsit generated
if [ -e "${build_path}" ]; then
   rm -rf ${build_path}
fi

# make generated dir
mkdir -p  ${build_path}

cd ${build_path}

cmake -G "Visual Studio 16 2019" \
   -A "${__arch}" \
   -DCMAKE_CONFIGURATION_TYPES="Debug;Release;RelWithDebInfo" \
   -DCMAKE_INSTALL_PREFIX="${install_path}" \
   ${TARGET_SOURCE_DIR} || exit 1


# cmake --build . --target install --config Debug -- /maxcpucount:8 || exit 1
cmake --build . --target install --config Release -- /maxcpucount:8 || exit 1
# cmake --build . --target install --config RelWithDebInfo -- /maxcpucount:8 || exit 1

echo "*** build finised ${TARGET} ***"

if [ -n "${__upload_url}" ]; then

   echo "=== start upload ${TARGET} ==="

   cd ${__install_dir}

   set -e

   tar -czvf ${TARGET}.tar.gz ${TARGET}

   shasum -a 256 ${TARGET}.tar.gz > ${TARGET}.tar.gz.sha256

   curl --insecure --ftp-create-dirs -T ${TARGET}.tar.gz ${__upload_url}
   curl --insecure --ftp-create-dirs -T ${TARGET}.tar.gz.sha256 ${__upload_url}

   echo "=== upload finished ${TARGET} ==="
fi








