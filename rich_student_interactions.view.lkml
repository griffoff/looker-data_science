# If necessary, uncomment the line below to include explore_source.
# include: "data_mining.model.lkml"


#these are the aggregates of the signals used
view: rich_student_interactions {
  derived_table: {
    explore_source: flat_studentinteractions_4m_ga {
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
}
