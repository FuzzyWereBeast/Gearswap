--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- __________.__                                ________                          __               .__.__  __      __  .__    .__           _____.__.__              
-- \______   |  |   ____ _____    ______ ____   \______ \   ____     ____   _____/  |_    ____   __| _|___/  |_  _/  |_|  |__ |__| ______ _/ ____|__|  |   ____      
--  |     ___|  | _/ __ \\__  \  /  ____/ __ \   |    |  \ /  _ \   /    \ /  _ \   __\ _/ __ \ / __ ||  \   __\ \   __|  |  \|  |/  ___/ \   __\|  |  | _/ __ \     
--  |    |   |  |_\  ___/ / __ \_\___ \\  ___/   |    `   (  <_> ) |   |  (  <_> |  |   \  ___// /_/ ||  ||  |    |  | |   Y  |  |\___ \   |  |  |  |  |_\  ___/     
--  |____|   |____/\___  (____  /____  >\___  > /_______  /\____/  |___|  /\____/|__|    \___  \____ ||__||__|    |__| |___|  |__/____  >  |__|  |__|____/\___  > /\ 
--                     \/     \/     \/     \/          \/              \/                   \/     \/                      \/        \/                      \/  \/ 
--
--	Please do not edit this file!							Please do not edit this file!							Please do not edit this file!
--
--	Editing this file will cause you to be unable to use Github Desktop to update!
--
--	Any changes you wish to make in this file you should be able to make by overloading. That is Re-Defining the same variables or functions in another file, by copying and
--	pasting them to a file that is loaded after the original file, all of my library files, and then job files are loaded first.
--	The last files to load are the ones unique to you. User-Globals, Charactername-Globals, Charactername_Job_Gear, in that order, so these changes will take precedence.
--
--	You may wish to "hook" into existing functions, to add functionality without losing access to updates or fixes I make, for example, instead of copying and editing
--	status_change(), you can instead use the function user_status_change() in the same manner, which is called by status_change() if it exists, most of the important 
--  gearswap functions work like this in my files, and if it's unique to a specific job, user_job_status_change() would be appropriate instead.
--
--  Variables and tables can be easily redefined just by defining them in one of the later loaded files: autofood = 'Miso Ramen' for example.
--  States can be redefined as well: state.HybridMode:options('Normal','PDT') though most of these are already redefined in the gear files for editing there.
--	Commands can be added easily with: user_self_command(commandArgs, eventArgs) or user_job_self_command(commandArgs, eventArgs)
--
--	If you're not sure where is appropriate to copy and paste variables, tables and functions to make changes or add them:
--		User-Globals.lua - 			This file loads with all characters, all jobs, so it's ideal for settings and rules you want to be the same no matter what.
--		Charactername-Globals.lua -	This file loads with one character, all jobs, so it's ideal for gear settings that are usable on all jobs, but unique to this character.
--		Charactername_Job_Gear.lua-	This file loads only on one character, one job, so it's ideal for things that are specific only to that job and character.
--
--
--	If you still need help, feel free to contact me on discord or ask in my chat for help: https://discord.gg/ug6xtvQ
--  !Please do NOT message me in game about anything third party related, though you're welcome to message me there and ask me to talk on another medium.
--
--  Please do not edit this file!							Please do not edit this file!							Please do not edit this file!
-- __________.__                                ________                          __               .__.__  __      __  .__    .__           _____.__.__              
-- \______   |  |   ____ _____    ______ ____   \______ \   ____     ____   _____/  |_    ____   __| _|___/  |_  _/  |_|  |__ |__| ______ _/ ____|__|  |   ____      
--  |     ___|  | _/ __ \\__  \  /  ____/ __ \   |    |  \ /  _ \   /    \ /  _ \   __\ _/ __ \ / __ ||  \   __\ \   __|  |  \|  |/  ___/ \   __\|  |  | _/ __ \     
--  |    |   |  |_\  ___/ / __ \_\___ \\  ___/   |    `   (  <_> ) |   |  (  <_> |  |   \  ___// /_/ ||  ||  |    |  | |   Y  |  |\___ \   |  |  |  |  |_\  ___/     
--  |____|   |____/\___  (____  /____  >\___  > /_______  /\____/  |___|  /\____/|__|    \___  \____ ||__||__|    |__| |___|  |__/____  >  |__|  |__|____/\___  > /\ 
--                     \/     \/     \/     \/          \/              \/                   \/     \/                      \/        \/                      \/  \/ 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Requires Gearswap and Motenten includes.
being_attacked = false
engaging = os.clock()

include('Sel-MonsterAbilities.lua')

state.AutoDefenseMode = M(false, 'Auto Defense Mode')
state.TankAutoDefense = M(false, 'Maintain Tanking Defense')
state.AutoEngageMode = M(false, 'Auto Engage Mode')
state.AutoStunMode = M(false, 'Auto Stun Mode')
state.BlockWarp = M(false, 'BlockWarp')

CureAbility = S{"Cure","Cure II","Cure III","Cure IV","Cure V","Cure VI","Magic Fruit","Wild Carrot","Plenilune Embrace","Curaga","Curaga II",
				"Curaga III","Curaga IV","Curaga V",
				 }
				 
CuragaAbility = S{"Curaga","Curaga II","Curaga III","Curaga IV","Curaga V","Cura","Cura III","Cura III","White Wind",
				 }
				 
ProshellAbility = S{"Protect","Protect II","Protect III","Protect IV","Protect V",
					"Shell","Shell II","Shell III","Shell IV","Shell V",
				 }
				 
ProshellraAbility = S{"Protectra","Protectra II","Protectra III","Protectra IV","Protectra V",
					"Shellra","Shellra II","Shellra III","Shellra IV","Shellra V",
				 }
				 
RefreshAbility = S{"Refresh","Refresh II", "Refresh III"
				 }
				 
PhalanxAbility = S{"Phalanx II"
				 }
				 
EnhancingAbility = S{"Haste","Haste II","Flurry","Flurry II","Adloquium","Erratic Flutter","Animating Wail",
				 }

function check_reaction(act)

	--Gather Info
    local curact = T(act)
    local actor = T{}
	local otherTarget = T{}

    actor.id = curact.actor_id
	-- Make sure it's something we actually care about reacting to.
	if curact.category == 1 and not ((state.AutoEngageMode.value and player.status == 'Idle')) and being_attacked then return end

	if not ((curact.category == 1 or curact.category == 3 or curact.category == 4 or curact.category == 7 or curact.category == 8 or curact.category == 11 or curact.category == 13)) then return end
	-- Make sure it's a mob that's doing something.
    if windower.ffxi.get_mob_by_id(actor.id) then
        actor = windower.ffxi.get_mob_by_id(actor.id)
    else
        return
    end

	-- Check if we're targetting it.
    if player and player.target and player.target.id and actor.id == player.target.id then
        isTarget = true
    else
		isTarget = false
    end

	if curact.targets[1].id == nil then
		targetsMe = false
		targetsSelf = false
		otherTarget.in_party = false
		otherTarget.in_alliance = false
		targetsDistance = 50
	elseif curact.targets[1].id == player.id then
		otherTarget.in_party = false
		otherTarget.in_alliance = false
		targetsMe = true
		targetsSelf = false
		targetsDistance = 0
	elseif curact.targets[1].id == actor.id	then
		if windower.ffxi.get_mob_by_id(curact.targets[1].id) then
			otherTarget = windower.ffxi.get_mob_by_id(curact.targets[1].id)
		else
			otherTarget.in_party = false
			otherTarget.in_alliance = false
			otherTarget.distance = 10000
		end
		targetsMe = false
		targetsSelf = true
		targetsDistance = math.sqrt(otherTarget.distance)
	else
		if windower.ffxi.get_mob_by_id(curact.targets[1].id) then
			otherTarget = windower.ffxi.get_mob_by_id(curact.targets[1].id)
		else
			otherTarget.in_party = false
			otherTarget.in_alliance = false
			otherTarget.distance = 10000
		end
		targetsSelf = false
		targetsMe = false
		targetsDistance = math.sqrt(otherTarget.distance)
	end
	
	if curact.category == 1 then
		if targetsMe then
			if state.AutoEngageMode.value and actor.race == 0 and math.sqrt(actor.distance) < (3.2 + actor.model_size) and player.status == 'Idle' and not (moving or engaging > os.clock() or actor.name:contains("'s ")) then
				engaging = os.clock() + 2
				
				packets.inject(packets.new('outgoing', 0x1a, {
					['Target'] = actor.id,
					['Target Index'] = actor.index,
					['Category']     = 0x02,
				}))
				
			elseif player.status == 'Idle' and not (being_attacked or midaction() or pet_midaction() or (petWillAct + 2) > os.clock()) then
				windower.send_command('gs c forceequip')
			end
			being_attacked = true
		elseif isTarget and otherTarget.in_party and check_cover then
			check_cover(otherTarget)
		end
		return
	end

	-- Track buffs locally
	if curact.category == 4 then
		act_info = res.spells[curact.param]
		if curact.targets[1].actions[1].message == 230 and targetsMe then
			if EnhancingAbility:contains(act_info.name) then
				if act_info.name:endswith('II') then
					if act_info.name:startswith('Haste') then
						lasthaste = 2
					elseif act_info.name:startswith('Flurry') then
						lastflurry = 2
					end
				else
					if act_info.name:startswith('Haste') then
						lasthaste = 1
					elseif act_info.name:startswith('Flurry') then
						lastflurry = 1
					elseif act_info.name == "Erratic Flutter" then
						lasthaste = 2
					elseif act_info.name == "Animating Wail" then
						lasthaste = 1
					end
				end
			end
		end
	elseif curact.category == 13 then
		act_info = res.job_abilities[curact.param]
		if act_info.name == 'Hastega II' then
			lasthaste = 2
		elseif act_info.name == 'Hastega' then
			lasthaste = 1
		end
	end
	
	-- Turn off Defense if needed for things we're targetting.
	if (curact.category == 3 or curact.category == 4 or curact.category == 11 or curact.category == 13) then
		if isTarget and player.target.type == "MONSTER" and state.AutoDefenseMode.value and state.DefenseMode.value ~= 'None' then
			if state.TankAutoDefense.value then
				if state.DefenseMode.value ~= 'Physical' then
					state.DefenseMode:set('Physical')
					send_command('gs c forceequip')
					if state.DisplayMode.value then update_job_states()	end
				end
			else
				state.DefenseMode:reset()
				send_command('gs c forceequip')
				if state.DisplayMode.value then update_job_states()	end
			end
		elseif not (actor.id == player.id or midaction() or pet_midaction()) and (targetsMe or (otherTarget.in_alliance and targetsDistance < 10)) then
			--reequip proper gear after curaga/recieved buffs
			send_command('gs c forceequip')
		end
		if isTarget and otherTarget.in_party and check_cover then
			check_cover(otherTarget)
		end
		return
	end
	
	-- Make sure it's not US from this point on!
	if actor.id == player.id then return end
    -- Make sure it's a WS or MA precast before reacting to it.		
    if not (curact.category == 7 or curact.category == 8) then return end
	
    -- Get the name of the action.
    if curact.category == 7 then act_info = res.monster_abilities[curact.targets[1].actions[1].param] end
    if curact.category == 8 then act_info = res.spells[curact.targets[1].actions[1].param] end
	if act_info == nil then return end

	-- Reactions begin.
	if state.BlockWarp.value and ((targetsMe and (act_info.name == 'Warp II' or act_info.name == 'Retrace')) or (actor.in_party and (act_info.name:contains('Teleport') or act_info.name:contains('Recall')))) then
		local party = windower.ffxi.get_party()
	
		if party.party1_leader == player.id then
			windower.chat.input('/pcmd kick '..actor.name..'')
		else
			windower.chat.input('/pcmd leave')
		end
		return
	elseif midaction() or curact.category ~= 8 or state.DefenseMode.value ~= 'None' or ((petWillAct + 2) > os.clock()) then
			
	elseif targetsMe then
		if CureAbility:contains(act_info.name) and player.hpp < 75 then
			if sets.Cure_Received then
				do_equip('sets.Cure_Received')
			elseif sets.Self_Healing then
				do_equip('sets.Self_Healing') 
			end
			return
		elseif RefreshAbility:contains(act_info.name) then
			if sets.Refresh_Received then
				do_equip('sets.Refresh_Received')
			elseif sets.Self_Refresh then
				do_equip('sets.Self_Refresh')
			end
			return
		elseif PhalanxAbility:contains(act_info.name) then
			if sets.Phalanx_Received then
				do_equip('sets.Phalanx_Received')
			elseif sets.midcast.Phalanx then
				do_equip('sets.midcast.Phalanx')
			end
			return
		elseif ProshellAbility:contains(act_info.name) then
			if sets.Sheltered then do_equip('sets.Sheltered') return end
		end
	elseif actor.in_party and otherTarget.in_party and targetsDistance < 10 then

		if CuragaAbility:contains(act_info.name) and player.hpp < 75 then
			if sets.Cure_Received then
				do_equip('sets.Cure_Received')
			elseif sets.Self_Healing then
				do_equip('sets.Self_Healing') 
			end
			return
		elseif ProshellraAbility:contains(act_info.name) and sets.Sheltered then
			do_equip('sets.Sheltered') return
		end
	end
	
	-- Make sure this is our target. 	send_command('input /echo Actor:'..actor.id..' Target:'..player.target.id..'')
	if curact.param == 24931 then --24931 is initiation paramater for action category 7 and 8
		if isTarget and state.AutoStunMode.value and player.target.type == "MONSTER" and not moving then
			if StunAbility:contains(act_info.name) and not midaction() and not pet_midaction() then
				gearswap.refresh_globals(false)				
				if not (buffactive.silence or  buffactive.mute or buffactive.Omerta) then
					local spell_recasts = windower.ffxi.get_spell_recasts()
				
					if player.main_job == 'BLM' or player.sub_job == 'BLM' or player.main_job == 'DRK' or player.sub_job == 'DRK' and spell_recasts[252] < spell_latency then
						windower.chat.input('/ma "Stun" <t>') return
					elseif player.main_job == 'BLU' and spell_recasts[692] < spell_latency then
						windower.chat.input('/ma "Sudden Lunge" <t>') return
					elseif player.sub_job == 'BLU' and spell_recasts[623] < spell_latency then
						windower.chat.input('/ma "Head Butt" <t>') return
					end
				end

				local abil_recasts = windower.ffxi.get_ability_recasts()
				
				if not (buffactive.amnesia or buffactive.impairment) then
				
					if (player.main_job == 'PLD' or player.sub_job == 'PLD') and abil_recasts[73] < latency then
						windower.chat.input('/ja "Shield Bash" <t>') return
					elseif (player.main_job == 'DRK' or player.sub_job == 'DRK') and abil_recasts[88] < latency then
						windower.chat.input('/ja "Weapon Bash" <t>') return
					elseif player.main_job == 'SMN' and pet.name == "Ramuh" and abil_recasts[174] < latency then
						windower.chat.input('/pet "Shock Squall" <t>') return
					elseif (player.main_job == 'SAM') and player.merits.blade_bash and abil_recasts[137] < latency then
						windower.chat.input('/ja "Blade Bash" <t>') return
					elseif not player.status == 'Engaged' then
					
					elseif (player.main_job == 'DNC' or player.sub_job == 'DNC') and abil_recasts[221] < latency then
						windower.chat.input('/ja "Violent Flourish" <t>') return
					end
				
					local available_ws = S(windower.ffxi.get_abilities().weapon_skills)
					if player.tp > 700 then
						if available_ws:contains(35) then
							windower.chat.input('/ws "Flat Blade" <t>') return
						elseif available_ws:contains(145) then
							windower.chat.input('/ws "Tachi Hobaku" <t>') return
						elseif available_ws:contains(2) then
							windower.chat.input('/ws "Shoulder Tackle" <t>') return
						elseif available_ws:contains(65) then
							windower.chat.input('/ws "Smash Axe" <t>') return
						elseif available_ws:contains(115) then
							windower.chat.input('/ws "Leg Sweep" <t>') return
						end
					end
				end
			end
		end
		if state.AutoDefenseMode.value then
			local ability_type = nil
			if PhysicalAbility:contains(act_info.name) then
				ability_type = 'Physical'
			elseif MagicalAbility:contains(act_info.name) then
				ability_type = 'Magical'
			elseif ResistAbility:contains(act_info.name) then
				ability_type = 'Resist'
			end
			if targetsMe or (AoEAbility:contains(act_info.name) and ((otherTarget.in_alliance and targetsDistance < 10) or targetsSelf)) then
				local defensive_action = false
				if not midaction() then
					local abil_recasts = windower.ffxi.get_ability_recasts()
					if state.AutoSuperJumpMode.value and  abil_recasts[160] and abil_recasts[160] < latency then
						windower.chat.input('/ja "Super Jump" <t>')
						defensive_action = true
					elseif (player.main_job == 'SAM' or player.sub_job == 'SAM') and ability_type == 'Physical' and abil_recasts[133] < latency then
						windower.chat.input('/ja "Third Eye" <me>')
						defensive_action = true
					end
				end

				if not defensive_action then
					if ability_type and state.DefenseMode.value ~= ability_type then
						state.DefenseMode:set(ability_type)
					end
					send_command('gs c forceequip')
					being_attacked = true
					if state.DisplayMode.value then update_job_states()	end
					return
				end
			end
		end
	end
	
	if targetsMe and actor.race == 0 and not being_attacked then
		being_attacked = true
		if not (midaction() or pet_midaction()) then
			send_command('gs c forceequip')
		end
	end
end

windower.raw_register_event('action', check_reaction)

windower.raw_register_event('incoming chunk', function(id, data)
    if id == 0xF9 and state.AutoAcceptRaiseMode.value and data:byte(11) == 1 then
        local player = windower.ffxi.get_mob_by_target('me')
        if player then
			packets.inject(packets.new('outgoing', 0x01A, {
				['Target'] = player.id,
				['Target Index'] = player.index,
				['Category'] = 0x0D,
			}))
            return true
        end
    end
end)
