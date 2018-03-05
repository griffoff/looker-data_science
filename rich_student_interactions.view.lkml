# If necessary, uncomment the line below to include explore_source.
include: "data_mining.model.lkml"


#these are the aggregates of the signals used
view: rich_student_interactions {
  derived_table: {
    explore_source: flat_studentinteractions_4m_ga {
      column: pk_id_min {}
      column: coursekey {}
      column: userssoguid {}
      column: logins {}
      column: highlights {}
      column: reading {}
      column: total_time_in_mindtap {}
      column: searches {}
      column: media {}
      column: flashcards {}
      column: notes {}
      column: attempt {}
      column: intensity {}
      column: homework {}
      column: cnow {}
      column: daysname {}
    }
    sql_trigger_value: select count(*) from ${flat_studentinteractions_4m_ga.SQL_TABLE_NAME} ;;
  }
  dimension: pk_id_min {
    primary_key:yes
    hidden:yes
  }
  dimension: coursekey {}
  dimension: userssoguid {}
  measure: logins {
    type: average
  }
  measure: highlights {
    type: average
  }
  measure: reading {
    type: average
  }
  dimension: total_time_in_mindtap {
    type: number
    hidden: yes
  }

  measure: time_in_mindtap_sum {
    type: sum
    sql: ${total_time_in_mindtap} ;;
  }
  measure: avg_time_in_mindtap {
    type: average
    sql: ${total_time_in_mindtap} ;;
  }
  measure: searches {
    type: average
  }
  measure: media {
    type: average
  }
  measure: flashcards {
    type: average
  }
  measure: notes {
    type: average
  }
  measure: attempt {
    type: average
  }
  measure: intensity {
    type: average
  }
  measure: homework {
    type: average
  }
  measure: cnow {
    type: average
  }
  dimension: daysname {
    label: "Days Relative to Course Start Date"
    value_format: "\D\a\y 0"
    type: number
  }

  measure: count {
    type: count
  }
}
