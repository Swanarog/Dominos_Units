local Addon = _G[...]local modName = ...local StatusBar = {}do	function StatusBar:New(parent)		local bar = Addon.Merge(StatusBar, CreateFrame("Frame" , nil, parent))		bar.scrollFrame = CreateFrame("ScrollFrame", nil, bar)		bar.helper = CreateFrame("Frame", nil, bar.scrollFrame)		bar.texture = bar.helper:CreateTexture(nil, "BACKGROUND")		bar.texture:SetAllPoints(bar)		bar.scrollFrame:SetScrollChild(bar.helper)				bar.Text = bar:CreateFontString(nil, 'ARTWORK', 'TextStatusBarText')		bar.Text:SetAllPoints(bar)		bar.text = bar.Text		bar.predictionBar = CreateFrame("Frame", nil, bar)		bar.predictionBar.texture = bar.predictionBar:CreateTexture(nil, 'ARTWORK')		bar.predictionBar.texture:SetColorTexture(1,1,1,.5)		bar.predictionBar.texture:SetAllPoints(bar.predictionBar)				bar:SetFillStyle("STANDARD")				bar.color = {r = 1, g = 1, b = 1, a = 1}		bar.borderHandler = CreateFrame("Frame", nil, bar.scrollFrame)		bar.borderHandler.textures = {}		for i, info in pairs(bar:GetBorderInfo()) do			local texture = bar.borderHandler:CreateTexture(nil, 'ARTWORK')			texture.info = info			bar.borderHandler.textures[i] = texture		end				return bar	end	function StatusBar:GetFillStyle()		return self.fillstyle	end	function StatusBar:GetMinMaxValues()		return self.min or 0, self.max or 1	end	function StatusBar:GetOrientation() --"HORIZONTAL" or "VERTICAL		return self.orientation or "HORIZONTAL"	end	function StatusBar:GetReverseFill()		return self.reversefill	end	function StatusBar:GetRotatesTexture()		return self.rotatestexture, self.rotatesdegrees or 90	end	function StatusBar:GetStatusBarColor()		local color = self.color		return color.r, color.g, color.b, color.a	end	function StatusBar:GetStatusBarTexture()		return self.texture	end	function StatusBar:GetValue()		return self.value	end	function StatusBar:SetFillStyle(style)		style = string.upper(style or "STANDARD")		self.fillstyle = style		self.scrollFrame:ClearAllPoints()		self.predictionBar:ClearAllPoints()		local orientation = self:GetOrientation()		if style ~= "REVERSE" then			self.reversefill = nil		end				local drop = self		local e,f,g,h = "Top", "Bottom", "Left", "Right"				if self.predictionStyle == "gain" then			f,e,h,g = "Top", "Bottom", "Left", "Right"		end				if orientation == "BOTH" then			self.scrollFrame:SetPoint("Center", drop)		elseif orientation == "VERTICAL" then			if style == "STANDARD" then				self.scrollFrame:SetPoint("BottomLeft")				self.scrollFrame:SetPoint("BottomRight")								self.predictionBar:SetPoint(e.."Left", self.scrollFrame, "TopLeft")				self.predictionBar:SetPoint(e.."Right", self.scrollFrame, "TopRight")			elseif style == "STANDARD_NO_RANGE_FILL" then				self.scrollFrame:SetPoint("Top", drop)				self.predictionBar:SetPoint("BottomLeft", self.scrollFrame)				self.predictionBar:SetPoint("BottomRight", self.scrollFrame)			elseif style == "CENTER" then				self.scrollFrame:SetPoint("Left")				self.scrollFrame:SetPoint("Right")			elseif style == "REVERSE" then				self.scrollFrame:SetPoint("TopLeft")				self.scrollFrame:SetPoint("TopRight")				self.predictionBar:SetPoint(f.."Left", self.scrollFrame, "BottomLeft")				self.predictionBar:SetPoint(f.."Right", self.scrollFrame, "BottomRight")			end		else			if style == "STANDARD" then			self.scrollFrame:SetPoint("TopLeft")			self.scrollFrame:SetPoint("BottomLeft")				self.predictionBar:SetPoint(e.."Right", self.scrollFrame, "TopRight")				self.predictionBar:SetPoint(f.."Right", self.scrollFrame, "BottomRight")			elseif style == "STANDARD_NO_RANGE_FILL" then			self.scrollFrame:SetPoint("TopRight")			self.scrollFrame:SetPoint("BottomRight")				self.predictionBar:SetPoint(e.."Right", self.scrollFrame, "TopRight")				self.predictionBar:SetPoint(f.."Right", self.scrollFrame, "BottomRight")			elseif style == "CENTER" then				self.scrollFrame:SetPoint("Top")				self.scrollFrame:SetPoint("Bottom")			elseif style == "REVERSE" then			self.scrollFrame:SetPoint("TopRight")			self.scrollFrame:SetPoint("BottomRight")				self.predictionBar:SetPoint(e.."Left", self.scrollFrame, "TopLeft")				self.predictionBar:SetPoint(f.."Left", self.scrollFrame, "BottomLeft")			end		end	end	function StatusBar:SetPredictionStyle(style)		self.predictionStyle = style	end	function StatusBar:SetMinMaxValues(min, max)		self.min = min		self.max = max	end	function StatusBar:SetOrientation(orientation)		self.orientation = orientation		self:SetFillStyle(self:GetFillStyle())	end	function StatusBar:SetReverseFill(state)		if state == false then			state = nil		end		local orient = "STANDARD"		if (state == true) or (state == nil) then			self.reversefill = state		end		if state == true then			orient = "REVERSE"		else			orient = "STANDARD"		end		self:SetFillStyle(orient)	end	local s2 = sqrt(2);	local cos, sin, rad = math.cos, math.sin, math.rad;	local function CalculateCorner(angle)		local r = rad(angle);		return 0.5 + cos(r) / s2, 0.5 + sin(r) / s2;	end	local function RotateTexture(texture, angle)		local LRx, LRy = CalculateCorner(angle + 45);		local LLx, LLy = CalculateCorner(angle + 135);		local ULx, ULy = CalculateCorner(angle + 225);		local URx, URy = CalculateCorner(angle - 45);				texture:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy);	end		function StatusBar:SetRotatesTexture(state, degrees)		if state ~= true then			state = nil			self.texture:SetTexCoord(0, 1, 0, 1) --trick to reset the rotation		end		if state then			RotateTexture(self.texture, degrees or 90)					end	end	function StatusBar:SetStatusBarColor(r, g, b, a)		local color = self.color		color.r, color.g, color.b, color.a = r, g, b, a		self.texture:SetVertexColor(r, g, b, a)	end	function StatusBar:ApplyStatusBarTexture(file, layer)		self.statusbartexture = file				self.texture:SetTexture(file)				if layer then			self.texture:SetDrawLayer(layer)		end	end	function StatusBar:GetBorderInfo()		return {				{--Top 1				points = {							{"Bottom", 0, "Top", 0, 0},							{"Left", 0, "Left", 0, 0},							{"Right", 0, "Right", 0, 0},							{"Top", 0, "Top", 0, 1}						 },				texture = {37/256, 1 - (37/256), 0, 25/64}			},			{--Right 2				points = {							{"Left", 0, "Right", 0, 0},							{"Top", 0, "Top", 0, 0},							{"Bottom", 0, "Bottom", 0, 0},							{"Right", 0, "Right", 1, 0}						 },				texture = {1 - (37/256),    1, 25/64,  1- (25/64)}			},			{--Bottom 3				points = {							{"Top", 0, "Bottom", 0, 0},							{"Left", 0, "Left", 0, 0},							{"Right", 0, "Right", 0, 0},							{"Bottom", 0, "Bottom", 0, -1}						 },				texture = { 37/256,   1 - (37/256),    1- (25/64),   1}			},			{--Left 4				points = {							{"Right", 0, "Left", 0, 0},							{"Top", 0, "Top", 0, 0},							{"Bottom", 0, "Bottom", 0, 0},							{"Left", 0, "Left", -1, 0}						 },				texture = {0, 37/256,   25/64,  1- (25/64)}			},						{--TopLeft 5				points = {							a = {"BottomLeft", 4, "TopLeft", 0, 0},							b = {"TopRight", 1, "TopLeft", 0, 0},						 },				texture = {0, 37/256, 0, 25/64},			},				{--BottomLeft 6				points = {							a = {"TopLeft", 4, "BottomLeft", 0, 0},							b = {"BottomRight", 3, "BottomLeft", 0, 0},						 },				texture = {0, 37/256,   1- (25/64),   1}			},				{--TopRight 7				points = {							{"TopLeft", 1, "TopRight", 0, 0},							{"BottomRight", 2, "TopRight", 0, 0},						 },				texture = {1 - (37/256),    1, 0, 25/64}			},					{--BottomRight 8				points = {							{"TopRight", 2, "BottomRight", 0, 0},							{"BottomLeft", 3, "BottomRight", 0, 0},						 },				texture = { 1 - (37/256),    1, 1- (25/64),   1}			},			{--Center 9				points = {							{"TopLeft", 0, "TopLeft", 0, 0},							{"BottomRight", 0, "BottomRight", 0, 0},						 },				texture = {37/256,   1 - (37/256),    25/64,  1- (25/64)}			},		}	end	function StatusBar:GetBorderPath(mediaName)		return (Addon.lib and Addon.lib:Fetch("castborder", mediaName))	end	function StatusBar:SetBorderTexture(file, flip, inset)		inset = inset or 0		inset = inset/100		local handle = self.borderHandler		for i , texture in pairs(handle.textures) do			if texture then				texture:SetTexture(self:GetBorderPath(file))				local left, right, top, bottom = unpack(texture.info.texture)								if flip then					top = 1 - top					bottom = 1- bottom				end								if i == 1 then					--Top					bottom = bottom + inset					left = left + inset					right = right - inset				elseif i == 2 then					--Right					left = left - inset					top = top + inset					bottom = bottom - inset				elseif i == 3 then					--Bottom					top = top - inset					left = left + inset					right = right - inset				elseif i == 4 then					--Left					right = right + inset					top = top + inset					bottom = bottom - inset				elseif i == 5 then					--TopLeft					bottom, right = bottom + inset, right +inset				elseif i == 6 then					--BottomLeft					top, right = top - inset, right +inset				elseif i == 7 then					--TopRight					left, bottom = left - inset, bottom + inset				elseif i == 8 then					--BottomRight					left, top = left - inset, top - inset				elseif i == 9 then					--Center					bottom = bottom - inset					left = left + inset					right= right - inset					top = top + inset				end								texture:SetTexCoord(left, right, top, bottom)			end		end	end		function StatusBar:SetBorderColor(r,b,g,a)		local handle = self.borderHandler		for i , texture in pairs(handle.textures) do			if texture then				texture:SetVertexColor(r,b,g,a)			end		end	end		function StatusBar:SetBorderPadding(h, v)		h,v = h or 0, v or 0		local handle = self.borderHandler		handle:ClearAllPoints()		handle:SetPoint("TopLeft", self, -h, v)		handle:SetPoint("BottomRight", self, h, -v)	end		function StatusBar:SetBorderThickness(h, v)		h,v = h or 0, v or 0		local handle = self.borderHandler		for i , texture in pairs(handle.textures) do			if texture then				texture:ClearAllPoints()				for k, c in pairs(texture.info.points) do					local point, anchor, relPoint, x, y = unpack(c)					texture:SetPoint(point, handle.textures[anchor] or handle, relPoint, h * (x or 0), v * (y or 0))				end			end		end	end			function StatusBar:EnableBorder(enable)		if enable then			self.borderHandler:Show()		else			self.borderHandler:Hide()		end	end		function StatusBar:SetValue(value, predictedCost, k)		if self.isRunning then return end		self.isRunning = true			self.value = value		local min, max = self:GetMinMaxValues()		if min ~= 0 then			if min > 0 then				max = max - min			elseif max < 0 then				max = max + math.abs(min)			end			min = 0		end								local orientation = self:GetOrientation()		local width, height = self:GetSize()		local fillstyle = self:GetFillStyle()		local e = value/max--width =width*2		local predict = 0		if predictedCost and predictedCost > 0 then			predict = predictedCost/max						if self.predictionStyle == "gain" then				if (e + predict) > 1 then					predict = predict + (1 - (e + predict))				end			else				if (e - predict) < 0 then					predict = e				end			end						self.predictionBar:Show()		else			self.predictionBar:Hide()		end		self:SetSize(0,0)				local w, h, pw, ph				if (fillstyle == "STANDARD_NO_RANGE_FILL") and (min == max) then			w, h = width, height		else			w, h, pw, ph = e * width, e * height, predict * width, predict * height		end		if (w == 0) and (h == 0) then			self.scrollFrame:Hide()		else			self.scrollFrame:Show()		end				self.scrollFrame:SetWidth(w or 0)		self.scrollFrame:SetHeight(h or 0)		self.predictionBar:SetWidth(pw or 0)		self.predictionBar:SetHeight(ph or 0)		self.isRunning = nil	endendAddon.StatusBar = StatusBar--Health Barlocal title = "Health"local widget = Addon:NewWidget('Health', 'StatusBar')local hori = {'LEFT', 'CENTER', 'RIGHT'}local vert = {'TOP',  'MIDDLE', 'BOTTOM'}local function FormatValue(value)	if (value <= 1000) then		return value	elseif (value < 1000000) then		return ('%.1fk'):format(value / 1000);	elseif (value < 1000000000) then		return ('%.2fm'):format(value / 1000000);	else		return ('%.2fg'):format(value / 1000000000);	endendAddon.FormatValue = FormatValuelocal function FormatBarValues(value,max,type)	if (type == 'none') or (value == nil) then		return ''	elseif (type == 'value') or (max == 0) then		return string.format('%s / %s',AbbreviateLargeNumbers(value),AbbreviateLargeNumbers(max))	elseif (type == 'current') then		return string.format('%s',AbbreviateLargeNumbers(value))	elseif (type == 'full') then		return string.format('%s / %s (%.0f%%)',FormatValue(value),FormatValue(max),value / max * 100)	elseif (type == 'deficit') then		if (value ~= max) then			return string.format('-%s',FormatValue(max - value))		else			return ''		end	elseif (type == 'percent') then		return string.format('%.0f%%',value / max * 100)	endendAddon.FormatBarValues = FormatBarValueswidget.defaults = {	text = {		text = {			color = {				a = 1,				b = 1,				g = 1,				r = 1,			},			justifyV = 1,			justifyH = 2,			format = "percent",			enable = true,			file = "Friz Quadrata TT",			mouseover = "value",			size = 11,		},		position = {			anchor = "Center",			x = 0,			y = 0,		},	},	visibility = {		background = {			enable = true,			color = {				a = 0.5,				b = 0,				g = 0,				r = 0,			},		},		border = {			hpadding = 13,			vthickness = 17,			vpadding = -4,			color = {				a = 1,				b = 1,				g = 1,				r = 1,			},			file = "WoodBoards",			hthickness = 21,		},		texture = {			orientation = "HORIZONTAL",			file = "Druid",			fillStyle = "STANDARD",			opacity = 100,		},	},	basic = {		advanced = {			enable = true,			tooltip = true,		},		position = {			y = -29,			x = 6,			frameLevel = 2,			anchor = "TopLeft",			frameStrata = 2,		},		size = {			enable = true,			scale = 100,			height = 12,			width = 115,		},	},}	function widget:New(parent)		local bar = self:Bind(CreateFrame("Frame", name, parent.box))		bar.status = StatusBar:New(bar)	bar.status:SetAllPoints(bar)	bar.status:ApplyStatusBarTexture('Interface\\RaidFrame\\Raid-Bar-Hp-Fill', 'BORDER')	bar.status:SetStatusBarColor(0,1,0,1)	bar.status:EnableMouse(false)	bar.status:Show()	bar.text = bar.text or bar:CreateFontString(nil, 'ARTWORK', 'TextStatusBarText')	bar.text:SetTextColor(1.0,1.0,1.0)	bar.status:SetPredictionStyle("gain")	bar:SetFrameLevel(3)	bar.drop = bar.drop or CreateFrame('StatusBar', nil, bar)	bar.drop:SetMinMaxValues(0,1)	bar.drop:SetValue(1)	bar.drop:SetAllPoints(bar)	bar.drop:SetFrameLevel(bar:GetFrameLevel()-2)		bar.owner = parent	bar.title = title	bar.handler = parent.id	return barendfunction widget:Layout()	if self.sets.basic.advanced.enable == true then		self:Show()		self.noUpdate = nil	else		self:Hide()		self.noUpdate = true		return	end	self:Resize()	self:Reposition()		self:LayoutText()	self:SetVisibility()	if self.status.EnableBorder then		local border = self.sets.visibility.border		self.status:EnableBorder(border.enable)		if border.enable == true then			self.status:SetBorderTexture(border.file, border.flipVertical)			self.status:SetBorderPadding(border.hpadding, border.vpadding)			self.status:SetBorderThickness(border.hthickness, -border.vthickness)			self.status:SetBorderColor(border.color.r,border.color.g,border.color.b,border.color.a)		end	end	self:Update()endlocal function LookForSets(frame)	if not frame:GetParent() then		return nil, "Dead End"	elseif frame:GetParent().sets then		return frame:GetParent().sets	else		return LookForSets(frame:GetParent())	endendfunction widget:Resize()	local size = self.sets.basic.size		local width, height = (size.width), (size.height)	self:SetHeight(height)		local scale = size.scale/100	self:SetScale(scale)		local set = LookForSets(self)	if set then		local w = set.width		if set.magicWidth then			local d = w - 191			self:SetWidth((size.width  + d)/ scale)		else			self:SetWidth(width)		end	else		self:SetWidth(width)	endendfunction widget:Reposition()	local position = self.sets.basic.position	local scale = self.sets.basic.size.scale/100	self:ClearAllPoints()	self:SetPoint(position.anchor, self:GetParent(), position.x / scale, position.y / scale)		local lay = Addon.layers[position.frameStrata]	self:SetFrameStrata(lay)	self.status:SetFrameStrata(lay)	local level = position.frameLevel	self:SetFrameLevel(level+2)	self.status:SetFrameLevel(level)	self.status.predictionBar:SetFrameLevel(level+2)endfunction widget:LayoutText()	local text = self.text			local font = self.sets.text.text	if font.enable then		text:Show()	else		text:Hide()		return	end	text:SetJustifyH(hori[font.justifyH] or font.justifyH or "CENTER") -- Sets horizontal text justification ('LEFT','RIGHT', or 'CENTER')	text:SetFont(self:GetMediaPath("font", font.file), font.size or 12)	text:SetTextColor(font.color.r, font.color.g, font.color.b, font.color.a)		local position = self.sets.text.position	text:ClearAllPoints()	local point	if font.justifyH == 1 then		point = "Left"	elseif font.justifyH == 2 then		point = "Center"	else		point = "Right"	end		if string.find(position.anchor, "Top") then		if point == "Center" then point = "" end		point = "Top"..point	elseif string.find(position.anchor, "Bottom") then		if point == "Center" then point = "" end		point = "Bottom"..point	end		text:SetPoint(point, self, position.anchor, position.x, position.y)endfunction widget:SetVisibility()	local visibility = self.sets.visibility		local background = visibility.background    if background.enable then        self.drop:SetStatusBarColor(background.color.r, background.color.g, background.color.b, background.color.a)    else        self.drop:SetStatusBarTexture("")    end	local texture = visibility.texture	self.status:SetOrientation(texture.orientation) -- "HORIZONTAL" or "VERTICAL"	self.drop:SetOrientation(texture.orientation)		self.status:SetFillStyle(texture.fillStyle)		self.status:ApplyStatusBarTexture(self:GetMediaPath('statusbar', texture.file) or texture.file)	self.drop:SetStatusBarTexture(self:GetMediaPath('statusbar', texture.file) or texture.file)        self.status:SetRotatesTexture(texture.rotateTexture)    self.drop:SetRotatesTexture(texture.rotateTexture)endfunction widget:Update()	if self.noUpdate then		return	end	if self.OnUpdate then		self:OnUpdate()	endendfunction widget:SetValues(current, minimum, maximum, overide, overideText)	local font = self.sets.text.text	self.status:SetMinMaxValues(minimum or 0, maximum or 0)	if ((overide) or (maximum <= 0)or (maximum == nil)) and self.text then		self.status:SetValue(math.max(minimum, 0))		self.text:SetText(overideText)		return		end	local Form = font.format	if font.mouseover ~= 'none' and (MouseIsOver(self)) then		Form = font.mouseover	end	self.text:SetText(FormatBarValues(current, maximum, Form))		self.status:SetValue(current or 0, UnitGetIncomingHeals(self.ID) or 0)endfunction widget:SetColor(r, g, b, a)	if ( r ~= self.r or g ~= self.g or b ~= self.b) or (a ~= self.a) then		self.status:SetStatusBarColor(r, g, b)		self.r, self.g, self.b, self.a = r, g, b, a	endendfunction widget:GetMediaPath(kind, fileName)	if Addon.lib then		return Addon.lib:Fetch(kind, fileName)	endendlocal function GetClassColors(unit)	local colors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS	local localizedClass, englishClass = UnitClass(unit)	return colors[englishClass]endfunction widget:OnUpdate()	local unit = self.owner.id	local dead = UnitIsGhost(unit) or UnitIsDead(unit)	local deadText	if dead then		deadText = "Dead"	end	self:SetValues(UnitHealth(unit), 0, UnitHealthMax(unit), dead, deadText)	local value = (UnitHealth(unit)/UnitHealthMax(unit))	local r, g, b	if not unit or not UnitIsConnected(unit) then		r, g, b = .7, .7, .7	elseif UnitIsDeadOrGhost(unit) then		r, g, b = .6, .6, .6	elseif UnitIsTapDenied(unit) then		r, g, b = .5, .5, .5	else		local high_r, high_g, high_b = 0, 1, 0				if self.sets.visibility.texture.classColored then			local c = GetClassColors(unit)			if c then				high_r, high_g, high_b = c.r, c.g, c.b			end		end		local low_r, low_g, low_b	 = 1, 1, 0		local RGB_value = value * 2 - 1		if value < .5 then			high_r, high_g, high_b  = 1, 1, 0			low_r, low_g, low_b 	= 1, 0, 0			RGB_value = value * 2		end		local inverse = 1 - RGB_value		r = low_r * inverse + high_r * RGB_value		g = low_g * inverse + high_g * RGB_value		b = low_b * inverse + high_b * RGB_value	end	self:SetColor(r, g, b, 1)endwidget.Options = {	{		name = "Basic",		kind = "Panel",		key = "basic",		panel = "Basic",		options = {			{				name = 'Scale',				kind = 'Slider',				key = 'scale',				min = 25,				max = 200,				panel = 'size',			},			{				name = 'Width',				kind = 'Slider',				key = 'width',				min = 10,				max = 200,				panel = 'size',			},			{				name = 'Height',				kind = 'Slider',				key = 'height',				min = 10,				max = 200,				panel = 'size',			},			{				name = 'X Offset',				kind = 'Slider',				key = 'x',				panel = 'position',				min = -400,				max = 400,			},			{				name = 'Y Offset',				kind = 'Slider',				key = 'y',				panel = 'position',				min = -400,				max = 400,			},			{				name = 'Anchor',				kind = 'Menu',				key = 'anchor',				panel = 'position',				table = {					'TopLeft',					'Top',					'TopRight',					'Right',					'BottomRight',					'Bottom',					'BottomLeft',					'Left',					'Center',				},			},			{				name = "Frame Level",				kind = "Slider",				key = "frameLevel",				panel = 'position',				min = 1,				max = 100,			},			{				name = "Frame Strata",				kind = "Slider",				key = "frameStrata",				panel = 'position',				min = 1,				max = 8,			},			{				name = 'Enable',				kind = 'CheckButton',				key = 'enable',				panel = "advanced",			},			{				name = 'Tooltip',				kind = 'CheckButton',				key = 'tooltip',				panel = "advanced",			},		}	},		{ 		name = "Text",		kind = "Panel",		key = "text",		panel = "Text",		options = {			{				name = 'Enable',				kind = 'CheckButton',				key = 'enable',				panel = "text",			},			{				name = 'Format',				kind = 'Menu',				key = 'format',				table = {					'none',					'value',					'current',					'full',					'deficit',					'percent',				},				panel = "text",			},			{				name = 'MouseOver Format',				kind = 'Menu',				key = 'mouseover',				table = {					'none',					'value',					'current',					'full',					'deficit',					'percent',				},				panel = "text",			},			{				name = 'Font',				kind = 'Media',				key = 'file',				mediaType = 'Font',				panel = 'text',			},			{				name = 'Size',				kind = 'Slider',				key = 'size',				min = 1,				max = 25,				panel = 'text',			},			{				name = 'Color',				kind = 'ColorPicker',				key = 'color',				panel = 'text',			},			{				name = 'X Offset',				kind = 'Slider',				key = 'x',				panel = 'position',				min = -400,				max = 400,			},			{				name = 'Y Offset',				kind = 'Slider',				key = 'y',				panel = 'position',				min = -400,				max = 400,			},			{				name = 'Justify Horizontal',				kind = 'Slider',				key = 'justifyH',				panel = 'text',				min = 1,				max = 3,			},			{				name = 'Anchor',				kind = 'Menu',				key = 'anchor',				panel = 'position',				table = {					'TopLeft',					'Top',					'TopRight',					'Right',					'BottomRight',					'Bottom',					'BottomLeft',					'Left',					'Center',				},			},		}	},	{		name = "visibility",		kind = "Panel",		key = "visibility",		panel = "visibility",		options = {			{				name = 'Class Colored',				kind = 'CheckButton',				key = 'classColored',				panel = "texture",			},			{				name = 'Rotate Texture',				kind = 'CheckButton',				key = 'rotateTexture',				panel = "texture",			},									{				name = 'Texture',				kind = 'Media',				key = 'file',				mediaType = 'statusbar',				panel = 'texture',			},			{				name = 'Opacity',				kind = 'Slider',				key = 'opacity',				min = 0,				max = 100,				panel = 'texture',			},			{				name = 'Orientation',				kind = 'Menu',				key = 'orientation',				panel = 'texture',				table = {					'HORIZONTAL',					'VERTICAL',				},			},			{				name = 'Fill Style',				kind = 'Menu',				key = 'fillStyle',				panel = 'texture',				table = {					'STANDARD',					'REVERSE',					'CENTER',				},			},			{				name = 'Enable',				kind = 'CheckButton',				key = 'enable',				panel = "background",			},			{				name = 'Background Color',				kind = 'ColorPicker',				key = 'color',				panel = 'background',			},			{				name = 'Vertical Padding',				kind = 'Slider',				key = 'vpadding',				min = -50,				max = 50,				panel = 'border',			},						{				name = 'Horizontal Padding',				kind = 'Slider',				key = 'hpadding',				min = -50,				max = 50,				panel = 'border',			},			{				name = 'Vertical Thickness',				kind = 'Slider',				key = 'vthickness',				min = 1,				max = 50,				panel = 'border',			},			{				name = 'Horizontal Thickness',				kind = 'Slider',				key = 'hthickness',				min = 1,				max = 50,				panel = 'border',			},			{				name = 'Border Color',				kind = 'ColorPicker',				key = 'color',				panel = 'border',			},		}	},} 