add_custom_target(BootTest
    ALL
    COMMAND echo "boot test clean"
    COMMAND ${CMAKE_COMMAND} -E remove
            ${PROJECT_BINARY_DIR}/test/bootloader/boot.img

    COMMAND echo "copy bochs.conf"
    COMMAND ${CMAKE_COMMAND} -E copy
            ${PROJECT_SOURCE_DIR}/test/bootloader/bochs.conf
            ${PROJECT_BINARY_DIR}/test/bootloader/bochs.conf

    COMMAND echo "creating boot image"
    COMMAND bximage -fd -size=1.44 boot.img -q

    COMMAND echo "copying boot.bin"
    COMMAND ${CMAKE_COMMAND} -E copy
            ${PROJECT_BINARY_DIR}/bootloader/boot.bin
            ${PROJECT_BINARY_DIR}/test/bootloader/boot.bin

    COMMAND echo "writing boot.img"
    COMMAND dd if=boot.bin of=boot.img bs=512 count=1 conv=notrunc
    DEPENDS BootBin
)
