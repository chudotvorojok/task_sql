-- Справочник Дат
  create table [task].[dbo].[Dates]
  (
	datekey date primary key WITH (ignore_dup_key = on) not null,
	[month] int,
	[year] int
  )
  insert into [task].[dbo].[Dates]
  select [FDate]
        ,[Month]
        ,[Year]
  from [task].[dbo].[RES]


-- Справочник Клиентов
  create table [task].[dbo].[Clients]
  (
	[Client_id] bigint primary key WITH (ignore_dup_key = on) not null
   ,[Client] varchar(20)
  )
  insert into [task].[dbo].[Clients]
  select (case when (isnumeric([id_Client]) = 1) then cast([id_Client] AS bigint)
			   else 0
         end)
        ,[Client]
  from [task].[dbo].[RES]
  where [id_Client] is not null


-- Справочник поставщиков
  create table [task].[dbo].[Distributors]
  (
	[Distributor_id] int primary key WITH (ignore_dup_key = on) not null
   ,[Distributor] varchar(20)
  )
  insert into [task].[dbo].[Distributors]
  select (case when (isnumeric(id_Distributor) = 1) then cast([id_Distributor] AS bigint)
			   else 0
         end)
        ,[ Distributor]
  from [task].[dbo].[RES]
  where [id_Distributor] is not null


-- Справочник товаров
  create table [task].[dbo].[Products]
  (
	[Product_id] int primary key WITH (ignore_dup_key = on) not null
   ,[Product] varchar(20)
   ,[Brand] varchar(20)
  )
  insert into [task].[dbo].[Products]
  select (case when (isnumeric(id_Product) = 1) then cast([id_Product] AS bigint)
			   else 0
         end)
        ,[Product]
		,[Brand]
  from [task].[dbo].[RES]
  where [id_Product] is not null