cmake_minimum_required(VERSION 3.0)

project(lottie-qml VERSION 1.0)

find_package(ECM 5.42.0 REQUIRED NO_MODULE)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})

include(KDEInstallDirs)

find_package(Qt5 ${REQUIRED_QT_VERSION} REQUIRED NO_MODULE COMPONENTS Quick)

add_subdirectory(src)
