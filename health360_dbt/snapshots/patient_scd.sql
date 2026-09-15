{% snapshot patient_scd %}

{{
    config(
        target_schema='STAGING',
        unique_key='PATIENT_ID',
        strategy='check',
        check_cols=[
            'FIRST_NAME',
            'LAST_NAME',
            'DOB',
            'GENDER',
            'RACE',
            'ADDRESS',
            'ZIP'
        ]
    )
}}

SELECT
    PATIENT_ID,
    FIRST_NAME,
    LAST_NAME,
    DOB,
    GENDER,
    RACE,
    ADDRESS,
    ZIP,
    CREATED_TS

FROM {{ ref('stg_patient') }}

{% endsnapshot %}