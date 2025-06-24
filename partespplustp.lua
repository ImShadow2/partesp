-- Combined Hover + Parts Browser UI | Clean Execution | Organized in Tabs

-- Cleanup
for _, guiName in ipairs({"CombinedPartUI"}) do
	local gui = game:GetService("CoreGui"):FindFirstChild(guiName)
	if gui then gui:Destroy() end
end
if _G.CombinedPartConnections then
	for _, c in ipairs(_G.CombinedPartConnections) do pcall(function() c:Disconnect() end) end
end
if _G.CombinedPartESPs then
	for _, esp in ipairs(_G.CombinedPartESPs) do if esp and esp.Parent then esp:Destroy() end end
end
_G.CombinedPartConnections = {}
_G.CombinedPartESPs = {}

local function connect(signal, func)
	local c = signal:Connect(func)
	table.insert(_G.CombinedPartConnections, c)
	return c
end

-- Services
local player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local menuVisible = false

local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "CombinedPartUI"
gui.Enabled = menuVisible -- Start hidden

UIS.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == Enum.KeyCode.Insert then
		menuVisible = not menuVisible
		gui.Enabled = menuVisible
	end
end)


local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

-- Create Main GUI
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "CombinedPartUI"

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "Parts Utility Hub"

-- Tab Buttons
local tabFrame = Instance.new("Frame", mainFrame)
tabFrame.Position = UDim2.new(0, 0, 0, 40)
tabFrame.Size = UDim2.new(1, 0, 0, 30)
tabFrame.BackgroundTransparency = 1

local hoverTab = Instance.new("TextButton", tabFrame)
hoverTab.Position = UDim2.new(0, 10, 0, 0)
hoverTab.Size = UDim2.new(0, 180, 1, 0)
hoverTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
hoverTab.TextColor3 = Color3.fromRGB(255, 255, 255)
hoverTab.Font = Enum.Font.GothamBold
hoverTab.TextSize = 14
hoverTab.Text = "Hover + ESP"

local browserTab = Instance.new("TextButton", tabFrame)
browserTab.Position = UDim2.new(0, 200, 0, 0)
browserTab.Size = UDim2.new(0, 180, 1, 0)
browserTab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
browserTab.TextColor3 = Color3.fromRGB(255, 255, 255)
browserTab.Font = Enum.Font.GothamBold
browserTab.TextSize = 14
browserTab.Text = "Parts Browser"

-- Container Frames
local hoverContainer = Instance.new("Frame", mainFrame)
hoverContainer.Position = UDim2.new(0, 0, 0, 70)
hoverContainer.Size = UDim2.new(1, 0, 1, -70)
hoverContainer.BackgroundTransparency = 1

local browserContainer = Instance.new("Frame", mainFrame)
browserContainer.Position = UDim2.new(0, 0, 0, 70)
browserContainer.Size = UDim2.new(1, 0, 1, -70)
browserContainer.BackgroundTransparency = 1
browserContainer.Visible = false

-- Hover + ESP Elements
local hoverToggle = Instance.new("TextButton", hoverContainer)
hoverToggle.Position = UDim2.new(0, 10, 0, 10)
hoverToggle.Size = UDim2.new(0, 120, 0, 30)
hoverToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
hoverToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
hoverToggle.Font = Enum.Font.GothamBold
hoverToggle.TextSize = 14
hoverToggle.Text = "Hover: OFF"

local espInput = Instance.new("TextBox", hoverContainer)
espInput.Position = UDim2.new(0, 10, 0, 50)
espInput.Size = UDim2.new(0, 200, 0, 30)
espInput.PlaceholderText = "Filter Part Name"
espInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
espInput.TextColor3 = Color3.fromRGB(255, 255, 255)
espInput.Font = Enum.Font.Gotham
espInput.TextSize = 14

local espToggle = Instance.new("TextButton", hoverContainer)
espToggle.Position = UDim2.new(0, 220, 0, 50)
espToggle.Size = UDim2.new(0, 150, 0, 30)
espToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
espToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
espToggle.Font = Enum.Font.GothamBold
espToggle.TextSize = 14
espToggle.Text = "Part ESP: OFF"

local espOn, hoverOn, currentFilter = false, false, ""

-- BillboardGui for Hover Name
local hoverNameGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
hoverNameGui.Name = "HoverNameGui"

local hoverLabel = Instance.new("TextLabel", hoverNameGui)
hoverLabel.Size = UDim2.new(0, 150, 0, 25)
hoverLabel.BackgroundTransparency = 1 -- Fully transparent background
hoverLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
hoverLabel.TextStrokeTransparency = 0 -- Optional: add/remove stroke outline for visibility
hoverLabel.TextScaled = true
hoverLabel.Visible = false
hoverLabel.Font = Enum.Font.Arial -- ✅ Arial font here
hoverLabel.Text = ""



-- ESP Functions
local function createESP(part)
	local adorn = Instance.new("BoxHandleAdornment")
	adorn.Adornee = part
	adorn.AlwaysOnTop = true
	adorn.ZIndex = 10
	adorn.Size = part.Size
	adorn.Transparency = 0.25
	adorn.Color3 = Color3.fromRGB(255, 0, 0)
	adorn.Parent = gui
	table.insert(_G.CombinedPartESPs, adorn)

	-- Remove ESP if part is destroyed (AncestryChanged)
	connect(part.AncestryChanged, function(_, parent)
		if not parent and adorn and adorn.Parent then
			adorn:Destroy()
		end
	end)

	-- Extra: Check EVERY frame if adornee is missing
	connect(game:GetService("RunService").Heartbeat, function()
		if not adorn.Adornee or not adorn.Adornee.Parent then
			if adorn and adorn.Parent then adorn:Destroy() end
		end
	end)
end



local function refreshESP()
	for _, esp in ipairs(_G.CombinedPartESPs) do if esp and esp.Parent then esp:Destroy() end end
	table.clear(_G.CombinedPartESPs)
	if espOn and currentFilter ~= "" then
		for _, v in ipairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") and v.Name:lower():find(currentFilter:lower()) then
				createESP(v)
			end
		end
	end
end

local function getHoveredPart()
	local ray = camera:ScreenPointToRay(mouse.X, mouse.Y)
	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {workspace}
	params.FilterType = Enum.RaycastFilterType.Include
	params.IgnoreWater = true
	local result = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)

	if result and result.Instance then
		-- Ignore parts of your own character
		if result.Instance:IsDescendantOf(player.Character) then
			return nil
		end
		return result.Instance
	end
	return nil
end


connect(game:GetService("RunService").RenderStepped, function()
	if hoverOn then
		local hovered = getHoveredPart()
		if hovered and hovered:IsA("BasePart") then
			hoverLabel.Visible = true
			hoverLabel.Text = hovered.Name
			hoverLabel.Position = UDim2.new(0, mouse.X + 20, 0, mouse.Y) -- 20 pixels to the right of mouse
		else
			hoverLabel.Visible = false
		end
	else
		hoverLabel.Visible = false
	end
end)



hoverToggle.MouseButton1Click:Connect(function()
	hoverOn = not hoverOn
	hoverToggle.Text = hoverOn and "Hover: ON" or "Hover: OFF"
	hoverToggle.BackgroundColor3 = hoverOn and Color3.fromRGB(30, 120, 30) or Color3.fromRGB(30, 30, 30)
end)

espToggle.MouseButton1Click:Connect(function()
	espOn = not espOn
	espToggle.Text = espOn and "Part ESP: ON" or "Part ESP: OFF"
	espToggle.BackgroundColor3 = espOn and Color3.fromRGB(200, 30, 30) or Color3.fromRGB(30, 30, 30)
	currentFilter = espInput.Text
	refreshESP()
end)

espInput.FocusLost:Connect(function()
	currentFilter = espInput.Text
	if espOn then refreshESP() end
end)

-- Parts Browser Elements
local filterBox = Instance.new("TextBox", browserContainer)
filterBox.Position = UDim2.new(0, 10, 0, 10)
filterBox.Size = UDim2.new(1, -20, 0, 30)
filterBox.PlaceholderText = "Search parts by name..."
filterBox.Font = Enum.Font.Gotham
filterBox.TextSize = 14
filterBox.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
filterBox.TextColor3 = Color3.fromRGB(255, 255, 255)
filterBox.BorderSizePixel = 0
Instance.new("UICorner", filterBox).CornerRadius = UDim.new(0, 6)

local scroll = Instance.new("ScrollingFrame", browserContainer)
scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.Size = UDim2.new(1, -20, 1, -60)
scroll.BackgroundColor3 = Color3.fromRGB(23, 33, 53)
scroll.ScrollBarThickness = 6
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 6)

local listLayout = Instance.new("UIListLayout", scroll)
listLayout.Padding = UDim.new(0, 4)

local function teleportToPart(part)
	if part and part:IsA("BasePart") and part.Parent then
		player.Character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 3, 0)
	end
end

local function isPartOfPlayerCharacter(part)
	local ancestor = part.Parent
	while ancestor do
		if ancestor:IsA("Model") and game.Players:GetPlayerFromCharacter(ancestor) then
			return true
		end
		ancestor = ancestor.Parent
	end
	return false
end

local function createEntry(part, index)
	local item = Instance.new("Frame")
	item.Size = UDim2.new(1, -8, 0, 32)
	item.BackgroundColor3 = Color3.fromRGB(34, 45, 68)
	item.BorderSizePixel = 0
	Instance.new("UICorner", item).CornerRadius = UDim.new(0, 6)

	local nameLabel = Instance.new("TextLabel", item)
	nameLabel.Size = UDim2.new(1, -8, 1, 0)
	nameLabel.Position = UDim2.new(0, 8, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = tostring(index)..". "..part.Name
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextSize = 14
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left

	local btn = Instance.new("TextButton", item)
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Text = ""

	connect(btn.MouseButton1Click, function()
		for _, esp in ipairs(_G.CombinedPartESPs) do if esp and esp.Parent then esp:Destroy() end end
		table.clear(_G.CombinedPartESPs)
		createESP(part)
		teleportToPart(part)
	end)

	return item
end

local function populateParts(filter)
	scroll:ClearAllChildren()
	listLayout = Instance.new("UIListLayout", scroll)
	listLayout.Padding = UDim.new(0, 4)

	local count = 0
	for _, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") and not isPartOfPlayerCharacter(v) and (filter == "" or v.Name:lower():find(filter:lower())) then
			count = count + 1
			local entry = createEntry(v, count)
			entry.Parent = scroll
		end
	end

	task.wait(0.1)
	scroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end

filterBox.FocusLost:Connect(function()
	populateParts(filterBox.Text)
end)

populateParts("")

-- Tabs Toggle
hoverTab.MouseButton1Click:Connect(function()
	hoverContainer.Visible = true
	browserContainer.Visible = false
	hoverTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	browserTab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
end)

browserTab.MouseButton1Click:Connect(function()
	hoverContainer.Visible = false
	browserContainer.Visible = true
	hoverTab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	browserTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

-- Draggable MainFrame
local dragging, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
	end
end)
UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
end)
