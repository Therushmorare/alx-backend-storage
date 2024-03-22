-- Create a temporary table to hold the lifespan in years
CREATE TEMPORARY TABLE IF NOT EXISTS temp_bands AS
SELECT
    band_name,
    FLOOR(SPLIT(born, '-', 1)) AS formed,
    CASE
        WHEN died = 'present' THEN 2022 - FLOOR(SPLIT(born, '-', 1))
        ELSE FLOOR(SPLIT(died, '-', 1)) - FLOOR(SPLIT(born, '-', 1))
    END AS lifespan
FROM
    bands;

-- Select bands with Glam rock as their main style and rank them by longevity
SELECT
    band_name,
    lifespan
FROM
    temp_bands
WHERE
    band_name IN (SELECT band_name FROM styles WHERE style = 'Glam rock')
ORDER BY
    lifespan DESC;

