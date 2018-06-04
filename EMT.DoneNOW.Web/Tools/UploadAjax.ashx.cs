using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// UploadAjax 的摘要说明
    /// </summary>
    public class UploadAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            string action = request.QueryString["action"];
            switch (action)
            {
                case "config": //编辑器配置
                    EditorConfig(context);
                    break;
                case "uploadimage": //编辑器上传图片
                    EditorUploadImage(context);
                    break;
                default:
                    break;
            }
        }

        /// <summary>
        /// 初始化参数
        /// </summary>
        private void EditorConfig(HttpContext context)
        {
            StringBuilder jsonStr = new StringBuilder();
            jsonStr.Append("{");
            //上传图片配置项
            jsonStr.Append("\"imageActionName\": \"uploadimage\","); //执行上传图片的action名称
            jsonStr.Append("\"imageFieldName\": \"upfile\","); //提交的图片表单名称
            jsonStr.Append("\"imageMaxSize\": " + (10240 * 1024) + ","); //上传大小限制，单位B
            jsonStr.Append("\"imageAllowFiles\": [\".png\", \".jpg\", \".jpeg\", \".gif\", \".bmp\"],"); //上传图片格式显示
            jsonStr.Append("\"imageCompressEnable\": false,"); //是否压缩图片,默认是true
            jsonStr.Append("\"imageCompressBorder\": 1600,"); //图片压缩最长边限制
            jsonStr.Append("\"imageInsertAlign\": \"none\","); //插入的图片浮动方式
            jsonStr.Append("\"imageUrlPrefix\": \"\","); //图片访问路径前缀
            jsonStr.Append("\"imagePathFormat\": \"\","); //上传保存路径

            context.Response.AddHeader("Content-Type", "text/plain; charset=UTF-8");
            context.Response.Write(jsonStr.ToString());
            context.Response.End();
        }

        /// <summary>
        /// 上传图片
        /// </summary>
        private void EditorUploadImage(HttpContext context)
        {
            bool _iswater = false; //默认不打水印
            HttpPostedFile upFile = context.Request.Files["upfile"];
            //FileSave(context, upFile, _iswater);
        }
    }
}