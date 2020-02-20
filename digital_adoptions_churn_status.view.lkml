#courseware consumed units are digital units plus activations within CU
#digital units = digital bundles + digital standalone + loose-leaf bundles
# there are decimals because Strategy had to allocate certain things across adoptions


# EXploring digital adoptions (alone) and their churn patterns

#For instructors and students details look at instructors_students_and_adoptions_churn_status

explore: digital_adoptions_churn_status{
  label: "DS: Digital Adoption Churn"
}

view: digital_adoptions_churn_status {
  derived_table: {
    sql: select *
      from dev.ZSP.ADOPTION_LEVEL_MASTER
      where FY18_TO_FY19_ADOPTIONTRANSITION ilike '%digital%'
      and FY19_TO_FY20_ADOPTIONTRANSITION ilike '%digital%'
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: count_distinct_adoptions {
    type: count_distinct
    sql: ${adoption_key} ;;
  }

  measure: churn_count_19 {
    type: count_distinct
    sql: case when ${did_churn_19} = 1 then ${adoption_key} else NULL end  ;;
    drill_fields: [detail*]
  }

  dimension: fy18_courseware_consumed_units_buckets {
    type: tier
    tiers: [0 ,10, 50, 100, 250, 500]
    style: integer
    sql: ${fy18_courseware_consumed_units} ;;
  }

  dimension: adoption_key {
    type: string
    sql: ${TABLE}."ADOPTION_KEY" ;;
  }

  dimension: institution {
    type: string
    sql: ${TABLE}."INSTITUTION" ;;
  }

  dimension: course {
    type: string
    sql: ${TABLE}."COURSE" ;;
  }

  dimension: discipline {
    type: string
    sql: ${TABLE}."DISCIPLINE" ;;
  }

  dimension: fy18_to_fy19_adoptiontransition {
    type: string
    sql: ${TABLE}."FY18_TO_FY19_ADOPTIONTRANSITION" ;;
  }

  dimension: fy19_to_fy20_adoptiontransition {
    type: string
    sql: ${TABLE}."FY19_TO_FY20_ADOPTIONTRANSITION" ;;
  }

  # courseware_consumed_units could be seen as a proxy for adoption size ?
  dimension: fy18_courseware_consumed_units {
    type: number
    sql: ${TABLE}."FY18_COURSEWARE_CONSUMED_UNITS" ;;
  }

  dimension: fy19_courseware_consumed_units {
    type: number
    sql: ${TABLE}."FY19_COURSEWARE_CONSUMED_UNITS" ;;
  }

  dimension: fy20_courseware_consumed_units {
    type: number
    sql: ${TABLE}."FY20_COURSEWARE_CONSUMED_UNITS" ;;
  }

  dimension: did_churn_18 {
    type: number
    sql: ${TABLE}."DID_CHURN_18" ;;
  }

  dimension: did_churn_19 {
    type: number
    sql: ${TABLE}."DID_CHURN_19" ;;
  }

  set: detail {
    fields: [
      adoption_key,
      institution,
      course,
      discipline,
      fy18_to_fy19_adoptiontransition,
      fy19_to_fy20_adoptiontransition,
      fy18_courseware_consumed_units,
      fy19_courseware_consumed_units,
      fy20_courseware_consumed_units,
      did_churn_18,
      did_churn_19
    ]
  }
}
