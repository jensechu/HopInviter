local WHOLE_MSG_TRIGGERS = { -- These will only match the whole message
	"hop",
	"tithe rules",
}

local PARTIAL_MSG_TRIGGERS = { -- These will match parts of the message
}

local GUILD_MSG_TRIGGERS = { -- These will only match the whole guild message
	"hoppers",
}

-----------------
--END OF CONFIG--
-----------------
-- Do not change anything below here.

local ipairs = ipairs
local strfind = string.find

HOPINVITER_ENABLED = true

for i, trigger in ipairs(WHOLE_MSG_TRIGGERS) do
	WHOLE_MSG_TRIGGERS[i] = "^" .. trigger .. "$"
end

for i, trigger in ipairs(GUILD_MSG_TRIGGERS) do
	GUILD_MSG_TRIGGERS[i] = "^" .. trigger .. "$"
end

local function isMatch(msg)
	for _, trigger in ipairs(WHOLE_MSG_TRIGGERS) do
		if strfind(msg, trigger) then
			return true
		end
	end
	
	for _, trigger in ipairs(PARTIAL_MSG_TRIGGERS) do
		if strfind(msg, tirgger) then
			return true
		end
	end
	
	return false
end

local function isGuildMatch(msg)
	for _, trigger in ipairs(GUILD_MSG_TRIGGERS) do
		if strfind(msg, trigger) then
			return true
		end
	end	
	return false
end

local function isFull()
	 if (GetPartyMember(4)) then
	  return true
	 end
	
	return false
end

local function isFullMessage(author)
	return "[Hopper] " .. UnitName("player") .. "'s party is full."
end


local function isHoppingMessage(author)
	return "[Hopper] " .. author .. " is just visiting."
end

local function filter(self, event, msg, author, ...)
	-- NOTE: I don't think this Classic API supports grabbing number of group members. This is commented out until it is supported.
	-- isFullMessage(author)
	 -- if isFull() then
	  -- SendChatMessage(isFullMessage(author), "WHISPER", nil, author)
	 -- end
	if isMatch(msg:trim()) then
		SendChatMessage("[Hopper]: If you don't get an invite then " .. UnitName("player") ..  "'s party is full.", "WHISPER", nil, author)
		InviteUnit(author)
		SendChatMessage(isHoppingMessage(author), "PARTY", nil, nil)
	end
end

local function guildFilter(self, event, msg, author, ...)
	if isGuildMatch(msg:trim()) then
		SendChatMessage("[Hopper]: Active.", "WHISPER", nil, author)
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", guildFilter)

SLASH_HOPINVITER1, SLASH_HOPINVITER2 = "/hopinviter", "/hopper"

SlashCmdList.HOPINVITER = function(input)
	if HOPINVITER_ENABLED then
		HOPINVITER_ENABLED = false
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER", filter)
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_GUILD", guildFilter)
		print("Hopper: Disabled")
	else
		HOPINVITER_ENABLED = true
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_GUILD", guildFilter)
		print("Hopper: Enabled")
	end
end