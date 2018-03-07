connection: "snowflake_prod"

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project
include: "/core/common.lkml"
include: "/cube/dims.model.lkml"
#include: "/cube/source.model.lkml"
#include: "/cube/ga_data_parsed.view.lkml"
include: "/cube/dim_*.view.lkml"
include: "/cube/additional_info.*.view.lkml"

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
  join: dim_relative_to_start_date {
    relationship: many_to_one
    sql_on: ${flat_studentinteractions_4m_ga.daysname} = ${dim_relative_to_start_date.daysname} ;;
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
  label: "DS: Enriched Student Interactions"
  extends: [dim_course]
  join: dim_course {   # we need the dim_start_date join from the dim_course explore
    relationship: many_to_one
    sql_on: ${rich_student_interactions.coursekey} = ${dim_course.coursekey} ;;
  }
  join: user_final_scores {
    sql_on:  (${dim_course.courseid}, ${rich_student_interactions.userssoguid}) =( ${user_final_scores.courseid}, ${user_final_scores.sso_guid});;
    relationship: one_to_many
  }
  join: user_scores_daily {
    sql_on: (${user_final_scores.courseid}, ${user_final_scores.sso_guid}, ${rich_student_interactions.daysname}) = (${user_scores_daily.courseid}, ${user_scores_daily.sso_guid}, ${user_scores_daily.day_of_course}) ;;
    relationship: one_to_many
  }
}

explore: page_reads {
  label: "DS: Page Reads"
  extends: [dim_course]
  join: dim_course {   # we need the dim_start_date join from the dim_course explore
    relationship: many_to_one
    sql_on: ${page_reads.coursekey} = ${dim_course.coursekey} ;;
  }
}

explore: course {
  label: "DS: Courses"
  extends: [dim_course]
  from: dim_course
  view_name: dim_course

  join: user_final_scores {
    sql_on:  ${dim_course.courseid} = ${user_final_scores.courseid};;
    relationship: one_to_many
  }

  join: user_scores_daily {
    sql_on: (${user_final_scores.courseid}, ${user_final_scores.sso_guid}) = (${user_scores_daily.courseid}, ${user_scores_daily.sso_guid}) ;;
    relationship: one_to_many
  }

}
