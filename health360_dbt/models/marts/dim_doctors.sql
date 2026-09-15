{{ config(materialized='table') }}

SELECT
    PROVIDER_ID,
    FIRST_NAME,
    LAST_NAME,
    NPI,
    SPECIALTY,
    FACILITY_ID,
    UPDATED_AT

FROM {{ ref('stg_provider') }}