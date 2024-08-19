local sleep = 1000
local handsUp = false
local vehicleAttached = false
local closestVehicle = nil
local npcAttached = false
local closestPed = nil

RegisterCommand("superman", function()
    local playerPed = PlayerPedId()

    while true do
        Wait(sleep)
        local playerPed = PlayerPedId()
        closestVehicle, vehicleDistance = GetClosestVehicleToPlayer()
        closestPed, pedDistance = getClosestNPCToPlayer()


        if closestVehicle and vehicleDistance < 5.0 then
            if not vehicleAttached then
                sleep = 1
                -- Get the position of the vehicle and draw text on it
                local vehiclePos = GetEntityCoords(closestVehicle)
                Draw3DText(vehiclePos.x, vehiclePos.y, vehiclePos.z + 1.0, "Press E to grab the car")
            elseif vehicleAttached then
                sleep = 1
                -- Get the position of the vehicle and draw text on it
                local vehiclePos = GetEntityCoords(closestVehicle)
                Draw3DText(vehiclePos.x, vehiclePos.y, vehiclePos.z + 1.0, "Press E to throw the car")
            else
                sleep = 1000
            end
        elseif closestPed and pedDistance < 5.0 then
            if not IsPedInAnyVehicle(closestPed, false) then
                if not npcAttached then
                    sleep = 1
                    -- Get the position of the vehicle and draw text on it
                    local pedPos = GetEntityCoords(closestPed)
                    Draw3DText(pedPos.x, pedPos.y, pedPos.z + 1.0, "Press E to grab the ped")
                elseif npcAttached then
                    sleep = 1
                    -- Get the position of the vehicle and draw text on it
                    local pedPos = GetEntityCoords(closestPed)
                    Draw3DText(pedPos.x, pedPos.y, pedPos.z + 1.0, "Press E to throw the ped")
                else
                    sleep = 1000
                end
            end
        end

        -- Check if the player presses the "E" key
        if IsControlJustReleased(0, 38) then -- 38 is the control code for "E"
            if not vehicleAttached and closestVehicle and vehicleDistance < 5.0 then
                -- Attach the vehicle to the player's hands
                local playerCoords = GetEntityCoords(playerPed)
                local offset = vector3(1.2, 0.0, 0.0) -- Adjust this to change the vehicle's position relative to the player's hands

                -- Attach the vehicle to the player's hand
                AttachEntityToEntity(
                    closestVehicle,
                    playerPed,
                    GetPedBoneIndex(playerPed, 57005), -- 57005 is the bone index for the right hand
                    offset.x, offset.y, offset.z,
                    0.0, 0.0, 0.0,
                    false, false, false, false, 2, true
                )

                -- Raise the player's hand (animation)
                if not HasAnimDictLoaded('missminuteman_1ig_2') then
                    RequestAnimDict('missminuteman_1ig_2')
                    while not HasAnimDictLoaded('missminuteman_1ig_2') do
                        Wait(10)
                    end
                end
                
                TaskPlayAnim(playerPed, 'missminuteman_1ig_2', 'handsup_base', 8.0, 8.0, -1, 50, 0, false, false, false)

                vehicleAttached = true
            elseif vehicleAttached then
                -- Detach the vehicle and throw it in the direction the player's camera is facing
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local camRot = GetGameplayCamRot(2)
                local forwardVector = RotToDirection(camRot)

                SetEntityNoCollisionEntity(closestVehicle, playerPed, false)

                -- Detach the vehicle
                DetachEntity(closestVehicle, true, true)

                -- Apply force to the vehicle
                local forceVector = forwardVector * Config.throwForce
                ApplyForceToEntity(
                    closestVehicle,
                    1, -- Force type (1 is high force)
                    forceVector.x,
                    forceVector.y,
                    forceVector.z
                )

                vehicleAttached = false
                ClearPedTasks(playerPed)
            elseif not npcAttached and closestPed and pedDistance < 5.0 and not IsPedInAnyVehicle(closestPed, false)then
                -- Attach the vehicle to the player's hands
                local playerCoords = GetEntityCoords(playerPed)
                local offset = vector3(0.5, 0.0, 0.0) -- Adjust this to change the vehicle's position relative to the player's hands

                -- Attach the vehicle to the player's hand
                AttachEntityToEntity(
                    closestPed,
                    playerPed,
                    GetPedBoneIndex(playerPed, 57005), -- 57005 is the bone index for the right hand
                    offset.x, offset.y, offset.z,
                    0.0, 0.0, 0.0,
                    false, false, false, false, 2, true
                )

                -- Raise the player's hand (animation)
                if not HasAnimDictLoaded('missminuteman_1ig_2') then
                    RequestAnimDict('missminuteman_1ig_2')
                    while not HasAnimDictLoaded('missminuteman_1ig_2') do
                        Wait(10)
                    end
                end
                
                TaskPlayAnim(playerPed, 'missminuteman_1ig_2', 'handsup_base', 8.0, 8.0, -1, 50, 0, false, false, false)

                npcAttached = true
            elseif npcAttached then
                -- Detach the vehicle and throw it in the direction the player's camera is facing
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local camRot = GetGameplayCamRot(2)
                local forwardVector = RotToDirection(camRot)

                SetEntityNoCollisionEntity(closestPed, playerPed, false)

                -- Detach the vehicle
                DetachEntity(closestPed, true, true)
                -- Apply force to the vehicle
                local forceVector = forwardVector * Config.throwForce
                ApplyForceToEntity(
                    closestPed,
                    1, -- Force type (1 is high force)
                    forceVector.x,
                    forceVector.y,
                    forceVector.z
                )
                npcAttached = false
                ClearPedTasks(playerPed)
                Wait(10)
                SetPedToRagdoll(closestPed, 1000, 1000, 0, true, false, false)
            end
        end
    end
end, true)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    if closestVehicle then
        DetachEntity(closestVehicle, true, true)
    end
end)