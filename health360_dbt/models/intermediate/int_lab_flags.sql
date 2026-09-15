{{ config(materialized='view') }}

SELECT
    pr.ENCOUNTER_ID,
    pr.PROCEDURE_CODE,
    pr.PROCEDURE_DESCRIPTION,
    pr.PROCEDURE_DATE,

    CASE
        WHEN UPPER(pr.PROCEDURE_DESCRIPTION) LIKE '%LAB%'
            THEN 1
        ELSE 0
    END AS IS_LAB_PROCEDURE,

    CASE
        WHEN UPPER(pr.PROCEDURE_DESCRIPTION) LIKE '%TEST%'
            THEN 1
        ELSE 0
    END AS IS_TEST_PROCEDURE,

    CASE
        WHEN pr.PROCEDURE_CODE IS NOT NULL
            THEN 1
        ELSE 0
    END AS HAS_PROCEDURE

FROM {{ ref('stg_procedure') }} pr