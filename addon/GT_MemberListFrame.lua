local backdropInfo =
{
    bgFile="Interface\\FrameGeneral\\UI-Background-Marble",
    edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
 	tile = true,
 	tileEdge = true,
 	tileSize = 256,
 	edgeSize = 4,
 	insets = { left = 1, right = 1, top = 1, bottom = 1 },
}

GT_MemberListFrame = CreateFrame("Frame", nil, GT_MainFrame, "BackdropTemplate")
GT_MemberListFrame:SetPoint("TOPLEFT", 5, -25)
GT_MemberListFrame:SetSize(170, GT_MainFrame:GetHeight() - 10 - 20)
GT_MemberListFrame:SetBackdrop(backdropInfo)

local scrollFrame = CreateFrame("ScrollFrame", nil, GT_MemberListFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 3, -4)
scrollFrame:SetPoint("BOTTOMRIGHT", -27, 4)

scrollChild = CreateFrame("Frame")
scrollFrame:SetScrollChild(scrollChild)
scrollChild:SetWidth(GT_MemberListFrame:GetWidth()-18)
scrollChild:SetHeight(1)

GT_MemberListFrame.guildMemberFrames = {}

function GT_MemberListFrame:Clear()
    for index, frame in ipairs(GT_MemberListFrame.guildMemberFrames) do
        frame:Hide()
    end
end

local function initGuildMemberEntryFrame(index, name, isOnline, isSelffound)
    if (GT_MemberListFrame.guildMemberFrames[index] == nil) then
        GT_MemberListFrame.guildMemberFrames[index] = CreateFrame("Button", nil, scrollChild)
        GT_MemberListFrame.guildMemberFrames[index]:SetSize(325, 15)

        GT_MemberListFrame.guildMemberFrames[index].text = GT_MemberListFrame.guildMemberFrames[index]:CreateFontString()
        GT_MemberListFrame.guildMemberFrames[index].text:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
        GT_MemberListFrame.guildMemberFrames[index].text:SetPoint("LEFT", 20, 0)

        GT_MemberListFrame.guildMemberFrames[index].tag = CreateFrame("Frame", nil, GT_MemberListFrame.guildMemberFrames[index])
        GT_MemberListFrame.guildMemberFrames[index].tag:SetPoint("LEFT", 4, 0)
        GT_MemberListFrame.guildMemberFrames[index].tag:SetSize(12, 12)

        GT_MemberListFrame.guildMemberFrames[index].tag:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_LEFT")
            GameTooltip:SetText(GT_LocaleManager:GetLabel("memberdetailframe.rerollframe.sfcheckbox"))
        end)

        GT_MemberListFrame.guildMemberFrames[index].tag:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)

        GT_MemberListFrame.guildMemberFrames[index].tag.tex = GT_MemberListFrame.guildMemberFrames[index].tag:CreateTexture()
        GT_MemberListFrame.guildMemberFrames[index].tag.tex:SetAllPoints(GT_MemberListFrame.guildMemberFrames[index].tag)

        local highlightTexture = GT_MemberListFrame.guildMemberFrames[index]:CreateTexture(nil, "HIGHLIGHT")
        highlightTexture:SetAllPoints(true)
        highlightTexture:SetColorTexture(1, 0.8, 0, 0.4)
    end

	if isOnline == true then
		GT_MemberListFrame.guildMemberFrames[index].text:SetTextColor(1,0.8,0)
	else
		GT_MemberListFrame.guildMemberFrames[index].text:SetTextColor(0.5,0.5,0.5)
	end

	GT_MemberListFrame.guildMemberFrames[index].text:SetText(name)

	GT_MemberListFrame.guildMemberFrames[index].tag:Hide()
	if isSelffound == true then
	    GT_MemberListFrame.guildMemberFrames[index].tag.tex:SetTexture(5588107)
	    GT_MemberListFrame.guildMemberFrames[index].tag:Show()
	end

	GT_MemberListFrame.guildMemberFrames[index]:SetScript('OnClick', function()
		GT_MemberDetailFrame:SetData(name)
		GT_MemberDetailFrame:Show()
		GT_AddRerollPopup:Hide()
	end)

    GT_MemberListFrame.guildMemberFrames[index]:SetPoint("TOPLEFT", 0, -15 * (index - 1))
    GT_MemberListFrame.guildMemberFrames[index]:Show()
end

local function Update()
    GuildRoster()

    GT_MemberListFrame:Clear()

    for index, guildMember in ipairs(GT_Data.guildMembers) do
        initGuildMemberEntryFrame(index, guildMember.name, guildMember.isOnline, GT_HardcoreService:IsSelffound(guildMember.name))
    end
end

GT_MemberListFrame:SetScript("OnShow", function()
    Update()
end)

GT_EventManager:AddEventListener("REROLL_UPDATED_FROM_GUILD", function()
    Update()
end)

GT_EventManager:AddEventListener("SELFFOUND_MODIFIED", function()
    Update()
end)