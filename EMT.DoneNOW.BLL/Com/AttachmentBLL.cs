﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.BLL
{
    public class AttachmentBLL
    {
        private readonly com_attachment_dal dal = new com_attachment_dal();

        /// <summary>
        /// 新增附件
        /// </summary>
        /// <param name="objType">对象类型</param>
        /// <param name="objId">对象id</param>
        /// <param name="typeId">附件类型</param>
        /// <param name="title">附件名</param>
        /// <param name="attLink">附件内容</param>
        /// <param name="fileName">上传的文件名</param>
        /// <param name="fileSaveName">文件保存服务器的名称</param>
        /// <param name="contentType">文件类型</param>
        /// <param name="size">文件大小</param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool AddAttachment(int objType,long objId, int typeId, string title, string attLink, string fileName, string fileSaveName, string contentType, int size,long userId)
        {
            com_attachment att = new com_attachment();

            att.object_type_id = objType;
            att.object_id = objId;

            // 备注和附件的下级备注和附件不能再添加附件
            if (objType == (int)DicEnum.ATTACHMENT_OBJECT_TYPE.NOTES)
            {
                var note = new com_activity_dal().FindById(objId);
                if (note.object_type_id==(int)DicEnum.OBJECT_TYPE.NOTES)
                {
                    att.object_type_id = (int)DicEnum.ATTACHMENT_OBJECT_TYPE.NOTES;
                    att.object_id = note.object_id;
                }
                else if (note.object_type_id == (int)DicEnum.OBJECT_TYPE.ATTACHMENT)
                {
                    att.object_type_id = (int)DicEnum.ATTACHMENT_OBJECT_TYPE.ATTACHMENT;
                    att.object_id = note.object_id;
                }
            }
            else if (objType == (int)DicEnum.ATTACHMENT_OBJECT_TYPE.ATTACHMENT)
            {
                var attachment = dal.FindById(objId);
                if (attachment.object_type_id == (int)DicEnum.ATTACHMENT_OBJECT_TYPE.NOTES)
                {
                    att.object_type_id = (int)DicEnum.ATTACHMENT_OBJECT_TYPE.NOTES;
                    att.object_id = attachment.object_id;
                }
                else if (attachment.object_type_id == (int)DicEnum.ATTACHMENT_OBJECT_TYPE.ATTACHMENT)
                {
                    att.object_type_id = (int)DicEnum.ATTACHMENT_OBJECT_TYPE.ATTACHMENT;
                    att.object_id = attachment.object_id;
                }
            }

            if (att.object_type_id == (int)DicEnum.ATTACHMENT_OBJECT_TYPE.ATTACHMENT)
            {
                var attachment = dal.FindById(att.object_id);
                att.account_id = attachment.account_id;
                att.parent_id = attachment.id;
            }
            else if (att.object_type_id == (int)DicEnum.ATTACHMENT_OBJECT_TYPE.NOTES)
            {
                var note = new com_activity_dal().FindById(att.object_id);
                att.account_id = note.account_id;
            }
            else if (att.object_type_id == (int)DicEnum.ATTACHMENT_OBJECT_TYPE.OPPORTUNITY)
            {
                var opp = new crm_opportunity_dal().FindById(att.object_id);
                att.account_id = opp.account_id;
            }
            else if (att.object_type_id == (int)DicEnum.ATTACHMENT_OBJECT_TYPE.SALES_ORDER)
            {
                var so = new crm_sales_order_dal().FindById(att.object_id);
                var opp = new crm_opportunity_dal().FindById(so.opportunity_id);
                att.account_id = opp.account_id;
            }
            else if (att.object_type_id == (int)DicEnum.ATTACHMENT_OBJECT_TYPE.CONTRACT)
            {
                var contract = new ctt_contract_dal().FindById(att.object_id);
                att.account_id = contract.account_id;
            }
            else if (att.object_type_id == (int)DicEnum.ATTACHMENT_OBJECT_TYPE.COMPANY)
            {
                att.account_id = att.object_id;
            }
            else
                return false;

            att.id = dal.GetNextIdCom();
            att.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            att.create_user_id = userId;
            att.update_time = att.create_time;
            att.update_user_id = userId;
            att.title = title;
            att.type_id = typeId;
            if (typeId == (int)DicEnum.ATTACHMENT_TYPE.FILE_LINK
                || typeId == (int)DicEnum.ATTACHMENT_TYPE.FOLDER_LINK)
            {
                att.uncpath = attLink;
                att.filename = @"file://" + attLink;
            }
            else if (typeId == (int)DicEnum.ATTACHMENT_TYPE.URL)
            {
                att.urlpath = attLink;
                att.filename = @"http://" + attLink;
            }
            else if (typeId == (int)DicEnum.ATTACHMENT_TYPE.ATTACHMENT)
            {
                att.href = fileSaveName;
                att.filename = fileName;
                att.sizeinbyte = size;
                att.content_type = contentType;
            }
            else
                return false;

            dal.Insert(att);
            OperLogBLL.OperLogAdd<com_attachment>(att, att.id, userId, DicEnum.OPER_LOG_OBJ_CATE.ATTACHMENT, "新增附件");
            return true;
        }
        
        /// <summary>
        /// 删除附件
        /// </summary>
        /// <param name="id"></param>
        /// <param name="userId"></param>
        public void DeleteAttachment(long id, long userId)
        {
            var att = dal.FindById(id);
            if (att == null)
                return;
            att.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            att.delete_user_id = userId;
            dal.Update(att);
            OperLogBLL.OperLogDelete<com_attachment>(att, att.id, userId, DicEnum.OPER_LOG_OBJ_CATE.ATTACHMENT, "删除附件");
        }

        /// <summary>
        /// 获取附件实体
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public com_attachment GetAttachment(long id)
        {
            return dal.FindById(id);
        }

    }
}
