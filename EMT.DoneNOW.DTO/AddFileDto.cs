using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace EMT.DoneNOW.DTO
{
    public class AddFileDto
    {
        public string type_id;       // 附件类型 
        public string old_filename;  // 旧的上传文件名
        public string new_filename;  // 新的更改的名字
        public object files;         // 文件信息
        public string old_file_path; // 旧的文件的路径
        public string fileSaveName;  // 文件保存的名字
        public string conType;
        public int Size;
    }
}
