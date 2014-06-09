require "Apollo"

local NogaCharExport = {}

function NogaCharExport:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end


function NogaCharExport:Init()
	local bHasConfigureButton = false
	local strConfigureButtonText = ""
	local tDependencies = {"NogaCharLib"}
	Apollo.RegisterAddon(self, bHasConfigureButton, strConfigureButtonText, tDependencies)
end


function NogaCharExport:OnLoad()
	self.xmlDoc = XmlDoc.CreateFromFile("NogaCharExportForm.xml")
	self.xmlDoc:RegisterCallback("OnDocLoaded", self)
end


function NogaCharExport:OnDocLoaded()
	if self.xmlDoc ~= nil and self.xmlDoc:IsLoaded() then
		self.wndMain = Apollo.LoadForm(self.xmlDoc, "NogaCharExportForm", nil, self)
		if self.wndMain == nil then
			Apollo.AddAddonErrorText(self, "Could not load the main window for some reason.")
			return
		end
		self.wndMain:Show(false, true)
		Apollo.RegisterSlashCommand("nogacharexport", "OnNogaCharExportOn", self)
	end
end


function NogaCharExport:OnNogaCharExportOn()
	self.json = Apollo.GetPackage("Lib:dkJSON-2.5").tPackage
	self.nogaCharLib = Apollo.GetPackage("NogaCharLib").tPackage
	self.wndMain:Invoke()
end


function NogaCharExport:OnBtnBaseFn()
	local data = self.nogaCharLib.GetBaseStats()
	self.wndMain:FindChild("NEEditBox"):SetText(self.json.encode(data))
end


function NogaCharExport:OnBtnMiscFn()
	local data = self.nogaCharLib.GetMiscStats()
	self.wndMain:FindChild("NEEditBox"):SetText(self.json.encode(data))
end


function NogaCharExport:OnBtnCurrencyFn()
	local data = self.nogaCharLib.GetCurrency()
	self.wndMain:FindChild("NEEditBox"):SetText(self.json.encode(data))
end


function NogaCharExport:OnBtnAllFn()
	local data = self.nogaCharLib.GetAll()
	self.wndMain:FindChild("NEEditBox"):SetText(self.json.encode(data))
end


function NogaCharExport:OnCancel()
	self.wndMain:Close()
end


local NogaCharExportInst = NogaCharExport:new()
NogaCharExportInst:Init()
