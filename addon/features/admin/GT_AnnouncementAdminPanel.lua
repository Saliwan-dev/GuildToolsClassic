local backdrop =
{
    bgFile="Interface\\FrameGeneral\\UI-Background-Marble",
    edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
 	tile = true,
 	tileEdge = true,
 	tileSize = 256,
 	edgeSize = 4,
 	insets = { left = 1, right = 1, top = 1, bottom = 1 },
}

local GT_AnnouncementAdminPanel = CreateFrame("Frame", nil, GT_AdminPanel, "BackdropTemplate")
GT_AnnouncementAdminPanel:SetPoint("TOPLEFT")
GT_AnnouncementAdminPanel:SetSize(GT_AdminPanel:GetWidth(), GT_AdminPanel:GetHeight())
GT_AnnouncementAdminPanel:SetBackdrop(backdrop)

local levelLabel = GT_UIFactory:CreateLabel(GT_AnnouncementAdminPanel, 10, -10, "", 12, 1, 0.8, 0)
GT_LocaleManager:BindText(levelLabel, "adminframe.announcement.level")

local levelLabel = GT_UIFactory:CreateLabel(GT_AnnouncementAdminPanel, 10, -25, "", 10, 0.7, 0.7, 0.7)
GT_LocaleManager:BindText(levelLabel, "adminframe.announcement.level.help")

local function CreateLevelLine(level, yPos, label)
    GT_UIFactory:CreateLabel(GT_AnnouncementAdminPanel, 10, yPos, label, 10, 1, 1, 1)

    local input = CreateFrame("EditBox", nil, GT_AnnouncementAdminPanel, "InputBoxTemplate");
    input:SetSize(450, 10)
    input:SetPoint("TOPLEFT", 50, yPos)
    input:SetAutoFocus(false)
    input:SetText(GT_AchievementService:GetLevelAchievementMessage(level))

    local saveButton = CreateFrame("Button", nil, GT_AnnouncementAdminPanel, "UIPanelButtonTemplate")
    saveButton:SetSize(20, 20)
    saveButton:SetPoint("LEFT", input, "RIGHT", 5, 0)
    saveButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-CollapseButton-Up.PNG")
    saveButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-CollapseButton-Down.PNG")
    saveButton:SetScript('OnClick', function()
        GT_AchievementService:SaveLevelAchievementMessage(level, input:GetText())
        saveButton:SetShown(false)
    end)

    input:SetScript("OnTextChanged", function(self)
        local input = self:GetText()

        saveButton:SetShown(input ~= GT_AchievementService:GetLevelAchievementMessage(level))
    end)
end

GT_EventManager:AddEventListener("ADDON_READY", function()
    CreateLevelLine(10, -45, "10 : ")
    CreateLevelLine(20, -65, "20 : ")
    CreateLevelLine(30, -85, "30 : ")
    CreateLevelLine(40, -105, "40 : ")
    CreateLevelLine(50, -125, "50 : ")
    CreateLevelLine(51, -145, "51+ : ")
    CreateLevelLine(60, -165, "60 : ")
end)

-- Tab

local achievementsAdminTab = GT_UIFactory:AddTab(GT_AdminPanel, GT_LocaleManager:GetLabel("adminframe.tabs.announcement"), GT_AnnouncementAdminPanel)
GT_LocaleManager:BindText(achievementsAdminTab, "adminframe.tabs.announcement")