-- Consulta do gráfico "Crimes over Time" conforme o material da lição.
SELECT crime_type, COUNT(crime_type)
FROM crimes
GROUP BY crime_type;
