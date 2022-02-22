USE parcial1
GO

--1) Listado con Apellido y nombres de los técnicos que hayan prestado servicios a más
--de veinte clientes distintos.
Select T.Apellido, T.Nombre from Tecnicos as T
where (Select distinct count(S.IDCliente) from Servicios as S 
		inner join Clientes C on C.ID = S.IDCliente
		where T.ID = S.IDTecnico) > 20



/*
Select T.Apellido, T.Nombre
from Tecnicos T
where (Select distinct count(C.ID)
from Clientes C
inner join Servicios as S on S.IDCliente = C.ID
where S.IDTecnico = T.ID) > 20
*/

--2)Listado con ID, Apellido y nombres de los clientes que no hayan solicitado servicios
--de tipo "Reparacion de lavarropas" en el año 2020.

Select  C.ID, C.Apellido, C.Nombre from Clientes as C
inner join Servicios as S on S.IDCliente = C.ID
inner join TiposServicio as TS on TS.ID = S.IDTipo				
where S.IDCliente = C.ID and year(S.Fecha) = '2020' and TS.Descripcion <> 'Reparacion de lavarropas'

--3) Listado con Apellido y nombres de los clientes, cantidad de servicios solicitados con
--garantía y cantidad de servicios solicitados sin garantía.

    Select C.ID, C.Apellido, C.Nombre,
    (
       Select count(S.DiasGarantia) from Servicios S
       Where S.IDCliente = C.ID and S.DiasGarantia = 0
    ) as CantServiciosSinGarantia,
    (
       Select count(S.DiasGarantia) from Servicios S
       Where S.IDCliente = C.ID and S.DiasGarantia != 0
    ) as CantServiciosConGarantia
    from Clientes C

--4)Apellido y nombres de los técnicos que recaudaron más en servicios abonados en
--tarjeta que servicios abonados con efectivo. Pero que hayan recaudado con efectivo
--más de la mitad de su recaudación con tarjeta.

Select * from 
(
    select T.Apellido, T.Nombre, 
    (
       Select SUM(S.Importe) from Servicios S
       Where T.ID = S.IDTecnico and S.FormaPago = 'E'
    ) as CantEfectivo,
    (
       Select SUM(S.Importe) from Servicios S
       Where T.ID = S.IDTecnico and S.FormaPago = 'T'
    ) as CantTarjeta,
    (
       Select SUM(S.Importe) from Servicios S
       Where T.ID = S.IDTecnico and S.FormaPago = 'C'
    ) as CantCheque
    from Tecnicos T
) as Tabla
Where Tabla.CantTarjeta > Tabla.CantEfectivo and Tabla.CantEfectivo > (Tabla.CantTarjeta/2)

--5) Agregar las tablas y/o restricciones que considere necesario para permitir a los
--técnicos registrar todos los insumos que le fueron necesarios para realizar un
--servicio. Por cada insumo necesario se registrará una descripción, un costo y un
--origen del insumo (I - Importado o N - Nacional).

Create TABLE INSUMOS (
ID int not null primary key,
IDServicio int not null foreign key (IDServicio) references Servicios(ID),
Costo money not null check (Costo >= 0),
Descripcion varchar(100) not null,
OrigenInsumo char not null check (OrigenInsumo in ('I', 'N'))
)

create table Servicios(
    ID int not null primary key identity(1, 1),
    IDTecnico int not null,
    IDCliente int not null,
    IDTipo int not null ,
    Importe money not null check (Importe >= 0),
    Duracion int not null check (Duracion >= 0),
    Fecha date not null,
    DiasGarantia int not null check (DiasGarantia >= 0),
    FormaPago char check (FormaPago in ('E', 'C', 'T')),
    foreign key (IDTecnico) references Tecnicos(ID),
    foreign key (IDCliente) references Clientes(ID),
    foreign key (IDTipo) references TiposServicio(ID)
)