local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- FIX FOR JOINING: Safely waits for the UI layer without using a freeze-prone while-loop
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)

-- Legacy Chat Network Remote
local DefaultChatSystemChatEvents = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents", 5)
local SayMessageRequest = DefaultChatSystemChatEvents and DefaultChatSystemChatEvents:WaitForChild("SayMessageRequest", 5)

-- ==========================================
-- 1. SEARCH LOGIC FUNCTIONS (BUG-FIXED)
-- ==========================================

local function locateAdminPad()
    -- 1. Try checking the official Kohl's folder path first
    local adminFolder = workspace:FindFirstChild("Admin")
    if adminFolder then
        local pads = adminFolder:FindFirstChild("Pads")
        if pads then
            for _, padModel in ipairs(pads:GetChildren()) do
                local head = padModel:FindFirstChild("Head")
                if head then return head end
            end
        end
    end
    
    -- 2. FIRST-JOIN FALLBACK: If the folder hasn't streamed in yet, check the full map!
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name == "touch to get admin" then
                return obj
            elseif obj.Name == "Head" and obj.Parent and obj.Parent.Name == "Touch to get admin" then
                return obj
            end
        end
    end
    return nil
end

local function locateRegenButton()
    local adminFolder = workspace:FindFirstChild("Admin")
    if adminFolder then
        local regenModel = adminFolder:FindFirstChild("Regen")
        if regenModel then
            return regenModel:FindFirstChild("Regen") or regenModel:FindFirstChild("Head") or regenModel:FindFirstChildOfClass("BasePart")
        end
    end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name == "regen" or name == "respawn" or name == "reset house" then
                return obj
            end
        end
    end
    return nil
end

-- ==========================================
-- 2. THE MAIN PANEL UI CONTAINER
-- ==========================================
local function buildThePanel()
    -- Clean wipe old GUIs to prevent overlap bugs
    local oldGui = PlayerGui:FindFirstChild("LegacyMassiveDestroyerGui")
    if oldGui then oldGui:Destroy() end

    -- Create the ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LegacyMassiveDestroyerGui"
    ScreenGui.ResetOnSpawn = true -- Lets Roblox automatically refresh the UI cleanly on death
    ScreenGui.Parent = PlayerGui

    -- Create main container frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 150, 0, 305)
    MainFrame.Position = UDim2.new(0.5, -75, 0.15, 0)
    MainFrame.BackgroundTransparency = 1 
    MainFrame.Parent = ScreenGui

    -- Minimize Toggle Button (— / +)
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 35, 0, 35)
    ToggleButton.Position = UDim2.new(1, -75, 0, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    ToggleButton.TextSize = 18
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Text = "—"
    ToggleButton.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextStrokeTransparency = 0
    ToggleButton.Parent = MainFrame

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleButton

    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Color = Color3.fromRGB(180, 20, 20)
    ToggleStroke.Thickness = 1.5
    ToggleStroke.Parent = ToggleButton

    -- Self-Destruct / Unload Button (X)
    local DestroyButton = Instance.new("TextButton")
    DestroyButton.Size = UDim2.new(0, 35, 0, 35)
    DestroyButton.Position = UDim2.new(1, -35, 0, 0)
    DestroyButton.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
    DestroyButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    DestroyButton.TextSize = 18
    DestroyButton.Font = Enum.Font.GothamBold
    DestroyButton.Text = "X"
    DestroyButton.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    DestroyButton.TextStrokeTransparency = 0
    DestroyButton.Parent = MainFrame

    local DestroyCorner = Instance.new("UICorner")
    DestroyCorner.CornerRadius = UDim.new(0, 8)
    DestroyCorner.Parent = DestroyButton

    local DestroyStroke = Instance.new("UIStroke")
    DestroyStroke.Color = Color3.fromRGB(255, 0, 0)
    DestroyStroke.Thickness = 1.5
    DestroyStroke.Parent = DestroyButton

    -- Container Frame for Input Box + Ghost Layer
    local InputContainer = Instance.new("Frame")
    InputContainer.Size = UDim2.new(0, 150, 0, 35)
    InputContainer.Position = UDim2.new(0, 0, 0, 45)
    InputContainer.BackgroundTransparency = 1
    InputContainer.Parent = MainFrame

    -- Create Player Target TextBox
    local TargetBox = Instance.new("TextBox")
    TargetBox.Size = UDim2.new(1, 0, 1, 0)
    TargetBox.Position = UDim2.new(0, 0, 0, 0)
    TargetBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    TargetBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TargetBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
    TargetBox.PlaceholderText = "Type shortcut..."
    TargetBox.Text = ""
    TargetBox.TextSize = 14
    TargetBox.Font = Enum.Font.GothamBold
    TargetBox.ClearTextOnFocus = false
    TargetBox.TextXAlignment = Enum.TextXAlignment.Left
    TargetBox.ZIndex = 1
    TargetBox.Parent = InputContainer

    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 8)
    Padding.Parent = TargetBox

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 8)
    BoxCorner.Parent = TargetBox

    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.Color = Color3.fromRGB(60, 60, 70)
    BoxStroke.Thickness = 1.5
    BoxStroke.Parent = TargetBox

    -- Translucent Ghost Text Overlay
    local GhostLabel = Instance.new("TextLabel")
    GhostLabel.Size = UDim2.new(1, 0, 1, 0) 
    GhostLabel.Position = UDim2.new(0, 0, 0, 0)
    GhostLabel.BackgroundTransparency = 1 
    GhostLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    GhostLabel.TextTransparency = 0.55
    GhostLabel.TextSize = 14
    GhostLabel.Font = Enum.Font.GothamBold
    GhostLabel.TextXAlignment = Enum.TextXAlignment.Left
    GhostLabel.Text = ""
    GhostLabel.ZIndex = 2
    GhostLabel.Active = false
    GhostLabel.Interactable = false 
    GhostLabel.Parent = InputContainer

    local GhostPadding = Instance.new("UIPadding")
    GhostPadding.PaddingLeft = UDim.new(0, 8)
    GhostPadding.Parent = GhostLabel

    -- PANEL BUTTON 1: Run Combo
    local ComboButton = Instance.new("TextButton")
    ComboButton.Size = UDim2.new(0, 150, 0, 45)
    ComboButton.Position = UDim2.new(0, 0, 0, 85)
    ComboButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ComboButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    ComboButton.TextSize = 14
    ComboButton.Font = Enum.Font.GothamBold
    ComboButton.Text = "RUN COMBO"
    ComboButton.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    ComboButton.TextStrokeTransparency = 0
    ComboButton.Parent = MainFrame

    local ComboCorner = Instance.new("UICorner")
    ComboCorner.CornerRadius = UDim.new(0, 10)
    ComboCorner.Parent = ComboButton

    local ComboStroke = Instance.new("UIStroke")
    ComboStroke.Color = Color3.fromRGB(200, 20, 20)
    ComboStroke.Thickness = 2
    ComboStroke.Parent = ComboButton

    local ComboGradient = Instance.new("UIGradient")
    ComboGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 10, 10)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
    })
    ComboGradient.Rotation = 45
    ComboGradient.Parent = ComboButton

    -- PANEL BUTTON 2: Server Destroyer
    local DestroyServerButton = Instance.new("TextButton")
    DestroyServerButton.Size = UDim2.new(0, 150, 0, 45)
    DestroyServerButton.Position = UDim2.new(0, 0, 0, 135)
    DestroyServerButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DestroyServerButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    DestroyServerButton.TextSize = 13
    DestroyServerButton.Font = Enum.Font.GothamBold
    DestroyServerButton.Text = "SERVER DESTROY"
    DestroyServerButton.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    DestroyServerButton.TextStrokeTransparency = 0
    DestroyServerButton.Parent = MainFrame

    local ServerCorner = Instance.new("UICorner")
    ServerCorner.CornerRadius = UDim.new(0, 10)
    ServerCorner.Parent = DestroyServerButton

    local ServerStroke = Instance.new("UIStroke")
    ServerStroke.Color = Color3.fromRGB(255, 140, 0)
    ServerStroke.Thickness = 2
    ServerStroke.Parent = DestroyServerButton

    local ServerGradient = Instance.new("UIGradient")
    ServerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 25))
    })
    ServerGradient.Rotation = 45
    ServerGradient.Parent = DestroyServerButton

    -- TELEPORT BUTTON 1: TP to Admin Pad (Original Size System)
    local TeleportPadButton = Instance.new("TextButton")
    TeleportPadButton.Size = UDim2.new(0, 150, 0, 45)
    TeleportPadButton.Position = UDim2.new(0, 0, 0, 195)
    TeleportPadButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TeleportPadButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    TeleportPadButton.TextSize = 14
    TeleportPadButton.Font = Enum.Font.GothamBold
                RegenButton.Text = "REGENERATING..." RegenGradient.Enabled = false RegenButton.BackgroundColor3 = Color3.fromRGB(30, 35, 45) RegenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                
                -- Teleport to button container matrix
                rootPart.CFrame = regenPart.CFrame * CFrame.new(0, 2.5, 0)
                task.wait(0.05)
                
                -- Direct click detector invocation
                local detector = regenPart:FindFirstChildOfClass("ClickDetector") or (regenPart.Parent and regenPart.Parent:FindFirstChildOfClass("ClickDetector"))
                if fireclickdetector and detector then
                    fireclickdetector(detector, 0)
                elseif fireclickdetector then
                    local fallbackDetector = workspace:FindFirstChild("Admin") and workspace.Admin:FindFirstChild("Regen") and workspace.Admin.Regen:FindFirstChildOfClass("ClickDetector")
                    if fallbackDetector then fireclickdetector(fallbackDetector, 0) end
                end
                task.wait(0.1)
                
                -- Snap framework back to base origin spot
                rootPart.CFrame = originalCFrame
                RegenButton.Text = "TP TO REGEN" RegenButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255) RegenButton.TextColor3 = Color3.fromRGB(0, 0, 0) RegenGradient.Enabled = true
            else
                RegenButton.Text = "REGEN NOT FOUND" task.wait(1.5) RegenButton.Text = "TP TO REGEN"
            end
        end
    end)
end

-- ==========================================
-- 3. FINAL EXECUTION LISTENERS (BUG-FIXED)
-- ==========================================
local isFirstSpawn = true

-- Run immediately when entering the game
buildThePanel()

-- Run ONLY when you actually die and respawn, bypassing the initial login stream duplication bug
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.3)
    if isFirstSpawn then
        isFirstSpawn = false
    else
        buildThePanel() 
    end
end)
