function reqModel(model) 
    model = GetHashKey(model)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(5) end
    return model
end

function fillVehicleWithPeds(veh, pedsModel)
    local pedModel = reqModel(pedsModel)
    local peds = {}
    for i=1, GetVehicleMaxNumberOfPassengers(veh) do
        table.insert(peds, CreatePedInsideVehicle(veh, 4, pedModel, i, true, false))
    end
    return peds
end

function pickupJob(id)
    local p = table.remove(current_job.route, id)
    
    RemoveBlip(p.blip)
    p.blip = nil
    
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    local peds = fillVehicleWithPeds(veh, "THE_PRISONER_INMATE_MODEL_NAME_THAT_I_DONT_KNOW_CAN_YOU_REPLACE_THIS_PLEASE_THANKS_MR_TROUBLE") 
    local newpeds = 0
    if next(peds) ~= nil then
        for k,v in next, peds do
            newpeds = newpeds + 1
            table.insert(current_job.peds, v)
        end
    end
    
    current_job.fares = current_job.fares + newpeds
    
    TriggerServerEvent("gd_jobs_bus:pickupJob", newpeds, current_job.cargo.pay, current_job.tier)
    if (#current_job.route > 0) then
        drawMessage(string.format(continueMessage, current_job.cargo.name, current_job.total_stops - #current_job.route, current_job.total_stops))
    else
        deliverJob()
    end
end