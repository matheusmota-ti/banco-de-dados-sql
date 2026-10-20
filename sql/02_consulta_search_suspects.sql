-- Origem SQL da página Faceted Search "Search Suspects".
-- A junção externa preserva suspeitos sem gangue associada.
SELECT suspects.suspect_id,
       first_name,
       last_name,
       sex,
       age,
       height,
       hair_color,
       eye_color,
       facial_hair,
       tattoos,
       glasses,
       scars,
       feet_size,
       image,
       gang_affiliation,
       name,
       territory,
       criminal_speciality,
       symbol
FROM suspects, gangs
WHERE suspects.gang_affiliation = gangs.gang_id (+);
