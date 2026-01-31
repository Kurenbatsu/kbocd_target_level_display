--------------------------------------------------
-- Init
--------------------------------------------------
KBOCDTargetLevelDisplay = KBOCDTargetLevelDisplay or {}

--------------------------------------------------
-- Table Values
--------------------------------------------------
KBOCDTargetLevelDisplay.DefaultValues = {
    enabled     = true,
    xPos        = 1,
    yPos        = -37,
    zoomLevel   = "Default"
}

KBOCDTargetLevelDisplay.ZoomLevelToInt = {
    Smallest    = 0.4,
    Smaller     = 0.6,
    Small       = 0.8,
    Default     = 1,
    Large       = 1.2,
    Larger      = 1.4,
    Largest     = 1.6
}

--------------------------------------------------
-- User Defined Values (Uses 'DefaultValues' values if user defined values do not exist)
--------------------------------------------------
function KBOCDTargetLevelDisplay.CopyDefaultValues(src, dest, resetToDefaults)
    for key, value in pairs(src) do
        if type(value) == "table" then
            if type(dest[key]) ~= "table" or resetToDefaults then
                dest[key] = {}
            end
            KBOCDTargetLevelDisplay.CopyDefaultValues(value, dest[key])
        else
            if dest[key] == nil or resetToDefaults then
                dest[key] = value
            end
        end
    end
end

--------------------------------------------------
-- Target Level Frame
--------------------------------------------------
function KBOCDTargetLevelDisplay.CreateTargetLevelFrame()
    local targetLevelFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    targetLevelFrame:SetSize(32, 28)
    targetLevelFrame:SetFrameStrata("MEDIUM")
    targetLevelFrame:SetFrameLevel(100)
    targetLevelFrame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = {
            left = 4,
            right = 4,
            top = 4,
            bottom = 4,
        },
    })
    targetLevelFrame:SetBackdropColor(0, 0, 0, 1)
    targetLevelFrame:SetBackdropBorderColor(1, 0.8, 0, 1)

    local targetLevelFrameText = targetLevelFrame:CreateFontString(nil, "OVERLAY")
    targetLevelFrameText:SetTextColor(1, 0.8, 0, 1)
    targetLevelFrameText:SetAllPoints()

    KBOCDTargetLevelDisplay.targetLevelFrame = targetLevelFrame
    KBOCDTargetLevelDisplay.targetLevelFrameText = targetLevelFrameText
end

--------------------------------------------------
-- Update Frame Logic
--------------------------------------------------
function KBOCDTargetLevelDisplay.UpdateTargetLevelFrame()
    if not UnitExists("target") or not KBOCDTargetLevelDisplayDB.enabled then
        KBOCDTargetLevelDisplay.targetLevelFrame:Hide()
        KBOCDTargetLevelDisplay.targetLevelFrameText:Hide()
        return
    end

    if KBOCDTargetLevelDisplay.ZoomLevelToInt[KBOCDTargetLevelDisplayDB.zoomLevel] then
        KBOCDTargetLevelDisplay.targetLevelFrame:SetScale(KBOCDTargetLevelDisplay.ZoomLevelToInt[KBOCDTargetLevelDisplayDB.zoomLevel])
    else
        KBOCDTargetLevelDisplay.targetLevelFrame:SetScale(1)
    end

    local level = UnitLevel("target")
    local shouldDisplaySkull = (level == -1)

    KBOCDTargetLevelDisplay.targetLevelFrame:SetPoint("CENTER", TargetFrame.TargetFrameContainer.Portrait, "CENTER", KBOCDTargetLevelDisplayDB.xPos, KBOCDTargetLevelDisplayDB.yPos)
    KBOCDTargetLevelDisplay.targetLevelFrameText:SetFont("Fonts\\FRIZQT__.TTF", 12)
    KBOCDTargetLevelDisplay.targetLevelFrameText:ClearAllPoints()
    if shouldDisplaySkull then
        level = "|TInterface\\TargetingFrame\\UI-TargetingFrame-Skull:17:19|t"
        KBOCDTargetLevelDisplay.targetLevelFrameText:SetPoint("LEFT", KBOCDTargetLevelDisplay.targetLevelFrame, "LEFT", 2.55, 0)
        KBOCDTargetLevelDisplay.targetLevelFrameText:SetPoint("RIGHT", KBOCDTargetLevelDisplay.targetLevelFrame, "RIGHT", 0, 0)
    else
        KBOCDTargetLevelDisplay.targetLevelFrameText:SetPoint("CENTER", KBOCDTargetLevelDisplay.targetLevelFrame, "CENTER", 0.3, -0.3)
    end
    KBOCDTargetLevelDisplay.targetLevelFrameText:SetText(level)
    KBOCDTargetLevelDisplay.targetLevelFrame:Show()
    KBOCDTargetLevelDisplay.targetLevelFrameText:Show()
end

--------------------------------------------------
-- Initialize DB (set values)
--------------------------------------------------
function KBOCDTargetLevelDisplay.InitializeUserValues()
    KBOCDTargetLevelDisplayDB = KBOCDTargetLevelDisplayDB or {}
    KBOCDTargetLevelDisplay.CopyDefaultValues(KBOCDTargetLevelDisplay.DefaultValues, KBOCDTargetLevelDisplayDB)
end

--------------------------------------------------
-- Reset DB Values
--------------------------------------------------
function KBOCDTargetLevelDisplay.ResetUserValuesFor(dbTable, defaultValuesTable)
    KBOCDTargetLevelDisplayDB = KBOCDTargetLevelDisplayDB or {}
    KBOCDTargetLevelDisplay.CopyDefaultValues(defaultValuesTable, dbTable, true)
end
