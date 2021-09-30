-- incredible-gmod.ru

function ColorConstruct(r, g, b, a)
	if IsColor(r) then
		return r
	end

	return Color(r, g, b, a)
end

function AddProperty(self, name, construct)
	if construct then
		self["Set".. name] = function(me, ...)
			me[name] = construct(...)
		end
	else
		self["Set".. name] = function(me, val)
			me[name] = val
		end
	end

	self["Get".. name] = function(me)
		return me[name]
	end

	if #{...} > 0 and not self[name] then
		self[name] = construct and construct(...) or ...
	end
end


local PANEL = {}

AddProperty(PANEL, "Color", ColorConstruct, 255, 255, 255)
AddProperty(PANEL, "Material", function(var)
	if isstring(var) then
		return Material(var, "smooth mips")
	end

	return var
end, "error")

function PANEL:Paint(w, h)
	surface.SetDrawColor(self.Color)
	surface.SetMaterial(self.Material)
	surface.DrawTexturedRect(0, 0, w, h)
end

vgui.Register("Material", PANEL, "EditablePanel")

local PANEL = {}

AddProperty(PANEL, "Color", ColorConstruct, 255, 255, 255)

function PANEL:Paint(w, h)
	surface.SetDrawColor(self.Color)
	surface.DrawRect(0, 0, w, h)
end

vgui.Register("Rect", PANEL, "EditablePanel")

local PANEL = {}

AddProperty(PANEL, "Text", tostring, "")
AddProperty(PANEL, "Font", tostring, DermaDefault)
AddProperty(PANEL, "Color", ColorConstruct, 255, 255, 255)

function PANEL:Paint(w, h)
	draw.SimpleText(self:GetText(), self:GetFont(), self.TextX, self.TextY, self:GetColor(), self.TextAlignX, self.TextAlignY)
end

function PANEL:SetAlign(xalign, yalign)
	local pw, ph = self:GetParent():GetSize()

	surface.SetFont(self:GetFont())
	local w, h = surface.GetTextSize(self:GetText())

	local x, y = self:GetPos()

	if xalign == TEXT_ALIGN_CENTER then
		x = pw * 0.5 + w * 0.5
	elseif xalign == TEXT_ALIGN_RIGHT then
		x = pw - w
	end

	if yalign == TEXT_ALIGN_CENTER then
		y = ph * 0.5 - h * 0.5
	elseif yalign == TEXT_ALIGN_BOTTOM then
		y = ph - h
	end

	local x, y = math.ceil(x), math.ceil(y)
	self:SetPos(x, y)
	self.AlignX, self.AlignY = xalign, yalign

	return x, y
end

function PANEL:SizeToContents(xAdd, hAdd)
	surface.SetFont(self:GetFont())
	local w, h = surface.GetTextSize(self:GetText())
	w, h = w + (xAdd or 0), h + (hAdd or 0)

	self:SetSize(w, h)
	return w, h
end

vgui.Register("Text", PANEL, "EditablePanel")
