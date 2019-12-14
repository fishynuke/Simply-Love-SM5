return LoadFont("_miso")..{
	InitCommand=function(self) self:xy(IsUsingWideScreen() and 50, _screen.cy-24):zoom(0.8):diffusealpha(0) end,
	OnCommand=function(self)
		self:diffusealpha(0):settext(THEME:GetString("ScreenSelectMusic", "FooterTextSongs")):linear(0.15):diffusealpha(1)
	end,
}