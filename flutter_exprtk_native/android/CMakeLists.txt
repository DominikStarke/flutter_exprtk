cmake_minimum_required(VERSION 3.4.1)

add_library(flutter_exprtk_native SHARED
        ../ios/Classes/flutter_exprtk.cpp)

target_link_libraries(flutter_exprtk_native PRIVATE)