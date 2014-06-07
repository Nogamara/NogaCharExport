require "Apollo"
require "Window"

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
	local tDependencies = {}
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
	local NogaCharLib = _G["NogaCharLib"]
	local GeminiPackages = _G["GeminiPackages"]
	local json = GeminiPackages:GetPackage("dkjson")
	
	local foo = NogaCharLib:GetAll()
	
	self.wndMain:FindChild("NEEditBox"):SetText(json.encode(foo))

	self.wndMain:Show(true)
	-- self.wndMain:Invoke()
end


function NogaCharExport:OnCancel()
	self.wndMain:Show(false)
	-- self.wndMain:Close()
end


local NogaCharExportInst = NogaCharExport:new()
NogaCharExportInst:Init()