﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.DTO
{
    public class ContactAddAndUpdateDto
    {
        public crm_contact contact;                 // 联系人信息
        public List<UserDefinedFieldValue> udf;     // 联系人扩展信息
        public string company_name;                 // 客户名称
        public crm_location location;               // 联系人地址
        public crm_location location2;              // 联系人备用地址
    }
}
