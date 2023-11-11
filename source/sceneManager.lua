local pd <const> = playdate
local gfx <const> = pd.graphics

--cashing the faded images to improve performance
local fadedRects = {}
for i = 0,1,0.01 do
    local fadedImage = gfx.image.new(400,240)
    gfx.pushContext(fadedImage)
        local filledRect = gfx.image.new(400,240,gfx.kColorBlack)
        filledRect:drawFaded(0,0,i,gfx.image.kDitherTypeBayer8x8)
    gfx.popContext()
    fadedRects[math.floor(i*100)] = fadedImage
end
fadedRects[100] = gfx.image.new(400,240,gfx.kColorBlack)

class("SceneManager").extends()
--initializeation function
function SceneManager:init()
    self.transitionTime = 1000
    self.transitioning = false
end

--function to switch scenes
function SceneManager:switchScene(scene,type, ...) -- ... represents a variable number of arguments
    if(self.transitioning) then
        return
    end
    self.transitioning = true

    self.newScene = scene
    self.sceneArgs = ...
    if(type == "wipe")then
        self:startWipeTransition()
    elseif(type == "fade") then
        self:startFadeTransition()
    end
    
end
--function to load a new scene
function SceneManager:loadNewScene()
    self:cleanUpScene()
    self.newScene(self.sceneArgs)
end
--function to start the wipe transition
function SceneManager:startWipeTransition()
    local transitionTimer = self:wipeTransition(0,400)

    transitionTimer.timerEndedCallback = function ()
        self:loadNewScene()
        transitionTimer = self:wipeTransition(400,0)
        transitionTimer .timerEndedCallback = function()
            self.transitioning = false
        end
    end
end
--function to start a fade transition
function SceneManager:startFadeTransition()
    local transitionTimer = self:fadeTransition(0,1)

    transitionTimer.timerEndedCallback = function ()
        self:loadNewScene()
        transitionTimer = self:fadeTransition(1,0)
        transitionTimer .timerEndedCallback = function()
            self.transitioning = false
        end
    end
end
--function to get the faded image to use for transitioning
function SceneManager:getFadedImage(alpha)
   return fadedRects[math.floor(alpha * 100)]
end
--function to preform a fade transition
function SceneManager:fadeTransition(startValue, endValue)
    local transitionSprite = self:createTransitionSprite()
    transitionSprite:setImage(self:getFadedImage(startValue))

    local transitionTimer = pd.timer.new(self.transitionTime, startValue, endValue, pd.easingFunctions.inOutCubic)
    transitionTimer.updateCallback = function(timer)
        transitionSprite:setImage(self:getFadedImage(timer.value))
    end
    return transitionTimer
end

--function to preform a wipe transition
function SceneManager:wipeTransition(startValue, endValue)
    local transitionSprite = self:createTransitionSprite()
    transitionSprite:setClipRect(0,0,startValue,240)

    local transitionTimer = pd.timer.new(self.transitionTime, startValue, endValue, pd.easingFunctions.inOutCubic)
    transitionTimer.updateCallback = function(timer)
        transitionSprite:setClipRect(0,0, timer.value, 240) -- top left chords of cliprect, width, height
    end
    return transitionTimer
end
--function to create a transition sprite
function SceneManager:createTransitionSprite()
    local filledRect = gfx.image.new(400,240,gfx.kColorBlack)
    local transitionSprite = gfx.sprite.new(filledRect)
    transitionSprite:moveTo(200,120)
    transitionSprite:setZIndex(10000)
    transitionSprite:setIgnoresDrawOffset(true)
    transitionSprite:add()
    return transitionSprite
end
--function to clean up the old scene
function SceneManager:cleanUpScene()
    gfx.sprite.removeAll()
    self:removeAllTimers()
    gfx.setDrawOffset(0,0)
end
--function to remove all of the timers
function SceneManager:removeAllTimers()
    local allTimers = pd.timer.allTimers()
    for _, timer in ipairs(allTimers) do 
        timer:remove()
    end
end