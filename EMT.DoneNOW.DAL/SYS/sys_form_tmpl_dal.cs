using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sys_form_tmpl_dal : BaseDAL<sys_form_tmpl>
    {
        /// <summary>
        /// 比较两个对象的属性，记录不同的属性及属性值
        /// </summary>
        /// <param name="oldObj"></param>
        /// <param name="newObj"></param>
        /// <returns></returns>
        public string UpdateDetail(sys_form_tmpl oldObj, sys_form_tmpl newObj)
        {
            if (oldObj == null || newObj == null)
                return null;
            List<ObjUpdateDto> list = new List<ObjUpdateDto>();
            if (!Object.Equals(oldObj.id, newObj.id))
                list.Add(new ObjUpdateDto { field = "id", old_val = oldObj.id, new_val = newObj.id });
            if (!Object.Equals(oldObj.form_type_id, newObj.form_type_id))
                list.Add(new ObjUpdateDto { field = "form_type_id", old_val = oldObj.form_type_id, new_val = newObj.form_type_id });
            if (!Object.Equals(oldObj.tmpl_name, newObj.tmpl_name))
                list.Add(new ObjUpdateDto { field = "tmpl_name", old_val = oldObj.tmpl_name, new_val = newObj.tmpl_name });
            if (!Object.Equals(oldObj.speed_code, newObj.speed_code))
                list.Add(new ObjUpdateDto { field = "speed_code", old_val = oldObj.speed_code, new_val = newObj.speed_code });
            if (!Object.Equals(oldObj.tmpl_is_active, newObj.tmpl_is_active))
                list.Add(new ObjUpdateDto { field = "tmpl_is_active", old_val = oldObj.tmpl_is_active, new_val = newObj.tmpl_is_active });
            if (!Object.Equals(oldObj.remark, newObj.remark))
                list.Add(new ObjUpdateDto { field = "remark", old_val = oldObj.remark, new_val = newObj.remark });
            if (!Object.Equals(oldObj.range_type_id, newObj.range_type_id))
                list.Add(new ObjUpdateDto { field = "range_type_id", old_val = oldObj.range_type_id, new_val = newObj.range_type_id });
            if (!Object.Equals(oldObj.range_department_id, newObj.range_department_id))
                list.Add(new ObjUpdateDto { field = "range_department_id", old_val = oldObj.range_department_id, new_val = newObj.range_department_id });
            if (list.Count == 0)
                return "";
            return new Tools.Serialize().SerializeJson(list);
        }
    }

}
