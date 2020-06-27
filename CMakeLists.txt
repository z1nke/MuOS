cmake_minimum_required(VERSION 3.5)

project(
    MuOS 
    VERSION 0.0.1
    DESCRIPTION "Mini unix-like Operating System for x64 architecture"
    LANGUAGES C ASM
)

add_subdirectory(bootloader)