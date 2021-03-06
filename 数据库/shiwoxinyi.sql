USE [master]
GO
/****** Object:  Database [shiwoxinyigai]    Script Date: 2018/6/29 15:52:12 ******/
CREATE DATABASE [shiwoxinyigai]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'shiwoxinyigai', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\shiwoxinyigai.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'shiwoxinyigai_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\shiwoxinyigai_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [shiwoxinyigai] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [shiwoxinyigai].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [shiwoxinyigai] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [shiwoxinyigai] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [shiwoxinyigai] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [shiwoxinyigai] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [shiwoxinyigai] SET ARITHABORT OFF 
GO
ALTER DATABASE [shiwoxinyigai] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [shiwoxinyigai] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [shiwoxinyigai] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [shiwoxinyigai] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [shiwoxinyigai] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [shiwoxinyigai] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [shiwoxinyigai] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [shiwoxinyigai] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [shiwoxinyigai] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [shiwoxinyigai] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [shiwoxinyigai] SET  DISABLE_BROKER 
GO
ALTER DATABASE [shiwoxinyigai] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [shiwoxinyigai] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [shiwoxinyigai] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [shiwoxinyigai] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [shiwoxinyigai] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [shiwoxinyigai] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [shiwoxinyigai] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [shiwoxinyigai] SET RECOVERY FULL 
GO
ALTER DATABASE [shiwoxinyigai] SET  MULTI_USER 
GO
ALTER DATABASE [shiwoxinyigai] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [shiwoxinyigai] SET DB_CHAINING OFF 
GO
ALTER DATABASE [shiwoxinyigai] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [shiwoxinyigai] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'shiwoxinyigai', N'ON'
GO
USE [shiwoxinyigai]
GO
/****** Object:  StoredProcedure [dbo].[ShopCar_Orders]    Script Date: 2018/6/29 15:52:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ShopCar_Orders]
 @Users_id nvarchar(30),
 @UserName nvarchar(30),
 @UserPhone nvarchar(11),
 @Address nvarchar(MAX),
 @note nvarchar(MAX)
 AS
begin 
    --获取当前系统时间
    declare @TimeNow datetime = CONVERT(varchar, getdate(), 120 )
	--查找出购物车总金额
	declare @Amount float 
	select @Amount=SUM(Price*Count) from ShopCar where Users_id=@Users_id and flag=1
	--向订单表中 Orders 插入数据
	insert into Orders
	values(@Users_id,@TimeNow,@Amount,@UserName,@UserPhone,@Address,@note)
    --获取订单号
	declare @Orders_id int
	select @Orders_id=Orders_id from Orders where Users_id=@Users_id and OrderTime=@TimeNow 
	--向订单明细表 OrdersDetails 插入数据
	insert into OrdersDetails 
    select @Orders_id,Goods_id,Count,Price,@UserName,@UserPhone,@Address,@note
    from View_ShopCar 
    where  Users_id=@Users_id and flag=1 
	--更新相应商品库存
	update Goods 
	set Goods.Count=Goods.Count-( select ShopCar.Count 
	                        from ShopCar
							where Users_id=@Users_id and Goods.Goods_id=ShopCar.Goods_id )
	where Goods.Goods_id in (select Goods_id
	                       from ShopCar
						   where Users_id=@Users_id)
    --删除购物车表 ShopCar 里相应的用户信息
	delete ShopCar where Users_id=@Users_id and flag=1
	
	if @@ERROR <> 0 rollback
end
GO
/****** Object:  Table [dbo].[Goods]    Script Date: 2018/6/29 15:52:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Goods](
	[Goods_id] [int] IDENTITY(1,1) NOT NULL,
	[GoodsName] [nvarchar](50) NOT NULL,
	[GoodsImage] [nvarchar](max) NULL,
	[GoodsJianjie] [nvarchar](max) NULL,
	[GoodsDetails] [nvarchar](max) NULL,
	[AddTime] [datetime] NULL,
	[Price] [decimal](18, 2) NULL,
	[Count] [int] NULL,
	[GoodsK_id] [nvarchar](50) NULL,
	[flag] [int] NULL,
 CONSTRAINT [PK_Goods] PRIMARY KEY CLUSTERED 
(
	[Goods_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GoodsK]    Script Date: 2018/6/29 15:52:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GoodsK](
	[GoodsK_id] [nvarchar](50) NOT NULL,
	[GoodsKName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_GoodsK] PRIMARY KEY CLUSTERED 
(
	[GoodsK_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Manager]    Script Date: 2018/6/29 15:52:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Manager](
	[Manager_id] [nvarchar](50) NOT NULL,
	[ManagerName] [nvarchar](30) NOT NULL,
	[ManagerPass] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_Manager] PRIMARY KEY CLUSTERED 
(
	[Manager_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Orders]    Script Date: 2018/6/29 15:52:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[Orders_id] [int] IDENTITY(1,1) NOT NULL,
	[Users_id] [nvarchar](30) NOT NULL,
	[OrderTime] [datetime] NOT NULL,
	[Sum] [decimal](18, 2) NULL,
	[UserName] [nvarchar](30) NULL,
	[UserPhone] [nvarchar](30) NULL,
	[Address] [nvarchar](max) NULL,
	[note] [nvarchar](max) NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[Orders_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OrdersDetails]    Script Date: 2018/6/29 15:52:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrdersDetails](
	[Orders_id] [int] NOT NULL,
	[Goods_id] [int] NOT NULL,
	[Count] [int] NULL,
	[Price] [decimal](18, 2) NULL,
	[UserName] [nvarchar](30) NULL,
	[UserPhone] [nvarchar](30) NULL,
	[Address] [nvarchar](max) NULL,
	[note] [nvarchar](max) NULL,
 CONSTRAINT [PK_OrdersDetails] PRIMARY KEY CLUSTERED 
(
	[Orders_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ShopCar]    Script Date: 2018/6/29 15:52:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShopCar](
	[ShopCar_id] [int] IDENTITY(1,1) NOT NULL,
	[Goods_id] [int] NOT NULL,
	[Count] [int] NOT NULL,
	[Price] [numeric](18, 2) NOT NULL,
	[Users_id] [nvarchar](30) NOT NULL,
	[note] [nvarchar](max) NOT NULL,
	[Time] [datetime] NULL,
	[flag] [int] NOT NULL,
 CONSTRAINT [PK_ShopCar] PRIMARY KEY CLUSTERED 
(
	[ShopCar_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserAddress]    Script Date: 2018/6/29 15:52:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserAddress](
	[UserAddress_id] [int] NOT NULL,
	[Users_id] [nvarchar](30) NOT NULL,
	[Address] [nvarchar](max) NULL,
 CONSTRAINT [PK_UserAddress_1] PRIMARY KEY CLUSTERED 
(
	[UserAddress_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserInfo]    Script Date: 2018/6/29 15:52:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserInfo](
	[Users_id] [nvarchar](30) NOT NULL,
	[UserName] [nvarchar](30) NULL,
	[UserPass] [nvarchar](20) NOT NULL,
	[UserPhone] [nvarchar](11) NULL,
	[UserMail] [nvarchar](50) NULL,
	[Sex] [nchar](2) NULL,
	[Addtime] [datetime] NULL,
	[SafeQues] [nvarchar](50) NULL,
	[Answer] [nvarchar](50) NULL,
	[Address] [nvarchar](max) NULL,
	[UserSign] [nvarchar](50) NULL,
	[UserImage] [text] NULL,
	[Pifu] [nvarchar](50) NULL,
 CONSTRAINT [PK_UserInfo] PRIMARY KEY CLUSTERED 
(
	[Users_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  View [dbo].[View_OrderDetails]    Script Date: 2018/6/29 15:52:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_OrderDetails]
AS
SELECT   dbo.OrdersDetails.Orders_id, dbo.OrdersDetails.Goods_id, dbo.Orders.Sum, dbo.Orders.OrderTime, 
                dbo.Orders.UserName, dbo.Orders.UserPhone, dbo.Orders.Address, dbo.Orders.note, dbo.Goods.GoodsName, 
                dbo.Goods.GoodsImage, dbo.OrdersDetails.Count, dbo.OrdersDetails.Price, dbo.Orders.Users_id
FROM      dbo.Orders INNER JOIN
                dbo.OrdersDetails ON dbo.Orders.Orders_id = dbo.OrdersDetails.Orders_id INNER JOIN
                dbo.Goods ON dbo.OrdersDetails.Goods_id = dbo.Goods.Goods_id

GO
/****** Object:  View [dbo].[View_ShopCar]    Script Date: 2018/6/29 15:52:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_ShopCar]
AS
SELECT   dbo.Goods.Goods_id, dbo.Goods.GoodsName, dbo.Goods.GoodsImage, dbo.Goods.Price, dbo.ShopCar.ShopCar_id, 
                dbo.ShopCar.Count, dbo.ShopCar.note, dbo.ShopCar.flag, dbo.UserInfo.Users_id, dbo.UserInfo.UserName, 
                dbo.UserInfo.UserPhone, dbo.UserInfo.Address, dbo.ShopCar.Count * dbo.Goods.Price AS FinalPrice
FROM      dbo.Goods INNER JOIN
                dbo.ShopCar ON dbo.Goods.Goods_id = dbo.ShopCar.Goods_id INNER JOIN
                dbo.UserInfo ON dbo.ShopCar.Users_id = dbo.UserInfo.Users_id

GO
SET IDENTITY_INSERT [dbo].[Goods] ON 

INSERT [dbo].[Goods] ([Goods_id], [GoodsName], [GoodsImage], [GoodsJianjie], [GoodsDetails], [AddTime], [Price], [Count], [GoodsK_id], [flag]) VALUES (1, N'小蜜蜂耳钉', N'/Images/goods/xmfed.jpg', N'S925纯银百搭显瘦小蜜蜂耳钉一款两戴长款流苏耳环女时尚气质超仙', N'品牌: other/其他材质: 银饰金属材质: 925银颜色分类: 金色 银色风格: 原创设计图案: 蝴蝶/蜻蜒/昆虫适用性别: 女货号: 24788-A272成色: 全新是否现货: 现货价格区间: 51-100元新奇特: 新鲜出炉镶嵌材质: 合金镶嵌人工宝石/半宝石', CAST(0x0000A8D500FC6E65 AS DateTime), CAST(23.90 AS Decimal(18, 2)), 1318, N'4', NULL)
INSERT [dbo].[Goods] ([Goods_id], [GoodsName], [GoodsImage], [GoodsJianjie], [GoodsDetails], [AddTime], [Price], [Count], [GoodsK_id], [flag]) VALUES (2, N'古风新娘发饰流苏', N'/Images/goods/gfxnfs.jpg', N'婚饰手作 新娘古装头饰耳环 中式婚礼婚纱摄影写真 凤冠套装', N'材质: 合金/镀银/镀金品牌: 漪岚成色: 全新价格区间: 101-200元镶嵌材质: 未镶嵌新奇特: 新鲜出炉风格: 复古/宫廷', CAST(0x0000A8D600FC6E65 AS DateTime), CAST(168.00 AS Decimal(18, 2)), 51, N'2', 1)
INSERT [dbo].[Goods] ([Goods_id], [GoodsName], [GoodsImage], [GoodsJianjie], [GoodsDetails], [AddTime], [Price], [Count], [GoodsK_id], [flag]) VALUES (3, N'古风新娘发饰', N'/Images/goods/gfxnfs1.jpg', N'新娘头饰五件套装2018新款中式秀禾服龙凤褂结婚饰品复古发夹簪子', N'发饰分类: 发饰套装颜色分类: 金色材质: 合金/镀银/镀金品牌: other/其他成色: 全新价格区间: 51-100元镶嵌材质: 未镶嵌新奇特: 新鲜出炉货号: TS05 五件套风格: 复古/宫廷', CAST(0x0000A8D600FCB4B5 AS DateTime), CAST(68.00 AS Decimal(18, 2)), 147, N'2', NULL)
INSERT [dbo].[Goods] ([Goods_id], [GoodsName], [GoodsImage], [GoodsJianjie], [GoodsDetails], [AddTime], [Price], [Count], [GoodsK_id], [flag]) VALUES (4, N'珍珠新娘发饰', N'/Images/goods/gfxnfszz.jpg', N'新娘珍珠圆冠耳环套装 时尚韩式头饰婚礼婚纱头纱配饰品包邮', N'发饰分类: 发饰套装材质: 其他品牌: other/其他成色: 全新价格区间: 51-100元镶嵌材质: 未镶嵌新奇特: 新鲜出炉货号: F82-A19风格: 日韩', CAST(0x0000A8D600FD4155 AS DateTime), CAST(69.00 AS Decimal(18, 2)), 223, N'2', NULL)
INSERT [dbo].[Goods] ([Goods_id], [GoodsName], [GoodsImage], [GoodsJianjie], [GoodsDetails], [AddTime], [Price], [Count], [GoodsK_id], [flag]) VALUES (5, N'新娘发饰头纱', N'/Images/goods/xnfsts.jpg', N'新娘韩式精美气质锆石小皇冠高端婚礼晚会造型写真婚纱头饰品', N'发饰分类: 皇冠材质: 合金/镀银/镀金品牌: other/其他成色: 全新价格区间: 51-100元镶嵌材质: 未镶嵌新奇特: 新鲜出炉货号: R119-143风格: 日韩', CAST(0x0000A8D6010D2F75 AS DateTime), CAST(88.00 AS Decimal(18, 2)), 599, N'2', 1)
INSERT [dbo].[Goods] ([Goods_id], [GoodsName], [GoodsImage], [GoodsJianjie], [GoodsDetails], [AddTime], [Price], [Count], [GoodsK_id], [flag]) VALUES (6, N'雏菊耳线耳钉', N'/Images/goods/cjexed.jpg', N'韩国百搭少女心简约ins耳环小清新雏菊花朵S925纯银针耳线耳钉女', N'品牌: other/其他材质: 银饰金属材质: 925银颜色分类: # 1 短款小黄花（） # 2 长款小黄花 # 3 带珍珠。小黄花 #4小黄花，多个超仙。夏日风 锆石。小黄花耳环 花环。银针耳环 磨砂。小花。白色 磨砂。小花。粉色 花朵。猫眼石（三角形） 花朵。猫眼石（爱心形） 花朵。猫眼石（圆形） 玻璃花。短。水钻（黄色） 玻璃花。短。水钻（粉色） 长款。玻璃花。（绿色） 长款。玻璃花。（粉色） 蝴蝶结。玻璃花。（黄色） 金底蝴蝶结。玻璃花（绿色） 全花。耳朵耳环 半花。耳朵耳环风格: 原创设计图案: 植物花卉适用性别: 女成色: 全新是否现货: 现货价格区间: 10-19.99元新奇特: 新鲜出炉镶嵌材质: 未镶嵌', CAST(0x0000A8D7010D2EF0 AS DateTime), CAST(15.90 AS Decimal(18, 2)), 1777, N'4', NULL)
INSERT [dbo].[Goods] ([Goods_id], [GoodsName], [GoodsImage], [GoodsJianjie], [GoodsDetails], [AddTime], [Price], [Count], [GoodsK_id], [flag]) VALUES (7, N'四叶草手链', N'/Images/goods/sycsl.jpg', N'欧维希银手链女四叶草s925银首饰品日韩简约时尚学生饰品生日礼物
闪电发货 礼盒包装 可代写贺卡', N'材质: 银饰金属材质: 925银 颜色分类: 竹节紫钻手链 巴黎恋人手链 唯爱四叶草手 银色心连心手链 灵动手镯链 竹节白钻手链 星轨手链 四叶之恋手链 幸运有你手链 爱的符号手链 恋心手链 1314手链 520手链品牌: Ovish/欧维希适用性别: 女图案: 植物花卉风格: 日韩是否现货: 现货镶嵌材质: 纯银镶嵌宝石成色', CAST(0x0000A8D7010E8E80 AS DateTime), CAST(69.00 AS Decimal(18, 2)), 55, N'1', NULL)
INSERT [dbo].[Goods] ([Goods_id], [GoodsName], [GoodsImage], [GoodsJianjie], [GoodsDetails], [AddTime], [Price], [Count], [GoodsK_id], [flag]) VALUES (8, N'爱心戒指', N'/Images/goods/axjz.jpg', N'欧维希 925银戒指女气质双层镶钻爱心戒指指环字母love食指戒礼物', N'材质: 银饰金属材质: 925银颜色分类: 金色 银色品牌: Ovish/欧维希风格: 日韩适用性别: 女图案: 其他是否现货: 现货价格区间: 101-200元镶嵌材质: 其他成色: 全新', CAST(0x0000A8D7011F0940 AS DateTime), CAST(59.90 AS Decimal(18, 2)), 30, N'1', 1)
INSERT [dbo].[Goods] ([Goods_id], [GoodsName], [GoodsImage], [GoodsJianjie], [GoodsDetails], [AddTime], [Price], [Count], [GoodsK_id], [flag]) VALUES (9, N'蝴蝶结发圈', N'/Images/goods/hdjfq.jpg', N'4根装新款长飘带头绳 气质蝴蝶结发圈成人头饰 韩国清新樱桃发绳', N'发饰分类: 发绳颜色分类: 藏青色（4根装） 黑白格子（3根装） 黑色（4根装） 蝴蝶结飘带（4根装） 蕾丝飘带（4根装） 墨绿色（4根装）材质: 缎品牌: 魔丽小屋成色: 全新价格区间: 1.00-9.99元镶嵌材质: 未镶嵌新奇特: 新鲜出炉货号: 10246700风格: 日韩', CAST(0x0000A8D700BC28C0 AS DateTime), CAST(9.90 AS Decimal(18, 2)), 98, N'2', NULL)
INSERT [dbo].[Goods] ([Goods_id], [GoodsName], [GoodsImage], [GoodsJianjie], [GoodsDetails], [AddTime], [Price], [Count], [GoodsK_id], [flag]) VALUES (10, N'樱花流线发夹', N'/Images/goods/yhlxfq.jpg', N'2018新款樱花饰品流线发夹 韩国编发发饰 成人隐形小发卡甜美边夹', N'发饰分类: 边夹颜色分类: 珍珠花朵 粉色樱花 红色爱心 粉红色爱心 浅粉色爱心材质: 串珠品牌: 魔丽小屋成色: 全新价格区间: 1.00-9.99元镶嵌材质: 未镶嵌新奇特: 新鲜出炉货号: 10193600风格: 日韩', CAST(0x0000A8DA00BC28C0 AS DateTime), CAST(7.90 AS Decimal(18, 2)), 1530, N'2', 1)
INSERT [dbo].[Goods] ([Goods_id], [GoodsName], [GoodsImage], [GoodsJianjie], [GoodsDetails], [AddTime], [Price], [Count], [GoodsK_id], [flag]) VALUES (11, N'蝴蝶脚链', N'/Images/goods/hdjl.jpg', N'韩版简约18K玫瑰金社会女脚链女 性感个性森系蝴蝶脚踝链学生饰品', N'材质: 钛钢颜色分类: 蝴蝶脚链*银色 蝴蝶脚链*玫瑰金色品牌: other/其他风格: 日韩适用性别: 女图案: 蝴蝶/蜻蜒/昆虫镶嵌材质: 镀金镶嵌人工宝石/半宝石是否现货: 现货', CAST(0x0000A8DA00CCA380 AS DateTime), CAST(28.00 AS Decimal(18, 2)), 204, N'3', NULL)
INSERT [dbo].[Goods] ([Goods_id], [GoodsName], [GoodsImage], [GoodsJianjie], [GoodsDetails], [AddTime], [Price], [Count], [GoodsK_id], [flag]) VALUES (12, N'森系复古脚链', N'/Images/goods/sxfgjl.jpg', N'脚链女韩版多层叶子铃铛森系复古百搭民族风手工饰品手链闺蜜礼物', N'材质: 混合材质颜色分类: 手链 脚链品牌: other/其他 可调节，代写贺卡', CAST(0x0000A8DA00CF62A0 AS DateTime), CAST(39.00 AS Decimal(18, 2)), 377, N'3', NULL)
INSERT [dbo].[Goods] ([Goods_id], [GoodsName], [GoodsImage], [GoodsJianjie], [GoodsDetails], [AddTime], [Price], [Count], [GoodsK_id], [flag]) VALUES (13, N'魔方锁骨链', N'/Images/goods/mfsgl.jpg', N'简约气质吊坠925银项链魔方锁骨链女日韩时尚甜美配饰品生日礼物', N'链子材质: 其他链子样式: 水波链品牌: other/其他颜色分类: 魔方+水波链 六爪单钻+扭片链风格: 日韩是否带坠: 是适用性别: 女是否现货: 现货成色: 全新新奇特: 新鲜出炉', CAST(0x0000A8DB00CF62A0 AS DateTime), CAST(112.00 AS Decimal(18, 2)), 902, N'5', NULL)
INSERT [dbo].[Goods] ([Goods_id], [GoodsName], [GoodsImage], [GoodsJianjie], [GoodsDetails], [AddTime], [Price], [Count], [GoodsK_id], [flag]) VALUES (14, N'水晶项链', N'/Images/goods/sjxl.jpg', N'人鱼泡沫水晶项链女s925纯银韩版简约学生清新森系锁骨链', N'链子材质: 银饰金属材质: 925银链子样式: 其他坠子材质: 银品牌: 花芽延长链: 10cm以下颜色分类: 人鱼项链图案: 海洋生物风格: 原创设计镶嵌材质: 其他是否带坠: 是是否多层: 否适用性别: 女是否现货: 现货', CAST(0x0000A8DB00DFDD60 AS DateTime), CAST(89.00 AS Decimal(18, 2)), 1000, N'5', 1)
INSERT [dbo].[Goods] ([Goods_id], [GoodsName], [GoodsImage], [GoodsJianjie], [GoodsDetails], [AddTime], [Price], [Count], [GoodsK_id], [flag]) VALUES (15, N'胸针10件套', N'/Images/goods/txz.jpg', N'迷你可爱胸针 衬衫衬衣防走光小别针装饰 创意 百搭 日系小清新', N'材质: 混合材质颜色分类: 混合10件套 A款10件套 B款10件套 C款10件套 D款10件套 F款10件套 E款10件套 J款10件套 H款10件套 l款10件套 U款10件套 混合10件套 2号品牌: other/其他适用性别: 女图案: 其他风格: 日韩是否现货: 现货镶嵌材质: 未镶嵌成色: 全新', CAST(0x0000A8DB00F05820 AS DateTime), CAST(24.99 AS Decimal(18, 2)), 1005, N'6', NULL)
INSERT [dbo].[Goods] ([Goods_id], [GoodsName], [GoodsImage], [GoodsJianjie], [GoodsDetails], [AddTime], [Price], [Count], [GoodsK_id], [flag]) VALUES (16, N'闪闪胸针', N'/Images/goods/ssxz.jpg', N'奢华高档大气太阳花胸针水钻简约女珍珠胸花韩国外套别针开衫配饰', N'材质: 合成立方氧化锆/水钻颜色分类: 双生花 相伴一生满钻草莓 相伴一生钻锆草莓 爱的点滴棉花云 生如夏花拥簇 挥翅膀的女孩 翩翩起舞蒲公英 亭亭玉立郁金香 优雅蝴蝶贝珠 珍珠花 阳光云 笑脸云 天鹅A款 天鹅B款 太阳花（旋转款） 五星（旋转款） 双蝴蝶（迷你款） 叶子珍珠款品牌: other/其他适用性别: 女图案: 植物花卉风格: 日韩是否现货: 现货镶嵌材质: 合金镶嵌人工宝石/半宝石成色: 全新', CAST(0x0000A8DB0100D2E0 AS DateTime), CAST(29.80 AS Decimal(18, 2)), 2000, N'6', NULL)
INSERT [dbo].[Goods] ([Goods_id], [GoodsName], [GoodsImage], [GoodsJianjie], [GoodsDetails], [AddTime], [Price], [Count], [GoodsK_id], [flag]) VALUES (17, N'饰品收纳盒', N'/Images/goods/spsnh.jpg', N'首饰盒便携公主欧式韩国旅行小号简约耳环耳钉盒戒指手饰品收纳盒', N'旅行者首饰盒，自由随性。小巧身材，大容量。单车裸粉便携小巧。', CAST(0x0000A8DB01039200 AS DateTime), CAST(29.00 AS Decimal(18, 2)), 200, N'7', 1)
INSERT [dbo].[Goods] ([Goods_id], [GoodsName], [GoodsImage], [GoodsJianjie], [GoodsDetails], [AddTime], [Price], [Count], [GoodsK_id], [flag]) VALUES (18, N'太阳镜', N'/Images/goods/tyj.jpg', N'太阳镜女潮2018明星款网红大框显瘦圆脸无框切边眼镜时尚优雅墨镜', N'<p>
	dvfh</p>
', CAST(0x0000A90901020A1F AS DateTime), CAST(68.00 AS Decimal(18, 2)), 1, N'7', NULL)
INSERT [dbo].[Goods] ([Goods_id], [GoodsName], [GoodsImage], [GoodsJianjie], [GoodsDetails], [AddTime], [Price], [Count], [GoodsK_id], [flag]) VALUES (19, N'太阳', N'/Images/goods/cysl5.jpg', N'太阳镜女潮2018明星款网红大框显瘦圆脸无框切边眼镜时尚优雅墨镜', N'<p>
	短信费vvcfgbhmj</p>
', CAST(0x0000A90E01011353 AS DateTime), CAST(68.00 AS Decimal(18, 2)), 11, N'1', NULL)
SET IDENTITY_INSERT [dbo].[Goods] OFF
INSERT [dbo].[GoodsK] ([GoodsK_id], [GoodsKName]) VALUES (N'1', N'手饰')
INSERT [dbo].[GoodsK] ([GoodsK_id], [GoodsKName]) VALUES (N'2', N'发饰')
INSERT [dbo].[GoodsK] ([GoodsK_id], [GoodsKName]) VALUES (N'3', N'脚饰')
INSERT [dbo].[GoodsK] ([GoodsK_id], [GoodsKName]) VALUES (N'4', N'耳饰')
INSERT [dbo].[GoodsK] ([GoodsK_id], [GoodsKName]) VALUES (N'5', N'颈饰')
INSERT [dbo].[GoodsK] ([GoodsK_id], [GoodsKName]) VALUES (N'6', N'胸饰')
INSERT [dbo].[GoodsK] ([GoodsK_id], [GoodsKName]) VALUES (N'7', N'其他')
INSERT [dbo].[Manager] ([Manager_id], [ManagerName], [ManagerPass]) VALUES (N'00001', N'冷冰冰', N'jing2018')
SET IDENTITY_INSERT [dbo].[Orders] ON 

INSERT [dbo].[Orders] ([Orders_id], [Users_id], [OrderTime], [Sum], [UserName], [UserPhone], [Address], [note]) VALUES (1, N'a123', CAST(0x0000A90E00FE58E4 AS DateTime), CAST(336.00 AS Decimal(18, 2)), N'冷', N'1245658', N'江西南昌', N'')
SET IDENTITY_INSERT [dbo].[Orders] OFF
INSERT [dbo].[OrdersDetails] ([Orders_id], [Goods_id], [Count], [Price], [UserName], [UserPhone], [Address], [note]) VALUES (1, 2, 2, CAST(168.00 AS Decimal(18, 2)), N'冷', N'1245658', N'江西南昌', N'')
SET IDENTITY_INSERT [dbo].[ShopCar] ON 

INSERT [dbo].[ShopCar] ([ShopCar_id], [Goods_id], [Count], [Price], [Users_id], [note], [Time], [flag]) VALUES (5, 6, 2, CAST(15.90 AS Numeric(18, 2)), N'a123', N'', CAST(0x0000A90E00FFDCAB AS DateTime), 0)
SET IDENTITY_INSERT [dbo].[ShopCar] OFF
INSERT [dbo].[UserAddress] ([UserAddress_id], [Users_id], [Address]) VALUES (0, N'a123', N'江西南昌')
INSERT [dbo].[UserInfo] ([Users_id], [UserName], [UserPass], [UserPhone], [UserMail], [Sex], [Addtime], [SafeQues], [Answer], [Address], [UserSign], [UserImage], [Pifu]) VALUES (N'a000001', N'冰', N'a12345678', N'15279112121', N'1229150012@qq.com', N'女 ', CAST(0x0000A8B500000000 AS DateTime), NULL, NULL, N'江西省南昌市江西师范大学', N'无论何时，记得勇敢。', N'/Images/userInfo/touxiang1.jpg', NULL)
INSERT [dbo].[UserInfo] ([Users_id], [UserName], [UserPass], [UserPhone], [UserMail], [Sex], [Addtime], [SafeQues], [Answer], [Address], [UserSign], [UserImage], [Pifu]) VALUES (N'a000002', N'曾经的国际难民', N'a12345678', N'15879212127', N'5456575891@qq.com', N'男 ', CAST(0x0000A8B600000000 AS DateTime), NULL, NULL, N'江西省南昌市', NULL, NULL, NULL)
INSERT [dbo].[UserInfo] ([Users_id], [UserName], [UserPass], [UserPhone], [UserMail], [Sex], [Addtime], [SafeQues], [Answer], [Address], [UserSign], [UserImage], [Pifu]) VALUES (N'a1229', NULL, N'1jing0203', NULL, N'1222235@qq.com', N'女 ', CAST(0x0000A8FC001743BB AS DateTime), NULL, NULL, NULL, NULL, NULL, N'../../Images/userInfo/h_d.jpg')
INSERT [dbo].[UserInfo] ([Users_id], [UserName], [UserPass], [UserPhone], [UserMail], [Sex], [Addtime], [SafeQues], [Answer], [Address], [UserSign], [UserImage], [Pifu]) VALUES (N'a123', N'冰冰', N'leng0203', N'12345678910', N'1229150012@qq.com', N'女 ', CAST(0x0000A90E00FD2B62 AS DateTime), N'我喜欢的明星是谁？', N'郑爽', N'江西宜春', N'你对我是怎样的，那我就对你怎样！', NULL, NULL)
ALTER TABLE [dbo].[Goods]  WITH CHECK ADD  CONSTRAINT [FK_Goods_GoodsK] FOREIGN KEY([GoodsK_id])
REFERENCES [dbo].[GoodsK] ([GoodsK_id])
GO
ALTER TABLE [dbo].[Goods] CHECK CONSTRAINT [FK_Goods_GoodsK]
GO
ALTER TABLE [dbo].[GoodsK]  WITH CHECK ADD  CONSTRAINT [FK_GoodsK_GoodsK] FOREIGN KEY([GoodsK_id])
REFERENCES [dbo].[GoodsK] ([GoodsK_id])
GO
ALTER TABLE [dbo].[GoodsK] CHECK CONSTRAINT [FK_GoodsK_GoodsK]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_UserInfo] FOREIGN KEY([Users_id])
REFERENCES [dbo].[UserInfo] ([Users_id])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_UserInfo]
GO
ALTER TABLE [dbo].[OrdersDetails]  WITH CHECK ADD  CONSTRAINT [FK_OrdersDetails_Goods] FOREIGN KEY([Goods_id])
REFERENCES [dbo].[Goods] ([Goods_id])
GO
ALTER TABLE [dbo].[OrdersDetails] CHECK CONSTRAINT [FK_OrdersDetails_Goods]
GO
ALTER TABLE [dbo].[ShopCar]  WITH CHECK ADD  CONSTRAINT [FK_ShopCar_Goods] FOREIGN KEY([Goods_id])
REFERENCES [dbo].[Goods] ([Goods_id])
GO
ALTER TABLE [dbo].[ShopCar] CHECK CONSTRAINT [FK_ShopCar_Goods]
GO
ALTER TABLE [dbo].[ShopCar]  WITH CHECK ADD  CONSTRAINT [FK_ShopCar_UserInfo] FOREIGN KEY([Users_id])
REFERENCES [dbo].[UserInfo] ([Users_id])
GO
ALTER TABLE [dbo].[ShopCar] CHECK CONSTRAINT [FK_ShopCar_UserInfo]
GO
ALTER TABLE [dbo].[UserAddress]  WITH CHECK ADD  CONSTRAINT [FK_UserAddress_UserInfo] FOREIGN KEY([Users_id])
REFERENCES [dbo].[UserInfo] ([Users_id])
GO
ALTER TABLE [dbo].[UserAddress] CHECK CONSTRAINT [FK_UserAddress_UserInfo]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -1920
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Orders"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 146
               Right = 190
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OrdersDetails"
            Begin Extent = 
               Top = 6
               Left = 228
               Bottom = 146
               Right = 380
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Goods"
            Begin Extent = 
               Top = 6
               Left = 418
               Bottom = 146
               Right = 585
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_OrderDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_OrderDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[19] 2[22] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Goods"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 146
               Right = 205
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ShopCar"
            Begin Extent = 
               Top = 6
               Left = 243
               Bottom = 146
               Right = 398
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "UserInfo"
            Begin Extent = 
               Top = 6
               Left = 436
               Bottom = 146
               Right = 588
            End
            DisplayFlags = 280
            TopColumn = 2
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_ShopCar'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_ShopCar'
GO
USE [master]
GO
ALTER DATABASE [shiwoxinyigai] SET  READ_WRITE 
GO
