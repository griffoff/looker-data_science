  include: "//cube/raw_ga.ga_data_parsed.view.lkml"

view: ri_events_from_ga {
  extends: [ga_data_parsed]

  dimension: sessionid {
    hidden: no
  }

  dimension: interaction {
    sql:  InitCap((
            case    when ${eventaction} ilike 'view'
                        then lower(concat(concat(${eventaction}, space(1)), ${eventcategory}))
                    when ${eventcategory}  ilike 'activity'
                        then lower(concat(concat(${eventaction}, space(1)), split_part(${activityuri}, ':', 3)))
                    else lower(${eventcategory}) end
            )) ;;
  }

  measure: interaction_count{
    type: count
    drill_fields: [interaction]
  }

  measure: clickstream {
    type: string
    sql: listagg(${interaction}, ',') within group (order by ${localtime_timestamp_tz_raw})  ;;
  }
  measure: earliest_time {
    type: number
    sql: min(${localtime_timestamp_tz_raw}) ;;
  }

# Dimensions and measures for RI events
# Time in MT
  dimension:  time_in_mindtap {
    hidden: yes
    type:number
    sql: case when lower(${eventcategory}) = 'time-in-mindtap' then ${eventvalue}
                when lower(${eventaction}) = 'time-in-mindtap' then ${eventvalue}
                when contains(lower(${eventlabel}), 'time-in-mindtap') then ${eventvalue}
         else 0 end/(1000*60*60*24)  ;;
  }

  measure: pk_id {
    type: min
    sql: ${ga_data_parsed_id} ;;
    hidden: yes
  }

  measure: time_in_mindtap_sum {
    type: sum
    sql: ${time_in_mindtap} ;;
    value_format_name: duration_hms
    group_label : "DS event metrics"

  }

  measure: time_in_mindtap_avg {
    type: average
    sql: ${time_in_mindtap} ;;
    value_format_name: duration_hms
    group_label : "DS event metrics"
  }

  #total session time
  dimension: total_session_time {
    hidden: yes
    type: number
    sql: case when lower(${eventcategory}) = 'total-session-time' then ${eventvalue}::number
              when lower(${eventaction}) = 'total-session-time' then ${eventvalue}::number
              when contains(lower(${eventlabel}), 'total-session-time') then ${eventvalue}::number
          else 0 end/(1000*60*60*24);;

    }
    measure: total_session_time_sum {
      type: sum
      sql: ${total_session_time} ;;
      value_format_name: duration_hms
      group_label: "DS event metrics"
    }


    #ASSESSMENT
    dimension: assessment_activity_submitted {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'activity-submitted' and lower(${eventcategory}) = 'assessment' then 1 else 0 end ;;
    }

    dimension: assessment_launch {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'launch' and lower(${eventcategory}) = 'assessment' then 1 else 0 end ;;
    }

    dimension: assessment_activity_started {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'activity-started' and lower(${eventcategory}) = 'assessment' then 1 else 0 end ;;
    }

    dimension: assessment_view {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'view' and lower(${eventcategory}) = 'assessment' then 1 else 0 end ;;
    }

    dimension: assessment_activity {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'unknown'
           --and split_part(, ':','4') = 'activity_id'
          and lower(${eventcategory}) = 'assessment' then 1 else 0 end ;;
    }

    #TODO calculate measures for each category
    measure: assessment_activity_submitted_sum {
      type: sum
      sql: ${assessment_activity_submitted} ;;
      group_label : "DS event metrics"

    }

    measure: assessment_launch_sum {
      type: sum
      sql: ${assessment_launch} ;;
      group_label : "DS event metrics"

    }

    measure: assessment_activity_started_sum {
      type: sum
      sql: ${assessment_activity_started} ;;
      group_label : "DS event metrics"

    }

    measure: assessment_view_sum {
      type: sum
      sql: ${assessment_view} ;;
      group_label : "DS event metrics"

    }

    measure: assessment_activity_sum {
      type: sum
      sql: ${assessment_activity} ;;
      group_label : "DS event metrics"

    }


    #READING
    dimension: reading_Launch {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'launch' or     lower(${eventaction}) = 'app-dock-launch'
        and lower(${eventcategory}) = 'reading' then 1 else 0 end ;;
    }
    measure:  reading_Launch_sum{
      type: sum
      sql: ${reading_Launch} ;;
      group_label : "DS event metrics"
    }

    dimension: reading_view {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'view' and lower(${eventcategory}) = 'reading' then 1 else 0 end ;;
    }
    measure:  reading_view_sum{
      type: sum
      sql: ${reading_view} ;;
      group_label : "DS event metrics"
    }

    dimension: reading_activity {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'unknown' and lower(${eventcategory}) = 'reading' then 1 else 0 end ;;
    }
    measure:  reading_activity_sum{
      type: sum
      sql: ${reading_activity} ;;
      group_label : "DS event metrics"
    }



    #MEDIA
    dimension: media {
      hidden: yes
      type: number
      sql: case when lower(${eventcategory}) = 'media' then 1
                when lower(${eventaction}) = 'media' then 1
                when lower(${eventlabel}) ilike('%media%') then 1 else 0 end ;;
    }
    measure:  media_sum{
      type: sum
      sql: ${media} ;;
      group_label : "DS event metrics"
    }


    #SEARCHES
    dimension: search_launched {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'launch' or lower(${eventaction}) = 'app-dock-launch'
        and lower(${eventcategory}) = 'search' then 1 else 0 end;;
    }
    measure:  search_launched_sum{
      type: sum
      sql: ${search_launched} ;;
      group_label : "DS event metrics"
    }

    dimension: search_performed {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'search-performed' and lower(${eventcategory}) = 'search' then 1 else 0 end ;;
    }
    measure:  search_performed_sum{
      type: sum
      sql: ${search_performed} ;;
      group_label : "DS event metrics"
    }


    #NOTES
    #EVERNOTE
    dimension: everNote_Launch {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'launch' or lower(${eventaction}) = 'app-dock-launch' and lower(${eventcategory}) = 'evernote' then 1 else 0 end ;;
    }
    measure:everNote_Launch_sum{
      type: sum
      sql: ${everNote_Launch} ;;
      group_label : "DS event metrics"
    }

    dimension: everNoteMobile_Launch {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'app-dock-launch' and lower(${eventcategory}) = 'evernote.mobile' then 1 else 0 end;;
    }
    measure:everNoteMobile_Launch_sum{
      type: sum
      sql: ${everNoteMobile_Launch} ;;
      group_label : "DS event metrics"
    }

    dimension: flashnotes_Launch {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'launch' or lower(${eventaction}) = 'app-dock-launch' and lower(${eventcategory}) = 'flashnotes' then 1 else 0 end;;
    }
    measure:flashnotes_Launch_sum{
      type: sum
      sql: ${flashnotes_Launch} ;;
      group_label : "DS event metrics"
    }

    dimension: flashnotesQAD_Launch {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'app-dock-launch' and lower(${eventcategory}) = 'flashnotesqad' then 1 else 0 end;;
    }
    measure:flashnotesQAD_Launch_sum{
      type: sum
      sql: ${flashnotesQAD_Launch} ;;
      group_label : "DS event metrics"
    }

    dimension: flashnotesCEO_Launch {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'app-dock-launch' and lower(${eventcategory}) = 'flashnotes.ceo' then 1 else 0 end;;
    }
    measure:flashnotesCEO_Launch_sum{
      type: sum
      sql: ${flashnotesCEO_Launch} ;;
      group_label : "DS event metrics"
    }

    #MY+NOTES
    dimension: mynotes_launch {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'app-dock-launch' and lower(${eventcategory}) = 'my+notes' then 1 else 0 end;;
    }
    measure:mynotes_launch_sum{
      type: sum
      sql: ${mynotes_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: notepad_launch {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'launch' and lower(${eventcategory}) = 'notepad' then 1 else 0 end;;
    }
    measure:notepad_launch_sum{
      type: sum
      sql: ${notepad_launch} ;;
      group_label : "DS event metrics"
    }


    dimension: onenote_launch {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'launch' or lower(${eventaction}) = 'app-dock-launch' and lower(${eventcategory}) = 'onenote' then 1 else 0 end;;
    }
    measure:onenote_launch_sum{
      type: sum
      sql: ${onenote_launch} ;;
      group_label : "DS event metrics"
    }


    #QUICKNOTE
    dimension: quicknote_create {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'create' or lower(${eventaction}) = 'create-quicknote' and lower(${eventcategory}) = 'quicknote' then 1 else 0 end;;
    }
    measure:quicknote_create_sum{
      type: sum
      sql: ${quicknote_create} ;;
      group_label : "DS event metrics"
    }

    dimension: quicknote_launch {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'launch' and lower(${eventcategory}) = 'quicknote' then 1 else 0 end;;
    }
    measure:quicknote_launch_sum{
      type: sum
      sql: ${quicknote_launch} ;;
      group_label : "DS event metrics"
    }

    #GRADEBOOK
    dimension: gradebook_launch {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch' and lower(${eventcategory}) = 'gradebook' then 1 else 0 end;;
    }
    measure:gradebook_launch_sum{
      type: sum
      sql: ${gradebook_launch} ;;
      group_label : "DS event metrics"
    }


    #HOMEWORK
    dimension: homework_submitted {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'activity-submitted' and lower(${eventcategory}) = 'homework' then 1 else 0 end;;
    }
    measure:homework_submitted_sum{
      type: sum
      sql: ${homework_submitted} ;;
      group_label : "DS event metrics"
    }

    dimension: homework_launch {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'launch' and lower(${eventcategory}) = 'homework' then 1 else 0 end;;
    }
    measure:homework_launch_sum{
      type: sum
      sql: ${homework_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: homework_started {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'activity-started' and lower(${eventcategory}) = 'homework' then 1 else 0 end;;
    }
    measure:homework_started_sum{
      type: sum
      sql: ${homework_started} ;;
      group_label : "DS event metrics"
    }

    dimension: homework_view {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'view' and lower(${eventcategory}) = 'homework' then 1 else 0 end;;
    }
    measure:homework_view_sum{
      type: sum
      sql: ${homework_view} ;;
      group_label : "DS event metrics"
    }

    dimension: homework {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'UNKNOWN' and lower(${eventcategory}) = 'homework' then 1 else 0 end;;
    }
    measure:homework_sum{
      type: sum
      sql: ${homework} ;;
      group_label : "DS event metrics"
    }


    #BOOKMARKS
    dimension: bookmarks_launch {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'launch' or lower(${eventaction}) = 'app-dock-launch' and lower(${eventcategory}) ='bookmarks' then 1 else 0 end;;
    }
    measure:bookmarks_launch_sum{
      type: sum
      sql: ${bookmarks_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: bookmarks_create {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'create' or lower(${eventaction}) = 'create-bookmark' and lower(${eventcategory}) ='bookmarks' then 1 else 0 end;;
    }
    measure:bookmarks_create_sum{
      type: sum
      sql: ${bookmarks_create} ;;
      group_label : "DS event metrics"
    }

    #PROGRESS
    dimension: progress_launch {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch' and lower(${eventcategory}) = 'progress' then 1 else 0 end;;
    }
    measure:progress_launch_sum{
      type: sum
      sql: ${progress_launch} ;;
      group_label : "DS event metrics"
    }

    #FLASHCARDS
    dimension: flashcards_launch {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'launch' or lower(${eventaction}) = 'app-dock-launch' and lower(${eventcategory}) = 'flashcards' or lower(${eventcategory}) = 'flash-cards' then 1 else 0 end;;
    }
    measure:flashcards_launch_sum{
      type: sum
      sql: ${flashcards_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: flashcards_view {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'view' and lower(${eventcategory}) = 'flashcards' then 1 else 0 end;;
    }
    measure:flashcards_view_sum{
      type: sum
      sql: ${flashcards_view} ;;
      group_label : "DS event metrics"
    }

    #GLOSSARY
    dimension: glossary_launch {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'launch' or lower(${eventaction}) = 'app-dock-launch' and lower(${eventcategory}) = 'glossary' then 1 else 0 end;;
    }
    measure:glossary_launch_sum{
      type: sum
      sql: ${glossary_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: glossary_view {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'view' and lower(${eventcategory}) = 'glossary' then 1 else 0 end;;
    }
    measure:glossary_view_sum{
      type: sum
      sql: ${glossary_view} ;;
      group_label : "DS event metrics"
    }

    dimension: glossary_show {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'glossary-show' and lower(${eventcategory}) = 'glossary' then 1 else 0 end;;
    }
    measure:glossary_show_sum1{
      type: sum
      sql: ${glossary_show} ;;
      group_label : "DS event metrics"
    }

    #HIGHLIGHTS
    dimension: highlights_launch {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'app-dock-launch' and lower(${eventcategory}) ='highlight' then 1 else 0 end;;
    }
    measure:highlights_launch_sum{
      type: sum
      sql: ${highlights_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: highlights_create {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'create' or lower(${eventaction}) = 'create-highlight' and lower(${eventcategory}) ='highlight' then 1 else 0 end;;
    }
    measure:highlights_create_sum{
      type: sum
      sql: ${highlights_create} ;;
      group_label : "DS event metrics"
    }

    #MESSAGECENTER
    dimension: messagecenter_launch {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'messagecenter' then 1 else 0 end;;
    }
    measure:messagecenter_launch_sum{
      type: sum
      sql: ${messagecenter_launch} ;;
      group_label : "DS event metrics"
    }

    #MESSAGE - CENTER
    dimension: messagecenter_preferences_changed {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) ='preferences-changed' and lower(${eventcategory}) = 'message-center' then 1 else 0 end;;
    }
    measure:messagecenter_preferences_changed_sum{
      type: sum
      sql: ${messagecenter_preferences_changed} ;;
      group_label : "DS event metrics"
    }

    dimension: messagecenter_message_sent {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='message-sent' and lower(${eventcategory}) = 'message-center' then 1 else 0 end;;
    }
    measure:messagecenter_message_sent_sum{
      type: sum
      sql: ${messagecenter_message_sent} ;;
      group_label : "DS event metrics"
    }

    #STUDY GUIDE
    dimension: studyguide_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' and lower(${eventcategory}) = 'studyguide' then 1 else 0 end;;
    }
    measure:studyguide_launch_sum1{
      type: sum
      sql: ${studyguide_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: studyguide {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='unknown' and lower(${eventcategory}) = 'studyguide' then 1 else 0 end;;
    }
    measure:studyguide_sum{
      type: sum
      sql: ${studyguide} ;;
      group_label : "DS event metrics"
    }

    #CONCEPT-MAP
    dimension: concept_map_interacted {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='interacted' and lower(${eventcategory}) = 'concept-map' then 1 else 0 end;;
    }
    measure:concept_map_interacted_sum{
      type: sum
      sql: ${concept_map_interacted} ;;
      group_label : "DS event metrics"
    }

    dimension: concept_map {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='unknown' and lower(${eventcategory}) = 'concept-map' then 1 else 0 end;;
    }
    measure:concept_map_sum{
      type: sum
      sql: ${concept_map} ;;
      group_label : "DS event metrics"
    }

    #CONCEPTMAP
    dimension: conceptmap_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' and lower(${eventcategory}) = 'conceptmap' then 1 else 0 end ;;
    }
    measure:conceptmap_launch_sum{
      type: sum
      sql: ${conceptmap_launch} ;;
      group_label : "DS event metrics"
    }

    #CONCEPTMAP.ACTIVITY
    dimension: conceptmap_activity_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'conceptmap.activity' then 1 else 0 end ;;
    }
    measure:conceptmap_activity_launch_sum{
      type: sum
      sql: ${conceptmap_activity_launch} ;;
      group_label : "DS event metrics"
    }

    #CONCEPTMAP-DOCK.APP
    dimension: conceptmap_app_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'conceptmap-dock.app' then 1 else 0 end;;
    }
    measure:conceptmap_app_launch_sum{
      type: sum
      sql: ${conceptmap_app_launch} ;;
      group_label : "DS event metrics"
    }

    #READSPEAKER
    dimension: readspeaker_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'readspeaker' then 1 else 0 end;;
    }
    measure:readspeaker_launch_sum{
      type: sum
      sql: ${readspeaker_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: readspeaker1_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'readspeaker1' then 1 else 0 end;;
    }
    measure:readspeaker1_launch_sum{
      type: sum
      sql: ${readspeaker1_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: readspeaker3_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'readspeaker3' then 1 else 0 end;;
    }
    measure:readspeaker3_launch_sum{
      type: sum
      sql: ${readspeaker3_launch} ;;
      group_label : "DS event metrics"
    }

    #DICTIONARY
    dimension: dictionary_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'dictionary' then 1 else 0 end;;
    }
    measure:dictionary_launch_sum{
      type: sum
      sql: ${dictionary_launch} ;;
      group_label : "DS event metrics"
    }

    #outcome.management
    dimension: outcome_management_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'outcome.management' then 1 else 0 end;;
    }
    measure:outcome_management_launch_sum{
      type: sum
      sql: ${outcome_management_launch} ;;
      group_label : "DS event metrics"
    }

    #RSSFEED
    dimension: rssfeed_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'rssfeed' or lower(${eventcategory}) = 'rss-feed' then 1 else 0 end;;
    }
    measure:rssfeed_launch_sum{
      type: sum
      sql: ${rssfeed_launch} ;;
      group_label : "DS event metrics"
    }

    #KALTURA
    dimension: kaltura_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch' and lower(${eventcategory}) = 'kaltura' then 1 else 0 end;;
    }
    measure:kaltura_launch_sum{
      type: sum
      sql: ${kaltura_launch} ;;
      group_label : "DS event metrics"
    }


    #GOOGLE.DOC
    dimension: googledoc_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'google.doc' then 1 else 0 end;;
    }
    measure:googledoc_launch_sum1{
      type: sum
      sql: ${googledoc_launch} ;;
      group_label : "DS event metrics"
    }

    #googledocs
    dimension: googledocs_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' and lower(${eventcategory}) = 'googledocs' then 1 else 0 end;;
    }
    measure:googledocs_launch_sum2{
      type: sum
      sql: ${googledocs_launch} ;;
      group_label : "DS event metrics"
    }

    #GOOGLE-DOC
    dimension: google_docs_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' and lower(${eventcategory}) = 'google-doc' then 1 else 0 end;;
    }
    measure:google_docs_launch_sum3{
      type: sum
      sql: ${google_docs_launch} ;;
      group_label : "DS event metrics"
    }

    #YOUSEEu.QA
    dimension: youseeu_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'youseeu' then 1 else 0 end;;
    }
    measure:youseeu_launch_sum{
      type: sum
      sql: ${youseeu_launch} ;;
      group_label : "DS event metrics"
    }

    #mindapp-scenario
    dimension: mindappscenario_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'mindapp-scenario' then 1 else 0 end;;
    }
    measure:mindappscenario_launch_sum{
      type: sum
      sql: ${mindappscenario_launch} ;;
      group_label : "DS event metrics"
    }

    #studyhub.mindapp
    dimension: studyhubmindapp_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'studyhub.mindapp' then 1 else 0 end;;
    }
    measure:studyhubmindapp_launch_sum{
      type: sum
      sql: ${studyhubmindapp_launch} ;;
      group_label : "DS event metrics"
    }

    #weblinks
    dimension: weblinks_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' and lower(${eventcategory}) = 'weblinks' then 1 else 0 end;;
    }
    measure:weblinks_launch_sum{
      type: sum
      sql: ${weblinks_launch} ;;
      group_label : "DS event metrics"
    }

    #dlappdock.techconnections
    dimension: dlappdock_techconnections_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch' and lower(${eventcategory}) = 'dlappdock.techconnections' then 1 else 0 end;;
    }
    measure:dlappdock_techconnections_launch_sum{
      type: sum
      sql: ${dlappdock_techconnections_launch} ;;
      group_label : "DS event metrics"
    }


    #dlmt.iq
    dimension: dlmt_iq_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) = 'app-dock-launch' and lower(eventCategory) = 'dlmt.iq' then 1 else 0 end;;
    }
    measure:dlmt_iq_launch_sum{
      type: sum
      sql: ${dlmt_iq_launch} ;;
      group_label : "DS event metrics"
    }

    #dlmt.iq.instructortestcreator
    dimension: dlmt_iq_instructortestcreator_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch' and lower(${eventcategory}) = 'dlmt.iq.instructortestcreator' then 1 else 0 end;;
    }
    measure:dlmt_iq_instructortestcreator_launch_sum{
      type: sum
      sql: ${dlmt_iq_instructortestcreator_launch} ;;
      group_label : "DS event metrics"
    }

    #dlmt.iq.studenttestcreator
    dimension: dlmt_iq_studenttestcreator_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'dlmt.iq.studenttestcreator' then 1 else 0 end;;
    }
    measure:dlmt_iq_studenttestcreator_launch_sum{
      type: sum
      sql: ${dlmt_iq_studenttestcreator_launch} ;;
      group_label : "DS event metrics"
    }

    #connectyard.learner
    dimension: connectyardlearner_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'connectyard.learner' then 1 else 0 end;;
    }
    measure:connectyardlearner_launch_sum{
      type: sum
      sql: ${connectyardlearner_launch} ;;
      group_label : "DS event metrics"
    }

    #mindtap_instructor_resourcecenter_launch
    dimension: mindtap_instructor_resourcecenter_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'mindtapinstructorresourcecenter' then 1 else 0 end;;
    }
    measure:mindtap_instructor_resourcecenter_launch_sum{
      type: sum
      sql: ${mindtap_instructor_resourcecenter_launch} ;;
      group_label : "DS event metrics"
    }

    #questia
    dimension: questia_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch' and lower(${eventcategory}) = 'questia' then 1 else 0 end;;
    }
    measure:questia_launch_sum{
      type: sum
      sql: ${questia_launch} ;;
      group_label : "DS event metrics"
    }

    #STUDYCENTER
    dimension: studycenter_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'studycenter' then 1 else 0 end;;
    }
    measure:studycenter_launch_sum{
      type: sum
      sql: ${studycenter_launch} ;;
      group_label : "DS event metrics"
    }

    #CHEMISTRYREFERENCE
    dimension: chemistryreference_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'chemistryreference' then 1 else 0 end;;
    }
    measure:chemistryreference_launch_sum{
      type: sum
      sql: ${chemistryreference_launch} ;;
      group_label : "DS event metrics"
    }

    #OUTLINE SPEECH
    dimension: outlinespeech_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'outline.speech' then 1 else 0 end;;
    }
    measure:outlinespeech_launch_sum{
      type: sum
      sql: ${outlinespeech_launch} ;;
      group_label : "DS event metrics"
    }

    #cnow.hw_preclass_ilrn_com
    dimension: cnowhw_preclass_ilrn_com_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='app-dock-launch' and lower(${eventcategory}) = 'cnow.hw-preclass_ilrn_com' or lower(${eventcategory}) = 'cnow.hw-preclass-ilrn-com' then 1 else 0 end;;
    }
    measure:cnowhw_preclass_ilrn_com_launch_sum{
      type: sum
      sql: ${cnowhw_preclass_ilrn_com_launch} ;;
      group_label : "DS event metrics"
    }

    #WAC
    dimension: wac_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'wac' then 1 else 0 end;;
    }
    measure:wac_launch_sum{
      type: sum
      sql: ${wac_launch} ;;
      group_label : "DS event metrics"
    }

    #INSITE
    dimension: insite_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch' and lower(${eventcategory}) = 'insite' then 1 else 0 end;;
    }
    measure:insite_launch_sum{
      type: sum
      sql: ${insite_launch} ;;
      group_label : "DS event metrics"
    }

    #ATP
    dimension: atp_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch' and lower(${eventcategory}) = 'atp' then 1 else 0 end;;
    }
    measure:atp_launch_sum{
      type: sum
      sql: ${atp_launch} ;;
      group_label : "DS event metrics"
    }

    #POLLING
    dimension: polling_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch' and lower(${eventcategory}) = 'polling' then 1 else 0 end;;
    }
    measure:polling_launch_sum{
      type: sum
      sql: ${polling_launch} ;;
      group_label : "DS event metrics"
    }

    #diet.wellnes.plus
    dimension: diet_wellnes_plus_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'diet.wellnes.plus' then 1 else 0 end;;
    }
    measure:diet_wellnes_plus_launch_sum{
      type: sum
      sql: ${diet_wellnes_plus_launch} ;;
      group_label : "DS event metrics"
    }

    #MINDAPP-EPORTFOLIO
    dimension: mindapp_eportfolio_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'mindapp-eportfolio' then 1 else 0 end;;
    }
    measure:mindapp_eportfolio_launch_sum{
      type: sum
      sql: ${mindapp_eportfolio_launch} ;;
      group_label : "DS event metrics"
    }

    #SYSTEMCHECK
    dimension: systemcheck_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'systemcheck' then 1 else 0 end;;
    }
    measure:systemcheck_launch_sum{
      type: sum
      sql: ${systemcheck_launch} ;;
      group_label : "DS event metrics"
    }

    #MINDAPP RESOURCE VIEWER
    dimension: mindapp_resource_viewer_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='app-dock-launch' and lower(${eventcategory}) = 'mindapp.resource.viewer' then 1 else 0 end ;;
    }
    measure:mindapp_resource_viewer_launch_sum{
      type: sum
      sql: ${mindapp_resource_viewer_launch} ;;
      group_label : "DS event metrics"
    }

    #DASHBOARD NAVIGATION
    dimension: dashboard_navigation {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='unknown' and lower(${eventcategory}) = 'dashboard' then 1 else 0 end;;
    }
    measure:dashboard_navigation_sum{
      type: sum
      sql: ${dashboard_navigation} ;;
      group_label : "DS event metrics"
    }

    #ONEDRIVE
    dimension: onedrive_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'onedrive' then 1 else 0 end ;;
    }
    measure:onedrive_launch_sum{
      type: sum
      sql: ${onedrive_launch} ;;
      group_label : "DS event metrics"
    }

    #FAQ
    dimension: faq_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch' and lower(${eventcategory}) = 'faq' then 1 else 0 end;;
    }
    measure:faq_launch_sum{
      type: sum
      sql: ${faq_launch} ;;
      group_label : "DS event metrics"
    }

    #BLOG
    dimension: blog_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch' and lower(${eventcategory}) = 'blog' then 1 else 0 end;;
    }
    measure:blog_launch_sum{
      type: sum
      sql: ${blog_launch} ;;
      group_label : "DS event metrics"
    }


    ##ACTIVITY
    dimension: rssfeed_activity_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) = 'launch' and ${activityuri} is not null and split_part(${activityuri}, ':', 3) = 'RSS Feed' then 1 else 0 end;;
    }
    measure:rssfeed_activity_launch_sum{
      type: sum
      sql: ${rssfeed_activity_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: studyguide_activity_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) = 'launch' and ${activityuri} is not null and split_part(${activityuri}, ':', 3) = 'study guide' then 1 else 0 end;;
    }
    measure:studyguide_activity_launch_sum{
      type: sum
      sql: ${studyguide_activity_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: studyguide_activity_view {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'view' and ${activityuri} is not null and split_part(${activityuri}, ':', 3) = 'study guide' then 1 else 0 end;;
    }
    measure:studyguide_activity_view_sum{
      type: sum
      sql: ${studyguide_activity_view} ;;
      group_label : "DS event metrics"
    }

    dimension: homework_activity_launch {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'launch' and ${activityuri} is not null and split_part(${activityuri}, ':', 3) = 'homework' then 1 else 0 end;;
    }
    measure:homework_activity_launch_sum{
      type: sum
      sql: ${homework_activity_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: homework_activity_view {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'view' and ${activityuri} is not null and split_part(${activityuri}, ':', 3) = 'homework' then 1 else 0 end;;
    }
    measure:homework_activity_view_sum{
      type: sum
      sql: ${homework_activity_view} ;;
      group_label : "DS event metrics"
    }

    dimension: media_activity_launch {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'launch' and ${activityuri} is not null and split_part(${activityuri}, ':', 3) = 'media' then 1 else 0 end;;
    }
    measure:media_activity_launch_sum{
      type: sum
      sql: ${media_activity_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: weblinks_activity_launch {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'launch' and ${activityuri} is not null and split_part(${activityuri}, ':', 3) = 'web links' then 1 else 0 end;;
    }
    measure:weblinks_activity_launch_sum{
      type: sum
      sql: ${weblinks_activity_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: googledocs_activity_launch {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'launch' and ${activityuri} is not null and split_part(${activityuri}, ':', 3) = 'google docs' then 1 else 0 end;;
    }
    measure:googledocs_activity_launch_sum{
      type: sum
      sql: ${googledocs_activity_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: flashcards_activity_launch {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'launch' and ${activityuri} is not null and split_part(${activityuri}, ':', 3) = 'flash-cards' then 1 else 0 end;;
    }
    measure:flashcards_activity_launch_sum{
      type: sum
      sql: ${flashcards_activity_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: assessment_activity_launch {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'launch' and ${activityuri} is not null and split_part(${activityuri}, ':', 3) = 'assessment' then 1 else 0 end;;
    }
    measure:assessment_activity_launch_sum{
      type: sum
      sql: ${assessment_activity_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: assessment_activity_view {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'view' and ${activityuri} is not null and split_part(${activityuri}, ':', 3) = 'assessment' then 1 else 0 end;;
    }
    measure:assessment_activity_view_sum{
      type: sum
      sql: ${assessment_activity_view} ;;
      group_label : "DS event metrics"
    }

    dimension: reading_activity_launch {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'launch' and ${activityuri} is not null and split_part(${activityuri}, ':', 3) = 'reading' then 1 else 0 end;;
    }
    measure:reading_activity_launch_sum{
      type: sum
      sql: ${reading_activity_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: reading_activity_view {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'view' and ${activityuri} is not null and split_part(${activityuri}, ':', 3) = 'reading' then 1 else 0 end ;;
    }
    measure:reading_activity_view_sum{
      type: sum
      sql: ${reading_activity_view} ;;
      group_label : "DS event metrics"
    }

    dimension: other_activity_launch {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'launch' and ${activityuri} is not null and split_part(${activityuri}, ':', 3) = 'other' then 1 else 0 end;;
    }
    measure:other_activity_launch_sum{
      type: sum
      sql: ${other_activity_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: other_activity_view {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'view' and ${activityuri} is not null and split_part(${activityuri}, ':', 3) = 'other' then 1 else 0 end;;
    }
    measure:other_activity_view_sum{
      type: sum
      sql: ${other_activity_view} ;;
      group_label : "DS event metrics"
    }

    dimension: generated_folder_activity {
      hidden: yes
      type: number
      sql: case when lower(${eventaction}) = 'launch' and ${activityuri} is not null and split_part(${activityuri}, ':', 3) = 'generated' then 1 else 0 end;;
    }
    measure:generated_folder_activity_sum{
      type: sum
      sql: ${generated_folder_activity} ;;
      group_label : "DS event metrics"
    }

    #activity-builder
    dimension: activitybuilder_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' and lower(${eventcategory}) = 'activity-builder' then 1 else 0 end;;
    }
    measure:activitybuilder_launch_sum{
      type: sum
      sql: ${activitybuilder_launch} ;;
      group_label : "DS event metrics"
    }

    #diet analysis plus
    dimension: diet_analysis_plus_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'diet.analysis.plus' then 1 else 0 end;;
    }
    measure:diet_analysis_plus_launch_sum{
      type: sum
      sql: ${diet_analysis_plus_launch} ;;
      group_label : "DS event metrics"
    }

    #profile plus
    dimension: profile_plus_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch' and lower(${eventcategory}) = 'profile.plus' then 1 else 0 end ;;
    }
    measure:profile_plus_launch_sum{
      type: sum
      sql: ${profile_plus_launch} ;;
      group_label : "DS event metrics"
    }

    #INAPPPURCHASE
    dimension: inapppurchase_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch' and lower(${eventcategory}) = 'inapppurchase' then 1 else 0 end;;
    }
    measure:inapppurchase_launch_sum{
      type: sum
      sql: ${inapppurchase_launch} ;;
      group_label : "DS event metrics"
    }

    #COMPOSITION
    dimension: composition_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='app-dock-launch' and lower(${eventcategory}) = 'composition' then 1 else 0 end;;
    }
    measure:composition_launch_sum{
      type: sum
      sql: ${composition_launch} ;;
      group_label : "DS event metrics"
    }

    #HISTORY-CONCEPTMAP.ACTIVITY
    dimension: history_conceptmapactivity_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'history-conceptmap.activity' then 1 else 0 end;;
    }
    measure:history_conceptmapactivity_launch_sum{
      type: sum
      sql: ${history_conceptmapactivity_launch} ;;
      group_label : "DS event metrics"
    }

    #LAMS
    dimension: lams_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'lams' then 1 else 0 end;;
    }
    measure:lams_launch_sum{
      type: sum
      sql: ${lams_launch} ;;
      group_label : "DS event metrics"
    }

    #LAMS-V2
    dimension: lams_v2_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) = 'app-dock-launch' and lower(${eventcategory}) = 'lams-v2' then 1 else 0 end;;
    }
    measure:lams_v2_launch_sum{
      type: sum
      sql: ${lams_v2_launch} ;;
      group_label : "DS event metrics"
    }

    #GLOSSARY-SHOW2
    dimension: glossary_show2 {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='glossary-show' and lower(${eventcategory}) = 'glossary-show' then 1 else 0 end;;
    }
    measure:glossary_show_sum2{
      type: sum
      sql: ${glossary_show2} ;;
      group_label : "DS event metrics"
    }

    dimension: create_glossary_show {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='create-glossary-show' and lower(${eventcategory}) = 'glossary-show' then 1 else 0 end  ;;
    }
    measure:create_glossary_show_sum{
      type: sum
      sql: ${create_glossary_show} ;;
      group_label : "DS event metrics"
    }


    #OUTLINE COMPOSITION
    dimension: outline_composition_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'outline.composition' then 1 else 0 end;;
    }
    measure:outline_composition_launch_sum{
      type: sum
      sql: ${outline_composition_launch} ;;
      group_label : "DS event metrics"
    }

    #OTHERS
    dimension: other_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' and lower(${eventcategory}) = 'other' then 1 else 0 end;;
    }
    measure:other_launch_sum{
      type: sum
      sql: ${other_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: other_activity_submitted {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='activity-submitted' and lower(${eventcategory}) = 'other' then 1 else 0 end;;
    }
    measure:other_activity_submitted_sum{
      type: sum
      sql: ${other_activity_submitted} ;;
      group_label : "DS event metrics"
    }


    #LAUNCHES
    dimension: assignment_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch assignment' and lower(${eventcategory}) = 'launch' then 1 else 0 end;;
    }
    measure:assignment_launch_sum{
      type: sum
      sql: ${assignment_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: assignment_learning_burst_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch assignment from learning burst' and lower(${eventcategory}) = 'launch' then 1 else 0 end ;;
    }
    measure:assignment_learning_burst_launch_sum{
      type: sum
      sql: ${assignment_learning_burst_launch} ;;
      group_label : "DS event metrics"
    }
    dimension: exerciseset_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch exercise set' and lower(${eventcategory}) = 'launch' then 1 else 0 end;;
    }
    measure:exerciseset_launch_sum{
      type: sum
      sql: ${exerciseset_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: mediaquiz_learning_burst_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch media quiz from learning burst' and lower(${eventcategory}) = 'launch' then 1 else 0 end ;;
    }
    measure:mediaquiz_learning_burst_launch_sum{
      type: sum
      sql: ${mediaquiz_learning_burst_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: class_skills_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch class skills' and lower(${eventcategory}) = 'launch' then 1 else 0 end ;;
    }
    measure:class_skills_launch_sum{
      type: sum
      sql: ${class_skills_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: textsnippet_learning_burst_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch text snippet from learning burst' and lower(${eventcategory}) = 'launch' then 1 else 0 end ;;
    }
    measure:textsnippet_learning_burst_launch_sum{
      type: sum
      sql: ${textsnippet_learning_burst_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: gradebook_launches {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch gradebook' and lower(${eventcategory}) = 'launch' then 1 else 0 end ;;
    }
    measure:gradebook_launches_sum{
      type: sum
      sql: ${gradebook_launches} ;;
      group_label : "DS event metrics"
    }

    dimension: quiz_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch quiz' and lower(${eventcategory}) = 'launch' then 1 else 0 end ;;
    }
    measure:quiz_launch_sum{
      type: sum
      sql: ${quiz_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: exerciseset_learning_burst_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch exercise set learning burst' and lower(${eventcategory}) = 'launch' then 1 else 0 end ;;
    }
    measure:exerciseset_learning_burst_launch_sum{
      type: sum
      sql: ${exerciseset_learning_burst_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: pred_reportactivity_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch pred report activity' and lower(${eventcategory}) = 'launch' then 1 else 0 end ;;
    }
    measure:pred_reportactivity_launch_sum{
      type: sum
      sql: ${pred_reportactivity_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: gameactivity_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch game activity' and lower(${eventcategory}) = 'launch' then 1 else 0 end ;;
    }
    measure:gameactivity_launch_sum{
      type: sum
      sql: ${gameactivity_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: mediaquiz_activity_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch media quiz activity' and lower(${eventcategory}) = 'launch' then 1 else 0 end ;;
    }
    measure:mediaquiz_activity_launch_sum{
      type: sum
      sql: ${mediaquiz_activity_launch} ;;
      group_label : "DS event metrics"
    }

    dimension: game_learning_burst_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch game from learning burst' and lower(${eventcategory}) = 'launch' then 1 else 0 end ;;
    }
    measure:game_learning_burst_launch_sum{
      type: sum
      sql: ${game_learning_burst_launch} ;;
      group_label : "DS event metrics"
    }

    #VIDEO CAPTURE
    dimension: videocapture_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'videocapture' then 1 else 0 end ;;
    }
    measure:videocapture_launch_sum{
      type: sum
      sql: ${videocapture_launch} ;;
      group_label : "DS event metrics"
    }

    #APLIMOBILE
    dimension: apliamobile_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch' and lower(${eventcategory}) = 'apliamobile' then 1 else 0 end;;
    }
    measure:apliamobile_launch_sum{
      type: sum
      sql: ${apliamobile_launch} ;;
      group_label : "DS event metrics"
    }

    #aplia
    dimension: aplia_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'aplia' then 1 else 0 end;;
    }
    measure:aplia_launch_sum{
      type: sum
      sql: ${aplia_launch} ;;
      group_label : "DS event metrics"
    }

    #alg
    dimension: alg_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'alg' then 1 else 0 end;;
    }
    measure:alg_launch_sum{
      type: sum
      sql: ${alg_launch} ;;
      group_label : "DS event metrics"
    }

    #cnow.hw
    dimension: cnowhw_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'cnow.hw' then 1 else 0 end ;;
    }
    measure:cnowhw_launch_sum{
      type: sum
      sql: ${cnowhw_launch} ;;
      group_label : "DS event metrics"
    }

    #MTSTUDYCENTER.MINDAPP
    dimension: mtstudycentermindapp_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='app-dock-launch' and lower(${eventcategory}) = 'mtstudycenter.mindapp' then 1 else 0 end ;;
    }
    measure:mtstudycentermindapp_launch_sum{
      type: sum
      sql: ${mtstudycentermindapp_launch} ;;
      group_label : "DS event metrics"
    }

    #SYSTEM+SETUP
    dimension: systemsetup_interacted {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='interacted' and lower(${eventcategory}) = 'system+setup' then 1 else 0 end ;;
    }
    measure:systemsetup_interacted_sum{
      type: sum
      sql: ${systemsetup_interacted} ;;
      group_label : "DS event metrics"
    }

    #system
    dimension: system_interacted {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='interacted' and lower(${eventcategory}) = 'system' then 1 else 0 end ;;
    }
    measure:system_interacted_sum{
      type: sum
      sql: ${system_interacted} ;;
      group_label : "DS event metrics"
    }

    #STUDYHUB.MT4
    dimension: studyhubmt4_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'studyhub.mt4' then 1 else 0 end;;
    }
    measure:studyhubmt4_launch_sum{
      type: sum
      sql: ${studyhubmt4_launch} ;;
      group_label : "DS event metrics"
    }


    #CEREGO
    dimension: cerego_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'cerego' then 1 else 0 end;;
    }
    measure:cerego_launch_sum{
      type: sum
      sql: ${cerego_launch} ;;
      group_label : "DS event metrics"
    }


    #nettutor6
    dimension: nettutor6_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'nettutor6' then 1 else 0 end;;
    }
    measure:nettutor6_launch_sum{
      type: sum
      sql: ${nettutor6_launch} ;;
      group_label : "DS event metrics"
    }


    #sam.appification.prod
    dimension: sam_appification_prod_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'sam.appification.prod' then 1 else 0 end;;
    }
    measure:sam_appification_prod_launch_sum{
      type: sum
      sql: ${sam_appification_prod_launch} ;;
      group_label : "DS event metrics"
    }


    #speechvideolibraryprod
    dimension: speechvideolibraryprod_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'speechvideolibraryprod' then 1 else 0 end;;
    }
    measure:speechvideolibraryprod_launch_sum{
      type: sum
      sql: ${speechvideolibraryprod_launch} ;;
      group_label : "DS event metrics"
    }

    #nettutorlti
    dimension: nettutorlti_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch'and lower(${eventcategory}) = 'nettutorlti' then 1 else 0 end;;
    }
    measure:nettutorlti_launch_sum{
      type: sum
      sql: ${nettutorlti_launch} ;;
      group_label : "DS event metrics"
    }

    #WEBASSIGN.BSPAGE
    dimension: webassignbspage_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) = 'app-dock-launch' and lower(eventCategory) = 'webassign.bspage' then 1 else 0 end;;
    }
    measure:webassignbspage_launch_sum{
      type: sum
      sql: ${webassignbspage_launch} ;;
      group_label : "DS event metrics"
    }

    #milady
    dimension: milady_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'milady' then 1 else 0 end;;
    }
    measure:milady_launch_sum{
      type: sum
      sql: ${milady_launch} ;;
      group_label : "DS event metrics"
    }

    #MILADY.PROCEDURAL.TRACKER
    dimension: milady_procedural_tracker_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'milady.procedural.tracker' then 1 else 0 end;;
    }
    measure:milady_procedural_tracker_launch_sum{
      type: sum
      sql: ${milady_procedural_tracker_launch} ;;
      group_label : "DS event metrics"
    }

    #midapp-ab
    dimension: mindapp_ab_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'mindapp-ab' then 1 else 0 end;;
    }
    measure:mindapp_ab_launch_sum{
      type: sum
      sql: ${mindapp_ab_launch} ;;
      group_label : "DS event metrics"
    }

    #mindapp-grove
    dimension: mindapp_grove_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'mindapp-grove' then 1 else 0 end;;
    }
    measure:mindapp_grove_launch_sum{
      type: sum
      sql: ${mindapp_grove_launch} ;;
      group_label : "DS event metrics"
    }

    #mindapp-office-365
    dimension: mindapp_office_365_launch {
      hidden: yes
      type: number
      sql:case when lower(${eventaction}) ='launch' or lower(${eventaction}) = 'app-dock-launch'and lower(${eventcategory}) = 'mindapp-office-365' then 1 else 0 end;;
    }
    measure:mindapp_office_365_launch_sum{
      type: sum
      sql: ${mindapp_office_365_launch} ;;
      group_label : "DS event metrics"
    }

    #CONDENSED MEASURES
    measure:  glossary_sum {
      type: number
      sql:  ${glossary_show_sum1} + ${glossary_show_sum2} ;;
      group_label: "DS event metrics"

    }

    measure:  studyguide_launch_sum {
      type: number
      sql:  ${studyguide_launch_sum1} + ${studyguide_sum} ;;
      group_label: "DS event metrics"

    }

    measure: googledocs_launch_sum {
      type: number
      group_label: "DS event metrics"
      sql: ${googledoc_launch_sum1} + ${googledocs_launch_sum2} + ${google_docs_launch_sum3} ;;
    }

#     dimension: reading_page_view {
#       type: number
#       sql: ${datalayer_json}:readingPageView::string::int+1 ;;
#     }

#TODO calculate measures max_page_viewed, max_total_pages, actual_pages_viewed, page_reread_ratio
    # measure: total_pages_viewed {
    #   type: count
    #   sql: ${reading_page_view} ;;
    # }
    #we are assuming that pages viewed are read?
    # measure: total_pages_read {
    #   type: max
    #   sql: ${reading_page_view} ;;
    # }

  # measure: total_pages {
  #   type: sum
  #   sql: ${reading_page_count} ;;

  # }



#     dimension: reading_page_count {
#       type: number
#       sql: ${datalayer_json}:readingPageCount ;;
#     }

  measure: count {
    type: count
    drill_fields: [productplatform, visit_start_time, hits_time, hits_hitnumber, eventaction, eventcategory, datalayer_json, url]
  }
}
