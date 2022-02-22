Use BluePrint

-- 2)
-- Por cada cliente listar razón social, cuit y nombre de la ciudad y nombre del país. Sólo de aquellos
-- clientes que posean ciudad y país.
--select CL.razonsocial, CL.cuit, C.nombre as Ciudad, P.nombre as Pais
--From Clientes as CL
--Inner Join Ciudades as C ON C.ID = CL.IDCiudad
--Inner Join Paises as P ON P.ID = C.IDPais

-- 3)
-- Por cada cliente listar razón social, cuit y nombre de la ciudad y nombre del país. 
-- Listar también los datos de aquellos clientes que no tengan ciudad relacionada.
--select CL.razonsocial, CL.cuit, C.nombre as Ciudad, P.nombre as Pais
--From Clientes as CL
--Left Join Ciudades as C ON C.ID = CL.IDCiudad
--Left Join Paises as P ON P.ID = C.IDPais

--4)Por cada cliente listar razón social, cuit y nombre de la ciudad y nombre del país. 
--Listar también los datos de aquellas ciudades y países que no tengan clientes relacionados.
--SELECT CL.RazonSocial, CL.cuit, C.Nombre as Ciudad, P.Nombre as Pais
--from Clientes as CL
--right join Ciudades as C on C.ID = CL.IDCiudad
--right join Paises as P on P.ID = C.IDPais
--GO

--5)Listar los nombres de las ciudades que no tengan clientes asociados. 
--Listar también el nombre del país al que pertenece la ciudad.
--SELECT C.Nombre as Ciudad, P.Nombre as Pais
--from Clientes as CL
--right join Ciudades as C on C.ID = CL.IDCiudad
--right join Paises as P on P.ID = C.IDPais
--WHERE CL.ID IS NULL
--GO 


--Listar para cada proyecto el nombre del proyecto, el costo, la razón social del cliente, 
--el nombre del tipo de cliente y el nombre de la ciudad (si la tiene registrada) 
--de aquellos clientes cuyo tipo de cliente sea 'Extranjero' o 'Unicornio'.

--SELECT Pr.Nombre as Proyecto, Pr.CostoEstimado as CostoEstimado, 
--CL.razonsocial as Razonsocial, T.Nombre as TipoCliente, C.Nombre as Ciudad
--From Proyectos as Pr
--inner join Clientes as CL on Pr.IDCliente = CL.ID
--inner join TiposCliente as T on CL.IDTipo = T.ID
--inner join Ciudades as C on C.ID = CL.IDCiudad
--WHERE T.Nombre IN ('Extranjero','Unicornio')
--GO

/*
7
Listar los nombres de los proyectos de aquellos clientes que sean 
de los países 'Argentina' o 'Italia'.

SELECT P.Nombre as Proyecto
FROM Proyectos as P
inner join Clientes as CL on P.IDCliente = CL.ID
inner join Ciudades as C on CL.IDCiudad = C.ID
inner join Paises as Pa on C.IDPais = Pa.ID
WHERE Pa.Nombre in ('Argentina','Italia')
*/

--2.4)
--1)Listar los nombres de proyecto y costo estimado de aquellos proyectos cuyo costo estimado sea mayor al promedio de costos.
/*Select P.Nombre, P.CostoEstimado from Proyectos as P
where P.CostoEstimado >(Select avg(CostoEstimado) from Proyectos) */

/*Select avg(CostoEstimado) as PromCostos,
	(
	Select P.Nombre, P.CostoEstimado from Proyectos as P
	where P.CostoEstimado > PromCostos
	)
from Proyectos*/


/*--2)Listar razón social, cuit y contacto (email, celular o teléfono) de aquellos clientes
--que no tengan proyectos que comiencen en el año 2020.
Select distinct C.RazonSocial, C.CUIT, case
--when email is null and celular is null and telefono is null then 'Incontactable'
when C.Email is not null then C.EMail
when C.Celular is not null then C.Celular
when C.Telefono is not null then C.Telefono
else 'Incontactable'
end as 'Contacto'
from Clientes as C
	inner join Proyectos as P on P.IDCliente = C.ID
where P.FechaInicio <> '2020'*/


/*--3)listado de paises que no tengan clientes relacionados.
select * from paises where id not in(
	select distinct p.id from paises p
	inner join ciudades c on p.id = c.IDPais
	inner join clientes cl on c.ID = cl.IDCiudad
)*/

/*--4)Listado de proyectos que no tengan tareas registradas. 
Select * from Proyectos where id not in(
	Select distinct P.ID from Proyectos P
	INNER join Modulos as M on M.IDProyecto = P.ID
	INNER join Tareas as T on T.IDModulo = M.ID
	)
*/
/*--5)Listado de tipos de tareas que no registren tareas pendientes.

Select * from TiposTarea as TT where TT.ID not in
	(Select count(*) as Cant from Tareas as T
	where T.FechaFin is null
	group by T.IDTipo
	)*/

	
/*6)Listado con ID, nombre y costo estimado de proyectos 
	cuyo costo estimado sea menor al costo estimado de cualquier proyecto de clientes extranjeros 
	(clientes que no sean de Argentina o no tengan asociado un país).*/

/*Select P.ID, P.Nombre, P.CostoEstimado From Proyectos as P 
where P.CostoEstimado < 
	(Select min(P.CostoEstimado) from Proyectos as P	
	inner join Clientes as C on C.ID = P.IDCliente
	left join Ciudades as C2 on C2.ID = C.IDCiudad
	left join Paises as P2 on P2.ID = C2.IDPais
	where P2.ID = 1 or C.IDCiudad is null)

Select * from Proyectos where CostoEstimado <(
	Select /*distinct (para evitar repetidos)*/ Min(pr.CostoEstimado) from Proyectos as pr
inner join Clientes as cl on cl.ID = pr.IDCliente
left join Ciudades as c on c.ID = cl.IDCiudad
left join Paises as p on p.ID = c.IDPais
where p.Nombre = 'Argentina' or cl.IDCiudad is null
)*/

--1) Por cada colaborador listar el apellido y nombre y la cantidad de proyectos distintos en los que haya trabajado.

/*Select C.Apellido as Nombre, C.Nombre as Apellido,
	(Select count(CL.IDColaborador) from Proyectos as P
	inner join Modulos as M on P.ID = M.IDProyecto
	inner join Tareas as T on M.ID = T.IDModulo
	inner join Colaboraciones as CL on CL.IDTarea = T.IDModulo 
	where C.ID = CL.IDColaborador 
	group by CL.IDColaborador
	) as Cantidad
	from Colaboradores as C*/

	
/*--2) Por cada cliente, listar la razón social y el costo estimado del módulo más costoso que haya solicitado.

Select C.RazonSocial, 
	(Select Max(M.CostoEstimado) from Modulos as M
	left join Proyectos as P on P.ID = M.IDProyecto
	where C.ID = P.IDCliente
	) as CostoEstimado
	from Clientes as C*/

	
--3) Los nombres de los tipos de tareas que hayan registrado más de diez colaboradores distintos en el año 2020. 

Select TT.Nombre from TiposTarea as TT 
inner join Tareas as T on T.IDTipo = TT.ID
	where (Select count(CC.ID) from Colaboradores as CC 
	inner join Colaboraciones as C on C.IDColaborador = CC.ID
	inner join Tareas as T on T.ID = C.IDTarea 
	where T.IDTipo = TT.ID
	) > 10 and T.FechaInicio = '2020' 
	
