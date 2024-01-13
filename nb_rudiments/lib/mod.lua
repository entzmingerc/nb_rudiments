local music = require("musicutil")
local mod = require 'core/mods'

local function add_rudiments_params(i)
    params:add_group("rudiments_"..i.."_group", "rudiments voice " .. i, 9) -- keep an eye on this number
    params:hide("rudiments_"..i.."_group")
    params:add_trigger("rudiments_trigger_"..i, "trigger")
    params:set_action("rudiments_trigger_"..i, function()
        osc.send({ "localhost", 57120 }, "/nb_rudiments/perc", {
            params:get("rudiments_shape_" .. i), 
            music.note_num_to_freq(params:get("rudiments_freq_" .. i)), --pitch in hz, 
            params:get("rudiments_decay_" .. i),
            params:get("rudiments_sweep_" .. i), 
            params:get("rudiments_lfoFreq_" .. i), 
            params:get("rudiments_lfoShape_" .. i),
            params:get("rudiments_lfoSweep_" .. i), 
            params:get("rudiments_gain_" .. i), 
        })
    end)

    -- OSC
    params:add_control("rudiments_shape_" .. i, "osc shape", controlspec.new(0, 1, 'lin', 1, 0, ''))
    -- params:add_control("rudiments_freq_" .. i, "osc freq", controlspec.new(20, 10000, 'lin', 1, 120, 'hz'))
    params:add_number("rudiments_freq_"..i, "osc freq", 12, 127, 36, function(p)
        return music.note_num_to_name(p:get(), true)
    end)

    -- ENV
    params:add_control("rudiments_decay_" .. i, "env decay", controlspec.new(0.05, 1, 'lin', 0.01, 0.2, 'sec'))
    params:add_control("rudiments_sweep_" .. i, "env sweep", controlspec.new(0, 2000, 'lin', 1, 100, ''))
    -- TODO: Sweep direction sounds a little wonky right now...

    -- LFO
    params:add_control("rudiments_lfoFreq_" .. i, "lfo freq", controlspec.new(1, 1000, 'lin', 1, 1, 'hz'))
    params:add_control("rudiments_lfoShape_" .. i, "lfo shape", controlspec.new(0, 1, 'lin', 1, 0, ''))
    params:add_control("rudiments_lfoSweep_" .. i, "lfo sweep", controlspec.new(0, 2000, 'lin', 1, 0, ''))

    -- OUTPUT
    params:add_control("rudiments_gain_" .. i, "gain", controlspec.new(0, 50, 'lin', 0.2, 15, ''))

end

function add_rudiments_player(i)
    local player = {
        timbre_modulation = 0,
    }

    function player:active()
        if self.name ~= nil then
            params:show("rudiments_"..i.."_group")
            _menu.rebuild_params()
        end
    end

    function player:inactive()
        if self.name ~= nil then
            params:hide("rudiments_"..i.."_group")
            _menu.rebuild_params()
        end
    end

    function player:stop_all()
        -- N/A
    end

    function player:modulate(val)
        -- N/A
    end

    function player:set_slew(s)
        -- N/A
    end

    function player:describe()
        return {
            name = "rudiments " .. i,
            supports_bend = false,
            supports_slew = false,
            modulate_description = "none",
            note_mod_targets = {"none"}
        }
    end

    function player:pitch_bend(note, amount)
        -- N/A
    end

    function player:modulate_note(note, key, value)
        -- N/A
    end

    function player:note_on(note, vel, properties)
        if properties == nil then
            properties = {}
        end
        osc.send({ "localhost", 57120 }, "/nb_rudiments/perc", {
            params:get("rudiments_shape_" .. i), 
            music.note_num_to_freq(note), --pitch passed to note_on, 
            params:get("rudiments_decay_" .. i),
            params:get("rudiments_sweep_" .. i), 
            params:get("rudiments_lfoFreq_" .. i), 
            params:get("rudiments_lfoShape_" .. i),
            params:get("rudiments_lfoSweep_" .. i), 
            params:get("rudiments_gain_" .. i),
        })
    end

    function player:note_off(note)
        -- N/A
    end

    function player:add_params()
        add_rudiments_params(i)
    end

    if note_players == nil then
        note_players = {}
    end
    note_players["rudiments " .. i] = player
end

function pre_init()
    for v = 1, 4 do
        add_rudiments_player(v)
    end
end

mod.hook.register("script_pre_init", "nb_rudiments pre init", pre_init)