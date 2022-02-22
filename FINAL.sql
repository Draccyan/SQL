Create Database Examen
go
Use Examen
go
Create Table Camiones(
    ID varchar(4) not null primary key,
    AñoPatentamiento smallint not null,
    PesoLimite int not null check (PesoLimite > 0 ),
    AptoAlimentos bit not null
)
go
Create Table Choferes(
    ID int not null primary key identity (1, 1),
    Apellidos varchar(50) not null,
    Nombres varchar(50) not null
)
go
Create Table Viajes(
    ID bigint not null primary key identity (1, 1),
    Fecha date not null,
    IDChofer int not null foreign key references Choferes(ID),
    IDCamion varchar(4) not null foreign key references Camiones(ID),
    Kilometros int not null
)
go
Create Table Paquetes(
    ID bigint not null primary key identity (1, 1),
    IDViaje bigint not null foreign key references Viajes(ID),
    Peso int not null,
    Alimento bit not null
)
go
INSERT INTO Camiones (ID, AñoPatentamiento, PesoLimite, AptoAlimentos)
VALUES(1111, 2020,	300,	1), 
(2222	,2015,	1500,	0), 
(3333	,2010,	900,	1),
(4444	,2000,	800,	0),
(5555	,2004,	750,	0),
(6666	,2009,	100,	1),
(7777	,2021,	400,	1),
(8888	,2018,	500,	0),
(9999	,2019,	950,	0)

INSERT INTO Choferes( Apellidos,Nombres)
VALUES('Kloster', 'Daniel'),
('Lara', 'Brian'),
('Simon',	'Angel'),
('Fernandez',	'Gladys')


SET DATEFORMAT 'DMY'
INSERT INTO Viajes(Fecha,IDChofer,IDCamion,Kilometros)
VALUES('10/07/2021',1,1111,500),
('09/07/2021',2,2222,600),
('08/07/2021',3,1111,50),
('04/07/2021',4,3333,140),
('24/7/21',1,4444,150),
('10/07/2021',2,5555,900),
('09/07/2021',3,5555,400),
('08/07/2021',4,6666,300),
('04/07/2021',1,7777,600),
('24/7/21',2,8888,800),
('10/07/2021',3,7777,500),
('09/07/2021',4,7777,700),
('08/07/2021',1,3333,50),
('04/07/2021',2,5555,150),
('05/08/2021',3,6666,300)

INSERT INTO Paquetes(IDViaje,Peso,Alimento)
VALUES(1,10,1),
(1,50,1),
(1,100,1),
(1,50,1),
(2,80,1),
(2,50,1),
(2,60,1),
(2,100,1),
(3,100,1),
(3,100,0),
(3,50,0),
(4,250,0),
(4,250,0),
(4,350,1),
(5,500,0)

--1) Hacer un trigger que no permita que un camión realice un viaje de más de 500
--kilómetros si la antigüedad del mismo es mayor a 5 años. Mostrar un mensaje de
--error aclaratorio, sino insertar el registro. La antigüedad se calcula a partir del año de
--patentamiento.Create Trigger TR_VerificarKMyCincoAños ON Viajes
instead of insert
as
begin
    Declare @Kilometros int
	Declare @Fecha date
	Declare @IDChofer int   
	Declare @IDCamion varchar
    Declare @AñoPatentamiento smallint

    Select @IDCamion = @IDCamion from inserted
    Select @Fecha = Fecha from inserted
    Select @AñoPatentamiento = c.AñoPatentamiento from Camiones c where c.ID = @IDCamion
	select @IDChofer = IDChofer from inserted

	Select @Kilometros =  Kilometros from inserted

    if(@Kilometros >=500 and @AñoPatentamiento > 5)
    begin 
        Raiserror('El camion tiene mas de 5 años',16,1)
    end
	else 
	begin 
		INSERT INTO Viajes(Fecha,IDChofer,IDCamion,Kilometros)
		VALUES(@Fecha,@IDChofer,@IDCamion,@Kilometros)
	end
end--Hacer un trigger que no permita que un camión ni un chofer realicen más de un viaje
--el mismo día. Mostrar un mensaje de error aclaratorio para cada situación, sino
--insertar el registro.Create Trigger TR_VerificarViajesEnFecha ON Viajes
instead of insert
as
begin
    Declare @Kilometros int
	Declare @Fecha date
	Declare @IDChofer int   
	Declare @IDCamion varchar
    Declare @ViajesEnFechaChofer smallint
	Declare @ViajesEnFechaCamion smallint

    Select @IDCamion = @IDCamion from inserted
    Select @Fecha = Fecha from inserted
	select @IDChofer = IDChofer from inserted
	Select @Kilometros =  Kilometros from inserted

	Select @ViajesEnFechaChofer = isnull(count(ID),0) from Viajes where Fecha = @Fecha and (IDChofer= @IDChofer)
	Select @ViajesEnFechaCamion = isnull(count(ID),0) from Viajes where Fecha = @Fecha and (IDCamion = @IDCamion)

    if(@ViajesEnFechaChofer = 1)
    begin 
        Raiserror('El chofer ya realizo un viaje en la fecha',16,1)
    end
	else if (@ViajesEnFechaCamion = 1)
    begin 
        Raiserror('El camion ya realizo un viaje en la fecha',16,1)
    end
	else
	begin 
		INSERT INTO Viajes(Fecha,IDChofer,IDCamion,Kilometros)
		VALUES(@Fecha,@IDChofer,@IDCamion,@Kilometros)
	end
end


--3) Hacer un trigger que al ingresar un paquete no permita que el peso del mismo supere
--la capacidad máxima que puede llevar el camión en ese viaje (teniendo en cuenta
--todos los paquetes del viaje). Tampoco puede cargarse el paquete si es un alimento
--y el camión no es apto para transporte de alimentos. Mostrar un mensaje de error
--aclaratorio por cada situación, sino insertar el registro.	
Create Trigger TR_VerificarCapacidad ON Paquetes
instead of insert 
as 
begin
	Declare @ID bigint
	Declare @IDViaje bigint
	Declare @Peso int
	Declare @Alimento bit
	Declare @CapacidadMaxima int
	Declare @CapacidadActual int
	Declare @AptoAlimento bit

	Select @ID = ID from inserted
	Select @IDViaje = IDViaje from inserted
	Select @Peso = Peso from inserted
	Select @Alimento = Alimento from inserted

    Select @CapacidadMaxima = c.PesoLimite from Camiones c
    inner join Viajes v on v.IDCamion = c.ID 
    where v.ID = @IDViaje

    Select @CapacidadActual = sum(p.Peso) from Paquetes p 
    inner join Viajes v on p.IDViaje = v.ID
    where v.ID = @IDViaje

    Select @AptoAlimento = c.AptoAlimentos from Camiones c
    inner join Viajes v on v.IDCamion = c.ID 
    where v.ID = @IDViaje

	if(@Alimento = 1 and @AptoAlimento = 0)
	begin
		 Raiserror('El camion no es apto para alimentos',16,1)
	end
	else if ((@CapacidadActual + @Peso) > @CapacidadMaxima)
	begin 
		 Raiserror('La capacidad del camion fue superada',16,1)
	end
	else 
	INSERT INTO Paquetes(IDViaje,Peso,Alimento)
	VALUES(@IDViaje,@Peso,@Alimento)
end

--Por cada camión, listar el ID, el año de patentamiento y la cantidad de viajes que
--hayan superado la mitad del peso límite en concepto de peso de paquetes..select c.ID,c.AñoPatentamiento, otraTabla.cantidadViajes from camiones c 
	left join
		(select
			count(c.ID) as cantidadViajes,c.ID as IDCamion
		from camiones c 
		inner join
			(select c.ID as IDCamion,v.ID as IDViaje, sum(p.Peso) as pesoPorViaje from camiones c 
			inner join Viajes v on v.IDCamion = c.ID 
			inner join Paquetes p on p.IDViaje = v.ID 
			group by c.ID,v.ID) as tabla
		on c.ID = tabla.IDCamion
    where tabla.pesoPorViaje>(c.PesoLimite/2) group by c.ID) as otraTabla
    on c.ID = otraTabla.IDCamion