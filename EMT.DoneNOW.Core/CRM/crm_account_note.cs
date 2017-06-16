using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace EMT.DoneNOW.Core
{
    [Table("crm_account_note")]
    [Serializable]
    public partial class crm_account_note
    {

        [Key]
        [Column("id")]
        public Int64 id { get; set; }
        [Column("external_id")]
        public String external_id { get; set; }
        [Column("account_id")]
        public Int64 account_id { get; set; }
        [Column("contact_id")]
        public Int64? contact_id { get; set; }
        [Column("assigned_to_id")]
        public Int64? assigned_to_id { get; set; }
        [Column("proposal_id")]
        public Int64? proposal_id { get; set; }
        [Column("classification_id")]
        public Int32? classification_id { get; set; }
        [Column("action_type")]
        public Int32 action_type { get; set; }
        [Column("type_value")]
        public Int32 type_value { get; set; }
        [Column("status")]
        public Int32? status { get; set; }
        [Column("start_date")]
        public Int64 start_date { get; set; }
        [Column("end_date")]
        public Int64? end_date { get; set; }
        [Column("date_completed")]
        public Int64? date_completed { get; set; }
        [Column("name")]
        public String name { get; set; }
        [Column("detail")]
        public String detail { get; set; }
        [Column("priority")]
        public Int32 priority { get; set; }
        [Column("date_stamp")]
        public DateTime date_stamp { get; set; }
        [Column("create_date")]
        public DateTime create_date { get; set; }
        [Column("task_id")]
        public Int64? task_id { get; set; }
        [Column("contract_id")]
        public Int64? contract_id { get; set; }
        [Column("parent_crm_note_id")]
        public Int64? parent_crm_note_id { get; set; }
        [Column("parent_attachment_id")]
        public Int64? parent_attachment_id { get; set; }
        [Column("sales_order_id")]
        public Int64? sales_order_id { get; set; }
        [Column("create_time")]
        public Int64? create_time { get; set; }
        [Column("create_by_id")]
        public Int64? create_by_id { get; set; }
        [Column("update_time")]
        public Int64? update_time { get; set; }
        [Column("update_by_id")]
        public Int64? update_by_id { get; set; }
        [Column("delete_time")]
        public Int64? delete_time { get; set; }
        [Column("delete_by_id")]
        public Int64? delete_by_id { get; set; }


    }
}
