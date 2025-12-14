#!/bin/bash
# Скрипт для генерации PNG иконок из SVG
# Требует установленного ImageMagick или rsvg-convert

SVG_FILE="ru.aurora.contactform.server.svg"
ICON_NAME="ru.aurora.contactform.server.png"

SIZES=(86 108 128 172)

# Проверка наличия инструментов
if command -v rsvg-convert &> /dev/null; then
    CONVERTER="rsvg"
elif command -v convert &> /dev/null; then
    CONVERTER="imagemagick"
elif command -v inkscape &> /dev/null; then
    CONVERTER="inkscape"
else
    echo "Ошибка: не найден конвертер SVG -> PNG"
    echo "Установите один из: librsvg, ImageMagick, Inkscape"
    echo ""
    echo "macOS:   brew install librsvg"
    echo "Ubuntu:  sudo apt install librsvg2-bin"
    echo "Fedora:  sudo dnf install librsvg2-tools"
    exit 1
fi

echo "Используется конвертер: $CONVERTER"

for SIZE in "${SIZES[@]}"; do
    OUTPUT_DIR="${SIZE}x${SIZE}"
    OUTPUT_FILE="${OUTPUT_DIR}/${ICON_NAME}"
    
    echo "Генерация ${OUTPUT_FILE}..."
    
    case $CONVERTER in
        rsvg)
            rsvg-convert -w $SIZE -h $SIZE "$SVG_FILE" -o "$OUTPUT_FILE"
            ;;
        imagemagick)
            convert -background none -resize ${SIZE}x${SIZE} "$SVG_FILE" "$OUTPUT_FILE"
            ;;
        inkscape)
            inkscape -w $SIZE -h $SIZE "$SVG_FILE" -o "$OUTPUT_FILE"
            ;;
    esac
    
    if [ -f "$OUTPUT_FILE" ]; then
        echo "  ✓ Создан: $OUTPUT_FILE"
    else
        echo "  ✗ Ошибка создания: $OUTPUT_FILE"
    fi
done

echo ""
echo "Готово! Иконки созданы."


