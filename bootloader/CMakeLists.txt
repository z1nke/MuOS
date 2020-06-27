enable_language(ASM_NASM)

add_custom_target(
    BootImg
    ALL
    COMMAND echo "building boot.img"
    COMMAND nasm -o ${PROJECT_BINARY_DIR}/bootloader/boot.img 
            ${PROJECT_SOURCE_DIR}/bootloader/boot.asm
    COMMENT "building boot.img"
    SOURCES ${PROJECT_SOURCE_DIR}/bootloader/boot.asm
) 