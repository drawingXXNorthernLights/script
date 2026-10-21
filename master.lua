local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Legacy Chat Network Remote
local DefaultChatSystemChatEvents = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents", 5)
local SayMessageRequest = DefaultChatSystemChatEvents and DefaultChatSystemChatEvents:WaitForChild("SayMessageRequest", 5)

-- Create the ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LegacyMassiveDestroyerGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Create main container frame (Made taller to comfortably fit both buttons)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 150, 0, 195)
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

-- BUTTON 1: Single Target Combo Button (The Working Original Setup)
local ComboButton = Instance.new("TextButton")
ComboButton.Size = UDim2.new(0, 150, 0, 50)
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

-- NEW BUTTON 2: The Looping Server Destroyer Button (Targeted to 'others')
local DestroyServerButton = Instance.new("TextButton")
DestroyServerButton.Size = UDim2.new(0, 150, 0, 50)
DestroyServerButton.Position = UDim2.new(0, 0, 0, 140)
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

-- Configuration Lists
local targetBaseCommands = {
    ":punish ",
    ":blind ",
    ":jail ",
    ":freeze ",
    ":setgrav "
}

local serverDestroyCommands = {
    ":sm FACE MY WRATH BRUV",
    ":respawn others",
    ":infect others",
    ":brightness 10000000000",
    ":fogend 1",
    ":fire others",
    ":sparkles others",
    ":smoke others",
    ":trip others",
    ":seizure others",
    ":flashify others",
    ":dog others",
    ":clone others",
    ":explode others",
    ":skydive others",
    ":freeze others",
    ":kill others",
    ":blind others",
    ":jail others",
    ":stun others",
    ":minihead others",
    ":bighead others",
    ":shiny others",
    ":removelimbs others",
    ":noobify others",
    ":fling others",
    ":creeper others",
    ":music 111044390005146"
}

local isRunningCombo = false
local loopDestroyerActive = false
local isMinimized = false
local dragConnection

-- Background Autocomplete Name Matcher Filter
local function findRealPlayerName(searchString)
    local cleaned = string.lower(searchString)
    if searchString == "" or cleaned == "others" or cleaned == "all" or cleaned == "me" then
        return searchString ~= "" and searchString or "others"
    end
    for _, player in ipairs(Players:GetPlayers()) do
        local playerNameLower = string.lower(player.Name)
        local displayNameLower = string.lower(player.DisplayName)
        if string.sub(playerNameLower, 1, #cleaned) == cleaned or string.sub(displayNameLower, 1, #cleaned) == cleaned then
            return player.Name
        end
    end
    return searchString
end

-- Hook Keystrokes to Ghost Overlay Layer
TargetBox:GetPropertyChangedSignal("Text"):Connect(function()
    local currentText = TargetBox.Text
    if currentText == "" then GhostLabel.Text = "" return end
    local resolved = findRealPlayerName(currentText)
    if resolved and string.lower(string.sub(resolved, 1, #currentText)) == string.lower(currentText) then
        GhostLabel.Text = currentText .. string.sub(resolved, #currentText + 1)
    else
        GhostLabel.Text = ""
    end
end)

-- Mobile Draggable Drag Mechanics (Exclusive to ToggleButton)
local dragging = false
local dragInput, dragStart, startPos

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true dragStart = input.Position startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)

ToggleButton.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
dragConnection = UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Window Minimization Handler
ToggleButton.MouseButton1Click:Connect(function()
    if isMinimized then
        ComboButton.Visible = true
        DestroyServerButton.Visible = true
        InputContainer.Visible = true
        ToggleButton.Text = "—"
        isMinimized = false
    else
        ComboButton.Visible = false
        DestroyServerButton.Visible = false
        InputContainer.Visible = false
        ToggleButton.Text = "+"
        isMinimized = true
    end
end)

-- Script Disposal Mechanics
DestroyButton.MouseButton1Click:Connect(function()
    loopDestroyerActive = false
    if dragConnection then 
        dragConnection:Disconnect() 
    end
    ScreenGui:Destroy()
end)

-- Button 1 Logic (The working original legacy code block)
ComboButton.MouseButton1Click:Connect(function()
    if isRunningCombo or loopDestroyerActive then return end
    local resolvedTarget = findRealPlayerName(TargetBox.Text)
    
    if SayMessageRequest then
        isRunningCombo = true
        ComboGradient.Enabled = false
        ComboButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        ComboStroke.Color = Color3.fromRGB(60, 60, 70)
        ComboButton.Text = "EXECUTING..."
        
        for i, commandBase in ipairs(targetBaseCommands) do
            local finalExecutionString
            if i == 5 then
                finalExecutionString = commandBase .. resolvedTarget .. " -1e9"
            else
                finalExecutionString = commandBase .. resolvedTarget
            end
            SayMessageRequest:FireServer(finalExecutionString, "All")
            task.wait(0.2)
        end
        
        TargetBox.Text = "" 
        GhostLabel.Text = ""
        ComboButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ComboGradient.Enabled = true
        ComboStroke.Color = Color3.fromRGB(200, 20, 20)
        ComboButton.Text = "RUN COMBO"
        isRunningCombo = false
    else
        ComboButton.Text = "CHAT ERROR"
        task.wait(1)
        ComboButton.Text = "RUN COMBO"
    end
end)

-- Button 2 Logic (Looping Server Destroyer utilizing your exact working legacy system)
DestroyServerButton.MouseButton1Click:Connect(function()
    if isRunningCombo then return end
    
    if loopDestroyerActive then
        loopDestroyerActive = false
        return
    end
    
    if SayMessageRequest then
        loopDestroyerActive = true
        ServerGradient.Enabled = false
        DestroyServerButton.BackgroundColor3 = Color3.fromRGB(130, 15, 15)
        ServerStroke.Color = Color3.fromRGB(255, 255, 255)
        DestroyServerButton.Text = "STOP LOOP"
        
        while loopDestroyerActive do
            for _, command in ipairs(serverDestroyCommands) do
                if not loopDestroyerActive then break end
                
                -- Fires directly to your game server's active legacy system bridge
                SayMessageRequest:FireServer(command, "All")
                task.wait(0.25)
            end
            task.wait(0.5)
        end
        
        TargetBox.Text = "" 
        GhostLabel.Text = ""
        DestroyServerButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ServerGradient.Enabled = true
        ServerStroke.Color = Color3.fromRGB(255, 140, 0)
        DestroyServerButton.Text = "SERVER DESTROY"
    end
end)

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- Variables
local LocalPlayer = Players.LocalPlayer

-- FIX FOR JOINING GAME: Forces the script to wait until PlayerGui completely loads
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
while not PlayerGui do
    task.wait(0.1)
    PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
end

-- Custom Kohl's Admin House Pad Searcher
local function locateAdminPad()
    local adminFolder = workspace:FindFirstChild("Admin")
    if adminFolder then
        local pads = adminFolder:FindFirstChild("Pads")
        if pads then
            for _, padModel in ipairs(pads:GetChildren()) do
                local head = padModel:FindFirstChild("Head")
                if head then
                    return head
                end
            end
        end
    end
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Touch to get admin" and obj:IsA("BasePart") then
            return obj
        elseif obj.Name == "Head" and obj.Parent and obj.Parent.Name == "Touch to get admin" then
            return obj
        end
    end
    return nil
end

-- Function to safely spawn and build the button
local function buildTeleportUI()
    -- 1. CREATE OR RE-ESTABLISH THE SCREEN GUI
    local ScreenGui = PlayerGui:FindFirstChild("AdminTeleportGui")
    if not ScreenGui then
        ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "AdminTeleportGui"
        ScreenGui.ResetOnSpawn = false -- Protects it from breaking when character resets
        ScreenGui.Parent = PlayerGui
    else
        -- Wipe any overlapping buttons if it duplicated
        local oldButton = ScreenGui:FindFirstChild("TeleportPadButton")
        if oldButton then oldButton:Destroy() end
    end

    -- 2. CREATE THE TEXT BUTTON
    local TeleportPadButton = Instance.new("TextButton")
    TeleportPadButton.Name = "TeleportPadButton"
    TeleportPadButton.Size = UDim2.new(0, 200, 0, 50)
    TeleportPadButton.Position = UDim2.new(0.5, -100, 0.8, -25) -- Centers it near bottom
    TeleportPadButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TeleportPadButton.Text = "TP TO PAD"
    TeleportPadButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    TeleportPadButton.Font = Enum.Font.SourceSansBold
    TeleportPadButton.TextSize = 18
    TeleportPadButton.BorderSizePixel = 0
    TeleportPadButton.Parent = ScreenGui

    -- 3. CREATE THE GRADIENT EFFECT
    local TPGradient = Instance.new("UIGradient")
    TPGradient.Name = "TPGradient"
    TPGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 255))
    })
    TPGradient.Parent = TeleportPadButton

    -- 4. BUTTON CLICK EVENT LOGIC
    TeleportPadButton.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")
        
        if rootPart then
            local pad = locateAdminPad()
            if pad then
                TeleportPadButton.Text = "TELEPORTING..."
                TPGradient.Enabled = false
                TeleportPadButton.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
                TeleportPadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                
                -- Fast touch simulation to override blockers
                local startTime = os.clock()
                while os.clock() - startTime < 0.5 do
                    if not pad or not rootPart.Parent then break end
                    rootPart.CFrame = pad.CFrame * CFrame.new(0, 2.5, 0)
                    task.wait()
                end
                
                TeleportPadButton.Text = "TP TO PAD"
                TeleportPadButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                TeleportPadButton.TextColor3 = Color3.fromRGB(0, 0, 0)
                TPGradient.Enabled = true
            else
                TeleportPadButton.Text = "PAD NOT FOUND"
                task.wait(1.5)
                TeleportPadButton.Text = "TP TO PAD"
            end
        end
    end)
end

-- Instantly attempts to spawn it upon entering the server
buildTeleportUI()

-- Double-down listener to patch loading gaps if character initializes late
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.3)
    buildTeleportUI()
end)

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- Variables
local LocalPlayer = Players.LocalPlayer

-- FIX FOR JOINING GAME: Forces the script to wait until PlayerGui completely loads
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
while not PlayerGui do
    task.wait(0.1)
    PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
end

-- ==========================================
-- 1. SEARCH LOGIC FUNCTIONS
-- ==========================================

-- Custom Kohl's Admin House Pad Searcher
local function locateAdminPad()
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
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Touch to get admin" and obj:IsA("BasePart") then
            return obj
        elseif obj.Name == "Head" and obj.Parent and obj.Parent.Name == "Touch to get admin" then
            return obj
        end
    end
    return nil
end

-- Custom Kohl's Regen Button Searcher
local function locateRegenButton()
    -- 1. Standard Kohl's Admin House setup path
    local adminFolder = workspace:FindFirstChild("Admin")
    if adminFolder then
        local regenModel = adminFolder:FindFirstChild("Regen")
        if regenModel then
            return regenModel:FindFirstChild("Regen") or regenModel:FindFirstChild("Head") or regenModel:FindFirstChildOfClass("BasePart")
        end
    end

    -- 2. Universal fallback scanner for any part named "Regen"
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
-- 2. UI BUILDER FUNCTION
-- ==========================================
local function buildTeleportUI()
    -- Create or re-establish the ScreenGui container
    local ScreenGui = PlayerGui:FindFirstChild("AdminTeleportGui")
    if not ScreenGui then
        ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "AdminTeleportGui"
        ScreenGui.ResetOnSpawn = false -- Keeps UI alive when you reset/die
        ScreenGui.Parent = PlayerGui
    else
        -- Wipe old instances if they duplicate
        if ScreenGui:FindFirstChild("TeleportPadButton") then ScreenGui.TeleportPadButton:Destroy() end
        if ScreenGui:FindFirstChild("RegenButton") then ScreenGui.RegenButton:Destroy() end
    end

    ------------------------------------------
    -- BUTTON 1: TELEPORT TO ADMIN PAD
    ------------------------------------------
    local TeleportPadButton = Instance.new("TextButton")
    TeleportPadButton.Name = "TeleportPadButton"
    TeleportPadButton.Size = UDim2.new(0, 200, 0, 50)
    TeleportPadButton.Position = UDim2.new(0.5, -100, 0.75, -25) -- Placed slightly higher up
    TeleportPadButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TeleportPadButton.Text = "TP TO PAD"
    TeleportPadButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    TeleportPadButton.Font = Enum.Font.SourceSansBold
    TeleportPadButton.TextSize = 16
    TeleportPadButton.BorderSizePixel = 0
    TeleportPadButton.Parent = ScreenGui

    local TPGradient = Instance.new("UIGradient")
    TPGradient.Name = "TPGradient"
    TPGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 255))
    })
    TPGradient.Parent = TeleportPadButton

    ------------------------------------------
    -- BUTTON 2: TELEPORT TO REGEN (STACKED UNDERNEATH)
    ------------------------------------------
    local RegenButton = Instance.new("TextButton")
    RegenButton.Name = "RegenButton"
    RegenButton.Size = UDim2.new(0, 200, 0, 50) -- Identical size
    RegenButton.Position = UDim2.new(0.5, -100, 0.75, 35) -- Centered on X axis, shifted directly down on Y axis
    RegenButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    RegenButton.Text = "TP TO REGEN"
    RegenButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    RegenButton.Font = Enum.Font.SourceSansBold
    RegenButton.TextSize = 16
    RegenButton.BorderSizePixel = 0
    RegenButton.Parent = ScreenGui

    local RegenGradient = Instance.new("UIGradient")
    RegenGradient.Name = "RegenGradient"
    RegenGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 255, 100)), -- Distinct green/blue tint
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 200, 255))
    })
    RegenGradient.Parent = RegenButton

    -- ==========================================
    -- 3. CLICK EVENT LOGIC
    -- ==========================================

    -- Admin Pad Click Event
    TeleportPadButton.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")
        
        if rootPart then
            local pad = locateAdminPad()
            if pad then
                TeleportPadButton.Text = "TELEPORTING..."
                TPGradient.Enabled = false
                TeleportPadButton.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
                TeleportPadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                
                local startTime = os.clock()
                while os.clock() - startTime < 0.5 do
                    if not pad or not rootPart.Parent then break end
                    rootPart.CFrame = pad.CFrame * CFrame.new(0, 2.5, 0)
                    task.wait()
                end
                
                TeleportPadButton.Text = "TP TO PAD"
                TeleportPadButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                TeleportPadButton.TextColor3 = Color3.fromRGB(0, 0, 0)
                TPGradient.Enabled = true
            else
                TeleportPadButton.Text = "PAD NOT FOUND"
                task.wait(1.5)
                TeleportPadButton.Text = "TP TO PAD"
            end
        end
    end)

    -- Regen Button Click Event
    RegenButton.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")
        
        if rootPart then
            local regenPart = locateRegenButton()
            if regenPart then
                RegenButton.Text = "REGENERATING..."
                RegenGradient.Enabled = false
                RegenButton.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
                RegenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    
                 -- Continuously teleports you to the Regen brick to force a clean server touch
                local startTime = os.clock()
                while os.clock() - startTime < 0.5 do
                    if not regenPart or not rootPart.Parent then break end
                    rootPart.CFrame = regenPart.CFrame * CFrame.new(0, 2.5, 0)
                    task.wait()
                end
                
                RegenButton.Text = "TP TO REGEN"
                RegenButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                RegenButton.TextColor3 = Color3.fromRGB(0, 0, 0)
                RegenGradient.Enabled = true
            else
                RegenButton.Text = "REGEN NOT FOUND"
                task.wait(1.5)
                RegenButton.Text = "TP TO REGEN"
            end
        end
    end)
end

-- Instantly attempts to spawn the dual buttons upon entry
buildTeleportUI()

-- Rebuild interface safely if character initializes late/spawns after death
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.3)
    buildTeleportUI()
end)
