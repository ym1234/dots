local mp = require('mp')
local http = require("socket.http")
local math = require('math')
local io = require('io')
local os = require('os')
local table = require('table')
local string = require('string')

local json =  require('cjson')
local start_time = 0
local end_time = 0

local deck_name = "Japanese::Anime cards"
local model_name = "Japanese"
local collection = "/home/ym/.local/share/Anki2/User 1/collection.media/"
local sentence_field = "Examples"
local word_field = "Word"
local audio_field = "Audio"

function render()
	mp.osd_message("Sub start time: " .. start_time .. "\nSub end time: " .. end_time)
end

function set_start()
	start_time = mp.get_property_native('time-pos')
	render()
end

function set_end()
	end_time = mp.get_property_native('time-pos')
	render()
end

function get_source()
	local sub_file, sub_external, sub_track_no, audio_track_no
	for i, k in ipairs(mp.get_property_native('track-list')) do
		if audio_track_no ~= nil and sub_external ~= nil then
			break
		end

		if k.type == 'sub' and k.selected == true then
			print('subs')
			if k.external == true then
				sub_file = k["external-filename"]
				sub_external = true
				sub_track_no = 0
			else
				sub_external = false
				sub_track_no = k["src-id"] - 1 -- TODO fix this
			end
		end
		if k.type == 'audio' and k.selected == true then
			audio_track_no = k["src-id"] - 1 -- TODO fix this
		end
	end
	return mp.get_property_native('filename'), sub_file, sub_external, sub_track_no, audio_track_no
end

function my_popen(arg, sep)
	local file = io.popen(arg)
	local out = ""
	for line in file:lines() do
		out = out .. line .. sep
	end
	file:close()
	return out
end

function create_card()
	local video_file, subtitle_file, external, track_no, audio_track_no = get_source()
	print(video_file, subtitle_file, external, track_no, audio_track_no)

	local cmd = '~/bin/extract-dialogue' .. ' -i ' .. ("%q"):format(video_file) .. '  -a ' .. audio_track_no .. ' -k ' .. (start_time * 1000) .. ' -e ' .. (end_time  * 1000)
	if external then
		cmd = cmd .. ' -s ' .. ("%q"):format(subtitle_file)
	else
		if track_no ~= nil then
			cmd = cmd ..  ' -s ' ..track_no
		end
	end
	print(cmd)

	subs = my_popen(cmd, "<br>")
	print(subs)

	local new_name = "mpvcreate" .. os.time() .. ".mp3"
	my_popen('mv output.mp3 \'' .. collection .. new_name .. '\'', "") -- seriously?

	req  = {
		action = "findNotes",
		version = 6,
		params = { query = "\"deck:" .. deck_name .. "\" added:1 is:new" }
	}
	resp, _, _ = http.request('http://127.0.0.1:8765/', json.encode(req))
	val = json.decode(resp)
	table.sort(val.result)

	req = {
		action = "updateNoteFields",
		version = 6,
		params = {
			note = {
				id = val.result[#val.result],
				fields = {
					[sentence_field] = subs,
					[audio_field] = "[sound:" .. new_name .. "]",
				},
			}
		}
	}
	print(json.encode(req))
	b, _, _ = http.request('http://127.0.0.1:8765/', json.encode(req))
	print(b)

	req = {
		action = "addTags",
		version = 6,
		params = { notes = { val.result[#val.result] }, tags = "mpv-create" }
	}
	http.request('http://127.0.0.1:8765/', json.encode(req))
end


-- SERIOUSLY?
function save_clip()
	local video_file, subtitle_file, _, _, _ = get_source()
	local new_name = "mpv-clip-" .. os.time() .. ".mp4"
	my_popen('ln -s ' .. ("%q"):format(subtitle_file) .. ' sub_file', "")
	my_popen('ffmpeg -v fatal -ss ' .. start_time  .. ' -to ' .. end_time .. " -copyts -i " .. ("%q"):format(video_file)  .. " -vf subtitles=sub_file -reset_timestamps 1 " .. new_name, "")
	my_popen('rm sub_file', "")
	mp.osd_message('Clip: ' .. new_name)
end

mp.add_forced_key_binding('ctrl+n', 'sub-start', set_start)
mp.add_forced_key_binding('ctrl+t', 'sub-end',  set_end)
mp.add_forced_key_binding('ctrl+h', 'create-card', create_card)
mp.add_forced_key_binding('ctrl+s', 'save-clip', save_clip)
