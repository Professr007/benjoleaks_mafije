
ESX	= nil

PlayerData = {}
local handcuffTimer     = {}
local IsHandcuffed            = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(5000)
	end


	Citizen.Wait(2000)
	PlayerData = ESX.GetPlayerData()
end)


-----------------------------------meni organizacije-------------------
RegisterKeyMapping('+benjo', 'Benjo Mafije', 'keyboard', 'F6')

RegisterCommand("+benjo", function() 
	for k, v in pairs(Config.Organizacije) do     
        if ESX.PlayerData.job and ESX.PlayerData.job.name == v.job then  
            TriggerEvent('vule:otvorimeni')
        end
    end  
end)

RegisterNetEvent("vule:otvorimeni")
AddEventHandler("vule:otvorimeni", function()
	TriggerEvent('nh-context:sendMenu', {
		{
			id = 1,
			header = "< Nazad",
			txt = "",
			params = {
				event = "",
			}
		},
		{
			id = 2,
			header = "➪ ZAVEZI",
			txt = "",
			params = {
				event = "vaskezzyy:vezivanje1",
			}
		},
		{
			id = 4,
			header = "➪ VUCI",
			txt = "",
			params = {
				event = "vaskezzyy:vuci",
			}
		},
		{
			id = 5,
			header = "➪ UBACI U VOZILO",
			txt = "",
			params = {
				event = "vule:uvozilo",
			}
		},
		{
			id = 6,
			header = "➪ IZBACI IZ VOZILA",
			txt = "",
			params = {
				event = "vule:izbaci",
			}
		},
		{
			id = 6,
			header = "➪ PRETRAZI",
			txt = "",
			params = {
				event = "vaskezzyy:pretrazi",
			}
		}
	})
end)


RegisterNetEvent("vaskezzyy:pretrazi",function()
	
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	--local IsHandcuffed = true
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		
		TriggerEvent('pretrazi')
		
	else
		exports['okokNotify']:Alert("", "Nema igraca u vasoj blizini", 2500, 'info')
	end
	
end)

RegisterNetEvent("vule:uvozilo", function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		
		if pretrazujes then
			
			TriggerServerEvent('vule:akohocestavi', GetPlayerServerId(closestPlayer))
				
		end	
	else
		exports['okokNotify']:Alert("", "Nema igraca u vasoj blizini", 4000, 'success')
	end
end)

RegisterNetEvent("vule:izbaci", function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		TriggerServerEvent('vule:idegas2', GetPlayerServerId(closestPlayer))
  else
    exports['okokNotify']:Alert("", "Nema igraca u vasoj blizini", 4000, 'success')
		print("idegas")
	end
end)

RegisterNetEvent('vaskezzyy:vezivanje1')
AddEventHandler('vaskezzyy:vezivanje1', function(target)
	local player, distance = ESX.Game.GetClosestPlayer()
	if distance ~= -1 and distance <= 3.0 then
		TriggerServerEvent('vaskezzyy:vezivanje', GetPlayerServerId(player))
	else
		exports['okokNotify']:Alert("", "Nema nikog u blizini", 2500, 'info')
	end
end)

RegisterNetEvent('vaskezzyy:vezivanje')
AddEventHandler('vaskezzyy:vezivanje', function()

  IsHandcuffed    = not IsHandcuffed;
  local playerPed = PlayerPedId()

  Citizen.CreateThread(function()

    if IsHandcuffed then

      RequestAnimDict('mp_arresting')

      while not HasAnimDictLoaded('mp_arresting') do
        Wait(100)
      end

      TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
      SetEnableHandcuffs(playerPed, true)
      SetPedCanPlayGestureAnims(playerPed, false)
      FreezeEntityPosition(playerPed,  true)

    else

      ClearPedSecondaryTask(playerPed)
      SetEnableHandcuffs(playerPed, false)
      SetPedCanPlayGestureAnims(playerPed,  true)
      FreezeEntityPosition(playerPed, false)

    end

  end)
end)

Citizen.CreateThread(function()
	while true do
	  Wait(0)
	  if IsHandcuffed then
		if IsDragged then
		  local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
		  local myped = PlayerPedId()
		  AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
		else
		  DetachEntity(PlayerPedId(), true, false)
		end
	  end
	end
end)

Citizen.CreateThread(function()
	while true do
	  Wait(0)
	  if IsHandcuffed then
			DisableControlAction(0, 1, true) -- Disable pan
			DisableControlAction(0, 2, true) -- Disable tilt
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 32, true) -- W
			DisableControlAction(0, 34, true) -- A
			DisableControlAction(0, 31, true) -- S
			DisableControlAction(0, 30, true) -- D
			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?
			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job
			DisableControlAction(0, 0, true) -- Disable changing view
			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen
			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle
			DisableControlAction(2, 36, true) -- Disable going stealth
			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
	  	end
	end
end)
