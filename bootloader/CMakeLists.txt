enable_language(ASM_NASM)

add_custom_target(
    BootBin
    ALL
    COMMAND echo "building boot.bin"
    COMMAND nasm -o ${PROJECT_BINARY_DIR}/bootloader/boot.bin 
            ${PROJECT_SOURCE_DIR}/bootloader/boot.asm
    COMMENT "building boot.bin"
    SOURCES ${PROJECT_SOURCE_DIR}/bootloader/boot.asm
) 