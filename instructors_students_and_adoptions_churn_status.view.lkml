explore: instructors_students_and_adoptions_churn_status {
  label: "DS: Instructors and Digital Adoption Churn"
}

view: instructors_students_and_adoptions_churn_status {
  derived_table: {
    sql: select *
      from  dev.ZSP.INSTRUCTORS_AND_ADOPTIONS
       ;;
  }


  dimension: adoption_key {
    type: string
    label: "Digital Adoption key"
    sql: ${TABLE}."ADOPTION_KEY" ;;
  }


  dimension: instructor_guid {
    type: string
    sql: ${TABLE}."INSTRUCTOR_GUID" ;;
  }

  dimension: user_sso_guid {
    type: string
    sql: ${TABLE}."USER_SSO_GUID" ;;
  }

  dimension: course_key {
    type: string
    label: "Course Section"
    sql: ${TABLE}."COURSE_KEY" ;;
  }

  dimension: discipline {
    type: string
    sql: ${TABLE}."DISCIPLINE" ;;
  }

  dimension: entity_no {
    type: number
    hidden: yes
    sql: ${TABLE}."ENTITY_NO" ;;
  }

  dimension: institution_nm {
    type: string
    label: "Institution"
    sql: ${TABLE}."INSTITUTION_NM" ;;
  }

  dimension: state_cd {
    type: string
    hidden: yes
    sql: ${TABLE}."STATE_CD" ;;
  }

  dimension: isbn13 {
    type: string
    sql: ${TABLE}."ISBN13" ;;
  }

  dimension: prod_family_cd {
    type: string
    label: "Product Family Code"
    hidden: yes
    sql: ${TABLE}."PROD_FAMILY_CD" ;;
  }

  dimension: product_type {
    type: string
    sql: ${TABLE}."PRODUCT_TYPE" ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}."PLATFORM" ;;
  }

  dimension: did_churn_19 {
    type: number
    label: "Did adoption churn 2019"
    sql: ${TABLE}."DID_CHURN_19" ;;
  }

  dimension: did_churn_18 {
    type: number
    label: "Did adoption churn 2018"
    sql: ${TABLE}."DID_CHURN_18" ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: count_distinct_adoptions {
    type: count_distinct
    sql: ${adoption_key} ;;
  }

  measure: count_distinct_students {
    type: count_distinct
    label: "Number of Distinct Students"
    sql:  ${user_sso_guid};;
  }

  measure: count_distinct_course_Sections{
    type: count_distinct
    label: "Number of Distinct Course Sections"
    sql:  ${course_key};;
  }

  set: detail {
    fields: [
      adoption_key,
      instructor_guid,
      user_sso_guid,
      discipline,
      entity_no,
      institution_nm,
      state_cd,
      isbn13,
      prod_family_cd,
      product_type,
      platform,
      did_churn_19,
      did_churn_18,
    ]
  }
}
