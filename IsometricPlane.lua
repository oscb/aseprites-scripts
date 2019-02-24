app.transaction(
  function()
    -- TODO All these should be options in a dialog
    local spacing = 7
    local brushSize = 1
    local slope = 3
    local color = Color{ r=0, g=0, b=255 }
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
    local scanSize = brushSize
    if slope > 0 then 
      scanSize = scanSize * slope
    end

    local realSpacing = spacing + scanSize
    app.alert("Spacing="..spacing.." RealSpacing="..realSpacing.." ScanSize="..scanSize)

    -- Instead of drawing each line individually I can "scan" each line
    -- in the image and draw individual pixels with the correct displacement and overflow

    -- TODO: For complete isometric do it again but in reverse, with another color
    -- TODO: Fix Brush size in y + slope < 0 (deltaY)
    local x = 0
    local size = scanSize
    for y=bottom, 0, -1 do

      while x < sprite.width do
        if size > 0 then
          app.activeImage:putPixel(x, y, color)
          x = x + 1
          size = size - 1
        else 
          x = x + spacing
          size = scanSize
        end
      end
      -- Preemptively check for the next run
      initialX = (initialX + scanSize) % realSpacing
      if initialX + scanSize >= realSpacing then
        size = (initialX + scanSize) % realSpacing
        x = 0
      else 
        size = scanSize
        x = initialX
      end
    end
end)