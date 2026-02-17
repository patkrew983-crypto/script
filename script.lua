local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Dupe/Spawner",
   LoadingTitle = "Dupe/Spawner",
   LoadingSubtitle = "Star Scripts",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false,
})

local Tab = Window:CreateTab("Dupe/Spawner", 4483362458)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local selectedBrainrot = nil
local VirtualInputManager = game:GetService("VirtualInputManager")

if game.CoreGui:FindFirstChild("StarToggle") then
    game.CoreGui.StarToggle:Destroy()
elseif LocalPlayer.PlayerGui:FindFirstChild("StarToggle") then
    LocalPlayer.PlayerGui.StarToggle:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StarToggle"
if pcall(function() ScreenGui.Parent = game.CoreGui end) then
    ScreenGui.Parent = game.CoreGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "Toggle"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleBtn.BackgroundTransparency = 0.4
ToggleBtn.Position = UDim2.new(0, 8, 0, 8)
ToggleBtn.Size = UDim2.new(0, 32, 0, 32) 
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "☰"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 22
ToggleBtn.BorderSizePixel = 0
ToggleBtn.AutoButtonColor = false

local Corner = Instance.new("UICorner")
Corner.Parent = ToggleBtn
Corner.CornerRadius = UDim.new(0, 8)

local dragging = false
local dragInput, dragStart, startPos

ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleBtn.Position
    end
end)

ToggleBtn.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

ToggleBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    local rayfieldUI = game.CoreGui:FindFirstChild("Rayfield") or LocalPlayer.PlayerGui:FindFirstChild("Rayfield")
    if rayfieldUI then
        rayfieldUI.Enabled = not rayfieldUI.Enabled
    end
end)

local function getToolList()
    local toolNames = {}
    local seen = {} 
    if LocalPlayer.Backpack then
        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local name = tool:GetAttribute("BrainrotName") or tool:GetAttribute("DisplayName") or tool.Name
                if not seen[name] then
                    table.insert(toolNames, name)
                    seen[name] = true
                end
            end
        end
    end
    table.sort(toolNames) 
    return toolNames
end

local ToolDropdown = Tab:CreateDropdown({
    Name = "Item",
    Options = getToolList(),
    CurrentOption = {"None"},
    MultipleOptions = false,
    Callback = function(Option)
        selectedBrainrot = Option[1]
    end,
})

Tab:CreateButton({
    Name = "Refresh",
    Callback = function()
        ToolDropdown:Refresh(getToolList(), true)
    end,
})

Tab:CreateButton({
    Name = "Dupe/Spawner",
    Callback = function()
        if not selectedBrainrot or selectedBrainrot == "None" then
            Rayfield:Notify({Title = "Error", Content = "Select item!", Duration = 2})
            return
        end

        local found = false
        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") and (tool:GetAttribute("BrainrotName") or tool:GetAttribute("DisplayName") or tool.Name) == selectedBrainrot then
                local clone = tool:Clone()
                clone.Parent = LocalPlayer.Backpack
                
                Rayfield:Notify({Title = "Done", Content = selectedBrainrot .. " spawned!", Duration = 2})
                found = true
                break
            end
        end

        if not found then
            Rayfield:Notify({Title = "Error", Content = "Not found!", Duration = 2})
        end
    end,
})

Rayfield:LoadConfiguration()
