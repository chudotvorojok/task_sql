-- »тогова€ таблица фактов с подт€нутыми справочниками по ключам
	select d.[Datekey]
		  ,d.[Month]
		  ,d.[Year]
		  ,c.[Client_id]
		  ,c.[Client]
		  ,ds.[Distributor_id]
		  ,ds.[Distributor]
		  ,p.[Product_id]
		  ,p.[Product]
		  ,p.[Brand]
		  ,r.[SalesType]
		  ,r.[QTY]
	from [task].[dbo].[RES] r
	left join [task].[dbo].[Dates] d
		on r.[FDate] = d.[Datekey]
	left join [task].[dbo].[Clients] c
		on r.[id_Client] = c.[Client_id]
	left join [task].[dbo].[Distributors] ds
		on r.[id_Distributor] = ds.[Distributor_id]
	left join [task].[dbo].[Products] p
		on r.[id_Product] = p.[Product_id]


-- Ќа основании запроса из пункта 2 необходимо вычислить количество уникальных id_Client, у каждого из них  сумма QTY более 100 и количество различных препаратов (id_Product) более двух
	select count(distinct r.[id_Client]) as [clinety qty]
	from [task].[dbo].[RES] r
	left join [task].[dbo].[Dates] d
		on r.[FDate] = d.[Datekey]
	left join [task].[dbo].[Clients] c
		on r.[id_Client] = c.[Client_id]
	left join [task].[dbo].[Distributors] ds
		on r.[id_Distributor] = ds.[Distributor_id]
	left join [task].[dbo].[Products] p
		on r.[id_Product] = p.[Product_id]
	group by r.[id_Client]
	having sum(r.[QTY]) > 100
		and count(distinct r.[id_Product]) > 2


--Ќа основании запроса из пункта 2 вывести рейтинг топ 5 поставщиков (Distributor) по сумме QTY дл€ каждого года.
--¬ расчете должны участвовать только клиенты (id_Client) с суммарными продажами Brand 4 и Brand 5  более 50 упаковок (дл€ каждого года отдельно).
	drop table if exists #dt;
	with client_cte as 
(
	select c.[Client_id]
		  ,d.[year]
		  ,r.Brand
		  ,sum(QTY) as qty 
	from [task].[dbo].[RES] r
	join [task].[dbo].[Dates] d
		on r.[FDate] = d.[Datekey]
	join [task].[dbo].[Clients] c
		on r.[id_Client] = c.[Client_id]
	where r.Brand in ('Brand 4','Brand 5')
	and d.[year] = 2022
	group by c.[Client_id]
			,d.[year]
			,r.Brand
	having sum(QTY) > 50
)
	select ds.[Distributor]
		  ,d.[year]
		  ,sum(r.[QTY]) as [qty]
	into #dt
	from [task].[dbo].[RES] r
	left join [task].[dbo].[Dates] d
		on r.[FDate] = d.[Datekey]
	left join [task].[dbo].[Clients] c
		on r.[id_Client] = c.[Client_id]	
	left join [task].[dbo].[Distributors] ds
		on r.[id_Distributor] = ds.[Distributor_id]
	left join [task].[dbo].[Products] p
		on r.[id_Product] = p.[Product_id]
	join client_cte cc
		on cc.[Client_id] = c.[Client_id]
		and cc.[year] = d.[year]
		and cc.[Brand] = p.[Brand]
	where ds.[Distributor] is not null
	group by ds.[Distributor]
		    ,d.[year]


	select [year]
		  ,[Distributor]
		  ,[place]
		  ,[qty]
	from (
	select [Distributor]
		  ,[year]
		  ,[qty]
		  ,row_number() over(partition by [year] order by [qty] desc) as [place]
	from  #dt
	) t
	where [place] between 1 and 5
	order by [year],[place]

