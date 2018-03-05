# If necessary, uncomment the line below to include explore_source.
# include: "data_mining.model.lkml"

view: clickstream_analysis {
  derived_table: {
    explore_source: ri_events_from_ga {
      column: sessionid {}
      column: userssoguid {}
      column: coursekey {}
      column: localtime_timestamp_tz_raw {}
      column: eventaction {}
      column: eventcategory {}
      column: activityuri {}
      derived_column: interaction {}
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
  dimension_group: localtime_timestamp_tz_raw {
    group_label: "Local Time"
    label: ""
    type: time
    timeframes: [raw,time, date, hour_of_day, day_of_week, time_of_day, month, year, week_of_year]
  }
  dimension: eventaction {
    label: "User Event Data Eventaction"
  }
  dimension: eventcategory {
    label: "User Event Data Eventcategory"
  }
  dimension: activityuri {
    label: "User Event Data Activityuri"
  }

  dimension: interaction {
    label: "Interaction With Platform Feature"
    type: string
    sql: InitCap((
            case    when eventAction ilike 'view'
                        then lower(concat(concat(eventaction, ' '), eventCategory))
                    when eventCategory  ilike 'activity'
                        then lower(concat(concat(eventAction, ' '), split_part(activityuri, ':', 3)))
                    else lower(eventCategory) end
            ))  ;;
  }
}
