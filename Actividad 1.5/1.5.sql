USE BluePrint
GO
--Una tarea debe registrar un ID único que la identifique y la autonumere.
--Una tarea debe pertenecer a un módulo.
--Una tarea debe registrar un tipo de tarea.
--Una tarea tiene que poder registrar la fecha en que comienza y la fecha en que finaliza.
--Una tarea puede registrarse antes de conocer las fechas de comienzo y fin.
--Una tarea debe registrar un estado. El mismo representará si la tarea se encuentra aceptada o suspendida.
--Una tarea puede ser realizada por muchos colaboradores.

CREATE TABLE Tareas(
	ID bigint primary key identity(1,1) not null,
	Modulo varchar(30) not null,
	TipoTarea varchar(30) not null,
	FechaInicio date null,
	FechaFin date null,
	CONSTRAINT CHK_Fechas check(FechaFin >= FechaInicio),
	Estado bit not null default (1),
)

--Una colaboración consiste en la realización de una tarea por parte de un colaborador.
--Una colaboración debe registrar la cantidad de horas que llevó realizar la tarea.
--Una colaboración debe registrar el valor hora acordado.
--Una colaboración debe registrar el estado. El mismo representará si la colaboración se encuentra aceptada o suspendida. 

CREATE TABLE Colaboraciones(
	IDColaborador bigint primary key not null,
	IDTarea bigint foreign key references Tareas(ID) not null,
	CantHoras time not null,
	ValorHora money not null check(ValorHora > 0),
	Estado bit not null default(1),
)

GO

ALTER TABLE Tareas ADD IDModulo bigint not null
GO

ALTER TABLE Colaboraciones ADD Nombre varchar(50) not null
GO
ALTER TABLE Colaboraciones ADD Apellido varchar(50) not null	
GO

INSERT INTO Tareas(IDModulo, Modulo, TipoTarea, FechaInicio, FechaFin, Estado) VALUES (1, 'Login','Análisis de requerimientos',	'2020-05-23', '2020-08-18',1)
INSERT INTO Tareas(IDModulo, Modulo, TipoTarea, FechaInicio, FechaFin, Estado) VALUES (2, 'Staff','Testing de integración', '2020-06-01', '2020-06-13',1)
INSERT INTO Tareas(IDModulo, Modulo, TipoTarea, FechaInicio, FechaFin, Estado) VALUES (3, 'Estudiantes', 'Programación en C#','2020-05-25','2020-06-25',1)
INSERT INTO Tareas(IDModulo, Modulo, TipoTarea, FechaInicio, FechaFin, Estado) VALUES (4, 'Calificaciones',	'Diseño de experiencia','2020-05-27','2020-06-22',1)
INSERT INTO Tareas(IDModulo, Modulo, TipoTarea, FechaInicio, FechaFin, Estado) VALUES (7, 'Proveedores', 'Diseño de interfaz UI','2018-10-13','2018-11-02',1)
