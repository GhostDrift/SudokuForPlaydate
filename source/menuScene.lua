-- This is the main menu for my version of sudoku for the playdate
-- Title: menuScene.lua
-- Author: Jessica Stojkovic
-- Date: 11/11/23
-- version: 0.0.1

--********************Constants**********************
local pd <const> = playdate
local gfx <const> = pd.graphics

class("MenuScene").extends(gfx.sprite)

function MenuScene:init()
    self:prepareSprites()
    self:add()
end

function MenuScene:prepareSprites()
    gfx.setFont(fontNontendoBold4X)
    local headerText = "Sudoku"
    local headerImage = gfx.image.new(gfx.getTextSize(headerText))
    gfx.setLineCapStyle(gfx.kLineCapStyleRound)
    gfx.setLineWidth(5)
    gfx.pushContext(headerImage)
        gfx.drawText(headerText,0,0)
        gfx.drawLine(2,50,147,50)
    gfx.popContext()
    self.headerSprite = gfx.sprite.new(headerImage)
    self.headerSprite:moveTo(200,35)
    self.headerSprite:add()
end

function MenuScene:update()
    if(pd.buttonJustPressed(pd.kButtonA))then
        screenShakeSprite:setShakeAmount(10)
    end
end