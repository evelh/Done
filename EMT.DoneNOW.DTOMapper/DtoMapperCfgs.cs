using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using EMT.Tools;
namespace EMT.DoneNOW.DTOMapper
{
    public static class DtoMapperCfgs
    {
        static DtoMapperCfgs()
        {
            var prf1 = new AutoMapperProfile();
            MapperConfiguration mapcfg1 = new MapperConfiguration(mapcfg =>
            {
                mapcfg.AddProfile(prf1);
            });

            Utils.InitialMapper(mapcfg1.CreateMapper());
        }

        public static void Init()
        {

        }
    }

    /// <summary>
    /// AutoMapper配置明细信息.
    /// 在此处添加实体和DTO的映射.
    /// </summary>
    public class AutoMapperProfile : Profile
    {
        
    }
}
