{{ config(materialized='table') }}

SELECT
    ENCOUNTER_ID,
    PROCEDURE_CODE,
    PROCEDURE_DESCRIPTION,
    PROCEDURE_DATE,
    IS_LAB_PROCEDURE,
    IS_TEST_PROCEDURE,
    HAS_PROCEDURE

FROM {{ ref('int_lab_flags') }}