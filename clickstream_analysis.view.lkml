# If necessary, uncomment the line below to include explore_source.
# include: "data_mining.model.lkml"

view: clickstream_analysis {
  derived_table: {
    explore_source: ri_events_from_ga {
      column: sessionid {}
      column: userssoguid {}
      column: coursekey {}
      #column: localtime_timestamp_tz_raw {}
      column: clickstream {}
      column: session_start_time {
        field: ri_events_from_ga.earliest_time
      }


      filters: {
        field: ri_events_from_ga.coursekey
        value: "-NULL"
      }
      filters: {
        field: ri_events_from_ga.userssoguid
        value: "-NULL"
      }
      filters: {
        field: ri_events_from_ga.eventcategory
        value: "-NULL"
      }
      filters: {
        field: ri_events_from_ga.sessionid
        value: "-NULL"
      }
      filters: {
        field: dim_filter.is_external
        value: "Yes"
      }
    }
    datagroup_trigger: ga_events_datagroup
  }
  dimension: sessionid {
    label: "User Event Data Sessionid"
  }
  dimension: userssoguid {
    label: "User Event Data Userssoguid"
  }
  dimension: coursekey {
    label: "User Event Data Coursekey"
  }

  dimension_group: session_start_time {
    group_label: "Session Start Local Time"
    label: ""
    type: time
    timeframes: [raw,time, date, hour_of_day, day_of_week, time_of_day, month, year, week_of_year]
  }

  dimension: clickstream {
      label: "Clickstream"
  }
}
