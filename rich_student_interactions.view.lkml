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
      column: final_score { field: user_final_scores.final_score }
      column: final_score_category { field: user_final_scores.final_score_category }
      column: daily_score { field: user_scores_daily.daily_score }
      column: daily_score_category { field: user_scores_daily.daily_score_category }
      column: to_date_score { field: user_scores_daily.to_date_score }
      column: to_date_score_category { field: user_scores_daily.to_date_score_category }
    }
    sql_trigger_value: select count(*) from ${flat_studentinteractions_4m_ga.SQL_TABLE_NAME} ;;
  }
  dimension: pk_id_min {
    primary_key:yes
    hidden:yes
  }
  dimension: coursekey {}
  dimension: userssoguid {}
  dimension: logins {
    type: number
  }
  dimension: highlights {
    type: number
  }
  dimension: reading {
    type: number
  }
  dimension: total_time_in_mindtap {
    type: number
  }
  dimension: searches {
    type: number
  }
  dimension: media {
    type: number
  }
  dimension: flashcards {
    type: number
  }
  dimension: notes {
    type: number
  }
  dimension: attempt {
    type: number
  }
  dimension: intensity {
    type: number
  }
  dimension: homework {
    type: number
  }
  dimension: cnow {
    type: number
  }
  dimension: daysname {
    label: "Days Relative to Course Start Date"
    value_format: "\D\a\y 0"
    type: number
  }
  dimension: final_score {group_label: "Scores"}
  dimension: final_score_category {group_label: "Scores"}
  dimension: daily_score {group_label: "Scores"}
  dimension: daily_score_category {group_label: "Scores"}
  dimension: to_date_score {group_label: "Scores"}
  dimension: to_date_score_category {group_label: "Scores"}

  measure: count {}
}
