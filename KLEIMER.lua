-- LocalScript dentro de ScreenGui en StarterGui

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Esperamos a que exista el PlayerGui
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = script.Parent -- El ScreenGui

-- Elementos de la GUI
local pasesButton = screenGui:WaitForChild("PasesButton")
local pasesMenu = screenGui:WaitForChild("PasesMenu")

-- Ocultamos el menú al inicio
pasesMenu.Visible = false

-- Lista de pases (puedes agregar más)
local pases = {
	{
		name = "Pase Épico",
		id = 12345678,        -- ID del GamePass real (cámbialo por el tuyo)
		precio = "399 Robux",
		desbloqueado = false
	},
	{
		name = "Doble XP Permanente",
		id = 87654321,
		precio = "199 Robux",
		desbloqueado = false
	},
	{
		name = "Skin Exclusiva",
		id = 11223344,
		precio = "499 Robux",
		desbloqueado = false
	}
}

-- Función para verificar si el jugador tiene el GamePass
local function tienePase(paseId)
	local success, tiene = pcall(function()
		return game.MarketplaceService:UserOwnsGamePassAsync(player.UserId, paseId)
	end)
	return success and tiene
end

-- Crear los botones de los pases dinámicamente
for i, pase in ipairs(pases) do
	local boton = Instance.new("TextButton")
	boton.Name = "Pase" .. i
	boton.Size = UDim2.new(0.9, 0, 0.15, 0)
	boton.Position = UDim2.new(0.05, 0, 0.1 + (i-1)*0.18, 0)
	boton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	boton.BorderSizePixel = 2
	boton.BorderColor3 = Color3.fromRGB(100, 100, 255)
	boton.TextColor3 = Color3.fromRGB(255, 255, 255)
	boton.Font = Enum.Font.GothamBold
	boton.TextScaled = true
	boton.Parent = pasesMenu

	-- Actualizar estado inicial
	local function actualizarEstado()
		if tienePase(pase.id) then
			boton.Text = pase.name .. "\nDESBLOQUEADO"
			boton.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
			boton.TextColor3 = Color3.fromRGB(200, 255, 200)
		else
			boton.Text = pase.name .. "\n" .. pase.precio .. "\n(Toca para comprar)"
			boton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		end
	end

	actualizarEstado()

	-- Evento al hacer clic
	boton.MouseButton1Click:Connect(function()
		if tienePase(pase.id) then
			-- Ya lo tiene, puedes mostrar un mensaje
			print("Ya tienes este pase!")
		else
			-- Intentar comprar
			game.MarketplaceService:PromptGamePassPurchase(player, pase.id)
		end
	end)

	-- Escuchar si se compra durante la sesión
	game.MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(plr, gamePassId, purchased)
		if plr == player and gamePassId == pase.id and purchased then
			actualizarEstado()
		end
	end)
end

-- Botón principal "PASES"
pasesButton.Text = "PASES"
pasesButton.MouseButton1Click:Connect(function()
	pasesMenu.Visible = not pasesMenu.Visible
	if pasesMenu.Visible then
		pasesButton.Text = "CERRAR"
	else
		pasesButton.Text = "PASES"
	end
end)

-- Opcional: Botón de cerrar en el menú
local cerrarBoton = Instance.new("TextButton")
cerrarBoton.Size = UDim2.new(0.15, 0, 0.1, 0)
cerrarBoton.Position = UDim2.new(0.825, 0, 0.02, 0)
cerrarBoton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
cerrarBoton.Text = "X"
cerrarBoton.TextColor3 = Color3.white
cerrarBoton.Font = Enum.Font.GothamBold
cerrarBoton.TextScaled = true
cerrarBoton.Parent = pasesMenu

cerrarBoton.MouseButton1Click:Connect(function()
	pasesMenu.Visible = false
	pasesButton.Text = "PASES"
end)
