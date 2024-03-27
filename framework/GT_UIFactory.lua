GT_UIFactory = {}

local uniquealyzer = 1;

function GT_UIFactory:CreateCheckbutton(parent, x_loc, y_loc, displayname)
	uniquealyzer = uniquealyzer + 1;

	local checkbutton = CreateFrame("CheckButton", "GT_Checkbutton_0" .. uniquealyzer, parent, "ChatConfigCheckButtonTemplate");
	checkbutton:SetPoint("TOPLEFT", x_loc, y_loc);
	getglobal(checkbutton:GetName() .. 'Text'):SetText(displayname);
	getglobal(checkbutton:GetName() .. 'Text'):SetPoint("TOPLEFT",25,-5);

	return checkbutton;
end

function GT_UIFactory:CreateLabel(parent,  x_loc, y_loc, text, fontSize, r, g, b)
    local label = parent:CreateFontString()
    label:SetFont("Fonts\\FRIZQT__.TTF", fontSize, "OUTLINE")
    label:SetPoint("TOPLEFT", x_loc, y_loc)
    label:SetTextColor(r,g,b)
    label:SetText(text)

    return label
end