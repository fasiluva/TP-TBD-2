/*
5. Considere la base de datos de la empresa inmobiliaria. Dar soluciones en SQL a las siguientes consultas
y mostrar los resultados obtenidos. Para ésto utilizar el archivo inmobiliaria.sql, script de generación
de la base de datos.
a) Obtener los nombres de los dueños de los inmuebles.
b) Obtener todos los códigos de los inmuebles cuyo precio está en el intervalo 600.000 a 700.000
    inclusive.
c) Obtener los nombres de los clientes que prefieran inmuebles sólo en la zona Norte de Santa Fe.
d) Obtener los nombres de los empleados que atiendan a algún cliente que prefiera la zona Centro
    de Rosario.
e) Para cada zona de Rosario, obtener el número de inmuebles en venta y el promedio de su valor.
f) Obtener los nombres de los clientes que prefieran inmuebles en todas las zonas de Santa Fe.
*/

/*
====================================================================================================
a) Obtener los nombres de los dueños de los inmuebles.

SELECT P.`nombre` 
FROM Persona as P
WHERE EXISTS (
    SELECT 1 
    FROM Propietario as PP
    WHERE P.`codigo` = PP.`codigo`
);

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

====================================================================================================
b) Obtener todos los códigos de los inmuebles cuyo precio está en el intervalo 600.000 a 700.000 inclusive.

SELECT I.`codigo`
FROM Inmueble AS I 
WHERE I.`precio` > 600000 AND I.`precio` <= 700000

====================================================================================================
c) Obtener los nombres de los clientes que prefieran inmuebles sólo en la zona Norte de Santa Fe.

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

====================================================================================================
d) Obtener los nombres de los empleados que atiendan a algún cliente que prefiera la zona Centro de Rosario.
 
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

====================================================================================================
e) Para cada zona de Rosario, obtener el número de inmuebles en venta y el promedio de su valor.

SELECT I.`nombre_zona`, COUNT(*), AVG(I.`precio`)
FROM Inmueble as I, Zona as Z
WHERE I.`nombre_poblacion` = Z.`nombre_poblacion` AND 
      I.`nombre_zona` = Z.`nombre_zona` AND 
      I.`nombre_poblacion` = "Rosario" 
GROUP BY I.`nombre_zona` 

====================================================================================================
f) Obtener los nombres de los clientes que prefieran inmuebles en todas las zonas de Santa Fe.

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

*/

