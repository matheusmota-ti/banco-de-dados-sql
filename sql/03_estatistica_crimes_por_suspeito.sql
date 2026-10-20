-- Consulta do gráfico principal: "Crimes by Criminal".
SELECT suspects.first_name || ' ' || suspects.last_name AS "Suspect",
       crime_type,
       COUNT(crime_type)
FROM suspects, crimes
WHERE suspects.suspect_id = crimes.suspect_id
GROUP BY suspects.first_name || ' ' || suspects.last_name,
         crime_type;
