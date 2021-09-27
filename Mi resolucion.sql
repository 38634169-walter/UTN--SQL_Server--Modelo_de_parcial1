USE parcial1
GO

--1 
--1era forma de resolucion
SELECT c.Apellido, c.Nombre
FROM Clientes AS c
INNER JOIN Servicios AS s ON s.IDCliente=c.ID
WHERE YEAR(s.Fecha)=2020
GROUP BY c.Apellido, c.Nombre
HAVING SUM(s.Importe)>60000;

--2da forma de resolucion
SELECT Tablita.Apellido,Tablita.Nombre FROM (
	SELECT c.Apellido, c.Nombre,SUM(s.Importe) AS [Total gastado] 
	FROM Clientes AS c
	INNER JOIN Servicios AS s ON s.IDCliente=c.ID
	WHERE YEAR(s.Fecha)=2020
	GROUP BY c.Apellido, c.Nombre
) AS Tablita
WHERE Tablita.[Total gastado] >60000


--2
SELECT DISTINCT t.ID,t.Apellido,t.Nombre
FROM Tecnicos AS t
INNER JOIN Servicios AS s on s.IDTecnico=t.ID
WHERE s.Importe < 2600 AND s.Duracion > (
	SELECT AVG(s2.Duracion) FROM Servicios AS s2
);

--3
SELECT t.Apellido, t.Nombre,
(
	SELECT ISNULL(SUM(s.Importe),0.0) FROM Servicios AS s
	WHERE s.FormaPago = 'E' AND s.IDTecnico=T.ID
) AS [Total recaudado en efectivo],
(
	SELECT ISNULL(SUM(s.Importe),0.0) FROM Servicios AS s
	WHERE s.FormaPago='T' AND s.IDTecnico=t.ID
) AS [Total recaudado con tarjeta]
FROM Tecnicos AS t;


--4
SELECT COUNT(*) AS [Servicio con mayor Particulares que empresas] 
FROM (
	SELECT
	(
		SELECT COUNT(DISTINCT s.IDCliente) FROM Clientes AS c
		INNER JOIN Servicios AS s ON s.IDCliente=c.ID
		WHERE c.Tipo = 'P' AND s.IDTipo=ts.ID
	) AS ClientesParticulares,
	(
		SELECT COUNT(DISTINCT s.IDCliente) FROM Clientes AS c
		INNER JOIN Servicios AS s ON s.IDCliente=c.ID
		WHERE c.Tipo = 'E' AND S.IDTipo=ts.ID
	) AS ClientesEmpresas
	FROM TiposServicio AS ts
) AS Tablita
WHERE Tablita.ClientesParticulares>Tablita.ClientesEmpresas;


--5
CREATE TABLE Calificaciones(
IDServicios INT NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Servicios(ID),
puntuacion SMALLINT NOT NULL CHECK(puntuacion BETWEEN 1 AND 10),
observacion VARCHAR(200) NOT NULL
)

