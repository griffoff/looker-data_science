connection: "snowflake_prod"

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project
include: "/core/common.lkml"
include: "/cube/dims.model.lkml"
#include: "/cube/source.model.lkml"
#include: "/cube/ga_data_parsed.view.lkml"
include: "/cube/dim_*.view.lkml"
include: "/cube/additional_info.user_scores_daily.view.lkml"

datagroup: ga_events_datagroup {
  sql_trigger: select count(*) from dev.raw_ga.ga_data_parsed ;;
}


#DEFINITION METHOD 2 from is rarely used with explore hence use definition 1
# explore: ga_data_parsed {
#   label: "Google Analytics Data"
#   from: ri_events_from_ga
#   view_name: ga_data_parsed
#   extends: [dim_course]
#   join: user_facts {
#     relationship: many_to_one
#     sql_on: ${ga_data_parsed.userssoguid} = ${user_facts.guid} ;;
#   }
#   join: dim_course {
#     relationship: many_to_one
#     sql_on: ${ga_data_parsed.coursekey} = ${dim_course.coursekey} ;;
#   }
#   join: dim_relative_to_start_date {
#     relationship: many_to_one
#     sql_on: datediff(days, ${olr_courses.begin_date_date}, ${ga_data_parsed.hit_date}) = ${dim_relative_to_start_date.days} ;;
#   }
# }

#DEFINITION METHOD 1
explore: ri_events_from_ga {
  label: " DS: RI event data from GA"
  extends: [dim_course]
  join: user_facts {
    relationship: many_to_one
    sql_on: ${ri_events_from_ga.userssoguid} = ${user_facts.guid} ;;
  }
  join: dim_course {
    relationship: many_to_one
    type: inner
    sql_on: ${ri_events_from_ga.coursekey} = ${dim_course.coursekey} ;;
  }
  join: user_final_scores {
    sql_on: (${dim_course.courseid}, ${ri_events_from_ga.userssoguid}) = (${user_final_scores.courseid}, ${user_final_scores.sso_guid}) ;;
    relationship: many_to_one
  }
  join: dim_relative_to_start_date {
    relationship: many_to_one
    sql_on: datediff(days, ${olr_courses.begin_date_date}, ${ri_events_from_ga.hit_date}) = ${dim_relative_to_start_date.days} ;;
  }
  join: user_scores_daily {
    sql_on: (${dim_course.courseid}, ${ri_events_from_ga.userssoguid}, ${dim_relative_to_start_date.days}) = (${user_scores_daily.courseid}, ${user_scores_daily.sso_guid}, ${user_scores_daily.day_of_course}) ;;
    relationship: many_to_one
  }
}

# 1st level of flattening
explore: flat_studentinteractions_4m_ga
{
  label: "DS: Flat Student Interactions"
  extends: [dim_course]
  join: dim_course {   # we need the dim_start_date join from the dim_course explore
    relationship: many_to_one
    sql_on: ${flat_studentinteractions_4m_ga.coursekey} = ${dim_course.coursekey} ;;
  }
  join: user_scores_daily {
    sql_on: (${dim_course.courseid}, ${flat_studentinteractions_4m_ga.userssoguid}, ${flat_studentinteractions_4m_ga.daysname}) = (${user_scores_daily.courseid}, ${user_scores_daily.sso_guid}, ${user_scores_daily.day_of_course}) ;;
    relationship: many_to_one
  }
  join: user_final_scores {
    sql_on: (${dim_course.courseid}, ${flat_studentinteractions_4m_ga.userssoguid}) = (${user_final_scores.courseid}, ${user_final_scores.sso_guid}) ;;
    relationship: many_to_one
  }

}

#2nd level of flattening
explore: rich_student_interactions {
}

explore: page_reads {}

explore : clickstream_analysis{}
