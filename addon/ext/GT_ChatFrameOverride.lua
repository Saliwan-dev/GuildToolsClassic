local chatFilters = {}

local isAddonLoaded = false

GT_EventManager:AddEventListener("ADDON_READY", function() isAddonLoaded = true end)

function ChatFrame_AddMessageEventFilter (event, filter)
	assert(event and filter);

	if ( chatFilters[event] ) then
		-- Only allow a filter to be added once
		for index, filterFunc in next, chatFilters[event] do
			if ( filterFunc == filter ) then
				return;
			end
		end
	else
		chatFilters[event] = {};
	end

	tinsert(chatFilters[event], filter);
end

function ChatFrame_RemoveMessageEventFilter (event, filter)
	assert(event and filter);

	if ( chatFilters[event] ) then
		for index, filterFunc in next, chatFilters[event] do
			if ( filterFunc == filter ) then
				tremove(chatFilters[event], index);
			end
		end

		if ( #chatFilters[event] == 0 ) then
			chatFilters[event] = nil;
		end
	end
end

function ChatFrame_GetMessageEventFilters (event)
	assert(event);

	return chatFilters[event];
end

local function FlashTabIfNotShown(frame, info, type, chatGroup, chatTarget)
	if ( not frame:IsShown() ) then
		if ( (frame == DEFAULT_CHAT_FRAME and info.flashTabOnGeneral) or (frame ~= DEFAULT_CHAT_FRAME and info.flashTab) ) then
			if ( not CHAT_OPTIONS.HIDE_FRAME_ALERTS or type == "WHISPER" or type == "BN_WHISPER" ) then	--BN_WHISPER FIXME
				if (not FCFManager_ShouldSuppressMessageFlash(frame, chatGroup, chatTarget) ) then
					FCF_StartAlertFlash(frame);
				end
			end
		end
	end
end

function ChatFrame_MessageEventHandler(self, event, ...)
	if ( TextToSpeechFrame_MessageEventHandler ~= nil ) then
		TextToSpeechFrame_MessageEventHandler(self, event, ...)
	end

	if ( strsub(event, 1, 8) == "CHAT_MSG" ) then
		local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17 = ...;
		if (arg16) then
			-- hiding sender in letterbox: do NOT even show in chat window (only shows in cinematic frame)
			return true;
		end

		local type = strsub(event, 10);
		local info = ChatTypeInfo[type];

		local filter = false;
		if ( chatFilters[event] ) then
			local newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newarg14;
			for _, filterFunc in next, chatFilters[event] do
				filter, newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newarg14 = filterFunc(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14);
				if ( filter ) then
					return true;
				elseif ( newarg1 ) then
					arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14 = newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newarg14;
				end
			end
		end

		local coloredName = GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14);

		local channelLength = strlen(arg4);
		local infoType = type;

		if type == "VOICE_TEXT" and not GetCVarBool("speechToText") then
			return;

		elseif ( (type == "COMMUNITIES_CHANNEL") or ((strsub(type, 1, 7) == "CHANNEL") and (type ~= "CHANNEL_LIST") and ((arg1 ~= "INVITE") or (type ~= "CHANNEL_NOTICE_USER"))) ) then
			if ( arg1 == "WRONG_PASSWORD" ) then
				local staticPopup = _G[StaticPopup_Visible("CHAT_CHANNEL_PASSWORD") or ""];
				if ( staticPopup and strupper(staticPopup.data) == strupper(arg9) ) then
					-- Don't display invalid password messages if we're going to prompt for a password (bug 102312)
					return;
				end
			end

			local found = 0;
			for index, value in pairs(self.channelList) do
				if ( channelLength > strlen(value) ) then
					-- arg9 is the channel name without the number in front...
					if ( ((arg7 > 0) and (self.zoneChannelList[index] == arg7)) or (strupper(value) == strupper(arg9)) ) then
						found = 1;
						infoType = "CHANNEL"..arg8;
						info = ChatTypeInfo[infoType];
						if ( (type == "CHANNEL_NOTICE") and (arg1 == "YOU_LEFT") ) then
							self.channelList[index] = nil;
							self.zoneChannelList[index] = nil;
						end
						break;
					end
				end
			end
			if ( (found == 0) or not info ) then
				return true;
			end
		end

		local chatGroup = Chat_GetChatCategory(type);
		local chatTarget;
		if ( chatGroup == "CHANNEL" ) then
			chatTarget = tostring(arg8);
		elseif ( chatGroup == "WHISPER" or chatGroup == "BN_WHISPER" ) then
			if(not(strsub(arg2, 1, 2) == "|K")) then
				chatTarget = strupper(arg2);
			else
				chatTarget = arg2;
			end
		end

		if ( FCFManager_ShouldSuppressMessage(self, chatGroup, chatTarget) ) then
			return true;
		end

		if ( chatGroup == "WHISPER" or chatGroup == "BN_WHISPER" ) then
			if ( self.privateMessageList and not self.privateMessageList[strlower(arg2)] ) then
				return true;
			elseif ( self.excludePrivateMessageList and self.excludePrivateMessageList[strlower(arg2)]
				and ( (chatGroup == "WHISPER" and GetCVar("whisperMode") ~= "popout_and_inline") or (chatGroup == "BN_WHISPER" and GetCVar("whisperMode") ~= "popout_and_inline") ) ) then
				return true;
			end
		end

		if (self.privateMessageList) then
			-- Dedicated BN whisper windows need online/offline messages for only that player
			if ( (chatGroup == "BN_INLINE_TOAST_ALERT" or chatGroup == "BN_WHISPER_PLAYER_OFFLINE") and not self.privateMessageList[strlower(arg2)] ) then
				return true;
			end

			-- HACK to put certain system messages into dedicated whisper windows
			if ( chatGroup == "SYSTEM") then
				local matchFound = false;
				local message = strlower(arg1);
				for playerName, _ in pairs(self.privateMessageList) do
					local playerNotFoundMsg = strlower(format(ERR_CHAT_PLAYER_NOT_FOUND_S, playerName));
					local charOnlineMsg = strlower(format(ERR_FRIEND_ONLINE_SS, playerName, playerName));
					local charOfflineMsg = strlower(format(ERR_FRIEND_OFFLINE_S, playerName));
					if ( message == playerNotFoundMsg or message == charOnlineMsg or message == charOfflineMsg) then
						matchFound = true;
						break;
					end
				end

				if (not matchFound) then
					return true;
				end
			end
		end

		if ( type == "SYSTEM" or type == "SKILL" or type == "CURRENCY" or type == "MONEY" or
		     type == "OPENING" or type == "TRADESKILLS" or type == "PET_INFO" or type == "TARGETICONS" or type == "BN_WHISPER_PLAYER_OFFLINE") then
			self:AddMessage(arg1, info.r, info.g, info.b, info.id);
		elseif (type == "LOOT") then
			self:AddMessage(arg1, info.r, info.g, info.b, info.id);
		elseif ( strsub(type,1,7) == "COMBAT_" ) then
			self:AddMessage(arg1, info.r, info.g, info.b, info.id);
		elseif ( strsub(type,1,6) == "SPELL_" ) then
			self:AddMessage(arg1, info.r, info.g, info.b, info.id);
		elseif ( strsub(type,1,10) == "BG_SYSTEM_" ) then
			self:AddMessage(arg1, info.r, info.g, info.b, info.id);
		elseif ( strsub(type,1,11) == "ACHIEVEMENT" ) then
			self:AddMessage(arg1:format(GetPlayerLink(arg2, ("[%s]"):format(coloredName))), info.r, info.g, info.b, info.id);
		elseif ( strsub(type,1,18) == "GUILD_ACHIEVEMENT" ) then
			local message = arg1:format(GetPlayerLink(arg2, ("[%s]"):format(coloredName)));
			self:AddMessage(message, info.r, info.g, info.b, info.id);
		elseif ( type == "IGNORED" ) then
			self:AddMessage(format(CHAT_IGNORED, arg2), info.r, info.g, info.b, info.id);
		elseif ( type == "FILTERED" ) then
			self:AddMessage(format(CHAT_FILTERED, arg2), info.r, info.g, info.b, info.id);
		elseif ( type == "RESTRICTED" ) then
			self:AddMessage(CHAT_RESTRICTED_TRIAL, info.r, info.g, info.b, info.id);
		elseif ( type == "CHANNEL_LIST") then
			if(channelLength > 0) then
				self:AddMessage(format(_G["CHAT_"..type.."_GET"]..arg1, tonumber(arg8), arg4), info.r, info.g, info.b, info.id);
			else
				self:AddMessage(arg1, info.r, info.g, info.b, info.id);
			end
		elseif (type == "CHANNEL_NOTICE_USER") then
			local globalstring = _G["CHAT_"..arg1.."_NOTICE_BN"];
			if ( not globalstring ) then
				globalstring = _G["CHAT_"..arg1.."_NOTICE"];
			end
			if not globalstring then
				GMError(("Missing global string for %q"):format("CHAT_"..arg1.."_NOTICE_BN"));
				return;
			end
			if(arg5 ~= "") then
				-- TWO users in this notice (E.G. x kicked y)
				self:AddMessage(format(globalstring, arg8, arg4, arg2, arg5), info.r, info.g, info.b, info.id);
			elseif ( arg1 == "INVITE" ) then
				local playerLink = GetPlayerLink(arg2, ("[%s]"):format(arg2), arg11);
				local accessID = ChatHistory_GetAccessID(chatGroup, chatTarget);
				local typeID = ChatHistory_GetAccessID(infoType, chatTarget, arg12);
				self:AddMessage(format(globalstring, arg4, playerLink), info.r, info.g, info.b, info.id, accessID, typeID);
			else
				self:AddMessage(format(globalstring, arg8, arg4, arg2), info.r, info.g, info.b, info.id);
			end
			if ( arg1 == "INVITE" and GetCVarBool("blockChannelInvites") ) then
				self:AddMessage(CHAT_MSG_BLOCK_CHAT_CHANNEL_INVITE, info.r, info.g, info.b, info.id);
			end
		elseif (type == "CHANNEL_NOTICE") then
			local globalstring;
			if ( arg1 == "TRIAL_RESTRICTED" ) then
				globalstring = CHAT_TRIAL_RESTRICTED_NOTICE_TRIAL;
			else
				globalstring = _G["CHAT_"..arg1.."_NOTICE_BN"];
				if ( not globalstring ) then
					globalstring = _G["CHAT_"..arg1.."_NOTICE"];
					if not globalstring then
						GMError(("Missing global string for %q"):format("CHAT_"..arg1.."_NOTICE"));
						return;
					end
				end
			end
			local accessID = ChatHistory_GetAccessID(Chat_GetChatCategory(type), arg8);
			local typeID = ChatHistory_GetAccessID(infoType, arg8, arg12);
			self:AddMessage(format(globalstring, arg8, ChatFrame_ResolvePrefixedChannelName(arg4)), info.r, info.g, info.b, info.id, accessID, typeID);
		elseif ( type == "BN_INLINE_TOAST_ALERT" ) then
			local globalstring = _G["BN_INLINE_TOAST_"..arg1];
			if not globalstring then
				GMError(("Missing global string for %q"):format("BN_INLINE_TOAST_"..arg1));
				return;
			end
			local message;
			if ( arg1 == "FRIEND_REQUEST" ) then
				message = globalstring;
			elseif ( arg1 == "FRIEND_PENDING" ) then
				message = format(BN_INLINE_TOAST_FRIEND_PENDING, BNGetNumFriendInvites());
			elseif ( arg1 == "FRIEND_REMOVED" or arg1 == "BATTLETAG_FRIEND_REMOVED" ) then
				message = format(globalstring, arg2);
			elseif ( arg1 == "FRIEND_ONLINE" or arg1 == "FRIEND_OFFLINE") then
				local _, accountName, battleTag, _, characterName, _, client = BNGetFriendInfoByID(arg13);
				if (client and client ~= "") then
					C_Texture.GetTitleIconTexture(client, Enum.TitleIconVersion.Small, function(success, texture)
						if success then
							local characterName = BNet_GetValidatedCharacterNameWithClientEmbeddedTexture(characterName, battleTag, texture, 32, 32, 10);
							local linkDisplayText = ("[%s] (%s)"):format(arg2, characterName);
							local playerLink = GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, Chat_GetChatCategory(type), 0);
							local message = format(globalstring, playerLink);
							self:AddMessage(message, info.r, info.g, info.b, info.id);
							FlashTabIfNotShown(self, info, type, chatGroup, chatTarget);
						end
					end);
					return;
				else
					local linkDisplayText = ("[%s]"):format(arg2);
					local playerLink = GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, Chat_GetChatCategory(type), 0);
					message = format(globalstring, playerLink);
				end
			else
				local linkDisplayText = ("[%s]"):format(arg2);
				local playerLink = GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, Chat_GetChatCategory(type), 0);
				message = format(globalstring, playerLink);
			end
			self:AddMessage(message, info.r, info.g, info.b, info.id);
		elseif ( type == "BN_INLINE_TOAST_BROADCAST" ) then
			if ( arg1 ~= "" ) then
				arg1 = RemoveNewlines(RemoveExtraSpaces(arg1));
				local linkDisplayText = ("[%s]"):format(arg2);
				local playerLink = GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, Chat_GetChatCategory(type), 0);
				self:AddMessage(format(BN_INLINE_TOAST_BROADCAST, playerLink, arg1), info.r, info.g, info.b, info.id);
			end
		elseif ( type == "BN_INLINE_TOAST_BROADCAST_INFORM" ) then
			if ( arg1 ~= "" ) then
				arg1 = RemoveExtraSpaces(arg1);
				self:AddMessage(BN_INLINE_TOAST_BROADCAST_INFORM, info.r, info.g, info.b, info.id);
			end
		else
			local msgTime = time();
			local playerName, lineID, bnetIDAccount = arg2, arg11, arg13;

			local function MessageFormatter(msg)
				local fontHeight = select(2, FCF_GetChatWindowInfo(self:GetID()));
				if ( fontHeight == 0 ) then
					--fontHeight will be 0 if it's still at the default (14)
					fontHeight = 14;
				end

				-- Add AFK/DND flags
				local pflag;
				if(arg6 ~= "") then
					if ( arg6 == "GM" ) then
						--If it was a whisper, dispatch it to the GMChat addon.
						if ( type == "WHISPER" ) then
							return;
						end
						--Add Blizzard Icon, this was sent by a GM
						pflag = "|TInterface\\ChatFrame\\UI-ChatIcon-Blizz:12:20:0:0:32:16:4:28:0:16|t ";
					elseif ( arg6 == "DEV" ) then
						--Add Blizzard Icon, this was sent by a Dev
						pflag = "|TInterface\\ChatFrame\\UI-ChatIcon-Blizz:12:20:0:0:32:16:4:28:0:16|t ";
					else
						pflag = _G["CHAT_FLAG_"..arg6];
					end
				else
					pflag = "";
				end
				if ( type == "WHISPER_INFORM" and GMChatFrame_IsGM and GMChatFrame_IsGM(arg2) ) then
					return;
				end

				local showLink = 1;
				if ( strsub(type, 1, 7) == "MONSTER" or strsub(type, 1, 9) == "RAID_BOSS") then
					showLink = nil;
				else
					msg = gsub(msg, "%%", "%%%%");
				end

				-- Search for icon links and replace them with texture links.
				msg = ChatFrame_ReplaceIconAndGroupExpressions(msg, arg17, not ChatFrame_CanChatGroupPerformExpressionExpansion(chatGroup)); -- If arg17 is true, don't convert to raid icons

				--Remove groups of many spaces
				msg = RemoveExtraSpaces(msg);

				local playerLink;
				local playerLinkDisplayText = coloredName;
				local relevantDefaultLanguage = self.defaultLanguage;
				if ( (type == "SAY") or (type == "YELL") ) then
					relevantDefaultLanguage = self.alternativeDefaultLanguage;
				end
				local usingDifferentLanguage = (arg3 ~= "") and (arg3 ~= relevantDefaultLanguage);
				local usingEmote = (type == "EMOTE") or (type == "TEXT_EMOTE");

				if ( usingDifferentLanguage or not usingEmote ) then
					playerLinkDisplayText = ("[%s]"):format(coloredName);
				end
--==============================================================================================================================================================
-- ---------------------------> ICI <------------------------------------
                if isAddonLoaded then
                    local rerollName = playerLinkDisplayText
                    if string.sub(rerollName, 1, 1) == "[" then
                        rerollName = string.sub(rerollName, 2, -2)
                    end

                    local mainName = GT_RerollService:GetMain(rerollName)
                    if rerollName ~= mainName then
                        playerLinkDisplayText = playerLinkDisplayText.."("..mainName..")"
                    end
                end
--===============================================================================================================================================================

				local isCommunityType = type == "COMMUNITIES_CHANNEL";
				if ( isCommunityType ) then
					local isBattleNetCommunity = bnetIDAccount ~= nil and bnetIDAccount ~= 0;
					local messageInfo, clubId, streamId, clubType = C_Club.GetInfoFromLastCommunityChatLine();
					if (messageInfo ~= nil) then
						if ( isBattleNetCommunity ) then
							playerLink = GetBNPlayerCommunityLink(playerName, playerLinkDisplayText, bnetIDAccount, clubId, streamId, messageInfo.messageId.epoch, messageInfo.messageId.position);
				else
							playerLink = GetPlayerCommunityLink(playerName, playerLinkDisplayText, clubId, streamId, messageInfo.messageId.epoch, messageInfo.messageId.position);
						end
					else
						playerLink = playerLinkDisplayText;
					end
				else
					if ( type == "BN_WHISPER" or type == "BN_WHISPER_INFORM" ) then
						playerLink = GetBNPlayerLink(playerName, playerLinkDisplayText, bnetIDAccount, lineID, chatGroup, chatTarget);
					else
						playerLink = GetPlayerLink(playerName, playerLinkDisplayText, lineID, chatGroup, chatTarget);
					end
				end

				local message = msg;
				-- isMobile
				if arg14 then
					message = ChatFrame_GetMobileEmbeddedTexture(info.r, info.g, info.b)..message;
				end

				local outMsg;
				if ( usingDifferentLanguage ) then
					local languageHeader = "["..arg3.."] ";
					if ( showLink and (arg2 ~= "") ) then
						outMsg = format(_G["CHAT_"..type.."_GET"]..languageHeader..message, pflag..playerLink);
					else
						outMsg = format(_G["CHAT_"..type.."_GET"]..languageHeader..message, pflag..arg2);
					end
				else
					if ( not showLink or arg2 == "" ) then
						if ( type == "TEXT_EMOTE" or type == "GUILD_DEATHS") then
							outMsg = message;
						else
							outMsg = format(_G["CHAT_"..type.."_GET"]..message, pflag..arg2, arg2);
						end
					else
						if ( type == "EMOTE" ) then
							outMsg = format(_G["CHAT_"..type.."_GET"]..message, pflag..playerLink);
						elseif ( type == "TEXT_EMOTE") then
							outMsg = string.gsub(message, arg2, pflag..playerLink, 1);
						elseif (type == "GUILD_ITEM_LOOTED") then
							outMsg = string.gsub(message, "$s", GetPlayerLink(arg2, playerLinkDisplayText));
						else
							outMsg = format(_G["CHAT_"..type.."_GET"]..message, pflag..playerLink);
						end
					end
				end

				-- Add Channel
				if (channelLength > 0) then
					outMsg = "|Hchannel:channel:"..arg8.."|h["..ChatFrame_ResolvePrefixedChannelName(arg4).."]|h "..outMsg;
				end

				--Add Timestamps
				local chatTimestampFmt = GetChatTimestampFormat();
				if ( chatTimestampFmt ) then
					outMsg = BetterDate(chatTimestampFmt, msgTime)..outMsg;
				end

				return outMsg;
			end

			local isChatLineCensored = C_ChatInfo.IsChatLineCensored(lineID);
			local msg = isChatLineCensored and arg1 or MessageFormatter(arg1);
			local accessID = ChatHistory_GetAccessID(chatGroup, chatTarget);
			local typeID = ChatHistory_GetAccessID(infoType, chatTarget, arg12 or arg13);

			-- The message formatter is captured so that the original message can be reformatted when a censored message
			-- is approved to be shown. We only need to pack the event args if the line was censored, as the message transformation
			-- step is the only code that needs these arguments. See ItemRef.lua "censoredmessage".
			local eventArgs;
			if isChatLineCensored then
				eventArgs = SafePack(...);
			end
			self:AddMessage(msg, info.r, info.g, info.b, info.id, accessID, typeID, event, eventArgs, MessageFormatter);
		end

		if ( type == "WHISPER" or type == "BN_WHISPER" ) then
			--BN_WHISPER FIXME
			ChatEdit_SetLastTellTarget(arg2, type);
			if ( self.tellTimer and (GetTime() > self.tellTimer) ) then
				PlaySound(SOUNDKIT.TELL_MESSAGE);
			end
			self.tellTimer = GetTime() + CHAT_TELL_ALERT_TIME;
			--FCF_FlashTab(self);
			FlashClientIcon();
		end

		FlashTabIfNotShown(self, info, type, chatGroup, chatTarget);

		return true;
	elseif ( event == "VOICE_CHAT_CHANNEL_TRANSCRIBING_CHANGED" ) then
		local _, isNowTranscribing = ...
		if ( not self.isTranscribing and isNowTranscribing ) then
			ChatFrame_DisplaySystemMessage(self, SPEECH_TO_TEXT_STARTED);
		end
		self.isTranscribing = isNowTranscribing;
	end
end
