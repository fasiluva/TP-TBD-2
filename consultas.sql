/*
Valentin Sosa, S-5621/9.
Santiago Bussanich, B-6488/2.
Ángelo Alvarez, A-4429/6.
*/

/*
====================================================================================================
!a) Obtener los nombres de los dueños de los inmuebles.

SELECT P.`nombre` 
FROM Persona as P
WHERE EXISTS (
    SELECT 1    
    FROM Propietario as PP
    WHERE P.`codigo` = PP.`codigo` AND EXISTS (
        SELECT 1 
        FROM PoseeInmueble as PI, Inmueble as I 
        WHERE PI.`codigo_propietario` = PP.`codigo` AND 
              PI.`codigo_inmueble` = I.`codigo`     
    )
); 

? Solo devolvemos los dueños que realmente poseen al menos un inmueble disponible para vender, no los 
? que simplemente figuran como dueño y no tienen inmuebles en venta.

+---------+
| nombre  |
+---------+
| Rogelio |
| Juan    |
| Luis    |
| Maria   |
+---------+
4 rows in set (0.003 sec)

====================================================================================================
!b) Obtener todos los códigos de los inmuebles cuyo precio está en el intervalo 600.000 a 700.000 inclusive.

SELECT I.`codigo`
FROM Inmueble AS I 
WHERE I.`precio` > 600000 AND I.`precio` <= 700000

? Asumo que el "inclusive" solo se refiere a la cota superior, no la inferior.

+---------+
| codigo  |
+---------+
| Cas0001 |
| Cas0002 |
| Ros0006 |
| Ros0009 |
| Ros0010 |
| Ros0011 |
| Stf0001 |
| Stf0004 |
+---------+
8 rows in set (0.000 sec)

====================================================================================================
!c) Obtener los nombres de los clientes que prefieran inmuebles sólo en la zona Norte de Santa Fe.

SELECT P.`nombre`
FROM Persona as P 
WHERE EXISTS (
    SELECT 1 
    FROM Cliente AS C 
    WHERE C.`codigo` = P.`codigo` AND NOT EXISTS (
        SELECT 1 
        FROM PrefiereZona as PZ 
        WHERE PZ.`codigo_cliente` = C.`codigo` AND 
              PZ.`nombre_zona` <> "Norte"      AND
              PZ.`nombre_poblacion` = "Santa Fe"
    ) AND EXISTS (
        SELECT 1 
        FROM PrefiereZona as PZ 
        WHERE PZ.`codigo_cliente` = C.`codigo` AND 
              PZ.`nombre_zona` = "Norte"      AND
              PZ.`nombre_poblacion` = "Santa Fe"
    )
);

+---------+
| nombre  |
+---------+
| Facundo |
+---------+
1 row in set (0.001 sec)

====================================================================================================
!d) Obtener los nombres de los empleados que atiendan a algún cliente que prefiera la zona Centro de Rosario.
 
SELECT P.`nombre`
FROM Persona AS P 
WHERE EXISTS (
    SELECT 1 
    FROM Vendedor AS V 
    WHERE V.`codigo` = P.`codigo` AND EXISTS (
        SELECT 1 
        FROM Cliente AS C, PrefiereZona as PZ
        WHERE C.`codigo` = PZ.`codigo_cliente` AND 
              PZ.`nombre_poblacion` = "Rosario" AND 
              PZ.`nombre_zona` = "Centro"
    )
);

+--------+
| nombre |
+--------+
| Juana  |
| Mirta  |
| Laura  |
+--------+
3 rows in set (0.001 sec)

====================================================================================================
!e) Para cada zona de Rosario, obtener el número de inmuebles en venta y el promedio de su valor.

SELECT I.`nombre_zona`, COUNT(*), AVG(I.`precio`)
FROM Inmueble as I, Zona as Z
WHERE I.`nombre_poblacion` = Z.`nombre_poblacion` AND 
      I.`nombre_zona` = Z.`nombre_zona` AND 
      I.`nombre_poblacion` = "Rosario" 
GROUP BY I.`nombre_zona` 

+-------------+----------+-----------------+
| nombre_zona | COUNT(*) | AVG(I.`precio`) |
+-------------+----------+-----------------+
| Centro      |        3 |    1266666.6667 |
| Sur         |        3 |     570000.0000 |
| Norte       |        2 |     825000.0000 |
| Oeste       |        3 |     650000.0000 |
+-------------+----------+-----------------+
4 rows in set (0.005 sec)

====================================================================================================
!f) Obtener los nombres de los clientes que prefieran inmuebles en todas las zonas de Santa Fe.

SELECT P.`nombre`
FROM Persona as P
WHERE (
    SELECT COUNT(*) 
    FROM Zona as Z 
    WHERE Z.`nombre_poblacion` = "Santa Fe"
) = (
    SELECT COUNT(*)
    FROM Cliente as C, PrefiereZona as PZ 
    WHERE C.`codigo` = P.`codigo` AND 
          C.`codigo` = PZ.`codigo_cliente` AND 
          PZ.`nombre_poblacion` = "Santa Fe"
);

? Asumimos que no hay filas repetidas en PrefiereZona. Esto es, la fila ("id_cliente", "Santa Fe", "Centro") solo 
? aparece una vez en la tabla.

+--------+
| nombre |
+--------+
| Emilio |
+--------+
1 row in set (0.005 sec)

*/

