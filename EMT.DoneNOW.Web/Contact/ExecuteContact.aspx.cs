using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.Contact
{
    public partial class ExecuteContact : BasePage
    {
        protected crm_contact_group pageGroup;
        //protected List<crm_contact> contactList;
        protected string chooseType;
        protected ContactBLL conBll = new ContactBLL();
        protected string conIds;
        protected string[] conIdArr;
        protected List<d_general> noteTypeList = new DAL.d_general_dal().GetGeneralByTableId((int)DTO.GeneralTableEnum.ACTION_TYPE);
        protected List<sys_resource> resList = new DAL.sys_resource_dal().GetSourceList();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var groupId = Request.QueryString["groupId"];
                if (!string.IsNullOrEmpty(groupId))
                    pageGroup = conBll.GetGroupById(long.Parse(groupId));
                conIds = Request.QueryString["ids"];
                if (string.IsNullOrEmpty(conIds))
                {
                    Response.Write($"<script>alert('请选择相关联系人！');window.close();</script>");
                    return;
                }
                conIdArr = conIds.Split(new char[] {','},StringSplitOptions.RemoveEmptyEntries);
                chooseType = Request.QueryString["chooseType"];
                if (noteTypeList != null && noteTypeList.Count > 0)
                    noteTypeList = noteTypeList.Where(_ => _.parent_id == (int)DTO.DicEnum.CALENDAR_DISPLAY.LIST).ToList();

                if (IsPostBack)
                {
                    ExexuteContactDto param = new ExexuteContactDto();
                    param.ids = conIds;
                    if (!string.IsNullOrEmpty(Request.Form["ckNote"]) && Request.Form["ckNote"].Equals("on"))
                        param.isHasNote = true;
                    if (param.isHasNote)
                    {
                        param.note_action_type = int.Parse(Request.Form["note_action_type"]);
                        param.note_content = Request.Form["note_content"];
                    }
                    if (!string.IsNullOrEmpty(Request.Form["ckTodo"]) && Request.Form["ckTodo"].Equals("on"))
                        param.isHasTodo = true;
                    if (param.isHasTodo)
                    {
                        param.todo_action_type = int.Parse(Request.Form["todo_action_type"]);
                        param.todo_content = Request.Form["todo_content"];
                        param.assignRes = long.Parse(Request.Form["todo_resource_id"]);
                        param.startDate = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(Request.Form["startDate"]));
                        param.endDate = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(Request.Form["endDate"]));
                    }
                    var result = false;
                    if (param.isHasTodo || param.isHasNote)
                        result = conBll.ExectueContactAction(param,LoginUserId);

                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('执行{(result?"成功":"失败")}');window.close();</script>");
                }
            }
            catch (Exception msg)
            {
                Response.Write($"<script>alert('{msg.Message}');window.close();</script>");
            }



        }
    }
}