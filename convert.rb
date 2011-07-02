require 'RMagick'

require 'nil/file'

def convertImage(imagePath, asciiPath)
  bytes = "\xdb\xb2\xb1\xb0 "

  image = Magick::Image.read(imagePath).first
  width = image.columns
  height = image.rows
  pixels = image.dispatch(0, 0, width, height, 'I', true)
  output = ''
  height.times do |y|
    line = ''
    width.times do |x|
      pixel = pixels[x + y * width]
      #invert
      pixel = 1.0 - pixel
      index = (pixel * (bytes.size - 1)).round
      line += bytes[index]
    end
    line += "\r\n" if y < height - 1
    output += line
  end
  Nil.writeFile(asciiPath, output)
end

if ARGV.size != 2
  puts 'Usage:'
  puts "ruby #{File.basename(__FILE__)} <image> <ASCII output>"
  exit
end

imagePath = ARGV[0]
asciiPath = ARGV[1]

convertImage(imagePath, asciiPath)
