# If necessary, uncomment the line below to include explore_source.
# include: "data_mining.model.lkml"

view: clickstream_analysis {
  derived_table: {
    explore_source: ri_events_from_ga {
      column: sessionid {}
      column: userssoguid {}
      column: coursekey {}
      column: localtime_timestamp_tz_time {}
      column: eventaction {}
      column: eventcategory {}
      column: activityuri {}
      #column: interaction {}
      filters: {
        field: ri_events_from_ga.coursekey
        value: "MTPQXFXPFQ77,-NULL"
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
  dimension: localtime_timestamp_tz_time {
    label: "User Event Data  Time"
    type: date_time
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

#   dimension: interaction {
#     label: "Interaction With Platform Feature"
#     type: string
#     sql: case
#               when eventAction ilike 'view' then lower(concat(eventaction, eventCategory))
#               when eventCategory  ilike 'activity'
#                     then lower(concat(eventAction, split_part(activityuri, ':', 3)))
#               else lower(eventCategory) end  ;;
#   }
}
