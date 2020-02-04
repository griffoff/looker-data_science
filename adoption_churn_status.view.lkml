explore: adoption_churn_status {
  label: "DS: Digital Adoption Churn"
}

view: adoption_churn_status {
  derived_table: {
    sql: select *
      from  dev.ZSP.INSTRUCTORS_AND_ADOPTIONS
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: adoption_key {
    type: string
    label: "Digital Adoption key"
    sql: ${TABLE}."ADOPTION_KEY" ;;
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

  dimension: fy18_courseware_consumed_units {
    type: number
    sql: ${TABLE}."FY18_COURSEWARE_CONSUMED_UNITS" ;;
  }

  dimension: fy19_courseware_consumed_units {
    type: number
    sql: ${TABLE}."FY19_COURSEWARE_CONSUMED_UNITS" ;;
  }

  dimension: instructor_guid {
    type: string
    sql: ${TABLE}."INSTRUCTOR_GUID" ;;
  }

  dimension: num_students {
    type: number
    label: "Total number of students taught by an Instructor"
    sql: ${TABLE}."NUM_STUDENTS" ;;
  }

  dimension: num_courses {
    type: number
    label: "Total number of course sections taught by an Instructor"
    sql: ${TABLE}."NUM_COURSES" ;;
  }

  dimension: num_products {
    type: number
    label: "Total number of product types used by an Instructor"
    sql: ${TABLE}."NUM_PRODUCTS" ;;
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

  set: detail {
    fields: [
      adoption_key,
      did_churn_19,
      did_churn_18,
      fy18_courseware_consumed_units,
      fy19_courseware_consumed_units,
      instructor_guid,
      num_students,
      num_courses,
      num_products,
      discipline,
      entity_no,
      institution_nm,
      state_cd,
      isbn13,
      prod_family_cd,
      product_type,
      platform
    ]
  }
}
