-- This is mostly copy/pasted directly from SM5's _fallback theme with
-- very minor modifications.

local function CreditsText( pn )
	return LoadFont("Common Normal") .. {
		InitCommand=function(self)
			self:visible(false)
			self:name("Credits" .. PlayerNumberToString(pn))
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen")
		end,
		UpdateTextCommand=function(self)
			local str = ScreenSystemLayerHelpers.GetCreditsMessage(pn)
			self:settext(str)
		end,
		UpdateVisibleCommand=function(self)
			local screen = SCREENMAN:GetTopScreen()
			local bShow = true
			-- we always want to show the CreditText for each player on ScreenEval, regardless of the ShowCreditDisplay metric
			if screen and (screen:GetName() ~= "ScreenEvaluationStage") and (screen:GetName() ~= "ScreenEvaluationNonstop") then
				bShow = THEME:GetMetric( screen:GetName(), "ShowCreditDisplay" )
			end
			self:visible( bShow )
		end
	}
end


local t = Def.ActorFrame{}

-- Aux
t[#t+1] = LoadActor(THEME:GetPathB("ScreenSystemLayer","aux"))

-- Credits
t[#t+1] = Def.ActorFrame {
 	CreditsText( PLAYER_1 );
	CreditsText( PLAYER_2 );
}

local SystemMessageText = nil

-- SystemMessage Text
t[#t+1] = Def.ActorFrame {
	SystemMessageMessageCommand=function(self, params)
		SystemMessageText:settext( params.Message )
		self:playcommand( "On" )
		if params.NoAnimate then
			self:finishtweening()
		end
		self:playcommand( "Off" )
	end,
	HideSystemMessageMessageCommand=function(self) self:finishtweening() end,

	Def.Quad {
		InitCommand=function(self)
			self:zoomto(_screen.w, 30):horizalign(left):vertalign(top)
				:diffuse(Color.Black):diffusealpha(0)
		end,
		OnCommand=function(self)
			self:finishtweening():diffusealpha(0.85)
				:zoomto(_screen.w, (SystemMessageText:GetHeight() + 16) * WideScale(1, 0.8) )
		end,
		OffCommand=function(self) self:sleep(3.33):linear(0.5):diffusealpha(0) end,
	},

	LoadFont("Common Normal")..{
		Name="Text",
		InitCommand=function(self)
			self:maxwidth(_screen.w-20):horizalign(left):vertalign(top)
				:xy(10, 10):diffusealpha(0):zoom(WideScale(1, 0.8))
			SystemMessageText = self
		end,
		OnCommand=function(self) self:finishtweening():diffusealpha(1) end,
		OffCommand=function(self) self:sleep(3):linear(0.5):diffusealpha(0) end,
	}
}

-- Wendy CreditText at lower-center of screen
t[#t+1] = LoadFont("_jfonts/_jfonts 16px")..{
	InitCommand=function(self) self:xy(_screen.cx, _screen.h-16):zoom(1):horizalign(center) end,

	OnCommand=function(self) self:playcommand("Refresh") end,
	ScreenChangedMessageCommand=function(self) self:playcommand("Refresh") end,
	CoinModeChangedMessageCommand=function(self) self:playcommand("Refresh") end,
	CoinsChangedMessageCommand=function(self) self:playcommand("Refresh") end,

	RefreshCommand=function(self)

		local screen = SCREENMAN:GetTopScreen()

		-- if this screen's Metric for ShowCreditDisplay=false, then hide this BitmapText actor
		-- PS: "ShowCreditDisplay" isn't a real Metric as far as the engine is concerned
		-- I invented it for Simply Love and it has (understandably) confused other themers.
		-- Sorry about this.
		if screen then
			self:visible( THEME:GetMetric( screen:GetName(), "ShowCreditDisplay" ) )
		end

		if PREFSMAN:GetPreference("EventMode") then
			self:settext( THEME:GetString("ScreenSystemLayer", "EventMode") )

		elseif GAMESTATE:GetCoinMode() == "CoinMode_Pay" then
			local credits = GetCredits()
			local text = THEME:GetString("ScreenSystemLayer", "Credits")..'  '

			text = text..credits.Credits..'  '

			if credits.CoinsPerCredit > 1 then
				text = text .. credits.Remainder .. '/' .. credits.CoinsPerCredit
			end
			self:settext(text)

		elseif GAMESTATE:GetCoinMode() == "CoinMode_Free" then
			self:settext( THEME:GetString("ScreenSystemLayer", "FreePlay") )

		elseif GAMESTATE:GetCoinMode() == "CoinMode_Home" then
			self:settext('')
		end
	end
}

return t