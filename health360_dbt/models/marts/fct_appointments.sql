{{ config(materialized='table') }}

SELECT
    ENCOUNTER_ID,
    PATIENT_ID,
    PROVIDER_ID,
    PATIENT_FIRST_NAME,
    PATIENT_LAST_NAME,
    AGE,
    START_DATE,
    END_DATE,
    ENCOUNTER_TYPE,
    ENCOUNTER_DURATION_DAYS,
    ENCOUNTER_STATUS

FROM {{ ref('int_appointment_metrics') }}