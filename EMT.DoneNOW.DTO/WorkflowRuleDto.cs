using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    public class WorkflowRuleDto
    {
        public Int64 id { get; set; }
        public Int64 oid { get; set; }
        public Int32 workflow_object_id { get; set; }
        public String name { get; set; }
        public String description { get; set; }
        public SByte is_active { get; set; }
        public String event_json { get; set; }
        public String condition_json { get; set; }
        public String time_json { get; set; }
        public String update_json { get; set; }
        public String action_json { get; set; }
        public String todo_json { get; set; }
        public String email_send_from { get; set; }
        public String recipient_json { get; set; }
        public Int32? notify_tmpl_id { get; set; }
        public SByte? use_default_tmpl { get; set; }
        public String notify_subject { get; set; }
        public Int32? notify_recur_every_days { get; set; }
        public Int32? notify_recur_every_hours { get; set; }
        public Int32? notify_recur_every_minutes { get; set; }
        public Int32? notify_recur_max_times { get; set; }
        public String notify_recur_update_json { get; set; }
        public Int32? note_type_id { get; set; }
        public Int32? publish_type_id { get; set; }
        public SByte? append_to_resolution { get; set; }
        public List<dynamic> eventJson { get; set; }
        public List<dynamic> conditionJson { get; set; }
        public List<dynamic> updateJson { get; set; }
        public List<dynamic> emailJson { get; set; }
    }
}
