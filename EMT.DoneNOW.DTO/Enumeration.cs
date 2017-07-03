using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 字典表字典项对应的id值
    /// </summary>
    public enum DICTIONARY_ENUM
    {
        // 表单模板应用范围
        FORM_TEMPLATE_RANG_TYPE_OWN = 88,
        FORM_TEMPLATE_RANG_TYPE_DEPARTMENT = 89,
        FORM_TEMPLATE_RANG_TYPE_ALL = 90,

        // 表单模板类型
        /// <summary>
        /// 表单模板类型-商机
        /// </summary>
        FORM_TEMPLATE_TYPE_OPPORTUNITY = 451,

        // 表单模型操作类型 operation
        FORM_TEMPLATE_OPERATION_TYPE_ADD = 800,
        FORM_TEMPLATE_OPERATION_TYPE_DELETE = 801,
        FORM_TEMPLATE_OPERATION_TYPE_UPDATE = 802,

        // 表单模型对象种类
        FORM_TEMPLATE_OBJECT_TYPE_CUSTOMER=760,                              // 客户
        FORM_TEMPLATE_OBJECT_TYPE_CUSTOMER_EXTENSION_INFORMATION = 761,      // 客户扩展信息
        FORM_TEMPLATE_OBJECT_TYPE_CONTACTS = 762,                            // 联系人
        FORM_TEMPLATE_OBJECT_TYPE_CONTACTS_EXTENSION_INFORMATION = 763,      // 联系人扩展信息
        FORM_TEMPLATE_OBJECT_TYPE_CUSTOMER_SITE = 764,                       // 客户站点    
        FORM_TEMPLATE_OBJECT_TYPE_TODO=765,                                  // 待办



    }
}
