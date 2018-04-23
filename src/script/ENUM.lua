-- [[
-- Copyright (C), 2015, 
-- 文 件 名: ENUM.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2015-12-31
-- 完成日期: 
-- 功能描述: 公共枚举定义
-- 其它相关: 
-- 修改记录: 
-- ]]

-- 日志文件名
local LOG_FILE_NAME = 'ENUM.log'
 
ENUM = {}
ENUM.__index = ENUM

-- 节点添加的位置
ENUM.LAYE_TYPE = 
{
    UISCENE  = 0,       -- 地图层
    SPRITE   = 1,       -- 精灵层    
    UI       = 2,       -- UI层
    UINotice = 3,       -- UI公告层
    UITips   = 4,       -- UITips层
    Guide    = 5,       -- 新手引导层
}

--游戏中的颜色值,ARGB
ENUM.GAME_COLOR_TYPE = 
{
    GRAY     = 0X00C0C0C0,                  -- 灰色
    WHITE    = 0X00FFFFFF,                  -- 白色
    BLACK    = 0X00000000,                  -- 黑色
    GREEN    = 0X0000FF00,                  -- 绿色
    RED      = 0X00FF0000,                  -- 红色
    YELLOW   = 0X00FFFF00,                  -- 黄色
}

ENUM.GameFightState = 
{
    None     = -1,  -- 无状态
    Begin    = 0,   -- 开始初始化
    Fighting = 1,   -- 战斗中
    End      = 2,   -- 结束
}

ENUM.RoomType = {
    Custom = 1,  -- 自定义房间
    Match  = 2,  -- 比赛房间
    MATCHING = 3,  -- 普通房间
}

ENUM.RoomLevel = {
    Test         = 1,  -- 试玩
    Primary      = 2,  -- 初级
    Intermediate = 3,  -- 中级
    Advance      = 4,  -- 高级
}

ENUM.RoomLevelWord = {
    [ENUM.RoomLevel.Test]         = "试玩场",  -- 试玩
    [ENUM.RoomLevel.Primary]      = "初级场",  -- 初级
    [ENUM.RoomLevel.Intermediate] = "中级场",  -- 中级
    [ENUM.RoomLevel.Advance]      = "高级场",  -- 高级
}

ENUM.AccountType = {
    Visitor = 0,  -- 游客
    Wechat = 1,  -- 微信
}

ENUM.OnLineType = {
    Offline = 0,
    Online = 1,
}

-- 实体类型枚举
ENUM.CLASS_TYPE = 
{
    CLASS_NULL              = 0,            -- 无类型
    CLASS_GOODS             = 1,            -- 物品类
    CLASS_ITEM              = 2,            -- 道具类
    CLASS_EQUIPMENT         = 3,            -- 装备类    
    CLASS_TANKITEM          = 4,            -- 坦克道具类     
    CLASS_ENTITY            = 5,            -- 实体
    CLASS_DEFFENDER         = 6,            -- 防御者
    CLASS_MOVER             = 7,            -- 移动者
    CLASS_ATTACKER          = 8,            -- 攻击者
    CLASS_ENTITYBULLET      = 9,            -- 实体飞弹类
    CLASS_CATAPULT          = 10,           -- 弹射类实体
    CLASS_BOATBULLET        = 11,           -- 实体飞弹类
    CLASS_NONETRACK         = 12,           -- 无轨迹实体
    CLASS_TANK              = 13,           -- 坦克实体类
    CLASS_SCENE             = 14,
    CLASS_MOUNTEQUIPMENT    = 15,           -- 挂件装备
    CLASS_MAXNUM            = 16,           -- 枚举上限制
}

-- 物品类型枚举
ENUM.ItemType = 
{
    None               = -1,               -- 无类型
    Item               = 2,                -- 道具
}

-- 获取
ENUM.CurrencyType = {
    Coin    = 1,  
    Diamond = 2,
}

-- 物品品质颜色枚举
ENUM.EGoodsQualityColor =
{
    EQUALITYCOLOR_WHITE         = 1,                -- 白色
    EQUALITYCOLOR_GREEN         = 2,                -- 绿色
    EQUALITYCOLOR_BLUE          = 3,                -- 蓝色
    EQUALITYCOLOR_PURPLE        = 4,                -- 紫色
    EQUALITYCOLOR_ORANGE        = 5,                -- 橙色
}           


ENUM.ANCHORPOINT = 
{
    [0]    = cc.p(0, 0),
    [90]   = cc.p(1, 0),
    [-90]  = cc.p(0, 1),
    [180]  = cc.p(1, 1),
    [-180] = cc.p(1, 1),
    [270]  = cc.p(0, 1),
}

ENUM.GameType = 
{
    NONE    = 0,
    DAER    = 1,    -- 大贰
    MAJIANG = 2,    -- 麻将
    POKER   = 3,    -- 德州
    ZJH     = 4,    -- 扎金花
    TANK    = 5,    -- 坦克
}
ENUM.GameDownloadFlagType = {
    [ENUM.GameType.NONE]    = "game_none",
    [ENUM.GameType.DAER]    = "game_daer",    -- 大贰
    [ENUM.GameType.MAJIANG] = "game_majiang",    -- 麻将
    [ENUM.GameType.POKER]   = "game_poker",    -- 德州
    [ENUM.GameType.ZJH]     = "game_zjh",    -- 扎金花  
}

ENUM.GameName = {
    [ENUM.GameType.NONE]    = "所有类型",
    [ENUM.GameType.DAER]    = "泸州大贰",
    [ENUM.GameType.MAJIANG] = "泸州鬼麻将",
    [ENUM.GameType.POKER]   = "德州扑克",
}

ENUM.RoomLevel = 
{   
    ShiWan  = 1, -- 试玩
    ChuJi   = 2, -- 初级
    ZhongJi = 3, -- 中级
    GaoJi   = 4, -- 高级
}

ENUM.RoomDaiGui = 
{
    BuDaiGui = 1, -- 不带归
    DaiGui   = 2, -- 带归
}

ENUM.RedPointType = {
    EMail    = 1,
    Task     = 2,
    Convert  = 3,
    Shop     = 4,
    Bag      = 5,
    Activity = 6,
    More     = 7,
}

ENUM.ChatType = {
    FixWord    = 1,     -- 固定文字
    Face       = 2,     -- 表情
    CustonWord = 3,     -- 自定义文字
}

ENUM.SexType = {
    Man = 0,
    Female = 1,
}

ENUM.EPLAYR_DIRECTION_TYPE =
{
    UP   = 1,       -- 上家
    DOWN = 2,       -- 下家
    SELF = 3,       -- 自己
}

ENUM.CoinType = 
{
    Score = 1,
    Coin  = 2,
}

-- 实体阵营
ENUM.ENTITY_CAMP =
{
    NONE    = 0,
    RED     = 1,
    BLUE    = 2,
}