using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// IndexAjax 的摘要说明
    /// </summary>
    public class IndexAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            switch (action)
            {
                case "SearchHistoryManage":
                    SearchHistoryManage(context);
                    break;
                case "LoadSearchHistory":
                    LoadSearchHistory(context);
                    break;
                case "ChangeNoticeNext":
                    ChangeNoticeNext(context);
                    break;
                case "ClearHistory":
                    ClearHistory(context);
                    break;
                case "LoadBrowerHistory":
                    LoadBrowerHistory(context);
                    break;
                case "BookMarkManage":
                    BookMarkManage(context);
                    break;
                case "LoadBook":
                    LoadBook(context);
                    break;
                case "DeleteChooseBook":
                    DeleteChooseBook(context);
                    break;
                case "DeleteAllBook":
                    DeleteAllBook(context);
                    break;
                default:
                    break;
            }
        }
        /// <summary>
        /// 新增编辑快速查询记录
        /// </summary>
        public void SearchHistoryManage(HttpContext context)
        {
            var result = false;
            var id = context.Request.QueryString["id"];
            
            if (!string.IsNullOrEmpty(id))
            {
                var search = new DAL.sys_recent_search_dal().FindById(long.Parse(id));
                if (search != null)
                    result = new DispatchBLL().ManageSearch(search,LoginUserId);
            }
            else
            {
                var searchText = context.Request.QueryString["searchText"];
                var searchType = context.Request.QueryString["searchType"];
                var searchTypeName = context.Request.QueryString["searchTypeName"];
                var url = context.Request.QueryString["url"];
                var searchDto = new DTO.QuickSearchDto() {
                    Condition = searchText,
                    Name = searchTypeName,
                    SearchType = searchType
                };
                var conditions = new Tools.Serialize().SerializeJson(searchDto);
                var search = new DAL.sys_recent_search_dal().GetByCon(conditions,url);
                if (search != null)
                    result = new DispatchBLL().ManageSearch(search, LoginUserId);
                else
                {
                    search = new Core.sys_recent_search()
                    {
                        conditions = conditions,
                        url = url,
                        title = "",
                    };
                    result = new DispatchBLL().ManageSearch(search, LoginUserId);
                }
               

            }
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 获取查询历史信息
        /// </summary>
        public void LoadSearchHistory(HttpContext context)
        {
            var url = context.Request.QueryString["url"];
            var list = new DAL.sys_recent_search_dal().GetListByUpdate(url);
            if(list!=null&& list.Count > 0)
            {
                context.Response.Write(new Tools.Serialize().SerializeJson(list));

            }
        }
        /// <summary>
        /// 是否下次登陆继续通知
        /// </summary>
        public void ChangeNoticeNext(HttpContext context)
        {
            var result = false;
            var noticeId = context.Request.QueryString["id"];
            var isAlert = context.Request.QueryString["isAlert"] == "1";
            if(!string.IsNullOrEmpty(noticeId))
                result = new IndexBLL().ChangeNoticeNext(long.Parse(noticeId), LoginUserId, isAlert);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 清除浏览历史
        /// </summary>
        public void ClearHistory(HttpContext context)
        {
            var result = false;
            result = new IndexBLL().ClearHistory(LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 获取浏览历史
        /// </summary>
        public void LoadBrowerHistory(HttpContext context)
        {
            var hisList = new IndexBLL().GetHistoryList(LoginUserId);
            if(hisList!=null&& hisList.Count > 0)
            {
                if (hisList.Count >= 50)
                    hisList = hisList.Take(50).ToList();
                context.Response.Write(new Tools.Serialize().SerializeJson(hisList));
            }
        }
        /// <summary>
        /// 获取书签信息
        /// </summary>
        public void LoadBook(HttpContext context)
        {
            var bookList = new DAL.sys_bookmark_dal().GetBookList(LoginUserId);
            if (bookList != null && bookList.Count > 0)
            {
                if (bookList.Count >= 50)
                    bookList = bookList.Take(50).ToList();
                context.Response.Write(new Tools.Serialize().SerializeJson(bookList));
            }
        }

        /// <summary>
        /// 书签管理
        /// </summary>
        public void BookMarkManage(HttpContext context)
        {
            var url = context.Request.QueryString["url"];
            var title = context.Request.QueryString["title"];
            var result = new IndexBLL().BookMarkManage(url,title,LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 删除选中的书签
        /// </summary>
        public void DeleteChooseBook(HttpContext context)
        {
            var ids = context.Request.QueryString["ids"];
            var result = new IndexBLL().DeleteBookByIds(ids,LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 删除全部书签
        /// </summary>
        public void DeleteAllBook(HttpContext context)
        {
            var result = new IndexBLL().DeleteAllBook(LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
    }
}