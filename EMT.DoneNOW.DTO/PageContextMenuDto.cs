using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 页面右键菜单结构内容
    /// </summary>
    public class PageContextMenuDto
    {
        public string text;     // 菜单文本内容
        public string click_function;   // 菜单点击功能
        public string image;    // 菜单图标
        public List<PageContextMenuDto> submenu;    // 子菜单
        public string id;   // 加个ID可以动态控制li的事件和显示样式
    }
}
