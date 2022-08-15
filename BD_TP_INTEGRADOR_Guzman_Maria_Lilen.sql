create database comercio;
use comercio;

-- creo tabla Carrito_compras--
-- --------------------------- --
create table if not exists Carrito_compras(
	Id_carrito int not null auto_increment primary key,
    Articulo_nombre varchar(50) not null,
    Cantidad int not null,
    Precio double not null,
    Fecha_compra date not null,
    Orden_compra int null
);
-- cargo Carrito_compras
insert into Carrito_compras (Articulo_nombre, Cantidad, Precio, Fecha_compra, Orden_compra)
values ("Televisor UHD",2,195000,"2017-01-02",270),("Tablet",2,75000,"2018-02-20",271),("Notebook",4,100000,"2020-02-21",null),
	   ("Ipad",1,75000,"2022-02-24",273),("Televisor UHD",1,95000,"2022-03-02",275),("Televisor led",1,155000,"2022-04-02",280),
       ("Televisor UHD",2,195000,"2022-07-02",281),("Tablet",2,75000,"2022-07-20",282),("Notebook",4,100000,"2022-07-21",null);

-- creo tabla Historial_compras--
-- --------------------------- --
create table if not exists Historial_compras(
	Id_historial int not null auto_increment,
    Articulo_nombre varchar(50) not null,
    Cantidad int not null,
    Precio double not null,
    Fecha_compra date not null,
    Orden_compra int,
    Id_carritoH int not null,
    constraint pk_IdHistorial primary key (Id_historial),
    constraint fk_IdCarritoH foreign key (Id_carritoH) references Carrito_compras (Id_carrito)
);
-- cargo Historial_compras
insert into Historial_compras(Articulo_nombre, Cantidad, Precio, Fecha_compra, Orden_compra, Id_carritoH)
values ("Televisor UHD",2,195000,"2017-01-02",270,1),("Tablet",2,75000,"2018-02-20",271,2), ("Ipad",1,75000,"2022-02-24",273,4),("Televisor UHD",1,95000,"2022-03-02",275,5),
("Televisor led",1,155000,"2022-04-02",280,6),("Televisor UHD",2,195000,"2022-07-02",281,7),("Tablet",2,75000,"2022-07-20",282,8);

insert into Historial_compras(Articulo_nombre, Cantidad, Precio, Fecha_compra, Orden_compra, Id_carritoH)
values ("Notebook",4,100000,"2020-02-21",null,3);

-- RESOLUCION DE LAS CONSIGNAS
-- 1)
-- creo tabla Cliente--
-- --------------------------- --
create table if not exists Cliente(
	Dni int not null,
    Nro_cliente int unique not null auto_increment,
    Apellido_paterno varchar(50) null,
    Apellido_materno varchar(50) null,
    Nombre varchar(30) not null,
    Calle varchar(70) null,
    Numero int null,
    Barrio varchar(50) null,
    Telefono_cel1 int not null,
    Telefono_cel2 int null,
    Edad int null,
    Email varchar(50) not null,
    Fecha_alta date not null,
    Id_carritoC int not null,
    Id_historialC int not null,
    constraint pk_Dni primary key (Dni),
    constraint fk_IdCarritoC foreign key (Id_carritoC) references Carrito_compras(Id_carrito),
    constraint fk_IdHistorialC foreign key (Id_historialC) references Historial_compras(Id_historial)
); 
-- inserto clientes
insert into Cliente (Dni, Apellido_paterno, Apellido_materno, Nombre, Calle, Numero, Barrio, Telefono_cel1, Telefono_cel2, Edad, Email, Fecha_alta, Id_carritoC, Id_historialC)
values (18180195,"Perez",null,"Jorge",null,null,"Industrial",155322691,null,28,"jorge@gmail.com","2017-01-02",1,1),
(22180195,"Lopez","Gutierrez","Ana",null,null,null,158322633,null,40,"Ana@gmail.com","2020-02-02",4,3),
(12345678,"Guzman",null,"Felipe","Elordi",256,"Parque",155322691,null,33,"FElipe@gmail.com","2020-01-02",5,4);

insert into Cliente (Dni, Apellido_paterno, Apellido_materno, Nombre, Calle, Numero, Barrio, Telefono_cel1, Telefono_cel2, Edad, Email, Fecha_alta, Id_carritoC, Id_historialC)
values (16180195,"Moreno","Diaz","Maria",null,null,null,158772691,null,30,"lorenae@gmail.com","2020-01-25",3,8);

-- 2)Inserte en la tabla correspondiente un nuevo cliente 
-- y asocie al mismo, una compra en el carrito.
insert into Cliente (Dni, Apellido_paterno, Apellido_materno, Nombre, Calle, Numero, Barrio, Telefono_cel1, Telefono_cel2, Edad, Email, Fecha_alta, Id_carritoC, Id_historialC)
values (40180195,"Borges","Zarate","Lorena",null,null,null,157772691,null,56,"lorenae@gmail.com","2020-01-25",7,6);


-- 3)Borre a un cliente que ya no tiene historial de compra. 
-- Para ello consulte antes en el historial, que algún cliente ya no 
-- tenga compras desde hace mucho tiempo.
select h.Fecha_compra,h.Id_historial, c.Dni, c.Nro_cliente, c.Id_historialC, c.Id_carritoC  
from Cliente c  inner join Historial_compras h on c.Id_carritoC = h.Id_carritoH 
where h.Fecha_compra<'2018-01-25';

delete from Cliente where Dni=18180195;

-- 4)Actualice la fecha de alta de algún cliente que usted considere.
update Cliente set Fecha_alta="2021-11-02" where Dni=40180195;

-- 5)Realice una consulta multitabla que arroje el nombre de todos los clientes
--  cuyos compras hayan sido de televisores UHD.
select c.DNI, c.Nro_cliente, c.Apellido_paterno, c.Nombre, h.Articulo_nombre
from Cliente c inner join Historial_compras h on c.Id_carritoC = h.Id_carritoH
where h.Articulo_nombre = 'Televisor UHD' ;

-- 6)Obtener todos los clientes que hicieron compras durante el 2022.
select c.DNI, c.Nro_cliente, c.Apellido_paterno, c.Nombre, h.Fecha_compra 
from Cliente c inner join Historial_compras h on c.Id_carritoC = h.Id_carritoH
where h.Fecha_compra between  '2022-01-01' AND '2022-12-31'; 

-- 7)Obtener los ingresos percibidos en Julio del 2022
select sum(Precio*Cantidad) Suma_Julio
from Historial_compras
where Fecha_compra between '2022-07-01' and '2022-07-31' ;

-- 8)Seleccionar todas las compras que no se finalizaron en el carrito (no
-- obtuvieron orden de compra) para depurarlas e identificar al cliente. De
-- esta forma, se le podría enviar una notificación de carrito abandonado
-- e invitar a retomar su compra.

select ca.Id_carrito, ca.Articulo_nombre, ca.Orden_compra, c.DNI, c.Nro_cliente, c.Apellido_paterno 
from Carrito_compras ca inner join Cliente c on ca.Id_carrito=c.Id_carritoC 
where ca.Orden_compra is null;

-- 9)Escriba una consulta que permita actualizar la dirección de un cliente,
-- (DNI: 12345678). Su nueva dirección es Libertad 123

update Cliente set calle="Libertad", Numero=123  where Dni=12345678;

-- 10)Vaciar la tabla historial y resetear el contador del campo ID.

set foreign_key_checks = 0;
truncate table Historial_compras;
alter table Historial_compras auto_increment = 0;
set foreign_key_checks = 1;

-- 11)Obtener a todos los clientes que tengan compras realizadas en los
-- últimos 2 años y que a su vez, no hayan desistido de la realización de
-- alguna compra en el carrito durante el 2022. Todo esto para realizar
-- una estrategia de marketing.

-- 12)Obtener a todos los clientes cuya edad sea menor a 35 años y
-- alguna vez hayan comprado una “consola de juegos”. Se necesitan
-- estos datos para realizar una campaña de marketing para el
-- lanzamiento de la nueva consola de juegos de la empresa Sony.

select c.DNI, c.Nro_cliente, c.Apellido_paterno, c.Apellido_Materno, c.Nombre, c.Edad, h.Articulo_nombre
from Cliente c inner join Historial_compras h on c.Id_carritoC = h.Id_carritoH
where c.Edad < 35 and h.Articulo_nombre = 'consola de juegos';






