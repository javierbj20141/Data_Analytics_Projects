--2.Muestra los nombres de todas las películas con una clasificación por edades de "R"
SELECT "title" AS Titulo, "rating" AS Clasificacion_edades 
FROM "film" fc
WHERE rating = 'R';

--3.Encuentra los nombres de los actores que tengan un "actor_id" entre 30 y 40
select actor_id , CONCAT(first_name, ' ' , last_name) as Nombre
from actor a 
order by actor_id 
limit 11
offset 29;

--4.Obtén las películas cuyo idioma coincide con el idioma original.
select title 
from film f 
where language_id = original_language_id; 

--5.Ordena las películas por duración de forma ascendente
select title as Titulo, length as Duracion
from film f 
order by length;

--6.Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su appelido.
select concat(first_name, ' ' ,last_name) as Nombre
from actor a
where last_name = 'ALLEN';

--7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento. 
select rating as Clasificacion, count(distinct title) as Recuento_Peliculas 
from film f 
group by rating; 

--8.Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film.
select title as Titulo 
from film f 
where rating = 'PG-13' or length > 180;

--9.Encuentra la variabilidad de lo que costaría reemplazar las películas.
select ROUND (variance(replacement_cost),2) 
from film f;

--10.Encuentra la mayor y menor duración de una película de nuestra BBDD.
select max(length) as Duracion_Maxima, min(length) as Duracion_Minima 
from film f;

--11.Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
select p."rental_id", p."amount", r."rental_date"
from rental r 
inner join payment p on p."rental_id" = r."rental_id"
order by r."rental_date" desc 
offset 2
limit 1;

--12.Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC-17’ ni ‘G’ en cuanto a su clasificación.
select title as Titulo 
from film f 
where rating not in ('NC-17', 'G');

--13.Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
select rating as Clasificacion, ROUND (avg(length),2) as Promedio_duracion
from film f 
group by rating;

--14.Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
select title as Titulo 
from film f 
where length > 180;

--15.¿Cuánto dinero ha generado en total la empresa?.
select ROUND (SUM (amount),2)
from payment p;

--16.Muestra los 10 clientes con mayor valor de id.
select customer_id as Identificador
from CUSTOMER c
order by customer_id desc
limit 10;

--17.Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.
with "Tabla1" as (
select concat(a."first_name", ' ' ,a."last_name") as Nombre, f."title" as Titulo 
from film f
inner join film_actor fa on f."film_id" = fa."film_id"
inner join actor a on fa."actor_id" = a."actor_id")
select Nombre
from "Tabla1"
where Titulo = 'EGG IGBY';

--18.Selecciona todos los nombres de las películas únicos.
select distinct title as Titulo
from film f;

--19.Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”.
create temporary table "Peliculas_Categoria_Comedia" as
select f2."title" as Titulo, c."name" as Categoria, f2."length"
from category c 
left join film_category f on c."category_id" = f."category_id" 
left join film f2 on f."film_id" = f2."film_id"
where c."name" = 'Comedy'
select Titulo
from "Peliculas_Categoria_Comedia"
where "length" > 180;

--20.Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.
select c."name" as Categoria, avg(f2."length") as Duracion 
from category c 
left join film_category f on c."category_id" = f."category_id" 
left join film f2 on f."film_id" = f2."film_id"
group by c."category_id"
having avg(f2."length") > 110;

--21.¿Cuál es la media de duración del alquiler de las películas? (Dos opciones).
select round(avg(rental_duration),2) as Tiempo_Promedio 
from film f;

select AVG (return_date - rental_date) as Tiempo_Promedio
from rental r;

--22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
select CONCAT (first_name, ' ' , last_name) as Nombre_completo
from actor a;

--23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente. 2 opciones
select cast (rental_date as DATE) as dia_alquiler, count (rental_id) as cantidad_alquiler
from rental r 
group by rental_date 
order by Cantidad_alquiler desc;

select to_char (rental_date,'YYYY-MM-DD') as dia_alquiler, count (rental_id) as cantidad_alquiler
from rental r 
group by rental_date 
order by Cantidad_alquiler desc;

--24.Encuentra las películas con una duración superior al promedio.
select title as Titulo 
from film f 
where length > (select avg (length)
				from film f2);

--25.Averigua el número de alquileres registrados por mes.
select to_char("rental_date",'Month') as Mes, count(rental_id) 
from rental r 
group by Mes;

--26.Encuentra el promedio, la desviación estándar y varianza del total pagado.
select avg (amount), stddev(amount), variance(amount) 
from payment p; 

--27.¿Qué películas se alquilan por encima del precio medio?
select title				 
from film f 
inner join inventory i on i.film_id = f.film_id 
inner join rental r on r.inventory_id = i.inventory_id 
inner join payment p on p.rental_id = r.rental_id 
where p.amount > (select avg(amount)
						from payment p);
--28.Muestra el id de los actores que hayan participado en más de 40 películas.
select actor_id 
from film_actor fa 
group by actor_id 
having count(film_id) > 40;

--29. Obtener todas las películas y, si están disponibles en el inventario,mostrar la cantidad disponible.
select f."title" as titulo, count(i."store_id") as cantidad_inventario 
from film f 
left join inventory i on i."film_id" = f."film_id"
Group by f."film_id";

--30. Obtener los actores y el número de películas en las que ha actuado.
select CONCAT (a."first_name", ' ' , a."last_name") as nombre, count(fa."film_id") as cantidad_peliculas 
from actor a 
full join film_actor fa on fa.actor_id = a.actor_id 
group by nombre;

--31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
select title as titulo, count (fa."actor_id") as Cantidad_actores 
from film f 
left join film_actor fa on f."film_id" = fa.film_id
group by titulo;

--32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
select  count(fa."film_id") as cantidad_peliculas, concat(first_name, ' ' ,last_name) as nombre
from film_actor fa 
right join actor a on a."actor_id" = fa."actor_id" 
group by a."actor_id";

--33.Obtener todas las películas que tenemos y todos los registros de alquiler
select f."title", r. "rental_id" 
from film f 
full join inventory i on i."film_id" = f."film_id"
full join rental r on r."inventory_id" = i."inventory_id";

--34.Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
select customer_id as cliente , sum (amount) as total_gastado
from payment p 
group by customer_id
order by total_gastado desc 
limit 5;

--35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
select CONCAT (first_name, ' ' , last_name)
from actor a
where first_name in ('JOHNNY');

--36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido. 
select first_name  as nombre, last_name as apellido
from actor a; 

--37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
select min(actor_id) as ID_minimo, max(actor_id) as ID_maximo 
from actor a;

--38. Cuenta cuántos actores hay en la tabla “actor”.
select Count (actor_id) as cantidad_actores
from actor a; 

--39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
select first_name as nombre, last_name as apellido
from actor a 
order by apellido;

--40. Selecciona las primeras 5 películas de la tabla “film”.
select title 
from film f 
limit 5;

--41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
select first_name as nombre, Count (first_name) as cuenta_nombre
from actor a 
group by nombre
order by cuenta_nombre desc;
--Keneth, Penelope y Julia es el nombre más repetido

select Concat (first_name, ' ' , last_name) as nombre_completo, Count (Concat (first_name, ' ' , last_name)) as cuenta_nombre_completo
from actor a 
group by nombre_completo 
order by cuenta_nombre_completo desc;
--Susan Davis es el nombre competo más repetido

--42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
select r."rental_id", CONCAT (c."first_name", ' ' , c."last_name") as nombre_cliente
from customer c 
inner join rental r on c."customer_id" = r."customer_id"; 

--43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
select CONCAT (c."first_name", ' ' , c."last_name") as nombre_cliente , COUNT (r.rental_id) as cantidad_alquileres
from customer c 
Left join rental r on c."customer_id" = r."customer_id"
group by nombre_cliente;

--44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.
 select *
 from film f 
 cross join category c;
--Explicación: No aporta ningún valor en relación al dato ya que no hay ninguna condición que relacione las tablas.
--Como mucho, muestra todas las combinaciones entre las dos tablas, pero sin poderse sacar ninguna conclusión.

--45. Encuentra los actores que han participado en películas de la categoría 'Action'.
with "tabla_nombres" as (
select CONCAT (a.first_name, ' ' , a.last_name) as nombre, fc.category_id
from actor a
inner join film_actor fa on a.actor_id = fa.actor_id
inner join film f on f.film_id = fa.film_id
inner join film_category fc on f.film_id = fc.film_id),
"tabla_categoria" as (
select name as categoria, category_id 
from category c) 
select "tabla_nombres".nombre
from "tabla_nombres"
inner join "tabla_categoria" on "tabla_nombres".category_id = "tabla_categoria".category_id
where "tabla_categoria".categoria = 'Action';

--46.Encuentra todos los actores que no han participado en películas.
select CONCAT (a.first_name, ' ' , a.last_name) as nombre
from actor a 
where not exists ( select 1
					from film f 
					inner join film_actor fa on fa.film_id = f.film_id
					where f.film_id = fa.film_id); 
				
--47.Selecciona el nombre de los actores y la cantidad de películas en las que han participado. 

create temporary table "tabla_actores" as  
select CONCAT (a.first_name, ' ' , a.last_name) as nombre, count(f.film_id) as cuenta 
from actor a 
inner join film_actor fa  on a.actor_id = fa.actor_id 
inner join film f on f.film_id = fa.film_id
group by nombre
select *
from "tabla_actores";

--48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.
create view "actor_num_peliculas" as (select CONCAT (a.first_name, ' ' , a.last_name) as nombre, count(f.film_id) as cuenta 
										from actor a 
										inner join film_actor fa  on a.actor_id = fa.actor_id 
										inner join film f on f.film_id = fa.film_id
										group by nombre);
									
--49. Calcula el número total de alquileres realizados por cada cliente.
select nombre,cuenta
from ( select Concat (c.first_name, ' ' ,c.last_name) as nombre, Count (r.rental_id) as cuenta
from customer c 
inner join rental r on r.customer_id = c.customer_id 
group by nombre); 

--50. Calcula la duración total de las películas en la categoría 'Action'.
with "duracion_action"as (
select c."name" as nombre, sum (f.length) as duracion 
from film f 
inner join film_category fc on fc.film_id = f.film_id 
inner join category c on c.category_id = fc.category_id
group by nombre)
select duracion 
from "duracion_action"
where nombre = 'Action';

--51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.
create temporary table "cliente_rentas_temporal" as 
select Concat (c.first_name, ' ' ,c.last_name) as nombre, Count (r.rental_id) as cuenta
from customer c 
inner join rental r on r.customer_id = c.customer_id 
group by nombre; 

--52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.
create temporary table "peliculas_alquiladas" as
select f.title as titulo , count (r.rental_id) as alquileres
from film f 
inner join inventory i on i.film_id = f.film_id 
inner join rental r on r.inventory_id = i.inventory_id
group by f.film_id 
having count (r.rental_id) >=10;

--53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena
--los resultados alfabéticamente por título de película.
with "tabla1" as (
select f.film_id as id_pelicula , f.title as titulo, r.rental_id as id_alquiler , Concat (c.first_name, ' ' ,c.last_name) as nombre, r.return_date as fecha_devolucion  
from film f 
inner join inventory i on i.film_id = f.film_id 
inner join rental r on r.inventory_id = i.inventory_id
inner join customer c on r.customer_id = c.customer_id) 
select titulo
from "tabla1"
where nombre = 'TAMMY SANDERS' and fecha_devolucion is null 
order by titulo;

--54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados
--alfabéticamente por apellido.
select distinct first_name as nombre, last_name as apellido
from actor a 
inner join film_actor fa on fa.actor_id = a.actor_id 
inner join film f on fa.film_id = f.film_id 
inner join film_category fc on fc.film_id = f.film_id 
where exists (select 1
				from category c
				where c.category_id = fc.category_id and c.name = 'Sci-Fi')
order by apellido;
--55. Encuentra el nombre y apellido de los actores que han actuado en
--películas que se alquilaron después de que la película ‘Spartacus
--Cheaper’ se alquilara por primera vez. Ordena los resultados
--alfabéticamente por apellido.
with "tabla5" as (
select a.first_name as nombre, a.last_name as apellido, f.title as titulo, r.rental_date as fecha
from actor a 
inner join film_actor fa on fa.actor_id = a.actor_id 
inner join film f on f.film_id = fa.film_id 
inner join inventory i on i.film_id =f.film_id
inner join rental r on i.inventory_id = r.inventory_id)
select nombre,apellido
from "tabla5"
where fecha > '2005-07-08 06:43:42.000'
order by apellido;

--Segunda manera con subconsulta en where:

with "tabla5" as (
select a.first_name as nombre, a.last_name as apellido, f.title as titulo, r.rental_date as fecha
from actor a 
inner join film_actor fa on fa.actor_id = a.actor_id 
inner join film f on f.film_id = fa.film_id 
inner join inventory i on i.film_id =f.film_id
inner join rental r on i.inventory_id = r.inventory_id)
select nombre, apellido
from "tabla5"
where fecha > (select min(fecha)
				from "tabla5"
				where titulo = 'SPARTACUS CHEAPER')
order by apellido;

--56.Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.
select distinct first_name as nombre, last_name as apellido 
from actor a 
inner join film_actor fa on fa.actor_id = a.actor_id 
inner join film f on fa.film_id = f.film_id 
inner join film_category fc on fc.film_id = f.film_id 
where not exists (select 1
				from category c
				where c.category_id = fc.category_id and c.name = 'Music');

--57.Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
select title 
from film f 
inner join inventory i on f.film_id = i.film_id 
inner join rental r on i.inventory_id = r.inventory_id 
where (r.return_date - r.rental_date) > '8 days';

--58.Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.
 select titulo
 from (select f.title as titulo, c.name as categoria
 from film f 
 inner join film_category fc on fc.film_id = f.film_id 
 inner join category c on c.category_id = fc.category_id 
 where c.name = 'Animation');

--59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. Ordena los resultados
--alfabéticamente por título de película.
select title as titulo  
from film f 
where length = (select length 
				from film f2 
				where title = 'DANCING FEVER')
and title not in ('DANCING FEVER')
order by title;

--60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
select first_name as nombre, last_name as apellido
from customer c 
inner join rental r ON r.customer_id = c.customer_id 
inner join inventory i on i.inventory_id = r.inventory_id 
inner join film f on f.film_id = i.film_id
group by c.customer_id 
having Count (distinct f.film_id) >= 7
order by apellido;

--61.Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
select c."name" as categoria, count (r.rental_id) as cantidad_peliculas
from category c
inner join film_category fc on c.category_id = fc.category_id 
inner join film f on f.film_id = fc.film_id 
inner join inventory i on f.film_id = i.film_id 
inner join rental r on i.inventory_id = r.inventory_id 
group by categoria;

--62. Encuentra el número de películas por categoría estrenadas en 2006.
select c."name" as categoria, count (f.film_id) as cantidad_peliculas
from category c
inner join film_category fc on c.category_id = fc.category_id 
inner join film f on f.film_id = fc.film_id 
where f.release_year = 2006
group by categoria;

--63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
select *
from staff s 
cross join store s2;

--64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de
--películas alquiladas.
select c.customer_id as id , CONCAT (c.first_name, ' ' , c.last_name) as nombre, count (r.rental_id) as peliculas_alquiladas
from customer c 
left join rental r on c.customer_id = r.customer_id 
group by id, nombre;


 












		



 









 
 
					






			





 



 



