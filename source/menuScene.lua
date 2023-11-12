-- This is the main menu for my version of sudoku for the playdate
-- Title: menuScene.lua
-- Author: Jessica Stojkovic
-- Date: 11/11/23
-- version: 0.0.1

--********************Constants**********************
import "Corelibs/crank"
local pd <const> = playdate
local gfx <const> = pd.graphics

class("MenuScene").extends(gfx.sprite)

function MenuScene:init()
    self:prepareSprites()
    self:add()
end

function MenuScene:prepareSprites()
    -- make the header sprite
    gfx.setFont(fontNontendoBold4X)
    local headerText = "Sudoku" -- set the text to be used for the header
    local headerImage = gfx.image.new(gfx.getTextSize(headerText)) -- create a image to use to create the sprite the same size as the text
    gfx.setLineCapStyle(gfx.kLineCapStyleRound) -- set the end of the line to round
    gfx.setLineWidth(5) -- set the line width
    gfx.pushContext(headerImage) -- start assembling the header image
        gfx.drawText(headerText,0,0) --add the text 
        gfx.drawLine(2,50,147,50) -- add the underline
    gfx.popContext() -- finish the header image
    self.headerSprite = gfx.sprite.new(headerImage) -- create the sprite with the new image
    self.headerSprite:moveTo(200,35) -- position the header sprite
    self.headerSprite:add() -- add the header sprite to the update list
    --make sprite for new game button
    -- make the unselected image
    gfx.setFont(fontNontendoBoldOutline1AndOneHalfX)
    local newGameText = "New Game"
    self.newGameImageUnselected = gfx.image.new(119,38,gfx.kColorWhite)
    gfx.setLineWidth(3)
    gfx.pushContext(self.newGameImageUnselected)
        gfx.drawRoundRect(2,2,116,35,5)
        gfx.drawTextAligned(newGameText,59,10,kTextAlignment.center)
    gfx.popContext()
    -- make the selected sprite
    self.newGameImageSelected = gfx.image.new(119,38)
    gfx.pushContext(self.newGameImageSelected)
        gfx.fillRoundRect(2,2,116,35,5)
        gfx.setColor(gfx.kColorWhite)
        gfx.setLineWidth(2)
        gfx.drawRoundRect(4,4,112,31,5)
        gfx.setColor(gfx.kColorBlack)
        gfx.drawTextAligned(newGameText,59,10,kTextAlignment.center)
    gfx.popContext()
    self.newGameSprite = gfx.sprite.new(self.newGameImageSelected)
    self.newGameSprite:moveTo(200,90)
    self.newGameSprite:add()
    --make sprite for resume game button
    --unselected 
    local resumeGameText = "Resume Game"
    self.resumeGameImageUnselected = gfx.image.new(150,38)
    gfx.pushContext(self.resumeGameImageUnselected)
        gfx.drawRoundRect(2,2,146,35,5)
        gfx.drawTextAligned(resumeGameText,75,10,kTextAlignment.center)
    gfx.popContext()
    --selected
    self.resumeGameImageSelected = gfx.image.new(156,38)
    gfx.pushContext(self.resumeGameImageSelected)
        gfx.fillRoundRect(2,2,152,35,5)
        gfx.setColor(gfx.kColorWhite)
        gfx.setLineWidth(2)
        gfx.drawRoundRect(4,4,148,31,5)
        gfx.setColor(gfx.kColorBlack)
        gfx.drawTextAligned(resumeGameText,77,10,kTextAlignment.center)
    gfx.popContext()
    self.resumeGameSprite = gfx.sprite.new(self.resumeGameImageUnselected)
    self.resumeGameSprite:moveTo(200,135)
    self.resumeGameSprite:add()
    self.selectedButton = 1
end

function MenuScene:changeSelection()
    local ticks = 0
    if  not pd.isCrankDocked() then
        ticks = pd.getCrankTicks(4)
    end
    if(pd.buttonJustPressed(pd.kButtonDown))then
        ticks = 1
    end
    if(pd.buttonJustPressed(pd.kButtonUp))then
        ticks = -1
    end
    if(ticks ~= 0)then
        self.selectedButton += ticks
        if(self.selectedButton > 2) then
            self.selectedButton = 2
        elseif (self.selectedButton < 1) then
            self.selectedButton = 1
        end
        if(self.selectedButton == 1) then
            self.newGameSprite:setImage(self.newGameImageSelected)
            self.resumeGameSprite:setImage(self.resumeGameImageUnselected)
        elseif(self.selectedButton == 2) then
            self.newGameSprite:setImage(self.newGameImageUnselected)
            self.resumeGameSprite:setImage(self.resumeGameImageSelected)
        end
    end
end

function MenuScene:update()
    self:changeSelection()
end