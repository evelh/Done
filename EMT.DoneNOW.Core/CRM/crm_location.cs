using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("crm_location")]
    [Serializable]
    [DataContract]
    public partial class crm_location : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64? account_id { get; set; }
        [DataMember]
        public Int32? cate_id { get; set; }
        [DataMember]
        public String address { get; set; }
        [DataMember]
        public Int32? town_id { get; set; }
        [DataMember]
        public Int32? district_id { get; set; }
        [DataMember]
        public Int32 city_id { get; set; }
        [DataMember]
        public Int32 province_id { get; set; }
        [DataMember]
        public String postal_code { get; set; }
        [DataMember]
        public Int32? country_id { get; set; }
        [DataMember]
        public String additional_address { get; set; }
        [DataMember]
        public String location_label { get; set; }
        [DataMember]
        public SByte is_default { get; set; }

        /// <summary>
        /// test 重写下equal方法
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public override bool Equals(object obj)
        {
            crm_location p = (crm_location)obj;
            return (this.id == p.id) && (this.account_id == p.account_id) && (this.cate_id == p.cate_id) && (this.address == p.address) && (this.town_id == p.town_id) && (this.district_id == p.district_id) && (this.city_id == p.city_id) && (this.province_id == p.province_id) && (this.postal_code == p.postal_code) && (this.country_id == p.country_id) && (this.additional_address == p.additional_address) && (this.location_label == p.location_label) && (this.is_default == p.is_default);
        }
    }
}
