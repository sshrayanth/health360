{{ config(materialized='view') }}

WITH patient_encounters AS (
    SELECT
        PATIENT_ID,
        COUNT(*) AS ENCOUNTER_COUNT,
        MAX(START_DATE) AS LAST_ENCOUNTER_DATE
    FROM {{ ref('stg_encounter') }}
    GROUP BY PATIENT_ID
),

patient_diagnoses AS (
    SELECT
        e.PATIENT_ID,
        COUNT(d.DIAGNOSIS_CODE) AS DIAGNOSIS_COUNT,

        MAX(
            CASE
                WHEN d.DIAGNOSIS_CODE = 'E11.9' THEN 1
                ELSE 0
            END
        ) AS HAS_DIABETES,

        MAX(
            CASE
                WHEN d.DIAGNOSIS_CODE = 'I10' THEN 1
                ELSE 0
            END
        ) AS HAS_HYPERTENSION

    FROM {{ ref('stg_encounter') }} e
    LEFT JOIN {{ ref('stg_diagnosis') }} d
        ON e.ENCOUNTER_ID = d.ENCOUNTER_ID
    GROUP BY e.PATIENT_ID
),

patient_risk AS (
    SELECT
        p.PATIENT_ID,
        p.FIRST_NAME,
        p.LAST_NAME,
        p.DOB,
        p.GENDER,
        p.RACE,

        COALESCE(pe.ENCOUNTER_COUNT, 0) AS ENCOUNTER_COUNT,
        COALESCE(pd.DIAGNOSIS_COUNT, 0) AS DIAGNOSIS_COUNT,
        pe.LAST_ENCOUNTER_DATE,

        COALESCE(pd.HAS_DIABETES, 0) AS HAS_DIABETES,
        COALESCE(pd.HAS_HYPERTENSION, 0) AS HAS_HYPERTENSION

    FROM {{ ref('stg_patient') }} p

    LEFT JOIN patient_encounters pe
        ON p.PATIENT_ID = pe.PATIENT_ID

    LEFT JOIN patient_diagnoses pd
        ON p.PATIENT_ID = pd.PATIENT_ID
)

SELECT
    *,
    CASE
        WHEN HAS_DIABETES = 1
             AND HAS_HYPERTENSION = 1
            THEN 'HIGH'
        WHEN HAS_DIABETES = 1
             OR HAS_HYPERTENSION = 1
            THEN 'MEDIUM'
        WHEN ENCOUNTER_COUNT >= 5
            THEN 'MEDIUM'
        ELSE 'LOW'
    END AS RISK_CATEGORY

FROM patient_risk