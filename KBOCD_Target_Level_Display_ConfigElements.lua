--------------------------------------------------
-- Element Creator Functions
--------------------------------------------------
function KBOCDTargetLevelDisplay.CreateLabelFor(label, parent, anchor)
    local fontString = parent:CreateFontString(nil, "ARTWORK", label.style)
    fontString:SetPoint(label.point, anchor, label.relativePoint, label.xPos, label.yPos)
    fontString:SetText(label.string)

    return fontString
end

function KBOCDTargetLevelDisplay.CreateHorizontalDivider(width, parent, anchor, point, relativePoint, xPos, yPos, alpha)
    local divider = parent:CreateTexture(nil, "ARTWORK")
    divider:SetPoint(point, anchor, relativePoint, xPos, yPos)
    divider:SetSize(width, 1)
    divider:SetColorTexture(1, 1, 1, alpha or 0.4)

    return divider
end

function KBOCDTargetLevelDisplay.CreateCheckButtonFor(checkBox, parent, anchor)
    local checkBoxFrame = CreateFrame("CheckButton", nil, parent, "InterfaceOptionsCheckButtonTemplate")
    checkBoxFrame:SetPoint(checkBox.point, anchor, checkBox.relativePoint, checkBox.xPos, checkBox.yPos)

    checkBoxFrame.Text:SetFontObject("GameFontNormal")
    checkBoxFrame.Text:SetText(checkBox.label)
    checkBoxFrame:SetChecked(checkBox.db[checkBox.dbKey])

    checkBoxFrame:SetScript("OnClick", function(btn)
        local enabled = btn:GetChecked()
        checkBox.db[checkBox.dbKey] = enabled
        if checkBox.closure then
            checkBox.closure(enabled)
        end
    end)

    return checkBoxFrame
end

function KBOCDTargetLevelDisplay.CreatePositionBoxFor(positionBox, parent, anchor)
    local positionBoxFrame = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
    positionBoxFrame:SetPoint(positionBox.point, anchor, positionBox.relativePoint, positionBox.xPos, positionBox.yPos)
    positionBoxFrame:SetSize(100, 24)
    positionBoxFrame:SetAutoFocus(false)
    positionBoxFrame:SetMaxLetters(10)
    positionBoxFrame:SetJustifyH("CENTER")
    positionBoxFrame:SetTextInsets(2, 7, 0, 0)
    if positionBox.position == "X" then
        positionBoxFrame:SetText(positionBox.db.xPos)
    else
        positionBoxFrame:SetText(positionBox.db.yPos)
    end


    local function ApplyPosition(value)
        value = tonumber(value)

        positionBoxFrame:SetText(value)  -- sanitize input

        local originalPoint, originalRelativeTo, originalRelativePoint, originalX, originalY = positionBox.frameToAdjust:GetPoint()
        positionBox.frameToAdjust:ClearAllPoints()
        if positionBox.position == "X" then
            positionBox.db.xPos = value    -- save to DB
            positionBox.frameToAdjust:SetPoint(originalPoint, originalRelativeTo, originalRelativePoint, value, originalY)
        else
            positionBox.db.yPos = value    -- save to DB
            positionBox.frameToAdjust:SetPoint(originalPoint, originalRelativeTo, originalRelativePoint, originalX, value)
        end
    end

    positionBoxFrame:SetScript("OnEnterPressed", function(selfBox)
        ApplyPosition(selfBox:GetText())
        selfBox:ClearFocus()
    end)

    positionBoxFrame:SetScript("OnEditFocusLost", function(selfBox)
        ApplyPosition(selfBox:GetText())
    end)

    return positionBoxFrame
end

function KBOCDTargetLevelDisplay.CreateScaleDropDownFor(dropDownMenu, parent, anchor)
    local dropDownFrame = CreateFrame("Frame", "ResourceDropDown", parent, "UIDropDownMenuTemplate")
    dropDownFrame:SetPoint(dropDownMenu.point, anchor, dropDownMenu.relativePoint, dropDownMenu.xPos, dropDownMenu.yPos)

    local scaleOptions = {
        "Smallest",
        "Smaller",
        "Small",
        "Default",
        "Large",
        "Larger",
        "Largest",
    }

    UIDropDownMenu_Initialize(dropDownFrame,
        function()
            for i, scale in ipairs(scaleOptions) do
                local info = UIDropDownMenu_CreateInfo()
                info.text = scale
                info.checked = (dropDownMenu.db.zoomLevel == scale)
                info.func = function()
                    dropDownMenu.db.zoomLevel = scale     -- save selection
                    KBOCDTargetLevelDisplay.UpdateTargetLevelFrame()
                    UIDropDownMenu_SetSelectedID(dropDownFrame, i)
                end
                UIDropDownMenu_AddButton(info)
            end
        end)
    UIDropDownMenu_SetWidth(dropDownFrame, 120)
    UIDropDownMenu_SetText(dropDownFrame, dropDownMenu.db.zoomLevel)

    return dropDownFrame
end

StaticPopupDialogs["RESTORE_DEFAULTS"] = {
    text = "Are you sure you want to reset all of the values of\n'%s'\nto their default values?\n\nThis will triger a UI reload\nand cannot be undone.",
    button1 = YES,
    button2 = NO,
    OnAccept = function(self)
        local data = self.data
        if data.dbTable and data.defaultValuesTable then
            KBOCDTargetLevelDisplay.ResetUserValuesFor(data.dbTable, data.defaultValuesTable)
        end
        ReloadUI()
    end,
    OnCancel = function()
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

local function StaticPopupHelper(dataTypeToReset, dbTable, defaultValuesTable)
    StaticPopup_Show("RESTORE_DEFAULTS", dataTypeToReset, nil, {
        dbTable = dbTable,
        defaultValuesTable = defaultValuesTable
    })
end

function KBOCDTargetLevelDisplay.CreateResetButtonFor(resetButton, parent, anchor)
    local resetButtonFrame = CreateFrame("Button", resetButton.typeForConfirmationBox, parent, "UIPanelButtonTemplate")
    resetButtonFrame:SetSize(92, 25)
    resetButtonFrame:SetPoint(resetButton.point, anchor, resetButton.relativePoint, resetButton.xPos, resetButton.yPos)
    resetButtonFrame:SetText("Defaults")

    local text = _G[resetButtonFrame:GetName() .. "Text"]
    text:SetJustifyH("CENTER")
    text:ClearAllPoints()
    text:SetPoint("LEFT", resetButtonFrame, "LEFT", 8, -0.65)
    text:SetPoint("RIGHT", resetButtonFrame, "RIGHT", -8, 0)

    resetButtonFrame:SetScript("OnClick", function()
        StaticPopupHelper(resetButton.typeForConfirmationBox, resetButton.db, resetButton.defaultValuesTable)
    end)

    return resetButtonFrame
end