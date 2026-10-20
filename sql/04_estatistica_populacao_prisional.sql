-- Consulta do gráfico "Prison Population over Time".
SELECT prison, COUNT(prison)
FROM crimes
GROUP BY prison;
