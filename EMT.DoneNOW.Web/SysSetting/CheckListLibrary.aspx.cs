using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class CheckListLibrary : BasePage
    {
        protected bool isAdd = true;
        protected sys_checklist_lib lib;
        protected List<sys_checklist> checkList;
        protected CheckListBLL clBll = new CheckListBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            long id = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["id"]) && long.TryParse(Request.QueryString["id"], out id))
                lib = clBll.GetLib(id);
            if (lib != null)
            {
                checkList = clBll.GetCheckList(lib.id);
                if (string.IsNullOrEmpty(Request.QueryString["copy"]))
                    isAdd = false;
            }

        }

        /// <summary>
        /// 获取检查单相关
        /// </summary>
        protected List<CheckListDto> GetCheckList()
        {
            List<CheckListDto> ckList = new List<CheckListDto>();
            #region 检查单相关
            var CheckListIds = Request.Form["CheckListIds"];  // 检查单Id
            if (!string.IsNullOrEmpty(CheckListIds))
            {

                var checkIdArr = CheckListIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                int sort = 1;
                foreach (var checkId in checkIdArr)
                {
                    if (string.IsNullOrEmpty(Request.Form[checkId + "_item_name"]))  // 条目名称为空 不添加
                        continue;
                    var is_complete = Request.Form[checkId + "_is_complete"];
                    var is_import = Request.Form[checkId + "_is_import"];
                    var sortOrder = Request.Form[checkId + "_sort_order"];

                    var thisCheck = new CheckListDto()
                    {
                        ckId = long.Parse(checkId),
                        isComplete = is_complete == "on",
                        itemName = Request.Form[checkId + "_item_name"],
                        isImport = is_import == "on",
                        sortOrder = sort,
                    };
                    ckList.Add(thisCheck);
                    sort++;
                }

            }
            #endregion
            return ckList;
        }

        protected void SaveClose_Click(object sender, EventArgs e)
        {
            sys_checklist_lib pageLib = AssembleModel<sys_checklist_lib>();
            if (!string.IsNullOrEmpty(Request.Form["isActive"]) && Request.Form["isActive"] == "on")
                pageLib.is_active = 1;
            else
                pageLib.is_active = 0;

            if (!isAdd)
            {
                lib.name = pageLib.name;
                lib.description = pageLib.description;
                lib.is_active = pageLib.is_active;
            }
            bool result = false;
            List<CheckListDto> check = GetCheckList();
            if (isAdd)
                result = clBll.AddCheckLib(pageLib, check,LoginUserId);
            else
                result = clBll.EditCheckLib(lib, check, LoginUserId);

            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}!');self.opener.location.reload();window.close();</script>");

        }
    }
}