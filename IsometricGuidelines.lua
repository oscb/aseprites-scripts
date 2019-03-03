local maxSize = {
  x = app.activeSprite.width, 
  y = app.activeSprite.height, 
}


local defaults = {
  xSize= 2,
  ySize= 1,
  spacing= 10,
  opacity= 255/2,
  reverse = false,
  color = Color{r=0, g=0, b=0},

}

local function createLayer(sprite, name, opacity)
  local layer = sprite:newLayer()
  layer.name = name
  layer.isEditable = false
  layer.isContinuous = true
  layer.opacity = opacity
  local cel = sprite:newCel(layer, 1)
  return layer
end

-- Instead of drawing each line individually I can "scan" each line
-- in the image and draw individual pixels with the correct displacement and overflow
local function drawGuidelines(xSize, ySize, spacing, width, height, color, reverse)
  local initialY = height-1
  local initialX = 0
  local xSpacing = spacing + xSize

  local x = 0
  local nextSize = xSize
  for y=initialY, 0, -1 do
    while x < width do
      local xt = not reverse and x or width - x -1

      if nextSize > 0 then
        app.activeImage:putPixel(xt, y, color)
        x = x + 1
        nextSize = nextSize - 1
      else 
        x = x + spacing
        nextSize = xSize
      end
    end
    if (initialY-y+1) % ySize == 0 then
      -- Set values for next line
      initialX = (initialX + xSize) % xSpacing
      if initialX + xSize >= xSpacing then
        nextSize = (initialX + xSize) % xSpacing
        x = 0
      else 
        nextSize = xSize
        x = initialX
      end
    else
      nextSize = xSize
      x = initialX
    end
  end
end


local dlg = Dialog("Isometric Guidelines")
dlg   :separator{ text="Slope:" }
      :slider {id="xSize", label="X Size:", min=0, max=maxSize.x, value=defaults.xSize}
      :slider {id="ySize", label="Y Size:", min=0, max=maxSize.y, value=defaults.ySize}
      :slider {id="spacing", label="Spacing:", min=1, max=maxSize.x, value=defaults.spacing}

      :separator()
      :radio {id="direction", label="Direction:", text="L -> R", selected=not defaults.reverse}
      :radio {id="reverse", text="R -> L", selected=defaults.reverse}

      :separator{ text="Appearance:" }
      :color {id="color", label="Stroke:", color = defaults.color}
      :slider {id="opacity", label="Opacity:", min=0, max=255, value=defaults.opacity}

      :separator()
      :button {id="ok", text="Add Guideline",onclick=function()
          local data = dlg.data
          app.transaction(function()
            local spacing = data.spacing
            local xSize = data.xSize
            local ySize = data.ySize
            local color = data.color
            local opacity = data.opacity
            local reverse = data.reverse

            local sprite = app.activeSprite
            local layer = createLayer(sprite, "Guidelines(x"..xSize.."y"..ySize..")", opacity)

            drawGuidelines(xSize, ySize, spacing, sprite.width, sprite.height, color, reverse)
          end)
          --Refresh screen
          app.command.Undo()
          app.command.Redo()
        end
      }
      :show{wait=false}