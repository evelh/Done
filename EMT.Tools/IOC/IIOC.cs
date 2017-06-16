using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.Tools
{
    public interface IIOC
    {
        T Resolve<T>();
        T Resolve<T>(string key);
    }
}
