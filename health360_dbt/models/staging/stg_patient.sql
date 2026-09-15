{{ config(materialized='view') }}

SELECT
    PATIENT_ID,
    TRIM(FIRST_NAME) AS FIRST_NAME,
    TRIM(LAST_NAME) AS LAST_NAME,
    DOB,
    GENDER,
    RACE,
    TRIM(ADDRESS) AS ADDRESS,
    ZIP,
    CREATED_TS
FROM {{ source('raw', 'PATIENTS') }}