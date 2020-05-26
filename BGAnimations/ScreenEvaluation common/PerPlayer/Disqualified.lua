-- I don't want disqualification to apply to Casual mode; it's too discouraging
-- for novice players and this game is already offputting enough as-is.
-- If we're in Casual mode, return early; don't evaluate the rest of this file.
if SL.Global.GameMode == "Casual" then return end
-- -----------------------------------------------------------------------

local player = ...

local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)
local disqualified = stats:IsDisqualified()

return LoadFont("_jfonts/_jfonts 16px")..{
	Name="Disqualified"..ToEnumShortString(player),
	InitCommand=function(self) self:diffusealpha(0.7):zoom(0.8):y(_screen.cy+138) end,
	OnCommand=function(self)
		if disqualified then
			self:settext(THEME:GetString("ScreenEvaluation","Disqualified"))
		end
	end
}