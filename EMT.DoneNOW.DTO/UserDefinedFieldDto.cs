using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 用户自定义字段
    /// </summary>
    [Serializable]
    [DataContract]
    public class UserDefinedFieldDto
    {
        [DataMember]
        public int id;              // 字段id
        public string col_name;     // 字段名
        [DataMember]
        public string name;         // 字段显示名
        [DataMember]
        public int cate;            // 对象类型(客户、联系人等)
        [DataMember]
        public int data_type;       // 字段类型(单行文本、列表等)
        [DataMember]
        public int? display_format; // 显示样式(单行、多行等)
        [DataMember]
        public SByte required;      // 是否必填
        [DataMember]
        public int? decimal_length; // 小数位数
        [DataMember]
        public string default_value;// 默认值
        [DataMember]
        public string description;  // 字段描述
        [DataMember]
        public List<DictionaryEntryDto> value_list;   // 字段类型为列表时的列表键值
    }
}
