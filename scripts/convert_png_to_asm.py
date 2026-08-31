#!/usr/bin/python
from PIL import Image

# CHR image data for the NES
# 
# --HALF NIBBLES--
# COLOR_0 = 0b00
# COLOR_1 = 0b01
# COLOR_2 = 0b10
# COLOR_3 = 0b11
# ...
# 
# A  :: 0b0000_0000 0b0000_0101
# will go to a low bit and a high bit
# ...
# A1 :: 0b0000_0000
# A2 :: 0b0000_0011

FILE_PATH = "./assets/img/B.png"

COLOR_INDEX = [
    0, # means background color - or NULL color
    1, # means color 1
    # ... colors 2 and 3 are unused
]

def loop_through_pixels(image: Image):
    image_width = image.width
    image_height = image.height

    for y in range(image_height):
        for x in range(image_width):

            print(f"X: {hex(x)} Y: {hex(y)} C:", image.getpixel((x, y)))
            

def open_image(img_path):
    with Image.open(img_path) as image:
        loop_through_pixels(image)

### run the program ###
open_image(FILE_PATH)
