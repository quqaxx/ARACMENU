-- Arac menusu (calisan surum, gorsel tasarim sonra).
-- Mantik: sunucu her slotun durumunu yayinlar; oyuncu bir modeli secince
-- ac.reconnectTo{ carID = model } ile ayni sunucuya o modelle yeniden baglanir.

local cars = {}          -- [slot] = { model, skin, taken }
local search = ''
local visible = false
local reconnecting = false

ac.OnlineEvent({
  ac.StructItem.key('carMenuState'),
  slot  = ac.StructItem.byte(),
  model = ac.StructItem.string(64),
  skin  = ac.StructItem.string(64),
  taken = ac.StructItem.byte(),
}, function (sender, data)
  cars[data.slot] = { model = data.model, skin = data.skin, taken = data.taken == 1 }
end)

-- slotlari modele gore grupla: { model, total, used }
local function groupByModel()
  local byModel, list = {}, {}
  for _, c in pairs(cars) do
    local g = byModel[c.model]
    if not g then
      g = { model = c.model, total = 0, used = 0 }
      byModel[c.model] = g
      list[#list + 1] = g
    end
    g.total = g.total + 1
    if c.taken then g.used = g.used + 1 end
  end
  table.sort(list, function (a, b) return a.model:lower() < b.model:lower() end)
  return list
end

local function pick(model)
  if reconnecting then return end
  reconnecting = true
  ac.log('CarMenu: yeniden baglaniliyor -> ' .. model)
  ac.reconnectTo({ carID = model })
end

function script.drawUI()
  if ui.keyboardButtonPressed(ui.KeyIndex.F6, false) then visible = not visible end
  if not visible then return end

  local current = ac.getCarID(0)

  ui.toolWindow('CarMenu', vec2(100, 100), vec2(420, 520), function ()
    ui.text('Mevcut arac: ' .. tostring(current))
    search = ui.inputText('Arac ara...', search)
    ui.separator()
    for _, g in ipairs(groupByModel()) do
      if search == '' or g.model:lower():find(search:lower(), 1, true) then
        local free = g.total - g.used
        ui.text(g.model .. '   ' .. g.used .. '/' .. g.total)
        ui.sameLine(300)
        if g.model == current then
          ui.textDisabled('MEVCUT')
        elseif free > 0 then
          if ui.button('SEC##' .. g.model) then pick(g.model) end
        else
          ui.textDisabled('DOLU')
        end
      end
    end
  end)
end
