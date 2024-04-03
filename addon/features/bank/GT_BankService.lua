GT_BankService = {}

local mockedBankChars = {"AAA", "BBB", "CCC"}

function GT_BankService:GetBankChars()
    return mockedBankChars
end

function GT_BankService:AddBankChar(bankCharName)
    table.insert(mockedBankChars, bankCharName)
end

function GT_BankService:RemoveBankChar(bankCharName)
    for index, char in ipairs(mockedBankChars) do
        if char == bankCharName then
            indexToRemove = index
        end
    end

    if indexToRemove ~= nil then
        table.remove(mockedBankChars, indexToRemove)
    end
end