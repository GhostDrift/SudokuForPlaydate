--import statements
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "sceneManager"
import "menuScene"
import "ScreenShake"

--constants
local gfx <const> = playdate.graphics
local pd <const> = playdate
fontNontendoBoldOutline6X = gfx.font.new('font/Nontendo-Bold-outline-6x')
fontNontendoBoldOutline1AndOneHalfX = gfx.font.new('font/Nontendo-Bold-1.5x')
fontNontendoBold4X = gfx.font.new("font/Nontendo-Bold-4x")
fontMiniSans2X = gfx.font.new("font/Mini-Sans-2X")
fontMiniSans3X = gfx.font.new("font/Mini-Sans-3X")
screenShakeSprite = ScreenShake()


--global singlton object
SCENE_MANAGER = SceneManager()

MenuScene()

--update function
function playdate.update()
   screenShakeSprite:update()
   pd.timer.updateTimers()
   gfx.sprite.update()
end
