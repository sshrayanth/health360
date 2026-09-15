{{ config(materialized='view') }}

SELECT
    e.ENCOUNTER_ID,
    e.PATIENT_ID,
    e.PROVIDER_ID,
    p.FIRST_NAME AS PATIENT_FIRST_NAME,
    p.LAST_NAME AS PATIENT_LAST_NAME,
    e.AGE,
    e.START_DATE,
    e.END_DATE,
    e.ENCOUNTER_TYPE,

    DATEDIFF(
        'day',
        e.START_DATE,
        e.END_DATE
    ) AS ENCOUNTER_DURATION_DAYS,

    CASE
        WHEN e.END_DATE IS NULL THEN 'OPEN'
        WHEN e.END_DATE >= e.START_DATE THEN 'COMPLETED'
        ELSE 'INVALID'
    END AS ENCOUNTER_STATUS

FROM {{ ref('stg_encounter') }} e

LEFT JOIN {{ ref('stg_patient') }} p
    ON e.PATIENT_ID = p.PATIENT_ID