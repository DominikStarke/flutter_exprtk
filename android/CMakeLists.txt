cmake_minimum_required(VERSION 3.4.1)  # for example

add_library(flutter_exprtk SHARED
        ../ios/Classes/flutter_exprtk.cpp)

target_link_libraries(flutter_exprtk PRIVATE android log)