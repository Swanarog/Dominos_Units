local Addon = _G[...]local modName = ...--Unit Menulocal widget = Addon:NewWidget('drop', 'Button')function widget:New(parent)	local name = ('%s_%s_UnitMenu'):format(modName, parent.id)	if _G[name] then return _G[name] end	local button = self:Bind(CreateFrame('Frame', name, parent.box, 'L_UIDropDownMenuTemplate'))	if button then		button.owner = parent	end	self.unitButton = button	return buttonendfunction widget:GetDefaults()    return {}endlocal shortcut = {	party = "PARTY",	boss = "BOSS",	focus = "FOCUS",	arenapet = "ARENAENEMY",	arena = "ARENAENEMY",	player = "SELF",	vehicle = "VEHICLE",	pet = "PET"}function widget:Initialize()	local unit = self.id	if not unit then return end		local unitType = string.match(unit, "^([a-z]+)[0-9]+$") or unit;	-- Mimic the default UI and prefer the relevant units menu when possible	local menu = shortcut[unitType]		if not menu then		-- Then try and detect the unit type and show the most relevant menu we can find		if( UnitIsUnit(unit, "player") ) then			menu = "SELF"		elseif( UnitIsUnit(unit, "vehicle") ) then			menu = "VEHICLE"		elseif( UnitIsUnit(unit, "pet") ) then			menu = "PET"		elseif( UnitIsOtherPlayersBattlePet(unit) ) then			menu = "OTHERBATTLEPET";		elseif( UnitIsOtherPlayersPet(unit) ) then			menu = "OTHERPET";		-- Last ditch checks 		elseif( UnitIsPlayer(unit) ) then			if( UnitInRaid(unit) ) then				menu = "RAID_PLAYER";			elseif( UnitInParty(unit) ) then				menu = "PARTY"			else				menu = "PLAYER";			end		elseif( UnitIsUnit(unit, "target") ) then			menu = "TARGET";		end	end	self:AddVehicle(unit, menu)	if( menu ) then		L_UnitPopup_ShowMenu(self, menu, unit);	endendfunction widget:Load()	self.id = self.owner.id	self.owner.box.dropDown = self	self.owner.box.id = self.owner.id	self.owner.box:SetAttribute('*type1', "target")	self.owner.box:SetAttribute('*type2', 'menu')	self.owner.box:RegisterForClicks('LeftButtonUp', 'RightButtonUp')	self.box = self.owner.box	self:SetFrameStrata("LOW")	if self.Initialize then		local box = self.owner.box		L_UIDropDownMenu_Initialize(box.dropDown, self.Initialize, "MENU")		box.menu = function()			L_ToggleDropDownMenu(1, 1, box.dropDown, box:GetName(), 0, 0, nil, nil, 5)		end	endendL_UnitPopupButtons["EJECT_PASSENGER"] = { text = "Eject Passenger", dist = 0 }local SEATIDhooksecurefunc("L_UnitPopup_OnClick", function(self)	local button = self.value;	if button == "EJECT_PASSENGER" and SEATID then		EjectPassengerFromSeat(SEATID)	endend)local function RemoveEject(menu)	local popup = L_UnitPopupMenus[menu]	if popup and popup[1] and popup[1] == "EJECT_PASSENGER" then		tremove(L_UnitPopupMenus[menu], 1)	endendlocal function AddEject(menu)	local popup = L_UnitPopupMenus[menu]	if popup and popup[1] and popup[1] ~= "EJECT_PASSENGER" then		tinsert(L_UnitPopupMenus[menu], 1 , "EJECT_PASSENGER")	endendfunction widget:AddVehicle(unit, menu)	local seatID	local i = 1	if not VehicleSeatIndicator.currSkin then		RemoveEject(menu)		return	end	local virtualID = GetVehicleUIIndicatorSeat(VehicleSeatIndicator.currSkin, i)	while virtualID do		local controlType, occupantName, serverName, ejectable, canSwitchSeats = UnitVehicleSeatInfo("player", virtualID)		if ejectable then			if UnitName(unit) == occupantName then				seatID = virtualID			end		end		i = i + 1		virtualID = GetVehicleUIIndicatorSeat(VehicleSeatIndicator.currSkin, i)	end	if seatID then		SEATID = seatID		AddEject(menu)	else		RemoveEject(menu)	endend