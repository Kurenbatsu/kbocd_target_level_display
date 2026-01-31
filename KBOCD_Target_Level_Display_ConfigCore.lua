--------------------------------------------------
-- Local Aliases
--------------------------------------------------
local db = nil
local targetLevelFrame = nil
local targetLevelFrameText = nil

--------------------------------------------------
-- Init Aliases
--------------------------------------------------
function KBOCDTargetLevelDisplay.InitializeConfigCoreAliases()
    db                      = KBOCDTargetLevelDisplayDB
    targetLevelFrame        = KBOCDTargetLevelDisplay.targetLevelFrame
    targetLevelFrameText    = KBOCDTargetLevelDisplay.targetLevelFrameText
end

--------------------------------------------------
-- Config UI Elements Table
--------------------------------------------------
function KBOCDTargetLevelDisplay.CreateUIElementValuesTable()
    KBOCDTargetLevelDisplay.UIElementValues = {
    --------------------------------------------------
    -- Global Confg UI
    --------------------------------------------------
        global = {
            label = {
                configHeader = {
                    string        = "KBOCD Target Level Display",
                    style         = "GameFontNormalLarge",
                    point         = "TOPLEFT",
                    relativePoint = "TOPLEFT",
                    xPos          = 16,
                    yPos          = -16,
                },
                configSubtitle = {
                    string        = "Configure your target level display.",
                    style         = "GameFontHighlight",
                    point         = "TOPLEFT",
                    relativePoint = "BOTTOMLEFT",
                    xPos          = 0,
                    yPos          = -8,
                },
                zoomDropDown = {
                    string        = "Scale",
                    style         = "GameFontNormal",
                    point         = "TOPLEFT",
                    relativePoint = "BOTTOMLEFT",
                    xPos          = 5,
                    yPos          = -12,
                },
                xPosition = {
                    string        = "X Position",
                    style         = "GameFontNormal",
                    point         = "TOPLEFT",
                    relativePoint = "TOPRIGHT",
                    xPos          = 175,
                    yPos          = 0,
                },
                yPosition = {
                    string        = "Y Position",
                    style         = "GameFontNormal",
                    point         = "TOPLEFT",
                    relativePoint = "TOPRIGHT",
                    xPos          = 70,
                    yPos          = 0,
                },

            },
            checkBox = {
                enable = {
                    label         = "Enable",
                    db            = db,
                    dbKey         = "enabled",
                    point         = "TOPLEFT",
                    relativePoint = "BOTTOMLEFT",
                    xPos          = 15,
                    yPos          = -8,
                    closure       = function(enabled)
                        KBOCDTargetLevelDisplay.UpdateTargetLevelFrame()
                    end
                },
            },
            positionBox = {
                levelFramePositionX = {
                    db            = db,
                    position      = "X",
                    frameToAdjust = targetLevelFrame,
                    point         = "CENTER",
                    relativePoint = "CENTER",
                    xPos          = 3,
                    yPos          = -25.5,
                },
                levelFramePositionY = {
                    db            = db,
                    position      = "Y",
                    frameToAdjust = targetLevelFrame,
                    point         = "CENTER",
                    relativePoint = "CENTER",
                    xPos          = 3,
                    yPos          = -25.5,
                }
            },
            dropDownBox = {
                zoom = {
                    db            = db,
                    point         = "TOPLEFT",
                    relativePoint = "BOTTOMLEFT",
                    xPos          = 0,
                    yPos          = -6,
                }
            },
            resetButton = {
                typeForConfirmationBox = "Target Level Display",
                db                     = db,
                defaultValuesTable     = KBOCDTargetLevelDisplay.DefaultValues,
                point                  = "CENTER",
                relativePoint          = "RIGHT",
                xPos                   = 100,
                yPos                   = -25.2,
            }
        },
    }
end
