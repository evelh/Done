using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.BLL
{
    public class SLABLL
    {
        private d_sla_dal _dal = new d_sla_dal();
        /// <summary>
        /// 根据名称获取SLA
        /// </summary>
        public d_sla GetSlaByName(string name)=> _dal.FindSignleBySql<d_sla>($"SELECT * from d_sla where delete_time = 0 and name = '{name}'");
        /// <summary>
        /// 根据Id 获取SLA
        /// </summary>
        public d_sla GetSlaById(long Id)=> _dal.FindNoDeleteById(Id);
        /// <summary>
        /// 检查SLA名称是否存在
        /// </summary>
        public bool CheckExist(string name,long id)
        {
            if (string.IsNullOrEmpty(name))
                return false;
            d_sla thisSla = GetSlaByName(name);
            if (thisSla != null && thisSla.id != id)
                return false;
            return true;
        }
        /// <summary>
        /// 添加SLA
        /// </summary>
        public bool AddSLA(d_sla sla,long userId)
        {
            if (!CheckExist(sla.name, sla.id))
                return false;
            sla.id = _dal.GetNextIdCom();
            sla.create_time = sla.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            sla.create_user_id = sla.update_user_id = userId;
            _dal.Insert(sla);
            SLAHoursManage(sla.id,null,userId);
            return true;
        }
        /// <summary>
        /// 编辑SLA
        /// </summary>
        public bool EditSLA(d_sla sla, long userId)
        {
            if (!CheckExist(sla.name, sla.id))
                return false;
            sla.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            sla.update_user_id = userId;
            _dal.Update(sla);

            return true;
        }
        /// <summary>
        /// 编辑SLA
        /// </summary>
        public bool EditSLA(d_sla sla, List<sys_organization_location_workhours> hoursList, long userId)
        {
            if (EditSLA(sla,userId))
            {
                SLAHoursManage(sla.id, hoursList, userId);
                return true;
            }
            return false;
        }
        /// <summary>
        /// 激活SLA
        /// </summary>
        public bool ActiveSLA(long id,bool isActive,long userId)
        {
            var thisSLA = GetSlaById(id);
            if (thisSLA == null)
                return false;
            sbyte act = (sbyte)(isActive?1:0);
            if(thisSLA.is_active != act)
            {
                thisSLA.is_active = act;
                EditSLA(thisSLA,userId);
            }
            return true;
        }
        /// <summary>
        /// 删除SLA
        /// </summary>
        public bool DeleteSLA(long id,long userId,ref string reason)
        {
            var sla = GetSlaById(id);
            if (sla == null)
            {
                reason = "SLA已经删除";return false;
            }
            var ticketList = _dal.FindListBySql<sdk_task>($"SELECT * from sdk_task where delete_time =0 and sla_id ={id}");
            if (ticketList != null && ticketList.Count > 0)
            {
                reason = "SLA被工单，合同，服务或服务包引用，不能删除！"; return false;
            }
            var contractList = _dal.FindListBySql<ctt_contract>($"SELECT * from ctt_contract where delete_time =0 and sla_id ={id}");
            if (contractList != null && contractList.Count > 0)
            {
                reason = "SLA被工单，合同，服务或服务包引用，不能删除！"; return false;
            }
            var serviceList = _dal.FindListBySql<ivt_service>($"SELECT * from ivt_service where delete_time =0 and sla_id ={id}");
            if (serviceList != null && serviceList.Count > 0)
            {
                reason = "SLA被工单，合同，服务或服务包引用，不能删除！"; return false;
            }
            var serviceBunList = _dal.FindListBySql<ivt_service_bundle>($"SELECT * from ivt_service_bundle where delete_time =0 and sla_id ={id}");
            if (serviceBunList != null && serviceBunList.Count > 0)
            {
                reason = "SLA被工单，合同，服务或服务包引用，不能删除！"; return false;
            }

            _dal.SoftDelete(sla,userId);
            return true;
        }


        /// <summary>
        /// SLA 时间管理
        /// </summary>
        public void SLAHoursManage(long slaId, List<sys_organization_location_workhours> hoursList, long user_id)
        {
            sys_organization_location_workhours_dal solwDal = new sys_organization_location_workhours_dal();
            long timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp();
            if (hoursList != null && hoursList.Count > 0)
            {
                foreach (var hours in hoursList)
                {
                    hours.update_time = timeNow;
                    hours.update_user_id = user_id;
                    solwDal.Update(hours);
                }
            }
            else
            {
                for (int i = 1; i < 8; i++)
                {
                    sys_organization_location_workhours hours = new sys_organization_location_workhours()
                    {
                        id = solwDal.GetNextIdCom(),
                        create_time = timeNow,
                        update_time = timeNow,
                        create_user_id = user_id,
                        update_user_id = user_id,
                        sla_id = slaId,
                        weekday = (sbyte)(i == 7 ? 0 : i),
                        start_time = (i == 7 || i == 6) ? "" : "09:00",
                        end_time = (i == 7 || i == 6) ? "" : "18:00",
                    };
                    solwDal.Insert(hours);
                }
            }
        }

        /// <summary>
        /// 根据SLA获取相关时间
        /// </summary>
        public List<sys_organization_location_workhours> GetWorkHourList(long id) =>  _dal.FindListBySql<sys_organization_location_workhours>($"SELECT * from sys_organization_location_workhours where delete_time = 0 and sla_id = {id} order by id");
        
        /// <summary>
        /// 根据SLA 获取相关条目
        /// </summary>
        public List<d_sla_item> GetSLAItem(long slaId) => _dal.FindListBySql<d_sla_item>($"SELECT * from d_sla_item  where delete_time = 0 and sla_id = {slaId}");
        /// <summary>
        /// 根据条目Id 获取相关SLA 条目
        /// </summary>
        public d_sla_item GetSLAItemById(long slaItemId) => new d_sla_item_dal().FindNoDeleteById(slaItemId);
        /// <summary>
        /// 新增条目
        /// </summary>
        public bool AddItem(d_sla_item item,long userId)
        {
            d_sla_item_dal siDal = new d_sla_item_dal();
            item.id = siDal.GetNextIdCom();
            item.create_time = item.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            item.create_user_id = item.update_user_id = userId;
            siDal.Insert(item);
            return true;
        }

        /// <summary>
        /// 编辑条目
        /// </summary>
        public bool EditItem(d_sla_item item, long userId)
        {
            d_sla_item_dal siDal = new d_sla_item_dal();
            var oldItem = GetSLAItemById(item.id);
            if (oldItem == null)
                return false;
            item.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            item.update_user_id = userId;
            siDal.Update(item);
            return true;
        }
        /// <summary>
        /// 删除SLA条目
        /// </summary>
        public bool DeleteItem(long id ,long userId)
        {
            d_sla_item item = GetSLAItemById(id);
            if (item == null)
                return false;
            new d_sla_item_dal().SoftDelete(item,userId);
            return true;
        }

    }
}
