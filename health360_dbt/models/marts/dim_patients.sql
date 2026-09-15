{{ config(materialized='table') }}

SELECT
    PATIENT_ID,
    FIRST_NAME,
    LAST_NAME,
    DOB,
    GENDER,
    RACE,
    ENCOUNTER_COUNT,
    DIAGNOSIS_COUNT,
    LAST_ENCOUNTER_DATE,
    HAS_DIABETES,
    HAS_HYPERTENSION,
    RISK_CATEGORY

FROM {{ ref('int_patient_risk') }}