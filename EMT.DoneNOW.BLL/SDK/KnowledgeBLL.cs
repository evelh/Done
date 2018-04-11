using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using Newtonsoft.Json.Linq;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.BLL
{
    public class KnowledgeBLL
    {

        private sdk_kb_article_dal _dal = new sdk_kb_article_dal();
        /// <summary>
        /// 获取所有的目录相关  isAddAll 决定集合的 count
        /// </summary>
        public List<KnowledgeCateDto> GetKnowledgeCateList(bool isAddAll = true)
        {
            var knowledgeList = _dal.FindListBySql<KnowledgeCateDto>($"SELECT id,name,parent_id,(SELECT count(0) from sdk_kb_article WHERE kb_category_id=g.id AND delete_time=0) as articleCnt FROM d_general as g WHERE general_table_id={(int)GeneralTableEnum.KNOWLEDGE_BASE_CATE} and delete_time=0 ORDER BY id ASC;");

            List<KnowledgeCateDto> dtoList = new List<KnowledgeCateDto>();
            var list = from cate in knowledgeList where cate.parent_id == null select cate;
            foreach (var cate in list)
            {
                cate.leaval = 1;
                if (isAddAll)
                {
                    dtoList.Add(cate);
                    cate.nodes = GetCateNodes(knowledgeList, cate.id, cate.leaval, dtoList);
                }
                else
                {
                    dtoList.Add(cate);
                    cate.nodes =AddSubNode(cate.id);
                }
            }
            return dtoList;
        }

        private List<KnowledgeCateDto> GetCateNodes(List<KnowledgeCateDto> allCates, long id,int level,List<KnowledgeCateDto> dtoList)
        {
            var list = (from node in allCates where node.parent_id == id select node).ToList();
            if (list != null)
            {
                for(int i=0;i< list.Count;i++)
                {
                    list[i].leaval = level + 1;
                    if (dtoList.Any(_ => _.id == list[i].id))
                        continue;
                    dtoList.Add(list[i]);
                    list[i].nodes = GetCateNodes(allCates, list[i].id, level+1, dtoList);
                }
            }
            return list;
        }

        private List<KnowledgeCateDto> AddSubNode(long parentId)
        {
             var subList = _dal.FindListBySql<KnowledgeCateDto>($"SELECT id,name,parent_id,(SELECT count(0) from sdk_kb_article WHERE kb_category_id=g.id AND delete_time=0) as articleCnt FROM d_general as g WHERE general_table_id={(int)GeneralTableEnum.KNOWLEDGE_BASE_CATE} and parent_id={parentId} and delete_time=0 ORDER BY id ASC;");
            if(subList!=null&& subList.Count > 0)
            {
                foreach (var sub in subList)
                {
                    sub.nodes = AddSubNode(sub.id);
                }
            }
            return subList;
        }



        /// <summary>
        /// 知识库管理
        /// </summary>
        public bool KnowManage(KnowledgeManageDto param, long userId)
        {
            try
            {
                var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                if (param.thisArt.id == 0)
                    AddKnow(param.thisArt,userId);
                else
                    UpdateKnow(param.thisArt, userId);

                KnowTicketManage(param.thisArt.id,param.ticketId,userId);

                KnowAttManage(param.thisArt.id, param.attIds, param.filtList,userId);

            }
            catch (Exception msg)
            {
                return false;
            }
            return true;
        }
        /// <summary>
        /// 新增知识库
        /// </summary>
        public void AddKnow(sdk_kb_article thisArt,long userId)
        {
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            thisArt.id = _dal.GetNextIdCom();
            thisArt.create_time = timeNow;
            thisArt.update_time = timeNow;
            thisArt.create_user_id = userId;
            thisArt.update_user_id = userId;
            _dal.Insert(thisArt);
            OperLogBLL.OperLogAdd<sdk_kb_article>(thisArt, thisArt.id, userId, OPER_LOG_OBJ_CATE.SDK_KONWLEDGE, "新增知识库");
        }
        /// <summary>
        /// 编辑知识库
        /// </summary>
        public bool UpdateKnow(sdk_kb_article thisArt, long userId)
        {
            var oldArt = _dal.FindNoDeleteById(thisArt.id);
            if (oldArt == null)
                return false;
            thisArt.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            thisArt.update_user_id = userId;
            _dal.Update(thisArt);
            OperLogBLL.OperLogUpdate<sdk_kb_article>(thisArt,oldArt, thisArt.id, userId, OPER_LOG_OBJ_CATE.SDK_KONWLEDGE, "编辑知识库");
            return true;
        }
        /// <summary>
        /// 知识库关联工单相关管理
        /// </summary>
        public void KnowTicketManage(long artId,string ticketIds,long userId)
        {
            var oldArt = _dal.FindNoDeleteById(artId);
            if (oldArt == null)
                return;
            var stDal = new sdk_task_dal();
            var skatDal = new sdk_kb_article_ticket_dal();
            var oldTickList = skatDal.GetArtTicket(artId);
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            if (oldTickList!=null&& oldTickList.Count > 0)
            {
                if (!string.IsNullOrEmpty(ticketIds))
                {
                    var ticketArr = ticketIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (var ticketId in ticketArr)
                    {
                        var thisTicket = stDal.FindNoDeleteById(long.Parse(ticketId));
                        if (thisTicket == null)
                            continue;
                        var artTicket = oldTickList.FirstOrDefault(_ => _.kb_article_id == artId && _.task_id.ToString() == ticketId);
                        if (artTicket != null)
                            oldTickList.Remove(artTicket);
                        else
                        {
                            artTicket = new sdk_kb_article_ticket()
                            {
                                id = skatDal.GetNextIdCom(),
                                create_time = timeNow,
                                create_user_id = userId,
                                update_time = timeNow,
                                update_user_id = userId,
                                kb_article_id = artId,
                                task_id = thisTicket.id,
                                task_no = thisTicket.no,
                            };
                            skatDal.Insert(artTicket);
                            OperLogBLL.OperLogAdd<sdk_kb_article_ticket>(artTicket, artTicket.id, userId, OPER_LOG_OBJ_CATE.SDK_KONWLEDGE_TICKET, "新增知识库关联工单");
                        }
                    }
                }
                oldTickList.ForEach(_ => {
                    skatDal.SoftDelete(_,userId);
                    OperLogBLL.OperLogDelete<sdk_kb_article_ticket>(_, _.id, userId, OPER_LOG_OBJ_CATE.SDK_KONWLEDGE_TICKET, "删除知识库关联工单");
                });
            }
            else
            {
                if (!string.IsNullOrEmpty(ticketIds))
                {
                    var ticketArr = ticketIds.Split(new char[] {','},StringSplitOptions.RemoveEmptyEntries);
                    foreach (var ticketId in ticketArr)
                    {
                        var thisTicket = stDal.FindNoDeleteById(long.Parse(ticketId));
                        if (thisTicket == null)
                            continue;
                        var artTicket = new sdk_kb_article_ticket() {
                            id = skatDal.GetNextIdCom(),
                            create_time = timeNow,
                            create_user_id = userId,
                            update_time = timeNow,
                            update_user_id = userId,
                            kb_article_id = artId,
                            task_id = thisTicket.id,
                            task_no = thisTicket.no,
                        };
                        skatDal.Insert(artTicket);
                        OperLogBLL.OperLogAdd<sdk_kb_article_ticket>(artTicket, artTicket.id, userId, OPER_LOG_OBJ_CATE.SDK_KONWLEDGE_TICKET, "新增知识库关联工单");
                    }
                }
            }
        }
        /// <summary>
        /// 知识库附件管理
        /// </summary>
        public void KnowAttManage(long artId,string attIds, List<AddFileDto> filtList,long userId)
        {
            var caDal = new com_attachment_dal();
            #region 修改原附件
            var oldAttList = new com_attachment_dal().GetAttListByOid(artId);
            if (oldAttList != null && oldAttList.Count > 0)
            {
                var attIdList = attIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                foreach (var oldAtt in oldAttList)
                {
                    if (!attIdList.Any(_ => _ == oldAtt.id.ToString()))
                    {
                        caDal.SoftDelete(oldAtt, userId);
                        OperLogBLL.OperLogDelete<com_attachment>(oldAtt, oldAtt.id, userId, OPER_LOG_OBJ_CATE.ATTACHMENT, "删除备注附件");
                    }
                }
            }
            #endregion


            #region 新增附件
            if (filtList != null && filtList.Count > 0)
            {
                var attBll = new AttachmentBLL();
                foreach (var thisFile in filtList)
                {
                    if (thisFile.type_id == ((int)DicEnum.ATTACHMENT_TYPE.ATTACHMENT).ToString())
                        attBll.AddAttachment((int)ATTACHMENT_OBJECT_TYPE.KNOWLEDGE, artId, (int)DicEnum.ATTACHMENT_TYPE.ATTACHMENT, thisFile.new_filename, "", thisFile.old_filename, thisFile.fileSaveName, thisFile.conType, thisFile.Size, userId);
                    else
                        attBll.AddAttachment((int)ATTACHMENT_OBJECT_TYPE.KNOWLEDGE, artId, int.Parse(thisFile.type_id), thisFile.new_filename, thisFile.old_filename, null, null, null, 0, userId);
                }
            }
            #endregion
        }
        /// <summary>
        /// 获取相关目录结构 字符串输出
        /// </summary>
        public string GetCateString(int cataId,string cataString)
        {
            var thisCata = new d_general_dal().FindNoDeleteById(cataId);
            if (thisCata != null)
            {
                cataString = thisCata.name + ">" + cataString;
                if (thisCata.parent_id != null)
                {
                    cataString = GetCateString((int)thisCata.parent_id, cataString);
                }
            }
            return cataString;
        }
        /// <summary>
        /// 新增评论
        /// </summary>
        public bool SaveComment(long artId,string comment,long userId)
        {
            var thisArt = _dal.FindNoDeleteById(artId);
            var thisUser = new sys_resource_dal().FindNoDeleteById(userId);
            if (thisArt != null && !string.IsNullOrEmpty(comment) && thisUser != null)
            {
                var skacDal = new sdk_kb_article_comment_dal();
                var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                var comm = new sdk_kb_article_comment()
                {
                    comment = comment,
                    create_time = timeNow,
                    create_user_id = userId,
                    id = skacDal.GetNextIdCom(),
                    update_time = timeNow,
                    update_user_id = userId,
                    creator_name = thisUser.name,
                    kb_article_id = thisArt.id,
                };
                skacDal.Insert(comm);
                OperLogBLL.OperLogAdd<sdk_kb_article_comment>(comm, comm.id, userId, OPER_LOG_OBJ_CATE.SDK_KONWLEDGE_COMMENT, "新增知识库评论");
                return true;
            }
            else
                return false;
        }
        /// <summary>
        /// 删除知识库评论
        /// </summary>
        public bool DeleteComment(long artComId,long userId)
        {
            var skacDal = new sdk_kb_article_comment_dal();
            var thisCom = skacDal.FindNoDeleteById(artComId);
            if (thisCom != null)
            {
                skacDal.SoftDelete(thisCom,userId);
                OperLogBLL.OperLogDelete<sdk_kb_article_comment>(thisCom, thisCom.id, userId, OPER_LOG_OBJ_CATE.SDK_KONWLEDGE_COMMENT, "删除知识库评论");
            }
                
            return true;
        }
        /// <summary>
        /// 删除知识库 
        /// </summary>
        public bool DeleteKnow(long artId,long userId)
        {
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            var skatDal = new sdk_kb_article_ticket_dal();
            var skacDal = new sdk_kb_article_comment_dal();
            var thisArt = _dal.FindNoDeleteById(artId);
            var thisArtTicket = skatDal.GetArtTicket(artId);
            var thisArtComm = skacDal.GetCommByArt(artId);
            if (thisArtComm != null && thisArtComm.Count > 0)
                thisArtComm.ForEach(_ => {
                    skacDal.SoftDelete(_, userId);
                    OperLogBLL.OperLogDelete<sdk_kb_article_comment>(_, _.id, userId, OPER_LOG_OBJ_CATE.SDK_KONWLEDGE_COMMENT, "删除知识库评论");
                });
            if (thisArtTicket != null && thisArtTicket.Count > 0)
                thisArtTicket.ForEach(_ => {
                    skatDal.SoftDelete(_, userId);
                    OperLogBLL.OperLogDelete<sdk_kb_article_ticket>(_, _.id, userId, OPER_LOG_OBJ_CATE.SDK_KONWLEDGE_TICKET, "删除知识库关联工单");
                });
            if (thisArt != null)
            {
                _dal.SoftDelete(thisArt,userId);
                OperLogBLL.OperLogDelete<sdk_kb_article>(thisArt, thisArt.id, userId, OPER_LOG_OBJ_CATE.SDK_KONWLEDGE, "删除知识库");
            }
                
            return true;
        }
        /// <summary>
        /// 获取所有可用的知识库
        /// </summary>
        public List<sdk_kb_article> GetArtList()
        {
            return _dal.FindListBySql<sdk_kb_article>("select * from sdk_kb_article where delete_time = 0 ");
        }
        /// <summary>
        /// 新增知识库目录
        /// </summary>
        public bool AddKnowMenu(string name,int parentId,long userId,ref string failReason)
        {
            if (string.IsNullOrEmpty(name))
            {
                failReason = "为获取到相关名称";
                return false;
            }
            var dgDal = new d_general_dal();
            var isCanAdd = true;
            var subList = dgDal.GetGeneralByParentId(parentId);
            if (subList != null && subList.Count > 0)
                if (subList.Any(_ => name.Equals(_.name)))
                    isCanAdd = false;
            if (!isCanAdd)
            {
                failReason = "同一级目录，名称不能相同！";
                return false;
            }
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            var thisCate = new d_general()
            {
                id = (int)dgDal.GetNextIdCom(),
                general_table_id = (int)DTO.GeneralTableEnum.KNOWLEDGE_BASE_CATE,
                create_time = timeNow,
                update_time = timeNow,
                create_user_id = userId,
                update_user_id = userId,
                name = name,
                parent_id = parentId,
            };
            dgDal.Insert(thisCate);
            OperLogBLL.OperLogAdd<d_general>(thisCate, thisCate.id, userId, OPER_LOG_OBJ_CATE.General_Code, "新增知识库目录");
            return true;
        }
        /// <summary>
        /// 编辑知识库目录
        /// </summary>
        public bool EditKnowMenu(long cateId,string name, int parentId, long userId, ref string failReason)
        {
            var dgDal = new d_general_dal();
            if (string.IsNullOrEmpty(name))
            {
                failReason = "为获取到相关名称";
                return false;
            }
            var cate = dgDal.FindNoDeleteById(cateId);
            if (cate == null)
            {
                failReason = "该目录已经删除";
                return false;
            }
            var isCanAdd = true;
            var subList = dgDal.GetGeneralByParentId(parentId);
            if (subList != null && subList.Count > 0)
                if (subList.Any(_ => name.Equals(_.name)&&_.id!=cateId))
                    isCanAdd = false;
            if (!isCanAdd)
            {
                failReason = "同一级目录，名称不能相同！";
                return false;
            }
            cate.name = name;
            cate.parent_id = parentId;
            cate.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            cate.update_user_id = userId;
            var oldCate = dgDal.FindNoDeleteById(cateId);
            dgDal.Update(cate);
            OperLogBLL.OperLogUpdate<d_general>(cate, oldCate, cate.id, userId, OPER_LOG_OBJ_CATE.General_Code, "编辑知识库目录");
            return true;
        }
        /// <summary>
        /// 删除知识库目录
        /// </summary>
        public bool DeleteKnowMenu(long cateId, long userId, ref string failReason)
        {
            var dgDal = new d_general_dal();
            var cate = dgDal.FindNoDeleteById(cateId);
            if (cate == null)
                return true;
            if (cate.parent_id == null)
            {
                failReason = "根目录不可删除";
                return false;
            }
            var gBll = new GeneralBLL();
            ChangeArtCate(cateId,userId, (int)cate.parent_id);
            //var subMenu = dgDal.GetGeneralByParentId(cateId);
            //if (subMenu != null && subMenu.Count > 0)
            //    subMenu.ForEach(_ => {
            //        _.parent_id = cate.parent_id;
            //        gBll.EditGeneral(_,userId);
            //    });
            //var subArt = _dal.GetArtByCate(cateId);
            //if(subArt!=null&& subArt.Count > 0)
            //    subArt.ForEach(_=> {
            //        _.kb_category_id = (int)cate.parent_id;
            //        UpdateKnow(_,userId);
            //    });
            dgDal.SoftDelete(cate,userId);
            OperLogBLL.OperLogAdd<d_general>(cate, cate.id, userId, OPER_LOG_OBJ_CATE.General_Code, "删除知识库目录");
            return true;
        }
        /// <summary>
        /// 修改知识库的类别( 某一类别下的所有知识库包括子类别的所有知识库 )
        /// </summary>
        public void ChangeArtCate(long cateId,long userId,int parentId)
        {
            var subArt = _dal.GetArtByCate(cateId);
            var dgDal = new d_general_dal();
            var gBll = new GeneralBLL();
            var subMenu = dgDal.GetGeneralByParentId(cateId);
            if (subArt!=null&& subArt.Count > 0)
            {
                foreach (var art in subArt)
                {
                    subArt.ForEach(_ => {
                        _.kb_category_id = parentId;
                        UpdateKnow(_, userId);
                    });
                }
            }
            if(subMenu!=null&& subMenu.Count > 0)
            {
                foreach (var menu in subMenu)
                {
                    ChangeArtCate(menu.id, userId,parentId);
                    dgDal.SoftDelete(menu, userId);
                    OperLogBLL.OperLogAdd<d_general>(menu, menu.id, userId, OPER_LOG_OBJ_CATE.General_Code, "删除知识库目录");
                }
            }
        }
    }
}
