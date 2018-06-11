using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.BLL
{
    public class CheckListBLL
    {
        sys_checklist_dal scDal = new sys_checklist_dal();
        sys_checklist_lib_dal sclDal = new sys_checklist_lib_dal();
        /// <summary>
        /// 获取检查单库
        /// </summary>
        public sys_checklist_lib GetLib(long id)
        {
            return sclDal.FindNoDeleteById(id);
        }
        /// <summary>
        /// 获取相关检查单
        /// </summary>
        public List<sys_checklist> GetCheckList(long libId)
        {
            return scDal.FindListBySql($"SELECT * from sys_checklist  where checklist_lib_id = {libId} and delete_time = 0 ORDER BY sort_order ");
        }
        /// <summary>
        /// 新增
        /// </summary>
        public bool AddCheckLib(sys_checklist_lib lib, List<CheckListDto> ckList, long userId)
        {
            lib.id = sclDal.GetNextIdCom();
            lib.create_time = lib.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            lib.create_user_id = lib.update_user_id = userId;
            sclDal.Insert(lib);
            // OperLogBLL.OperLogAdd<d_change_board>(board, board.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CHANGE_BOARD, "");
            CheckManage(ckList,lib.id,userId);
            return true;
        }
        /// <summary>
        /// 编辑
        /// </summary>
        public bool EditCheckLib(sys_checklist_lib lib, List<CheckListDto> ckList, long userId)
        {
            sys_checklist_lib oldLib = GetLib(lib.id);
            if (oldLib == null)
                return false;
            lib.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            lib.update_user_id = userId;
            sclDal.Update(lib);
            CheckManage(ckList, lib.id, userId);
            return true;
        }

        /// <summary>
        /// 检查单管理
        /// </summary>
        public void CheckManage(List<CheckListDto> ckList, long libId, long userId)
        {
            var thisLib = sclDal.FindNoDeleteById(libId);
            if (thisLib == null)
                return;
            var oldCheckList = GetCheckList(libId);
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            if (oldCheckList != null && oldCheckList.Count > 0)
            {
                if (ckList != null && ckList.Count > 0)
                {
                    var editList = ckList.Where(_ => _.ckId > 0).ToList();
                    var addList = ckList.Where(_ => _.ckId < 0).ToList();
                    if (editList != null && editList.Count > 0)
                    {
                        foreach (var thisEnt in editList)
                        {
                            var oldThisEdit = oldCheckList.FirstOrDefault(_ => _.id == thisEnt.ckId);
                            var thisEdit = scDal.FindNoDeleteById(thisEnt.ckId);
                            if (oldThisEdit != null && thisEdit != null)
                            {
                                oldCheckList.Remove(oldThisEdit);
                                //thisEdit.is_competed = (sbyte)(thisEnt.isComplete ? 1 : 0);
                                thisEdit.is_important = (sbyte)(thisEnt.isImport ? 1 : 0);
                                thisEdit.item_name = thisEnt.itemName;
                                thisEdit.kb_article_id = thisEnt.realKnowId;
                                thisEdit.sort_order = thisEnt.sortOrder;
                                thisEdit.update_user_id = userId;
                                thisEdit.update_time = timeNow;
                                scDal.Update(thisEdit);
                                //OperLogBLL.OperLogUpdate<sdk_task_checklist>(thisEdit, oldThisEdit, thisEdit.id, userId, OPER_LOG_OBJ_CATE.TICKET_CHECK_LIST, "修改检查单信息");
                            }
                        }
                    }
                    if (addList != null && addList.Count > 0)
                    {
                        foreach (var thisEnt in addList)
                        {
                            var thisCheck = new sys_checklist()
                            {
                                id = scDal.GetNextIdCom(),
                                //is_competed = (sbyte)(thisEnt.isComplete ? 1 : 0),
                                is_important = (sbyte)(thisEnt.isImport ? 1 : 0),
                                item_name = thisEnt.itemName,
                                kb_article_id = thisEnt.realKnowId,
                                update_user_id = userId,
                                update_time = timeNow,
                                create_time = timeNow,
                                create_user_id = userId,
                                //task_id = ticketId,
                                sort_order = thisEnt.sortOrder,
                                checklist_lib_id =libId,
                            };
                            scDal.Insert(thisCheck);
                            //OperLogBLL.OperLogAdd<sdk_task_checklist>(thisCheck, thisCheck.id, userId, OPER_LOG_OBJ_CATE.TICKET_CHECK_LIST, "新增检查单信息");
                        }
                    }
                }
                if (oldCheckList.Count > 0)
                {
                    oldCheckList.ForEach(_ =>
                    {
                        scDal.SoftDelete(_, userId);
                        //OperLogBLL.OperLogDelete<sdk_task_checklist>(_, _.id, userId, OPER_LOG_OBJ_CATE.TICKET_CHECK_LIST, "删除检查单信息");
                    });
                }
            }
            else
            {
                if (ckList != null && ckList.Count > 0)
                {
                    foreach (var thisEnt in ckList)
                    {
                        var thisCheck = new sys_checklist()
                        {
                            id = scDal.GetNextIdCom(),
                            //is_competed = (sbyte)(thisEnt.isComplete ? 1 : 0),
                            is_important = (sbyte)(thisEnt.isImport ? 1 : 0),
                            item_name = thisEnt.itemName,
                            kb_article_id = thisEnt.realKnowId,
                            update_user_id = userId,
                            update_time = timeNow,
                            create_time = timeNow,
                            create_user_id = userId,
                            //task_id = ticketId,
                            sort_order = thisEnt.sortOrder,
                            checklist_lib_id = libId,
                        };
                        scDal.Insert(thisCheck);
                        //OperLogBLL.OperLogAdd<sdk_task_checklist>(thisCheck, thisCheck.id, userId, OPER_LOG_OBJ_CATE.TICKET_CHECK_LIST, "新增检查单信息");
                    }
                }
            }
        }

        /// <summary>
        /// 激活/失活 检查单库
        /// </summary>
        public bool ActivLib(long bId, long userId, bool isActive)
        {
            sys_checklist_lib thisLib = GetLib(bId);
            if (thisLib == null)
                return false;
            sbyte thisActive = (sbyte)(isActive ? 1 : 0);
            if (thisLib.is_active != thisActive)
            {
                var oldBoard = GetLib(bId);
                thisLib.is_active = thisActive;
                thisLib.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                thisLib.update_user_id = userId;
                sclDal.Update(thisLib);
            }
            return true;
        }
        /// <summary>
        /// 删除 检查单库
        /// </summary>
        public bool DeleteBoard(long bId, long userId, ref string faileReason)
        {
            sys_checklist_lib thisLib = GetLib(bId);
            if (thisLib == null)
                return false;
            thisLib.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            thisLib.delete_user_id = userId;
            EditCheckLib(thisLib, null, userId);
      
            return true;
        }

        /// <summary>
        /// 复制检查单库
        /// </summary>
        public bool CopyLib(long id,long userId)
        {
            sys_checklist_lib thisLib = GetLib(id);
            if (thisLib == null)
                return false;
            thisLib.name += "(复制)";
            AddCheckLib(thisLib,null,userId);

            var checkList = GetCheckList(id);
            if(checkList!=null&& checkList.Count > 0)
            {
                checkList.ForEach(_ => {
                    _.checklist_lib_id = thisLib.id;
                    _.id = scDal.GetNextIdCom();
                    _.create_time = _.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    _.create_user_id = _.update_user_id = userId;
                    scDal.Insert(_);
                });
            }
            return true;
        }
    }
}
