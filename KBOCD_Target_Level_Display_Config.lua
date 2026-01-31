--------------------------------------------------
-- KBOCDResourceBars Config Panel Section Creation Functions
--------------------------------------------------
local function CreateConfigPanelFor(uiElementCategory, scrollChild, initialAnchorObj)
    local uiElement = uiElementCategory

    local enableBarButton = KBOCDTargetLevelDisplay.CreateCheckButtonFor(
        uiElement.checkBox.enable, scrollChild, initialAnchorObj
    )

    local zoomLabel = KBOCDTargetLevelDisplay.CreateLabelFor(
        uiElement.label.zoomDropDown, scrollChild, enableBarButton
    )
    local zoomDropDownBox = KBOCDTargetLevelDisplay.CreateScaleDropDownFor(
        uiElement.dropDownBox.zoom, scrollChild, zoomLabel
    )

    local xPositionText = KBOCDTargetLevelDisplay.CreateLabelFor(
        uiElement.label.xPosition, scrollChild, zoomLabel
    )
    KBOCDTargetLevelDisplay.CreatePositionBoxFor(
        uiElement.positionBox.levelFramePositionX, scrollChild, xPositionText
    )

    local yPositionText = KBOCDTargetLevelDisplay.CreateLabelFor(
        uiElement.label.yPosition, scrollChild, xPositionText
    )
    KBOCDTargetLevelDisplay.CreatePositionBoxFor(
        uiElement.positionBox.levelFramePositionY, scrollChild, yPositionText
    )

    KBOCDTargetLevelDisplay.CreateResetButtonFor(
        uiElement.resetButton, scrollChild, yPositionText
    )

    return enableBarButton
end

--------------------------------------------------
-- KBOCDResourceBars Config Panel
--------------------------------------------------
function KBOCDTargetLevelDisplay:CreateConfigPanel()
    local panel = CreateFrame("Frame")
    panel.name = "KBOCD Target Level Display"

    local category = Settings.RegisterCanvasLayoutCategory(panel, "KBOCD Target Level Display")
    Settings.RegisterAddOnCategory(category)

    -- For some reason, trying to open the config pane after selecting a different addon will always fail
    -- Forcing it to hide once on initial load fixes this
    panel:SetScript("OnUpdate", function()
        panel:Hide()
        panel:SetScript("OnUpdate", nil)
    end)

    panel:SetScript("OnShow", function(self)
        if self.initialized then return end
        self.initialized = true

        local globalUIElement = KBOCDTargetLevelDisplay.UIElementValues.global

        local title = KBOCDTargetLevelDisplay.CreateLabelFor(
            globalUIElement.label.configHeader, self, panel
        )
        local subtitle = KBOCDTargetLevelDisplay.CreateLabelFor(
            globalUIElement.label.configSubtitle, self, title
        )

        local headerDivider = KBOCDTargetLevelDisplay.CreateHorizontalDivider(610, self, subtitle, "TOPLEFT", "BOTTOMLEFT", 0, -6)

        local scrollFrame = CreateFrame("ScrollFrame", nil, self, "UIPanelScrollFrameTemplate")
        scrollFrame:SetPoint("TOPLEFT", headerDivider, "BOTTOMLEFT", 0, 0)
        scrollFrame:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -30, 10)

        local scrollChild = CreateFrame("Frame", nil, scrollFrame)
        scrollChild:SetPoint("TOPLEFT")
        scrollChild:SetSize(scrollFrame:GetWidth(), 1)
        scrollFrame:SetScrollChild(scrollChild)

        scrollChild:SetHeight(1) -- Adjust to make scrolling go down further

        scrollFrame:SetScript("OnMouseWheel", function(self, delta)
            local cur = self:GetVerticalScroll()
            local max = self:GetVerticalScrollRange()
            local step = 30 -- How many pixels to move per scroll notch

            if delta > 0 then
                -- Scroll Up
                self:SetVerticalScroll(math.max(0, cur - step))
            else
                -- Scroll Down
                self:SetVerticalScroll(math.min(max, cur + step))
            end
        end)

        CreateConfigPanelFor(KBOCDTargetLevelDisplay.UIElementValues.global, scrollChild, scrollChild)

    end)
end

--------------------------------------------------
-- Event Handling
--------------------------------------------------
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
eventFrame:RegisterEvent("UNIT_LEVEL")

eventFrame:SetScript("OnEvent", function(_, event, eventValue)
    if event == "ADDON_LOADED" and eventValue == "KBOCDTargetLevelDisplay" then
        KBOCDTargetLevelDisplay.InitializeUserValues()
    elseif event == "PLAYER_LOGIN" then
        KBOCDTargetLevelDisplay.CreateTargetLevelFrame()
        KBOCDTargetLevelDisplay.InitializeConfigCoreAliases()
    elseif event == "PLAYER_ENTERING_WORLD" and not KBOCDTargetLevelDisplay.initialEnteringWorldCompleted then
        KBOCDTargetLevelDisplay.CreateTargetLevelFrame()
        KBOCDTargetLevelDisplay.InitializeConfigCoreAliases()
        KBOCDTargetLevelDisplay.CreateUIElementValuesTable()
        KBOCDTargetLevelDisplay:CreateConfigPanel()

        DEFAULT_CHAT_FRAME:AddMessage("|cfff2e147KBOCDTargetLevelDisplay |cffa19d78loaded.|r")
        KBOCDTargetLevelDisplay.initialEnteringWorldCompleted = true
    elseif event == "PLAYER_TARGET_CHANGED" or (event == "UNIT_LEVEL" and eventValue == "target") then
        KBOCDTargetLevelDisplay.UpdateTargetLevelFrame()
    end
end)
