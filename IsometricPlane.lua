app.transaction(
  function()
    -- TODO All these should be options in a dialog
    local spacing = 7
    local brushSize = 1
    local slope = -3
    local color = Color{ r=0, g=255, b=0 }
    local isContinuous = true
    local opacity = 255/2

    local sprite = app.activeSprite
    local layer = sprite:newLayer()
    layer.name = "Baselines("..brushSize.."x"..spacing.."x"..slope..")"
    layer.isEditable = false
    layer.isContinuous = isContinuous
    layer.opacity = opacity
    local cel = sprite:newCel(layer, 1)

    local bottom = sprite.height-1
    local initialX = 0
    local scanXSize = brushSize
    local scanYSize = 1
    
    if slope > 0 then 
      scanXSize = scanXSize * slope
    elseif slope < 0 then
      scanYSize = scanYSize * slope * -1
    end

    local realSpacing = spacing + scanXSize

    -- Instead of drawing each line individually I can "scan" each line
    -- in the image and draw individual pixels with the correct displacement and overflow

    -- TODO: For complete isometric do it again but in reverse, with another color
    local x = 0
    local size = scanXSize
    for y=bottom, 0, -1 do

      while x < sprite.width do
        if size > 0 then
          app.activeImage:putPixel(x, y, color)
          x = x + 1
          size = size - 1
        else 
          x = x + spacing
          size = scanXSize
        end
      end
      if (bottom-y+1) % scanYSize == 0 then
        -- Set values for next line
        initialX = (initialX + scanXSize) % realSpacing
        if initialX + scanXSize >= realSpacing then
          size = (initialX + scanXSize) % realSpacing
          x = 0
        else 
          size = scanXSize
          x = initialX
        end
      else
        size = scanXSize
        x = initialX
      end
    end
end)